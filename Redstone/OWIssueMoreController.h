//
//  OWIssueMoreController.h
//  Redstone
//
//  Created by Rodrigo Recio on 26/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"
#import "OWListController.h"
@interface OWIssueMoreController : UITableViewController <OWListDelegate>
@property (strong, nonatomic) RKIssue *issue;
@property (strong, nonatomic) RKIssueOptions *updateOptions;
@property (strong, nonatomic) IBOutlet UITextField *subjectField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@end
