//
//  OWTarefasController.h
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"
#import "OWIssueUpdateController.h"

@interface OWIssuesController : UITableViewController <UISplitViewControllerDelegate, OWIssueUpdateDelegate>

@property (strong, nonatomic) RKProject *selectedProject;

@end
