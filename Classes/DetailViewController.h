//
//  DetailViewController.h
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/6/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
  UIPopoverController *popoverController;
  UIToolbar *toolbar;
  id detailItem;
  UILabel *detailDescriptionLabel;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@end
