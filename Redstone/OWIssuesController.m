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
#import "OWIssueUpdateController.h"
#import "OWAddIssueController.h"

@interface OWIssuesController ()
{
    NSMutableArray *_issues;
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
        [self configureView];
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
    _issues = [_selectedProject issues];
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
    
    [TestFlight passCheckpoint:@"Project's Issues List"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
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
    barButtonItem.title = NSLocalizedString(@"Projetos", nil);
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
    static NSString *cellId = @"Cell";
    OWTarefaCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    RKIssue *issue = [_issues objectAtIndex:indexPath.row];
    cell.subjectLabel.text = issue.subject;
    cell.indexLabel.text = [NSString stringWithFormat:@"#%@", issue.index];
    cell.trackerLabel.text = issue.tracker.name;
    cell.statusLabel.text = issue.status.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowIssue"]) {
        UINavigationController *nav = [segue destinationViewController];
        OWIssueUpdateController *issueUpdateController = (OWIssueUpdateController *)[nav topViewController];
        RKIssue *selectedIssue = [_issues objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        issueUpdateController.issue = selectedIssue;
        issueUpdateController.delegate = self;
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
