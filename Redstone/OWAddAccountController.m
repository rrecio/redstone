//
//  OWAddAccountController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAddAccountController.h"
#import "MBProgressHUD.h"

@interface OWAddAccountController ()
{
    RKRedmine *_newAccount;
}
@end

@implementation OWAddAccountController

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
    _newAccount = [[RKRedmine alloc] init];
    _newAccount.username = userField.text;
    _newAccount.password = passField.text;
    _newAccount.serverAddress = serverField.text;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = NSLocalizedString(@"Logging in...", nil);
    [self.view addSubview:hud];
    [hud show:YES];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(login:) object:hud];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)login:(MBProgressHUD *)hud
{
    [_newAccount login];
    [self performSelectorOnMainThread:@selector(finishedLogin:) withObject:hud waitUntilDone:YES];
}

- (void)finishedLogin:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.delegate accountControllerDidSaveAccount:_newAccount];
    [self dismissModalViewControllerAnimated:YES];
}

@end
