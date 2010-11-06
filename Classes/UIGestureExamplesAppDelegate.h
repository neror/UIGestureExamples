//
//  UIGestureExamplesAppDelegate.h
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/6/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;
@class DetailViewController;

@interface UIGestureExamplesAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UISplitViewController *splitViewController;
  
  RootViewController *rootViewController;
  DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
