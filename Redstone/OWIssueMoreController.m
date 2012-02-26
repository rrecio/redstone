//
//  OWIssueMoreController.m
//  Redstone
//
//  Created by Rodrigo Recio on 26/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssueMoreController.h"

@interface OWIssueMoreController ()

@end

@implementation OWIssueMoreController
@synthesize issue, subjectField, descriptionTextView, updateOptions;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    subjectField.text = issue.subject;
    descriptionTextView.text = issue.issueDescription;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    issue.subject = subjectField.text;
    issue.issueDescription = descriptionTextView.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIStoryboardPopoverSegue *popSegue = (UIStoryboardPopoverSegue *)segue;
    OWListController *listController = (OWListController *)[segue destinationViewController];
    popSegue.popoverController.popoverContentSize = CGSizeMake(320, listController.picker.frame.size.height);
    listController.popoverController = popSegue.popoverController;
    listController.identifier = [segue identifier];
    listController.delegate = self;
    listController.list = updateOptions.trackers;
    [listController.picker selectRow:[updateOptions.trackers indexOfObject:issue.tracker] inComponent:0 animated:NO];
}

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    issue.tracker = [controller.list objectAtIndex:index];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = issue.tracker.name;
    }
    
    return cell;
}

@end
