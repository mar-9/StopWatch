//
//  ViewController.m
//  StopWatch
//
//  Created by SONE MASANORI on 2013/01/03.
//  Copyright (c) 2013年 SONE MASANORI. All rights reserved.
//

#import "ViewController.h"
#import "GradientButton.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize lbl;
@synthesize image0;
@synthesize image1;
@synthesize image2;
@synthesize textDisplay;
@synthesize g_start;
@synthesize g_reset;

- (void)onTimer
{
    if(timeflg){
        NSDate *now = [NSDate date];
        float disptime = [now timeIntervalSinceDate:stdate] - laptime;
        self.lbl.text = [NSString stringWithFormat:@"%.3f", disptime];
        
        //int dispAngle = (int)(disptime * 100) % 100;
        int dispAngle = (int)([self.lbl.text floatValue] * 1000) % 1000;
        
        if([self.lbl.text isEqualToString:@"2.000"]){
            NSLog(@"%.3f", 1.9999f);
            NSLog(@"dispAngle =%d", dispAngle);
        }
        
        //NSLog(@"dispAngle =%d", dispAngle);
        // NSLog(@"%d", (360 * dispAngle / 100));
        if(!onGesture){
            image0.transform = CGAffineTransformMakeRotation((360 * dispAngle / 1000) *  M_PI / 180);
        }
        [self updateTextDisplay];
    }
}

- (IBAction)start_touchdown:(id)sender
{
    onGesture = FALSE;
    if(!timeflg){
        g_start.text = @"ストップ";
        self.g_start.backgroundColor = [UIColor redColor];
        
        timeflg = TRUE;
        if(pauseflg){
            laptime += [[NSDate date] timeIntervalSinceDate:stopDate];
        }else{
            stdate = [NSDate date];
        }
    }else{
        g_start.text = @"スタート";
        self.g_start.backgroundColor = [UIColor blueColor];
        
        timeflg = FALSE;
        pauseflg = TRUE;
        stopDate = [NSDate date];
    }
}

- (IBAction)reset_down:(id)sender
{
    timeflg = FALSE;
    pauseflg = FALSE;
    laptime = 0.0;
    self.lbl.text = @"0.000";
    image0.transform = CGAffineTransformMakeRotation(0);
    image1.transform = CGAffineTransformMakeRotation(0);
    image2.transform = CGAffineTransformMakeRotation(0);
}

- (void)viewDidLoad
{
    onGesture = FALSE;
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.001) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    laptime = 0.0;
    pauseflg = FALSE;
    timeflg = FALSE;
    
    self.lbl.text = @"0.000";
    self.g_start.text = @"スタート";
    self.g_start.backgroundColor = [UIColor blueColor];
    self.g_reset.text = @"リセット";
    self.g_reset.backgroundColor = [UIColor orangeColor];

    [self setupGestureRecognizer];
    [self updateTextDisplay];
}

- (void) gestureBegin
{
    NSLog(@"Begin");
    onGesture = TRUE;
}

- (void) gestureEnd
{
    NSLog(@"End");
    onGesture = FALSE;
}

- (void) rotation: (CGFloat)angle targetCircle:(NSInteger)targetCircle
{
    // calculate rotation angle
    
    //imageAngle0 += [[angle objectAtIndex:0] floatValue];
    if(targetCircle == 0){
        imageAngle0 += angle;
        NSLog(@"%f",angle);
        if (imageAngle0 > 360)
            imageAngle0 -= 360;
        else if (imageAngle0 < -360)
            imageAngle0 += 360;
        image0.transform = CGAffineTransformMakeRotation(imageAngle0 *  M_PI / 180);
    }else if(targetCircle == 1){
        imageAngle1 += angle;
        NSLog(@"%f",angle);
        if (imageAngle1 > 360)
            imageAngle1 -= 360;
        else if (imageAngle1 < -360)
            imageAngle1 += 360;
        image1.transform = CGAffineTransformMakeRotation(imageAngle1 *  M_PI / 180);
    }else if(targetCircle == 2){
        imageAngle2 += angle;
        NSLog(@"%f",angle);
        if (imageAngle2 > 360)
            imageAngle2 -= 360;
        else if (imageAngle2 < -360)
            imageAngle2 += 360;
        image2.transform = CGAffineTransformMakeRotation(imageAngle2 *  M_PI / 180);
    }
    [self updateTextDisplay];
}

// Updates the text field with the current rotation angle.
- (void) updateTextDisplay
{
    textDisplay.text = [NSString stringWithFormat: @"\u03b1 = %.2f", imageAngle0];
}

- (void) setupGestureRecognizer
{
    // calculate center and radius of the control
    CGPoint midPoint = CGPointMake(image0.frame.origin.x + image0.frame.size.width / 2,
                                   image0.frame.origin.y + image0.frame.size.height / 2);
    gestureRecognizer = [[OneFingerRotationGestureRecognizer alloc] initWithMidPoint: midPoint
                                                                         innerRadius: 0
                                                                         outerRadius: 300
                                                                              target: self];
    [self.view addGestureRecognizer: gestureRecognizer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UIControlEventTouchUpInside
{
    printf("UIControlEventTouchUpInside\n");
}
@end
