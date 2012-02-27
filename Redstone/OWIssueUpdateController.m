//
//  OWIssueUpdateController.m
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssueUpdateController.h"
#import "OWListController.h"
#import "MBProgressHUD.h"
#import "OWDatePickerController.h"
#import "OWIssueMoreController.h"

@interface OWIssueUpdateController ()
{
    RKIssueOptions *updateOptions;
    RKTimeEntry *timeEntry;
    NSArray *doneRatioValues;
}
- (NSString *)stringValueForIndex:(NSIndexPath *)indexPath;
@end

@implementation OWIssueUpdateController

@synthesize issue;
@synthesize notesTextView, commentsTextField;
@synthesize delegate;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeEntry = [[RKTimeEntry alloc] init];
    doneRatioValues = [[NSArray alloc] initWithObjects:[RKValue valueWithName:@"0 %" andIndex:[NSNumber numberWithInt:0]],
                       [RKValue valueWithName:@"10 %" andIndex:[NSNumber numberWithInt:10]],
                       [RKValue valueWithName:@"20 %" andIndex:[NSNumber numberWithInt:20]],
                       [RKValue valueWithName:@"30 %" andIndex:[NSNumber numberWithInt:30]],
                       [RKValue valueWithName:@"40 %" andIndex:[NSNumber numberWithInt:40]],
                       [RKValue valueWithName:@"50 %" andIndex:[NSNumber numberWithInt:50]],
                       [RKValue valueWithName:@"60 %" andIndex:[NSNumber numberWithInt:60]],
                       [RKValue valueWithName:@"70 %" andIndex:[NSNumber numberWithInt:70]],
                       [RKValue valueWithName:@"80 %" andIndex:[NSNumber numberWithInt:80]],
                       [RKValue valueWithName:@"90 %" andIndex:[NSNumber numberWithInt:90]],
                       [RKValue valueWithName:@"100 %" andIndex:[NSNumber numberWithInt:100]], nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!updateOptions) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = @"Loading update options...";
        [self.view addSubview:hud];
        [hud show:YES];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchUpdateOptions:) object:hud];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        OWIssueMoreController *moreController = [segue destinationViewController];
        moreController.updateOptions = updateOptions;
        moreController.issue = issue;
    } 
    if (indexPath.section == 1) {
        UIStoryboardPopoverSegue *popSegue = (UIStoryboardPopoverSegue *)segue;
        if ([[segue destinationViewController] isKindOfClass:[OWListController class]]) {
            OWListController *listController = (OWListController *)[segue destinationViewController];
            popSegue.popoverController.popoverContentSize = CGSizeMake(320, listController.picker.frame.size.height);
            listController.popoverController = popSegue.popoverController;
            listController.identifier = [segue identifier];
            listController.delegate = self;
            
            if ([[segue identifier] isEqualToString:@"ShowStatusList"]) {
                listController.list = updateOptions.statuses;
                [listController.picker selectRow:[updateOptions.statuses indexOfObject:issue.status] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowPriorityList"]) {
                listController.list = updateOptions.priorities;
                [listController.picker selectRow:[updateOptions.priorities indexOfObject:issue.priority] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowAssigneeList"]) {
                listController.list = updateOptions.assignableUsers;
                [listController.picker selectRow:[updateOptions.assignableUsers indexOfObject:issue.assignedTo] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowCategoryList"]) {
                if (updateOptions.categories.count > 0) {
                    listController.list = updateOptions.categories;
                } else {
                    listController.list = [NSArray arrayWithObject:[RKValue valueWithName:@"No categories available"]];
                }
                [listController.picker selectRow:[updateOptions.categories indexOfObject:issue.category] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowVersionList"]) {
                if (updateOptions.versions.count > 0) {
                    listController.list = updateOptions.versions;
                } else {
                    listController.list = [NSArray arrayWithObject:[RKValue valueWithName:@"No versions available"]];
                }
                [listController.picker selectRow:[updateOptions.versions indexOfObject:issue.fixedVersion] inComponent:0 animated:NO];
            }
            if ([[segue identifier] isEqualToString:@"ShowDoneRatioList"]) {
                listController.list = doneRatioValues;
                RKValue *doneRatio = [RKValue valueWithName:[NSString stringWithFormat:@"%@ %%", issue.doneRatio] andIndex:issue.doneRatio];
                [listController.picker selectRow:[doneRatioValues indexOfObject:doneRatio] inComponent:0 animated:NO];
            }
        }
        if ([[segue destinationViewController] isKindOfClass:[OWDatePickerController class]]) {
            OWDatePickerController *datePickerController = (OWDatePickerController *)[segue destinationViewController];
            popSegue.popoverController.popoverContentSize = CGSizeMake(320, datePickerController.datePicker.frame.size.height);
            datePickerController.popoverController = popSegue.popoverController;
            datePickerController.identifier = [segue identifier];
            datePickerController.delegate = self;
            if ([[segue identifier] isEqualToString:@"ShowEstimatedHours"]) {
                datePickerController.datePicker.countDownDuration = [issue.estimatedHours doubleValue]*3600;
            }
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

            if ([[segue identifier] isEqualToString:@"ShowActivityList"]) {
                listController.list = updateOptions.activities;
                [listController.picker selectRow:[updateOptions.activities indexOfObject:timeEntry.activity] inComponent:0 animated:NO];
            }
        }
        if ([[segue destinationViewController] isKindOfClass:[OWDatePickerController class]]) {
            OWDatePickerController *datePickerController = (OWDatePickerController *)[segue destinationViewController];
            popSegue.popoverController.popoverContentSize = CGSizeMake(320, datePickerController.datePicker.frame.size.height);
            datePickerController.popoverController = popSegue.popoverController;
            datePickerController.identifier = [segue identifier];
            datePickerController.delegate = self;
            if ([[segue identifier] isEqualToString:@"ShowSpentHours"]) {
                datePickerController.datePicker.countDownDuration = [timeEntry.hours doubleValue]*3600;
            }
        }
    }
}

#pragma mark - View Actions

- (IBAction)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate issueUpdateControllerDidDismissed:self];
}

- (IBAction)doneAction:(id)sender
{
    [self.notesTextView resignFirstResponder];
    [self.commentsTextField resignFirstResponder];
    
    if (timeEntry.hours != nil) {
        if (timeEntry.activity == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log time is invalid" message:@"Activity can't be blank" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            return;
        } else {
            [self beginPostingTimeEntry];
        }
    } else {
        [self beginSavingIssue];
    }
}

#pragma mark - NSOperations calls and callbacks

- (void)fetchUpdateOptions:(MBProgressHUD *)hud
{
    updateOptions = [issue updateOptions];
    [self performSelectorOnMainThread:@selector(finishedUpdatingOptions:) withObject:hud waitUntilDone:NO];
}

- (void)finishedUpdatingOptions:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
}

