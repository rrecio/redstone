//
//  OWProjectsController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWProjectsController.h"
#import "OWAccountsController.h"
#import "OWIssuesController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "OWIssueController.h"

@implementation OWProjectsController

@synthesize account=_account;
@synthesize projects=_projects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.parentViewController.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [TestFlight passCheckpoint:@"Projects List"];
    
    [super viewDidAppear:animated];
    
    if (!_projects) {
        [self loadProjects];
    }
}

- (void)loadProjects
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading projects...";
    [self.view addSubview:hud];
    [hud show:YES];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchProjects:) object:hud];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *navController = (UINavigationController *)[(UITabBarController *)[splitController.viewControllers lastObject] selectedViewController];
    if ([navController.topViewController isKindOfClass:[OWIssuesController class]]) {
        OWIssuesController *tarefasController = (OWIssuesController *)[navController topViewController];
        [tarefasController setSelectedProject:nil];
    }
    if ([navController.topViewController isKindOfClass:[OWIssueController class]]) {
        [navController popViewControllerAnimated:YES];
        OWIssuesController *tarefasController = (OWIssuesController *)[navController topViewController];
        [tarefasController setSelectedProject:nil];
    }
}

- (void)fetchProjects:(MBProgressHUD *)hud
{
    NSArray *projects = _projects ? [_account refreshProjects] : [_account projects];
    [self performSelectorOnMainThread:@selector(setProjects:) withObject:projects waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(finishedFetchingProjects:) withObject:hud waitUntilDone:NO];
}

- (void)finishedFetchingProjects:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddNewProject"]) {
        UINavigationController *navController = [segue destinationViewController];
        OWAddProjectController *addProjectController = (OWAddProjectController *)[navController topViewController];
        addProjectController.account = self.account;
        addProjectController.delegate = self;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            addProjectController.project = [_projects objectAtIndex:indexPath.row];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    RKProject *project = [_projects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    
    if (![cell.backgroundView isKindOfClass:[UIImageView class]]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg"]];
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == [_projects count]) {
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
    UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    RKProject *selectedProject = [_projects objectAtIndex:indexPath.row];
    UINavigationController *navController = (UINavigationController *)[(UITabBarController *)splitController.viewControllers.lastObject selectedViewController];
    if ([navController.topViewController isKindOfClass:[OWIssuesController class]]) {
        OWIssuesController *issuesController = (OWIssuesController *)navController.topViewController;
        [issuesController setSelectedProject:selectedProject];
    }
    if ([navController.topViewController isKindOfClass:[OWIssueController class]]) {
        [navController popViewControllerAnimated:YES];
        OWIssuesController *issuesController = (OWIssuesController *)navController.topViewController;
        [issuesController setSelectedProject:selectedProject];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AddNewProject" sender:indexPath];
}

- (void)addProjectControllerDidSave:(BOOL)result
{
    if (result) [self loadProjects];
}

@end
