//
//  BasicGestures.m
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/7/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import "DiscreteGestures.h"

@interface DiscreteGestures (GestureHandlers)

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleSwipeUpDown:(UISwipeGestureRecognizer *)recognizer;
- (void)handleThreeFingerSwipe:(UISwipeGestureRecognizer *)recognizer;

@end

@implementation DiscreteGestures

@synthesize eventTypeLabel;

+ (NSString *)friendlyName {
  return @"Discrete Gestures";
}

- (void)dealloc {
  [eventIndicator_ release];
  [eventTypeLabel release];
  [super dealloc];
}

- (CALayer *)eventIndicator {
  if(!eventIndicator_) {
    CGRect indicatorBounds = CGRectMake(0.f, 0.f, 50.f, 50.f);
    eventIndicator_ = [[CAShapeLayer alloc] init];
    eventIndicator_.bounds = indicatorBounds;
    eventIndicator_.fillColor = [[UIColor orangeColor] CGColor];
    eventIndicator_.lineWidth = 0.f;
    eventIndicator_.opacity = 0.f;
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddEllipseInRect(circle, NULL, indicatorBounds);
    eventIndicator_.path = circle;
    CGPathRelease(circle);
    eventIndicator_.shouldRasterize = YES;
  }
  return eventIndicator_;
}

- (void)showEventIndicatorAtPoint:(CGPoint)point  {
  [self.eventIndicator removeAllAnimations];
  [CATransaction begin];
  [CATransaction setAnimationDuration:.4f];
  [CATransaction setDisableActions:YES];
  
  self.eventIndicator.position = point;
  
  CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  scale.toValue = [NSNumber numberWithFloat:2.f];
  [self.eventIndicator addAnimation:scale forKey:@"scale"];
  
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:1.f];
  [self.eventIndicator addAnimation:fade forKey:@"fade"];
  
  [CATransaction commit];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view.layer addSublayer:self.eventIndicator];
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  [self.view addGestureRecognizer:singleFingerTap];
  [singleFingerTap release];

  UITapGestureRecognizer *twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerDoubleTap:)];
  twoFingerDoubleTap.numberOfTouchesRequired = 2;
  twoFingerDoubleTap.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:twoFingerDoubleTap];
  [twoFingerDoubleTap release];
  
  UISwipeGestureRecognizer *swipeUpDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpDown:)];
  swipeUpDown.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
  [self.view addGestureRecognizer:swipeUpDown];
  [swipeUpDown release];

  UISwipeGestureRecognizer *threeFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerSwipe:)];
  threeFingerSwipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
  threeFingerSwipe.numberOfTouchesRequired = 3;
  [self.view addGestureRecognizer:threeFingerSwipe];
  [threeFingerSwipe release];
}

#pragma mark -
#pragma mark Gesture handlers

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:[self.eventTypeLabel superview]];
  self.eventTypeLabel.text = @"Single Finger Tap";
  [self showEventIndicatorAtPoint:location];
}

- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:[self.eventTypeLabel superview]];
  self.eventTypeLabel.text = @"Two Finger Double Tap";
  [self showEventIndicatorAtPoint:location];
}

- (void)handleSwipeUpDown:(UISwipeGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:[self.eventTypeLabel superview]];
  self.eventTypeLabel.text = @"Swipe up or down";
  [self showEventIndicatorAtPoint:location];
}

- (void)handleThreeFingerSwipe:(UISwipeGestureRecognizer *)recognizer {
  CGPoint location = [recognizer locationInView:[self.eventTypeLabel superview]];
  self.eventTypeLabel.text = @"Swipe left or right (3 fingers)";
  [self showEventIndicatorAtPoint:location];
}
@end
