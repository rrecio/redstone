//
//  OWTarefasController.m
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssuesController.h"
#import "MBProgressHUD.h"
#import "OWTarefaCell.h"
#import "OWAddIssueController.h"
#import "OWIssueController.h"
#import <QuartzCore/QuartzCore.h>

@interface OWIssuesController ()
{
    NSMutableArray *_issues;
    BOOL _reconfigureViewWhenItAppear;
    OWIssueController *issueController;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation OWIssuesController

@synthesize selectedProject = _selectedProject;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setSelectedProject:(RKProject *)newSectedProject
{
    if (_selectedProject != newSectedProject) {
        _selectedProject = newSectedProject;
        _issues = nil;
        [self.tableView reloadData];
        
        // Update the view.
        if (self.navigationController.topViewController == self) {
            [self configureView];
        } else {
            _reconfigureViewWhenItAppear = YES;
        }
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (_selectedProject) {
        self.navigationItem.title = _selectedProject.name;

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
    _issues = _issues ? [_selectedProject refreshIssues] : [_selectedProject issues];
    [self performSelectorOnMainThread:@selector(finishedLoadingIssues:) withObject:hud waitUntilDone:YES];
}

- (void)finishedLoadingIssues:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.parentViewController.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
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
    return _issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKIssue *issue = [_issues objectAtIndex:indexPath.row];
    
    OWTarefaCell *cell = nil;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
   
    cell.subjectLabel.text      = issue.subject;
    cell.trackerLabel.text      = issue.tracker.name;
    cell.indexLabel.text        = [issue.index stringValue];
    cell.authorLabel.text       = issue.author.name;
    cell.assignedToLabel.text   = issue.assignedTo.name;
    cell.statusLabel.text       = issue.status.name;
    cell.startLabel.text        = [RKParseHelper shortDateStringFromDate:issue.startDate];
    cell.priorityLabel.text     = issue.priority.name;
    cell.versionLabel.text      = issue.fixedVersion.name;
    cell.dueLabel.text          = [RKParseHelper shortDateStringFromDate:issue.dueDate];
    
    if (![cell.backgroundView isKindOfClass:[UIImageView class]]) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg"]];
        cell.backgroundView.userInteractionEnabled = NO;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKIssue *issue = [_issues objectAtIndex:indexPath.row];
    NSLog(@"%@", [issue description]);
    
    if (indexPath.row+1 == [_issues count]) {
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
    NSLog(@"tableview didselect");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowIssue"]) {
        issueController = (OWIssueController *)[segue destinationViewController];
        RKIssue *selectedIssue = [_issues objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        issueController.issue = selectedIssue;
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    if ([[segue identifier] isEqualToString:@"AddNewIssue"]) {
        UINavigationController *nav = [segue destinationViewController];
        OWAddIssueController *addIssueController = (OWAddIssueController *)[nav topViewController];
        addIssueController.delegate = self;
        addIssueController.project = self.selectedProject;
    }
}

- (void)issueUpdateControllerDidDismissed:(OWIssueUpdateController *)issueUpdateController
{
    [self configureView];
}

@end
