//
//  OWProjectsController.m
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWProjectsController.h"
#import "OWAccountsController.h"
#import "OWTarefasController.h"
#import "MBProgressHUD.h"

@implementation OWProjectsController

@synthesize account=_account;
@synthesize projects=_projects;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_projects) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = @"Loading projects...";
        [self.view addSubview:hud];
        [hud show:YES];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchProjects:) object:hud];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    OWTarefasController *tarefasController = (OWTarefasController *)[(UINavigationController *)[(UITabBarController *)[splitController.viewControllers lastObject] selectedViewController] topViewController];
    [tarefasController setSelectedProject:nil];
}

- (void)fetchProjects:(MBProgressHUD *)hud
{
    NSArray *projects = [_account projects];
    [self performSelectorOnMainThread:@selector(setProjects:) withObject:projects waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(finishedFetchingProjects:) withObject:hud waitUntilDone:NO];
}

- (void)finishedFetchingProjects:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
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
    cell.detailTextLabel.text = project.projectDescription;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation | UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UISplitViewController *splitController = (UISplitViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    RKProject *selectedProject = [_projects objectAtIndex:indexPath.row];
    OWTarefasController *tarefasController = (OWTarefasController *)[(UINavigationController *)[(UITabBarController *)[splitController.viewControllers lastObject] selectedViewController] topViewController];
    [tarefasController setSelectedProject:selectedProject];
}

@end
