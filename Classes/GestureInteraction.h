//
//  BasicGestures.h
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/6/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ExampleController.h"


@interface GestureInteraction : ExampleController <UIGestureRecognizerDelegate> {
  NSDictionary *stateColorMap_;
  CAShapeLayer *centroidLayer_;
}

@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UILabel *tapLabel;
@property (nonatomic, retain) IBOutlet UILabel *swipeLabel;

@end
