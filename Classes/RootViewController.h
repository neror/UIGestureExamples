//
//  RootViewController.h
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/6/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
  DetailViewController *detailViewController;
  NSArray *examples_;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
