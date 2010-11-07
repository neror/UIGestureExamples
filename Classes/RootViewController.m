//
//  RootViewController.m
//  UIGestureExamples
//
//  Created by Nathan Eror on 11/6/10.
//  Copyright 2010 Free Time Studios. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "ExampleController.h"
#import "GestureInteraction.h"
#import "DiscreteGestures.h"

@implementation RootViewController

@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
  
  examples_ = [[NSArray alloc] initWithObjects:[DiscreteGestures class], [GestureInteraction class], nil];
}

- (void)dealloc {
  [detailViewController release];
  [examples_ release];
  [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
  return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return [examples_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"CellIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  Class example = [examples_ objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [example friendlyName];
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class exampleClass = [examples_ objectAtIndex:indexPath.row];
  ExampleController *example = [[exampleClass alloc] initWithNibName:nil bundle:nil];
  detailViewController.exampleController = example;
  [example release];
}

@end
