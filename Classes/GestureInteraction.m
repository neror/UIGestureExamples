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

#import "GestureInteraction.h"

@interface GestureInteraction (Private)

- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;

@end

@implementation GestureInteraction

@synthesize tapLabel;
@synthesize swipeLabel;
@synthesize containerView;

+ (NSString *)friendlyName {
  return @"Gesture Interaction";
}

- (void)setupUI {
  [self.tapLabel.layer setBorderColor:[[UIColor blueColor] CGColor]];
  [self.tapLabel.layer setBorderWidth:2.f];
  
  [self.swipeLabel.layer setBorderColor:[[UIColor blueColor] CGColor]];
  [self.swipeLabel.layer setBorderWidth:2.f];
  
  CGRect centriodMarkerBounds = CGRectMake(0.f, 0.f, 40.f, 40.f);
  centroidLayer_ = [[CAShapeLayer alloc] init];
  centroidLayer_.bounds = centriodMarkerBounds;
  centroidLayer_.fillColor = [[UIColor orangeColor] CGColor];
  centroidLayer_.lineWidth = 0.f;
  CGMutablePathRef circle = CGPathCreateMutable();
  CGPathAddEllipseInRect(circle, NULL, centriodMarkerBounds);
  centroidLayer_.path = circle;
  CGPathRelease(circle);
  centroidLayer_.shouldRasterize = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  stateColorMap_ = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [UIColor greenColor], [NSNumber numberWithInt:UIGestureRecognizerStateRecognized],
                    [UIColor blueColor], [NSNumber numberWithInt:UIGestureRecognizerStateBegan],
                    [UIColor blueColor], [NSNumber numberWithInt:UIGestureRecognizerStateChanged],
                    [UIColor blackColor], [NSNumber numberWithInt:UIGestureRecognizerStateEnded],
                    [UIColor redColor], [NSNumber numberWithInt:UIGestureRecognizerStateCancelled],
                    nil];
  
  [self setupUI];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  [self.tapLabel addGestureRecognizer:tap];
  [tap release];
  
  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
  [swipe setDirection:UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft];
  [self.swipeLabel addGestureRecognizer:swipe];
  [swipe release];

  UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
  pinch.delegate = self;
  [self.containerView addGestureRecognizer:pinch];
  [pinch release];
  
  UIPanGestureRecognizer *panContainerView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  panContainerView.delegate = self;
  [panContainerView requireGestureRecognizerToFail:swipe];
  [self.containerView addGestureRecognizer:panContainerView];
  [panContainerView release];
  

  UIPanGestureRecognizer *panMainView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [self.view addGestureRecognizer:panMainView];
  [panMainView release];


}

- (void)viewDidUnload {
  [centroidLayer_ release];
  [super viewDidUnload];
}

- (void)dealloc {
  [tapLabel release];
  [swipeLabel release];
  [stateColorMap_ release];
  [containerView release];
  [centroidLayer_ release];
  [super dealloc];
}

- (void)resetExample {
  self.tapLabel.backgroundColor = [UIColor blackColor];
  self.swipeLabel.backgroundColor = [UIColor blackColor];
  self.containerView.backgroundColor = [UIColor blackColor];
  self.containerView.transform = CGAffineTransformIdentity;
  self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark Tap

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
  [[recognizer view] setBackgroundColor:[stateColorMap_ objectForKey:[NSNumber numberWithInt:[recognizer state]]]];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
  [[recognizer view] setBackgroundColor:[stateColorMap_ objectForKey:[NSNumber numberWithInt:[recognizer state]]]];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
  [[recognizer view] setBackgroundColor:[stateColorMap_ objectForKey:[NSNumber numberWithInt:[recognizer state]]]];
  if([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
    [recognizer view].transform = CGAffineTransformScale([[recognizer view] transform], [recognizer scale], [recognizer scale]);
    [recognizer setScale:1];
  }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
  [[recognizer view] setBackgroundColor:[stateColorMap_ objectForKey:[NSNumber numberWithInt:[recognizer state]]]];
  if([recognizer state] == UIGestureRecognizerStateBegan) {
    [self.view.layer addSublayer:centroidLayer_];
  }
  if([recognizer state] == UIGestureRecognizerStateChanged || [recognizer state] == UIGestureRecognizerStateBegan) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    centroidLayer_.position = [recognizer locationInView:self.view];
    [CATransaction commit];
  }
  if([recognizer state] == UIGestureRecognizerStateEnded) {
    [centroidLayer_ removeFromSuperlayer];
  }
}

#pragma mark -
#pragma mark Gesture Recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
  return ([recognizer view] == [other view]); 
}

@end
