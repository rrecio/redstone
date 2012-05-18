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
}
@synthesize timeTrackerController, accountsController;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithContentViewController:(UIViewController *)contentController {
    self = [super init];
    if (self != nil) {
        _timeTrackController = [[OWTimeTrackController alloc] init];
        _contentController = contentController;
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
    _contentController.view.frame = contentFrame;
    [self addChildViewController:_contentController];
    [contentView addSubview:_contentController.view];
    
    [_contentController didMoveToParentViewController:self];
    self.view = contentView;
    
}

- (void)viewDidLayoutSubviews
{
    CGRect contentFrame = self.view.bounds;
    CGRect timerFrame = CGRectMake(0, contentFrame.size.height - 260, 320, 260);
    
    contentFrame.size.height -= timerFrame.size.height;
    timerFrame.origin.y = contentFrame.size.height;
    
    _contentController.view.frame = contentFrame;
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
