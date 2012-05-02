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

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        subjectField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, 160, 20)];
        subjectField.placeholder = @"Subject";
        subjectField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 400)];
        descriptionTextView.backgroundColor = [UIColor clearColor];
        descriptionTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

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

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    issue.tracker = [controller.list objectAtIndex:index];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) return 420;
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *trackerCell;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:trackerCell];
        cell.detailTextLabel.text = issue.tracker.name;
        cell.textLabel.text = @"Tracker";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        static NSString *subjectCell;        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:subjectCell];
        [cell.contentView addSubview:subjectField];
        cell.textLabel.text = @"Subject";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 2) {
        static NSString *descCell;        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:descCell];
        [cell.contentView addSubview:descriptionTextView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) return @"Description";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OWListController *listController = [[OWListController alloc] init];
        listController.delegate = self;
        listController.list = updateOptions.trackers;
        [listController.picker selectRow:[updateOptions.trackers indexOfObject:issue.tracker] inComponent:0 animated:NO];
        [self.navigationController pushViewController:listController animated:YES];
    }
}

@end
