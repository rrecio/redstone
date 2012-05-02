//
//  OWAccountsController.m
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAccountsController.h"
#import "OWAddAccountController.h"
#import "OWIssuesController.h"
#import "RedmineKitManager.h"
#import "RedmineKit.h"
#import "OWProjectsController.h"

@interface OWAccountsController () 
{
    RedmineKitManager *workflowManager;
}
@end

@implementation OWAccountsController

@synthesize tarefasController = _tarefasController;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Accounts";
    }
    return self;
}

- (void)addButtonTapped:(id)sender
{
    OWAddAccountController *addController = [[OWAddAccountController alloc] init];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(accountWasSaved:) name:@"RKAccountSaved" object:addController];
    
    UINavigationController *addNavController = [[UINavigationController alloc] initWithRootViewController:addController];
    addNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:addNavController animated:YES];
}

- (void)accountWasSaved:(id)sender
{
    NSLog(@"ACCOUNT SAVED!!!!!!!");
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    workflowManager = [RedmineKitManager sharedInstance];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }

    UINavigationController *nav = (UINavigationController *)[self.splitViewController.viewControllers lastObject];
    [nav pushViewController:_tarefasController animated:NO];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [TestFlight passCheckpoint:@"Account Menu"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return workflowManager.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    RKRedmine *account = [workflowManager.accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = account.username;
    cell.detailTextLabel.text = account.serverAddress;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKRedmine *account = [workflowManager.accounts objectAtIndex:indexPath.row];
    workflowManager.selectedAccount = account;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    OWProjectsController *projectsController = [[OWProjectsController alloc] init];
    [self.navigationController pushViewController:projectsController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RKRedmine *account = [workflowManager.accounts objectAtIndex:indexPath.row];
        [workflowManager removeAccount:account];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
