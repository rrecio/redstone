//
//  OWTarefasController.m
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssuesController.h"
#import "MBProgressHUD.h"
#import "OWIssueCell.h"
#import "OWAddIssueController.h"
#import "OWIssueController.h"
#import <QuartzCore/QuartzCore.h>
#import "RedmineKitManager.h"

@interface OWIssuesController ()
{
    RedmineKitManager *manager;
    BOOL _reconfigureViewWhenItAppear;
    OWIssueController *issueController;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation OWIssuesController

@synthesize masterPopoverController = _masterPopoverController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    issueController = [[OWIssueController alloc] init];
    manager = [RedmineKitManager sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectWasSelected:) name:@"RKProjectSelected" object:nil];
}

- (void)projectWasSelected:(id)sender
{
    [self setSelectedProject:manager.selectedProject];
}

#pragma mark - Managing the detail item

- (void)setSelectedProject:(RKProject *)newSectedProject
{
    [self.tableView reloadData];
    
    // Update the view.
    if (self.navigationController.topViewController == self) {
        [self configureView];
    } else {
        _reconfigureViewWhenItAppear = YES;
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (manager.selectedProject) {
        self.navigationItem.title = manager.selectedProject.name;

        // ...
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = NSLocalizedString(@"Loading issues...", nil);
        [self.view addSubview:hud];
        [hud show:YES];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadIssues:) object:hud];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

- (void)loadIssues:(MBProgressHUD *)hud
{
    NSArray *issues = manager.selectedProject.issues;
    if (issues != nil) {
        [self performSelectorOnMainThread:@selector(finishedLoadingIssues:) withObject:hud waitUntilDone:YES];
    } else {
        [self performSelectorOnMainThread:@selector(finishedLoadingIssuesWithError:) withObject:hud waitUntilDone:YES];
    }
}

- (void)finishedLoadingIssues:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
}

- (void)finishedLoadingIssuesWithError:(MBProgressHUD *)hud
{
    [hud hide:YES];
    NSLog(@"Error loading issues: returned nil (OWIssuesController class)");
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_reconfigureViewWhenItAppear || issueController.hasChanges) {
        [self configureView];
        _reconfigureViewWhenItAppear = NO;
    }
    
    [TestFlight passCheckpoint:@"Project's Issues List"];
}

-(IBAction)launchFeedback {
    [TestFlight openFeedbackView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
        return YES;
//    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Projects", nil);
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Table View delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [manager.selectedProject.issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKIssue *issue = [manager.selectedProject.issues objectAtIndex:indexPath.row];
    static NSString *identifier = @"Cell";
    OWIssueCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OWIssueCell" owner:self options:NULL];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.subjectLabel.text      = issue.subject;
    cell.dateCreatedLabel.text  = [RKParseHelper shortDateStringFromDate:issue.createdOn];
    cell.descriptionLabel.text  = issue.issueDescription;
    cell.trackerLabel.text      = [NSString stringWithFormat:@"%@ #%@", issue.tracker.name, issue.index];
    cell.indexLabel.text        = [issue.index stringValue];
    cell.authorLabel.text       = issue.author.name;
    cell.assignedToLabel.text   = issue.assignedTo.name;
    cell.statusLabel.text       = issue.status.name;
    cell.startLabel.text        = [RKParseHelper shortDateStringFromDate:issue.startDate];
    cell.priorityLabel.text     = issue.priority.name;
    cell.versionLabel.text      = issue.fixedVersion.name;
    cell.dueLabel.text          = [RKParseHelper shortDateStringFromDate:issue.dueDate];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.row+1 == [manager.selectedProject.issues count]) {
        cell.backgroundView.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.backgroundView.layer.shadowOffset = CGSizeMake(0, 10);
        cell.backgroundView.layer.shadowOpacity = 0.50;
        cell.selectedBackgroundView.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    } else {
        cell.backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
        cell.backgroundView.layer.shadowColor = [[UIColor clearColor] CGColor];
        cell.backgroundView.layer.shadowOpacity = 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    manager.selectedIssue = [manager.selectedProject.issues objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:issueController animated:YES];
}

@end
