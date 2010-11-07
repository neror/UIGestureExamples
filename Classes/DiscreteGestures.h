//
//  BasicGestures.h
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/7/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ExampleController.h"

@interface DiscreteGestures : ExampleController {
  CAShapeLayer *eventIndicator_;
}

@property (nonatomic,retain) IBOutlet UILabel *eventTypeLabel;
@property (readonly) CALayer *eventIndicator;

@end
