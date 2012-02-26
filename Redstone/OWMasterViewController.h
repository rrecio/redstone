//
//  OWMasterViewController.h
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWAccountController.h"

@class OWTarefasController;

@interface OWMasterViewController : UITableViewController <OWAccountDelegate>

@property (strong, nonatomic) OWTarefasController *tarefasController;

- (void)accountControllerDidSaveAccount:(OWAccountController *)accountController;

@end
