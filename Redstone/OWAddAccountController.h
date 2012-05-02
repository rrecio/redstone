//
//  OWAddAccountController.h
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedmineKit.h"

@protocol OWAddAccountDelegate;

@interface OWAddAccountController : UITableViewController

@property (strong, nonatomic) UITextField *serverField;
@property (strong, nonatomic) UITextField *userField;
@property (strong, nonatomic) UITextField *passField;
@property (strong, nonatomic) id<OWAddAccountDelegate> delegate;

- (void)doneAction:(id)sender;
- (void)cancelAction:(id)sender;

@end

@protocol OWAddAccountDelegate <NSObject>
- (void)accountControllerDidSaveAccount:(RKRedmine *)account;
@end