- (void)beginPostingTimeEntry
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Posting time entry...";
    [self.view addSubview:hud];
    [hud show:YES];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(postTimeEntry:) object:hud];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)postTimeEntry:(MBProgressHUD *)hud
{
    timeEntry.comments = commentsTextField.text;
    [issue postTimeEntry:timeEntry];
    [self performSelectorOnMainThread:@selector(finishedPostingTimeEntry:) withObject:hud waitUntilDone:NO];
}

- (void)finishedPostingTimeEntry:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self beginSavingIssue];
}

- (void)beginSavingIssue
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Posting issue update...";
    [self.view addSubview:hud];
    [hud show:YES];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveIssue:) object:hud];
    [[NSOperationQueue mainQueue] addOperation:op];
}

- (void)saveIssue:(MBProgressHUD *)hud
{
    [issue postUpdateWithNotes:notesTextView.text];
    [self performSelectorOnMainThread:@selector(finishedSavingIssue:) withObject:hud waitUntilDone:NO];
}

- (void)finishedSavingIssue:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate issueUpdateControllerDidDismissed:self];
}

#pragma mark - Helper methods

- (NSString *)stringValueForIndex:(NSIndexPath *)indexPath
{
    NSString *stringValue = nil;

    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                stringValue = issue.status.name;
                break;
            case 1:
                stringValue = issue.priority.name;
                break;
            case 2:
                stringValue = issue.assignedTo.name;
                break;
            case 3:
                stringValue = issue.category.name;
                break;
            case 4:
                stringValue = issue.fixedVersion.name;
                break;
            case 5:
                stringValue = [issue.parentTask stringValue];
                break;
            case 6:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                stringValue = [dateFormatter stringFromDate:issue.startDate];
            }
                break;
            case 7:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                stringValue = [dateFormatter stringFromDate:issue.dueDate];
            }
                break;
            case 8:
            {
                if (issue.estimatedHours) {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    [numberFormatter setMaximumFractionDigits:2];
                    NSString *hours = ([issue.estimatedHours intValue] > 1) ? NSLocalizedString(@"hours", nil) : NSLocalizedString(@"hour", nil);
                    stringValue = [NSString stringWithFormat:@"%@ %@", [numberFormatter stringFromNumber:issue.estimatedHours], hours];
                }
            }
                break;
            case 9:
                stringValue = [NSString stringWithFormat:@"%@ %%", issue.doneRatio];
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                if (timeEntry.hours) {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setLocale:[NSLocale currentLocale]];
                    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                    [numberFormatter setMaximumFractionDigits:2];
                    NSString *hours = ([timeEntry.hours intValue] > 1) ? NSLocalizedString(@"hours", nil) : NSLocalizedString(@"hour", nil);
                    stringValue = [NSString stringWithFormat:@"%@ %@", [numberFormatter stringFromNumber:timeEntry.hours], hours];
                }
            }
                break;
            case 1:
                if (timeEntry.activity.name != nil || [timeEntry.activity.name isEqualToString:@""]) {
                    stringValue = timeEntry.activity.name;
                } else {
                    if (updateOptions.activities.count > 0) {
                        stringValue = [[updateOptions.activities objectAtIndex:0] name];
                    }
                }
                break;
            default:
                break;
        }
    }
    return stringValue;
}

