//
//  CircularGestureRecognizer.m
//

#include <math.h>

#import "OneFingerRotationGestureRecognizer.h"

@implementation OneFingerRotationGestureRecognizer

// private helper functions
CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2);
CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB);

- (id) initWithMidPoint: (CGPoint) _midPoint
            innerRadius: (CGFloat) _innerRadius
            outerRadius: (CGFloat) _outerRadius
                 target: (id <OneFingerRotationGestureRecognizerDelegate>) _target
{
    if ((self = [super initWithTarget: _target action: nil]))
    {
        midPoint    = _midPoint;
        innerRadius = _innerRadius;
        outerRadius = _outerRadius;
        target      = _target;
        self.cancelsTouchesInView = NO;
    }
    return self;
}

/** Calculates the distance between point1 and point 2. */
CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point1.x - point2.x;
    CGFloat dy = point1.y - point2.y;
    return sqrt(dx*dx + dy*dy);
}

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;

    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);

    // convert radiants to degrees
    return (atanA - atanB) * 180 / M_PI;
}

#pragma mark - UIGestureRecognizer implementation

- (void)reset
{
    [super reset];
    cumulatedAngle = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([target respondsToSelector: @selector(gestureBegin)])
    {
        [target gestureBegin];
    }
    
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1)
    {
        self.state = UIGestureRecognizerStateFailed;

        return;
    }
    
    CGPoint nowPoint  = [[touches anyObject] locationInView: self.view];
    CGFloat distance = distanceBetweenPoints(midPoint, nowPoint);
    
    if( distance < 146 && distance > 104){
        targetCircle = 0;
    }else if( distance <= 104 && distance > 64){
        targetCircle = 1;
    } else {
        targetCircle = 2;
    }
    
    NSLog(@"Target is %d", targetCircle);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if (self.state == UIGestureRecognizerStateFailed) return;

    CGPoint nowPoint  = [[touches anyObject] locationInView: self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView: self.view];

    // make sure the new point is within the area
    CGFloat distance = distanceBetweenPoints(midPoint, nowPoint);
    if (   innerRadius <= distance
        && distance    <= outerRadius)
    {
        // calculate rotation angle between two points
        CGFloat angle0 = angleBetweenLinesInDegrees(midPoint, prevPoint, midPoint, nowPoint);

        // fix value, if the 12 o'clock position is between prevPoint and nowPoint
        if (angle0 > 180)
        {
            angle0 -= 360;
        }
        else if (angle0 < -180)
        {
            angle0 += 360;
        }

        // sum up single steps
        cumulatedAngle += angle0;
        
        NSLog(@"%f",angle0);
        // call delegate
        if ([target respondsToSelector: @selector(rotation: targetCircle:)])
        {
            //NSMutableArray *angle = [[NSMutableArray alloc] init];
            //[angle addObject:[NSNumber numberWithFloat:angle0]];
            [target rotation:angle0 targetCircle:targetCircle];
        }
    }
    else
    {
        // finger moved outside the area
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if ([target respondsToSelector: @selector(gestureEnd)])
    {
        [target gestureEnd];
    }
    
    [super touchesEnded:touches withEvent:event];
    if (self.state == UIGestureRecognizerStatePossible)
    {
        self.state = UIGestureRecognizerStateRecognized;

        if ([target respondsToSelector: @selector(finalAngle:)])
        {
            [target finalAngle:cumulatedAngle];
        }
    }
    else
    {
        self.state = UIGestureRecognizerStateFailed;
    }
    
    cumulatedAngle = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateFailed;
    cumulatedAngle = 0;
}

@end
