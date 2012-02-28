//
//  OWAddIssueController.h
//  Redstone
//
//  Created by Rodrigo Recio on 27/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWIssueUpdateController.h"
@class RKProject;
@interface OWAddIssueController : OWIssueUpdateController
@property (strong, nonatomic) RKProject *project;
@property (strong, nonatomic) IBOutlet UITextField *subjectField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@end
