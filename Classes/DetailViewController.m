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

#import "DetailViewController.h"
#import "RootViewController.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;
- (void)resetCurrentExample;
@end

@implementation DetailViewController

@synthesize toolbar;
@synthesize popoverController;
@synthesize exampleController;
@synthesize contentView;
@synthesize titleLabel;

- (void)viewDidLoad {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [self.view addGestureRecognizer:longPress];
  [longPress release];
}

- (void)viewDidUnload {
  self.popoverController = nil;
}

- (void)dealloc {
  [popoverController release];
  [toolbar release];
  [exampleController release];
  [contentView release];
  [titleLabel release];
  [super dealloc];
}

#pragma mark -
#pragma mark Touch Gesture Handling

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
  if([recognizer state] == UIGestureRecognizerStateBegan) {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Reset Example" action:@selector(resetCurrentExample)];
    CGPoint location = [recognizer locationInView:[recognizer view]];
    
    [self.view becomeFirstResponder];
    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
    [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[recognizer view]];
    [menuController setMenuVisible:YES animated:YES];
    [resetMenuItem release];
  }
}

- (void)resetCurrentExample {
  [self.exampleController resetExample];
}

#pragma mark -
#pragma mark Managing the detail item

- (void)setExampleController:(ExampleController *)newExample {
  if (exampleController != newExample) {
    [exampleController viewWillDisappear:YES];
    [newExample viewWillAppear:YES];
    [exampleController.view removeFromSuperview];
    [self.contentView insertSubview:newExample.view belowSubview:self.toolbar];
    [exampleController viewDidDisappear:YES];
    [newExample viewDidAppear:YES];
    
    [self.titleLabel setText:[[newExample class] friendlyName]];
    
    [exampleController release];
    exampleController = [newExample retain];
  }

  if (self.popoverController != nil) {
    [self.popoverController dismissPopoverAnimated:YES];
  }        
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{
    
  barButtonItem.title = @"Gesture Examples";
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items insertObject:barButtonItem atIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items removeObjectAtIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
  return YES;
}

@end

@implementation DetailView

- (BOOL)canBecomeFirstResponder {
  return YES;
}

@end
