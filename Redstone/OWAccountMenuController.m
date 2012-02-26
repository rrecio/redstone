//
//  OWAccountMenuController.m
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAccountMenuController.h"
#import "OWProjectsController.h"
#import "MBProgressHUD.h"

@interface OWAccountMenuController ()
{
    BOOL loggedIn;
}
@end

@implementation OWAccountMenuController
@synthesize account=_account;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!loggedIn) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = NSLocalizedString(@"Logging in...", nil);
        [self.view addSubview:hud];
        [hud show:YES];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(login:) object:hud];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

- (void)login:(MBProgressHUD *)hud
{
    [_account login];
    [self performSelectorOnMainThread:@selector(finishedLogin:) withObject:hud waitUntilDone:YES];
}

- (void)finishedLogin:(MBProgressHUD *)hud
{
    loggedIn = YES;
    [hud hide:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowProjects"]) {
        [(OWProjectsController *)[segue destinationViewController] setAccount:_account];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
