//
//  OWIssueUpdateController.h
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"
#import "OWListController.h"
#import "OWDatePickerController.h"

@protocol OWIssueUpdateDelegate;

@interface OWIssueUpdateController : UITableViewController <OWListDelegate, OWDatePickerControllerDelegate>

@property (strong, nonatomic) RKIssue *issue;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UITextField *commentsTextField;
@property (strong, nonatomic) id<OWIssueUpdateDelegate> delegate;
@property (strong, nonatomic) RKIssueOptions *issueOptions;
@property (strong, nonatomic) RKTimeEntry *timeEntry;
@property (strong, nonatomic) NSArray *doneRatioValues;

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (NSString *)stringValueForIndex:(NSIndexPath *)indexPath;
- (UITableViewCell *)myTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol OWIssueUpdateDelegate <NSObject>

- (void)issueUpdateControllerDidDismissed:(OWIssueUpdateController *)issueUpdateController;
@end