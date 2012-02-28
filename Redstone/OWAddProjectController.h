//
//  OWAddProjectController.h
//  Redstone
//
//  Created by Rodrigo Recio on 28/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"

@protocol OWAddProjectDelegate <NSObject>
- (void)addProjectControllerDidSave:(BOOL)result;
@end

@interface OWAddProjectController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *identifierField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;
@property (strong, nonatomic) RKRedmine *account;
@property (strong, nonatomic) id<OWAddProjectDelegate> delegate;

@end