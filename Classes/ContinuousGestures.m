/*
 The MIT License
 
 Copyright (c) 2010 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

#import "ContinuousGestures.h"
#import <QuartzCore/QuartzCore.h>

@interface ContinuousGestures (GestureRecognition)

- (void)addGestureRecognizersToView:(UIView *)theView;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)recognizer;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer;
- (void)handleScale:(UIPinchGestureRecognizer *)recognizer;
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleTwoFingerTap:(UITapGestureRecognizer *)recognizer;

@end


@implementation ContinuousGestures

@synthesize redView;
@synthesize greenView;
@synthesize blueView;
@synthesize orangeView;

+ (NSString *)friendlyName {
  return @"Continuous Gestures";
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addGestureRecognizersToView:self.redView];
  [self addGestureRecognizersToView:self.greenView];
  [self addGestureRecognizersToView:self.blueView];
  [self addGestureRecognizersToView:self.orangeView];
  
  UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  doubleTap.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:doubleTap];
  [doubleTap release];


  UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
  twoFingerTap.numberOfTouchesRequired = 2;
  [self.view addGestureRecognizer:twoFingerTap];
  [twoFingerTap release];

}

- (void)dealloc {
  [redView release];
  [greenView release];
  [blueView release];
  [orangeView release];
  [super dealloc];
}

- (void)resetExample {
  CGPoint defaultAnchorPoint = CGPointMake(.5f, .5f);
  NSArray *views = [NSArray arrayWithObjects:self.redView, self.greenView, self.blueView, self.orangeView, nil];
  [UIView animateWithDuration:.3f animations:^{
    self.view.transform = CGAffineTransformIdentity;
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      UIView *theView = (UIView *)obj;
      theView.transform = CGAffineTransformIdentity;
      theView.layer.anchorPoint = defaultAnchorPoint;
      NSValue *originalCenter = [theView.layer valueForKey:@"originalCenter"];
      if(originalCenter) {
        theView.center = [originalCenter CGPointValue];
      }
    }];
  }];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    CGPoint locationInView = [recognizer locationInView:recognizer.view];
    CGPoint locationInSuperview = [recognizer locationInView:recognizer.view.superview];
    CGSize viewSize = recognizer.view.bounds.size;
    
    recognizer.view.layer.anchorPoint = CGPointMake(locationInView.x / viewSize.width, locationInView.y / viewSize.height);
    recognizer.view.layer.position = locationInSuperview;
  }
}


- (void)addGestureRecognizersToView:(UIView *)theView {
  
  UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
  rotationGesture.delegate = self;
  [theView addGestureRecognizer:rotationGesture];
  [rotationGesture release];

  UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScale:)];
  pinchGesture.delegate = self;
  [theView addGestureRecognizer:pinchGesture];
  [pinchGesture release];
  
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [panGesture setMaximumNumberOfTouches:2];
  panGesture.delegate = self;
  [theView addGestureRecognizer:panGesture];
  [panGesture release];
  [theView.layer setValue:[NSValue valueWithCGPoint:theView.center] forKey:@"originalCenter"];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
  if(recognizer.state == UIGestureRecognizerStateBegan || 
     recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    recognizer.view.center = 
      CGPointMake(recognizer.view.center.x + translation.x, 
                  recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
  }
}


- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer {
  [self adjustAnchorPointForGestureRecognizer:recognizer];
  if(recognizer.state == UIGestureRecognizerStateBegan || 
     recognizer.state == UIGestureRecognizerStateChanged) {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    [recognizer setRotation:0];
  }
}

- (void)handleScale:(UIPinchGestureRecognizer *)recognizer {
  [self adjustAnchorPointForGestureRecognizer:recognizer];
  if ([recognizer state] == UIGestureRecognizerStateBegan || 
      [recognizer state] == UIGestureRecognizerStateChanged) {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    [recognizer setScale:1];
  }
  
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
  [self adjustAnchorPointForGestureRecognizer:recognizer];
  [UIView animateWithDuration:.2f animations:^{
    recognizer.view.transform = CGAffineTransformScale(self.view.transform, 1.5f, 1.5f);
  }];
}


- (void)handleTwoFingerTap:(UITapGestureRecognizer *)recognizer {
  recognizer.view.layer.anchorPoint = CGPointMake(.5f, .5f);
  [UIView animateWithDuration:.2f animations:^{
    recognizer.view.transform = CGAffineTransformIdentity;
  }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
  return YES;
}

@end