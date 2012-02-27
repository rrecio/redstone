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
@end

@implementation OWAccountMenuController
@synthesize account=_account;

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
