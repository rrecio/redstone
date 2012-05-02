//
//  OWAddIssueController.m
//  Redstone
//
//  Created by Rodrigo Recio on 27/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWAddIssueController.h"
#import "RedmineKit.h"
#import "MBProgressHUD.h"
@interface OWAddIssueController ()
@end

@implementation OWAddIssueController
@synthesize project;
@synthesize subjectField;
@synthesize descriptionTextView;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [TestFlight passCheckpoint:@"Add New Issue"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.issue = [RKIssue new];
}

- (void)fetchUpdateOptions:(MBProgressHUD *)hud
{
    self.issueOptions = [project newIssueOptions];
    [self performSelectorOnMainThread:@selector(finishedUpdatingOptions:) withObject:hud waitUntilDone:NO];
}

- (void)saveIssue:(MBProgressHUD *)hud
{
    self.issue.subject = subjectField.text;
    self.issue.issueDescription = descriptionTextView.text;
    [self.project postNewIssue:self.issue];
    [self performSelectorOnMainThread:@selector(finishedSavingIssue:) withObject:hud waitUntilDone:NO];
}

- (NSString *)stringValueForIndex:(NSIndexPath *)indexPath
{
    NSString *stringValue = nil;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.issue.tracker.name == nil)
                {
                    self.issue.tracker = [self.issueOptions.trackers objectAtIndex:0];
                }
                stringValue = self.issue.tracker.name;
            }
                break;
            case 1:
            {
                if (subjectField.text == nil) {
                    stringValue = self.issue.subject;
                } else {
                    stringValue = subjectField.text;
                }
            }
                break;
            default:
                break;
        }
    } 
    if (indexPath.section == 1) {
        if (descriptionTextView.text == nil) {
            stringValue = self.issue.issueDescription;
        } else {
            stringValue = descriptionTextView.text;
        }
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.issue.status.name == nil)
                {
                    self.issue.status = [self.issueOptions.statuses objectAtIndex:0];
                }
                stringValue = self.issue.status.name;
            }
                break;
            case 1:
            {
                if (self.issue.priority.name == nil)
                {
                    self.issue.priority = [self.issueOptions.priorities objectAtIndex:0];
                }
                stringValue = self.issue.priority.name;
            }
                break;
            case 2:
                stringValue = self.issue.assignedTo.name;
                break;
            case 3:
                stringValue = self.issue.category.name;
                break;
            case 4:
                stringValue = self.issue.fixedVersion.name;
                break;
            case 5:
                stringValue = [self.issue.parentTask stringValue];
                break;
            case 6:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                stringValue = [dateFormatter stringFromDate:self.issue.startDate];
            }
                break;
            case 7:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                stringValue = [dateFormatter stringFromDate:self.issue.dueDate];
            }
                break;
            case 8:
            {
                if (self.issue.estimatedHours) {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    [numberFormatter setMaximumFractionDigits:2];
                    NSString *hours = ([self.issue.estimatedHours intValue] > 1) ? NSLocalizedString(@"hours", nil) : NSLocalizedString(@"hour", nil);
                    stringValue = [NSString stringWithFormat:@"%@ %@", [numberFormatter stringFromNumber:self.issue.estimatedHours], hours];
                }
            }
                break;
            case 9:
            {
                if (self.issue.doneRatio) stringValue = [NSString stringWithFormat:@"%@ %%", self.issue.doneRatio];
            }
                break;
            default:
                break;
        }
    }
    
    return stringValue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue identifier]) {
        [TestFlight passCheckpoint:[@"Add New Issue: " stringByAppendingString:[segue identifier]]];
    } else {
        NSLog(@"Add New Issue: prepared for a segue without an identifier");
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        UIStoryboardPopoverSegue *popSegue = (UIStoryboardPopoverSegue *)segue;
        OWListController *listController = [segue destinationViewController];
        popSegue.popoverController.popoverContentSize = CGSizeMake(320, listController.picker.frame.size.height);
        listController.list = self.issueOptions.trackers;
        listController.delegate = self;
        listController.identifier = [segue identifier];
        if (self.issue.tracker) {
            [listController.picker selectRow:[self.issueOptions.trackers indexOfObject:self.issue.tracker] inComponent:0 animated:NO];
        }
    } 
    if (indexPath.section == 2) {
        UIStoryboardPopoverSegue *popSegue = (UIStoryboardPopoverSegue *)segue;
        if ([[segue destinationViewController] isKindOfClass:[OWListController class]]) {
            OWListController *listController = (OWListController *)[segue destinationViewController];
            popSegue.popoverController.popoverContentSize = CGSizeMake(320, listController.picker.frame.size.height);
            listController.popoverController = popSegue.popoverController;
            listController.identifier = [segue identifier];
            listController.delegate = self;
            
            if ([[segue identifier] isEqualToString:@"ShowStatusList"]) {
                listController.list = self.issueOptions.statuses;
                [listController.picker selectRow:[self.issueOptions.statuses indexOfObject:self.issue.status] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowPriorityList"]) {
                listController.list = self.issueOptions.priorities;
                [listController.picker selectRow:[self.issueOptions.priorities indexOfObject:self.issue.priority] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowAssigneeList"]) {
                listController.list = self.issueOptions.assignableUsers;
                [listController.picker selectRow:[self.issueOptions.assignableUsers indexOfObject:self.issue.assignedTo] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowCategoryList"]) {
                if (self.issueOptions.categories.count > 0) {
                    listController.list = self.issueOptions.categories;
                } else {
                    listController.list = [NSArray arrayWithObject:[RKValue valueWithName:@"No categories available"]];
                }
                [listController.picker selectRow:[self.issueOptions.categories indexOfObject:self.issue.category] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowVersionList"]) {
                if (self.issueOptions.versions.count > 0) {
                    listController.list = self.issueOptions.versions;
                } else {
                    listController.list = [NSArray arrayWithObject:[RKValue valueWithName:@"No versions available"]];
                }
                [listController.picker selectRow:[self.issueOptions.versions indexOfObject:self.issue.fixedVersion] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowDoneRatioList"]) {
                listController.list = self.doneRatioValues;
                RKValue *doneRatio = [RKValue valueWithName:[NSString stringWithFormat:@"%@ %%", self.issue.doneRatio] andIndex:self.issue.doneRatio];
                [listController.picker selectRow:[self.doneRatioValues indexOfObject:doneRatio] inComponent:0 animated:NO];
            }
        }
        if ([[segue destinationViewController] isKindOfClass:[OWDatePickerController class]]) {
            OWDatePickerController *datePickerController = (OWDatePickerController *)[segue destinationViewController];
            popSegue.popoverController.popoverContentSize = CGSizeMake(320, datePickerController.datePicker.frame.size.height);
            datePickerController.popoverController = popSegue.popoverController;
            datePickerController.identifier = [segue identifier];
            datePickerController.delegate = self;
            if ([[segue identifier] isEqualToString:@"ShowEstimatedHours"]) {
                datePickerController.datePicker.countDownDuration = [self.issue.estimatedHours doubleValue]*3600;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self stringValueForIndex:indexPath];
        }
        if (indexPath.row == 1) {
            self.subjectField.text = [self stringValueForIndex:indexPath];
        }
    } 
    if (indexPath.section == 1) {
        self.descriptionTextView.text = [self stringValueForIndex:indexPath];
    } 
    if (indexPath.section == 2) {
        cell.detailTextLabel.text = [self stringValueForIndex:indexPath];
    }
    
    return cell;
}

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    if ([controller.identifier isEqualToString:@"ShowTrackerList"]) {
        self.issue.tracker = [controller.list objectAtIndex:index];
    }
    
    [super listController:controller didSelectItemOnIndex:index];
}


@end
