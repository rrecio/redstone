//
//  OWAddProjectController.m
//  Redstone
//
//  Created by Rodrigo Recio on 28/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAddProjectController.h"
#import "MBProgressHUD.h"

@interface OWAddProjectController ()
{
    MBProgressHUD *hud;
}
@end

@implementation OWAddProjectController

@synthesize nameField, identifierField, descriptionField, account, delegate, project;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (project) {
        self.navigationItem.title = NSLocalizedString(@"Project Details", nil);
        nameField.text = project.name;
        identifierField.text = project.identifier;
        descriptionField.text = project.projectDescription;
    }
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneAction:(id)sender
{
    hud = [[MBProgressHUD alloc] initWithView:self.parentViewController.view];
    [self.parentViewController.view addSubview:hud];
    hud.labelText = NSLocalizedString(@"Saving project...", nil);
    [hud show:YES];
    [self postProject];
}

- (void)postProject
{
    if (!project) {
        project = [[RKProject alloc] init];
    }
    project.name = nameField.text;
    project.projectDescription = descriptionField.text;
    project.identifier = identifierField.text;
    BOOL result;
    if (!project.index) {
        result = [self.account postNewProject:project];
    } else {
        project.identifier = nil;
        result = [project postProjectUpdate];
    }
    [hud hide:YES];
    if (result) {
        [self.delegate addProjectControllerDidSave:result];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to create project" message:@"Could not create project. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

@end
