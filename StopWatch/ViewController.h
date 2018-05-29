//
//  ViewController.h
//  StopWatch
//
//  Created by SONE MASANORI on 2013/01/03.
//  Copyright (c) 2013年 SONE MASANORI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneFingerRotationGestureRecognizer.h"

@class GradientButton;

@interface ViewController : UIViewController<OneFingerRotationGestureRecognizerDelegate>{
    IBOutlet UILabel *lbl;
    NSTimer *timer;
    
    CGFloat imageAngle0;
    CGFloat imageAngle1;
    CGFloat imageAngle2;
    OneFingerRotationGestureRecognizer *gestureRecognizer;
    
    NSDate *stdate;
    NSDate *stopDate;
    float laptime;
    bool pauseflg;
    bool timeflg;
    bool onGesture;
    
}

@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) IBOutlet GradientButton *g_start;
@property (nonatomic, strong) IBOutlet GradientButton *g_reset;

@property (nonatomic, strong) IBOutlet UIImageView *image0;
@property (nonatomic, strong) IBOutlet UIImageView *image1;
@property (nonatomic, strong) IBOutlet UIImageView *image2;
@property (nonatomic, strong) IBOutlet UILabel *textDisplay;

- (void)onTimer;
- (IBAction)start_touchdown:(id)sender;
- (IBAction)reset_down:(id)sender;
@end
