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

@synthesize nameField, identifierField, descriptionField, account, delegate;

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
    [self postNewProject];
}

- (void)postNewProject
{
    RKProject *newProject = [[RKProject alloc] init];
    newProject.name = nameField.text;
    newProject.identifier = identifierField.text;
    newProject.projectDescription = descriptionField.text;
    BOOL result = [self.account postNewProject:newProject];
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
