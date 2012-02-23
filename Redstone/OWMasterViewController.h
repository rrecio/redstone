//
//  OWMasterViewController.h
//  Redstone
//
//  Created by Rodrigo Recio on 22/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWDetailViewController;

@interface OWMasterViewController : UITableViewController

@property (strong, nonatomic) OWDetailViewController *detailViewController;

@end