#pragma mark - Delegate Methods

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    if ([controller.identifier isEqualToString:@"ShowStatusList"]) {
        issue.status = [controller.list objectAtIndex:index];
    }
    if ([controller.identifier isEqualToString:@"ShowPriorityList"]) {
        issue.priority = [controller.list objectAtIndex:index];
    }
    if ([controller.identifier isEqualToString:@"ShowAssigneeList"]) {
        issue.assignedTo = [controller.list objectAtIndex:index];
    }
    if ([controller.identifier isEqualToString:@"ShowCategoryList"]) {
        if (updateOptions.categories.count > 0) {
            issue.category = [controller.list objectAtIndex:index];
        }
    }
    if ([controller.identifier isEqualToString:@"ShowVersionList"]) {
        if (updateOptions.versions.count > 0) {
            issue.fixedVersion = [controller.list objectAtIndex:index];
        }
    }
    if ([controller.identifier isEqualToString:@"ShowVersionList"]) {
        issue.fixedVersion = [controller.list objectAtIndex:index];
    }
    if ([controller.identifier isEqualToString:@"ShowDoneRatioList"]) {
        issue.doneRatio = [[controller.list objectAtIndex:index] index];
    }
    if ([controller.identifier isEqualToString:@"ShowActivityList"]) {
        timeEntry.activity = [controller.list objectAtIndex:index];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}

- (void)datePickerController:(OWDatePickerController *)controller didSelectDate:(NSDate *)date
{
    if (controller.valueChanged) {
        if ([controller.identifier isEqualToString:@"ShowEstimatedHours"]) {
            issue.estimatedHours = [NSNumber numberWithDouble:(controller.datePicker.countDownDuration/60)/60];
        }
        if ([controller.identifier isEqualToString:@"ShowSpentHours"]) {
            timeEntry.hours = [NSNumber numberWithDouble:(controller.datePicker.countDownDuration/60)/60];
        }
        if ([controller.identifier isEqualToString:@"ShowStartDate"]) {
            issue.startDate = date;
        }
        if ([controller.identifier isEqualToString:@"ShowDueDate"]) {
            issue.dueDate = date;
        }
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ #%@: %@", issue.tracker.name, issue.index, issue.subject];
    } else {
        cell.detailTextLabel.text = [self stringValueForIndex:indexPath];
    }

    return cell;
}

@end
