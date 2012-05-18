//
//  OWContainerViewController.m
//  Redstone
//
//  Created by Tales Pinheiro De Andrade on 17/05/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWContainerViewController.h"
#import "OWTimeTrackController.h"
#import <QuartzCore/QuartzCore.h>

@interface OWContainerViewController ()

@end

@implementation OWContainerViewController {
    OWTimeTrackController *_timeTrackController;
    UIViewController *_contentController;
    UINavigationController *_navigationController;
}
@synthesize timeTrackerController, accountsController;

- (id)initWithContentViewController:(UIViewController *)contentController {
    self = [super init];
    if (self != nil) {
        _timeTrackController = [[OWTimeTrackController alloc] init];
        _contentController = contentController;
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_contentController];
    }
    return self;
}

- (void)loadView
{
    CGRect mainFrame = CGRectMake(0, 0, 320, 780);
    UIView *contentView = [[UIView alloc] initWithFrame:mainFrame];
    
    CGRect timerFrame = CGRectMake(0, 520, 320, 260);
    _timeTrackController.view.frame = timerFrame;
    [self addChildViewController:_timeTrackController];
    [contentView addSubview:_timeTrackController.view];
    
    CGRect contentFrame = CGRectMake(0, 0, 320, 520);
    _navigationController.view.frame = contentFrame;
    [self addChildViewController:_navigationController];
    [contentView addSubview:_navigationController.view];
    
    [_navigationController didMoveToParentViewController:self];
    self.view = contentView;
    
}

- (void)viewDidLayoutSubviews
{
    CGRect contentFrame = self.view.bounds;
    CGRect timerFrame = CGRectMake(0, contentFrame.size.height - 200, 320, 200);
    
    contentFrame.size.height -= timerFrame.size.height;
    timerFrame.origin.y = contentFrame.size.height;
    
    _navigationController.view.frame = contentFrame;
    _timeTrackController.view.frame = timerFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [_contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
