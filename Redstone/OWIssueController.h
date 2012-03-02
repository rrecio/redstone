//
//  OWIssueController.h
//  Redstone
//
//  Created by Rodrigo Recio on 02/03/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"
#import "OWIssueUpdateController.h"

@interface OWIssueController : UITableViewController <OWIssueUpdateDelegate>

@property (nonatomic, copy) RKIssue *issue;
@property (nonatomic) BOOL hasChanges;

@end
