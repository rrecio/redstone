//
//  OWAccountController.h
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"

@protocol OWAccountDelegate;

@interface OWAccountController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *serverField;
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) id<OWAccountDelegate> delegate;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end

@protocol OWAccountDelegate <NSObject>
- (void)accountControllerDidSaveAccount:(RKRedmine *)account;
@end
