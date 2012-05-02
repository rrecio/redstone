//
//  OWAddAccountController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAddAccountController.h"
#import "MBProgressHUD.h"
#import "RedmineKitManager.h"

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

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [TestFlight passCheckpoint:@"Add Account"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
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

#pragma mark - Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"Username";
            userField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, cell.contentView.frame.size.width - cell.textLabel.frame.size.width - 20, 40)];
            NSLog(@"frame %@", NSStringFromCGRect(userField.frame));
            userField.placeholder = @"Type username here";
            [cell.contentView addSubview:userField];
            break;
        case 1:
            cell.textLabel.text = @"Password";
            passField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, cell.contentView.frame.size.width - cell.textLabel.frame.size.width - 20, 40)];
            passField.placeholder = @"Here goes your pass";
            [cell.contentView addSubview:passField];
            break;
        case 2:
            cell.textLabel.text = @"Server Address";
            serverField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, cell.contentView.frame.size.width - cell.textLabel.frame.size.width - 20, 40)];;
            serverField.placeholder = @"Ex.: http://myredmineserver.com";
            [cell.contentView addSubview:serverField];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate methods

- (void)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneAction:(id)sender
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
    if (_newAccount.apiKey == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to fetch Redmine's API key." message:@"It looks like the REST web service access is not activated." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        [[RedmineKitManager sharedInstance] addAccount:_newAccount];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RKAccountSaved" object:self];
        
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
