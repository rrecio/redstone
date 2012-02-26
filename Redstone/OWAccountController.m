//
//  OWAccountController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAccountController.h"

@interface OWAccountController ()
@end

@implementation OWAccountController

@synthesize serverField;
@synthesize userField;
@synthesize passField;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender
{
    RKRedmine *newAccount = [[RKRedmine alloc] init];
    newAccount.username = userField.text;
    newAccount.password = passField.text;
    newAccount.serverAddress = serverField.text;
    
    [self.delegate accountControllerDidSaveAccount:newAccount];
    [self dismissModalViewControllerAnimated:YES];
}

@end
