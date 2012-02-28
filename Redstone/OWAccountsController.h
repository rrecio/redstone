//
//  OWAccountsController.h
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWAddAccountController.h"

@class OWIssuesController;

@interface OWAccountsController : UITableViewController <OWAddAccountDelegate>

@property (strong, nonatomic) OWIssuesController *tarefasController;

- (void)accountControllerDidSaveAccount:(OWAddAccountController *)accountController;

@end
