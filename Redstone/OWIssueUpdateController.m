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
#import "RedmineKitManager.h"

@interface OWIssueUpdateController ()
@end

@implementation OWIssueUpdateController
{
    OWIssueMoreController *moreController;
}
@synthesize issue;
@synthesize notesTextView, commentsTextField, parentField;
@synthesize delegate;
@synthesize issueOptions;
@synthesize timeEntry;
@synthesize doneRatioValues;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    moreController = [[OWIssueMoreController alloc] init];
    commentsTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, 300, 40)];
    commentsTextField.textAlignment = UITextAlignmentRight;
    parentField = [[UITextField alloc] initWithFrame:CGRectMake(150, 10, 300, 40)];
    parentField.textAlignment = UITextAlignmentRight;
    notesTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 430, 200)];
    notesTextView.backgroundColor = [UIColor clearColor];
    notesTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    issue = [[RedmineKitManager sharedInstance] selectedIssue];    
    self.timeEntry = [[RKTimeEntry alloc] init];
    self.doneRatioValues = [[NSArray alloc] initWithObjects:[RKValue valueWithName:@"0 %" andIndex:[NSNumber numberWithInt:0]],
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
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (issueOptions) {
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [TestFlight passCheckpoint:@"Issue Update"];
    
    [super viewDidAppear:animated];
    
    if (!issueOptions) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = @"Loading issue options...";
        [self.view addSubview:hud];
        [hud show:YES];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchUpdateOptions:) object:hud];
        [[NSOperationQueue mainQueue] addOperation:op];
    }
}

#pragma mark - View Actions

- (IBAction)cancelAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
//    [self.delegate issueUpdateControllerDidDismissed:self];
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
    issueOptions = [issue updateOptions];
    [self performSelectorOnMainThread:@selector(finishedUpdatingOptions:) withObject:hud waitUntilDone:NO];
}

- (void)finishedUpdatingOptions:(MBProgressHUD *)hud
{
    [hud hide:YES];
    [self.tableView reloadData];
}

- (void)beginPostingTimeEntry
{
    [TestFlight passCheckpoint:@"Begin Posting Time Entry"];
    
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
    [TestFlight passCheckpoint:@"Posted Time Entry"];
    
    [hud hide:YES];
    [self beginSavingIssue];
}

- (void)beginSavingIssue
{
    [TestFlight passCheckpoint:@"Begin Updating Issue"];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Saving issue...";
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
    [TestFlight passCheckpoint:@"Issue Updated"];
    
    [hud hide:YES];
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate issueUpdateControllerDidDismissed:self];
}

#pragma mark - ListController and DatePickerController Delegate Methods

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if (controller.list.count > 0) {
        if ([controller.identifier isEqualToString:@"Status"]) {
            issue.status = [controller.list objectAtIndex:index];
        }
        if ([controller.identifier isEqualToString:@"Priority"]) {
            issue.priority = [controller.list objectAtIndex:index];
        }
        if ([controller.identifier isEqualToString:@"Assigned to"]) {
            issue.assignedTo = [controller.list objectAtIndex:index];
        }
        if ([controller.identifier isEqualToString:@"Category"]) {
            if (issueOptions.categories.count > 0) {
                issue.category = [controller.list objectAtIndex:index];
            }
        }
        if ([controller.identifier isEqualToString:@"Version"]) {
            if (issueOptions.versions.count > 0) {
                issue.fixedVersion = [controller.list objectAtIndex:index];
            }
        }
        if ([controller.identifier isEqualToString:@"% done"]) {
            issue.doneRatio = [[controller.list objectAtIndex:index] index];
        }
        if ([controller.identifier isEqualToString:@"Activity"]) {
            timeEntry.activity = [controller.list objectAtIndex:index];
        }
        [self.tableView reloadData];
    }
}

