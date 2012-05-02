//
//  OWProjectsController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RedmineKit.h"
#import "OWProjectsController.h"
#import "OWAccountsController.h"
#import "OWIssuesController.h"
#import "MBProgressHUD.h"
#import "OWIssueController.h"
#import "OWAddProjectController.h"
#import "RedmineKitManager.h"

@interface OWProjectsController ()
{
    RedmineKitManager *workflowManager;
}
@end

@implementation OWProjectsController

# pragma mark - Initializing

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    workflowManager = [RedmineKitManager sharedInstance];
    self.title = @"Projects";
    
    return self;
}

# pragma mark - UIView goodness

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (workflowManager.selectedAccount.projects != nil) {
        [self loadProjects];
    }
    
    [TestFlight passCheckpoint:@"Projects List"];   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *navController = (UINavigationController *)[splitController.viewControllers lastObject];
    if ([navController.topViewController isKindOfClass:[OWIssuesController class]]) {
        [workflowManager setSelectedProject:nil];
    }
    if ([navController.topViewController isKindOfClass:[OWIssueController class]]) {
        [navController popViewControllerAnimated:YES];
        [workflowManager setSelectedProject:nil];
    }
}

# pragma mark - Projects loading shit

- (void)loadProjects
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading projects...";
    [self.view addSubview:hud];
    [hud show:YES];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(beginFetchingProjects:) object:hud];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)beginFetchingProjects:(MBProgressHUD *)hud
{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(finishedFetchingProjects:) withObject:hud waitUntilDone:NO];
}

- (void)finishedFetchingProjects:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
}


# pragma mark - Table view delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return workflowManager.selectedAccount.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    RKProject *project = [workflowManager.selectedAccount.projects objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == [workflowManager.selectedAccount.projects count]) {
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
    RKProject *selectedProject = [workflowManager.selectedAccount.projects objectAtIndex:indexPath.row];
    workflowManager.selectedProject = selectedProject;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RKProjectSelected" object:nil];
    
    UINavigationController *navController = (UINavigationController *)splitController.viewControllers.lastObject;
    if ([navController.topViewController isKindOfClass:[OWIssueController class]]) {
        [navController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AddNewProject" sender:indexPath];
}

@end