- (void)datePickerController:(OWDatePickerController *)controller didSelectDate:(NSDate *)date
{
    if (controller.valueChanged) {
        if ([controller.identifier isEqualToString:@"Estimated hours"]) {
            issue.estimatedHours = [NSNumber numberWithDouble:(controller.datePicker.countDownDuration/60)/60];
        }
        if ([controller.identifier isEqualToString:@"Spent"]) {
            timeEntry.hours = [NSNumber numberWithDouble:(controller.datePicker.countDownDuration/60)/60];
        }
        if ([controller.identifier isEqualToString:@"Start date"]) {
            issue.startDate = date;
        }
        if ([controller.identifier isEqualToString:@"Due date"]) {
            issue.dueDate = date;
        }
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1; // More (subject, tracker, description)
    if (section == 1) return 10; // other props.
    if (section == 2) return 3; // Time entry shit
    if (section == 3) return 1; // Notes
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0 ||
        (indexPath.section == 1 && indexPath.row != 5) ||
        (indexPath.section == 2 && indexPath.row != 2)) {
        static NSString *identifier = @"Cell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if (indexPath.section == 1 && indexPath.row == 5) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"ParentCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ParentCell"];
            }
            if (parentField.superview == nil) [cell.contentView addSubview:parentField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.section == 2 && indexPath.row == 2) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CommentsCell"];
            }
            if (commentsTextField.superview == nil) [cell.contentView addSubview:commentsTextField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.section == 3) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"NotesCell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NotesCell"];
            }
            if (notesTextView.superview == nil) [cell.contentView addSubview:notesTextView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.textLabel.text         = [self labelForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self stringValueForIndex:indexPath];
    cell.selectionStyle         = [self selectionStyleForIndexPath:indexPath];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *destinationController;
    
    if (indexPath.section == 0) {
        moreController.updateOptions = issueOptions;
        moreController.issue = issue;
        [self.navigationController pushViewController:moreController animated:YES];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row < 5 || indexPath.row > 8) {
            OWListController *listController = [[OWListController alloc] init];
            listController.list = [self listForIndexPath:indexPath];
            listController.delegate = self;
            [listController.picker selectRow:[self selectedRowForIndexPath:indexPath] inComponent:0 animated:NO];
            listController.identifier = [self labelForIndexPath:indexPath];
            destinationController = listController;
        }
        
        if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8) {
            OWDatePickerController *datePicker = [[OWDatePickerController alloc] init];
            datePicker.delegate = self;
            datePicker.identifier = [self labelForIndexPath:indexPath];
            if (indexPath.row == 8) {
                datePicker.datePicker.countDownDuration = [timeEntry.hours doubleValue]*3600;
            }
            
            destinationController = datePicker;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            OWListController *listController = [[OWListController alloc] init];
            listController.list = [self listForIndexPath:indexPath];
            listController.delegate = self;
            [listController.picker selectRow:[self selectedRowForIndexPath:indexPath] inComponent:0 animated:NO];
            listController.identifier = [self labelForIndexPath:indexPath];
            destinationController = listController;
        }
        if (indexPath.row == 1) {
            OWDatePickerController *datePicker = [[OWDatePickerController alloc] init];
            datePicker.delegate = self;
            datePicker.datePicker.countDownDuration = [timeEntry.hours doubleValue]*3600;
            datePicker.identifier = [self labelForIndexPath:indexPath];
            destinationController = datePicker;
        }
    }
    
    [self.navigationController pushViewController:destinationController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return @"Time Entry";
    }
    if (section == 3) {
        return @"Issue Update Notes";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) return 220.0;
    return 44.0;
}

#pragma mark - Helper methods

- (NSArray *)listForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {            
        if (indexPath.row == 0) return issueOptions.statuses;
        if (indexPath.row == 1) return issueOptions.priorities;
        if (indexPath.row == 2) return issueOptions.assignableUsers;
        if (indexPath.row == 3) {
            if (issueOptions.categories.count > 0) {
                return issueOptions.categories;
            } else {
                return [NSArray arrayWithObject:[RKValue valueWithName:@"No categories available"]];
            }
        }
        if (indexPath.row == 4) {
            if (issueOptions.versions.count > 0) {
                return issueOptions.versions;
            } else {
                return [NSArray arrayWithObject:[RKValue valueWithName:@"No versions available"]];
            }
        }
        if (indexPath.row == 9) return doneRatioValues;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) return issueOptions.activities;        
    }
    return nil;
}

- (UITableViewCellSelectionStyle)selectionStyleForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 &&
        indexPath.row == 5) {
        return UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 2 &&
        indexPath.row == 2) {
        return UITableViewCellSelectionStyleNone;
    }
    
    return UITableViewCellSelectionStyleBlue;
}

- (NSString *)labelForIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == 0) return @"More";
    if (indexPath.section == 1) {
        if (indexPath.row == 0) return @"Status";
        if (indexPath.row == 1) return @"Priority";
        if (indexPath.row == 2) return @"Assigned to";
        if (indexPath.row == 3) return @"Category";
        if (indexPath.row == 4) return @"Version";
        if (indexPath.row == 5) return @"Parent issue";
        if (indexPath.row == 6) return @"Start date";
        if (indexPath.row == 7) return @"Due date";
        if (indexPath.row == 8) return @"Estimated hours";
        if (indexPath.row == 9) return @"% done";
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) return @"Activity";
        if (indexPath.row == 1) return @"Spent";
        if (indexPath.row == 2) return @"Comment";
    }
    return nil;
}

- (NSUInteger)selectedRowForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) return [issueOptions.statuses indexOfObject:issue.status];
        if (indexPath.row == 1) return [issueOptions.priorities indexOfObject:issue.priority];
        if (indexPath.row == 2) return [issueOptions.assignableUsers indexOfObject:issue.assignedTo];
        if (indexPath.row == 3) return [issueOptions.categories indexOfObject:issue.category];
        if (indexPath.row == 4) return [issueOptions.versions indexOfObject:issue.fixedVersion];
        if (indexPath.row == 9) {
            RKValue *doneRatio = [RKValue valueWithName:[NSString stringWithFormat:@"%@ %%", issue.doneRatio] andIndex:issue.doneRatio];
            return [doneRatioValues indexOfObject:doneRatio];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) return [issueOptions.activities indexOfObject:timeEntry.activity];
    }
    return 0;
}

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
                    if (issueOptions.activities.count > 0) {
                        stringValue = [[issueOptions.activities objectAtIndex:0] name];
                    }
                }
                break;
            default:
                break;
        }
    }
    return stringValue;
}


@end
