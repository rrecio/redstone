//
//  OWProjectsController.h
//  Redstone
//
//  Created by Rodrigo Recio on 23/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedmineKit.h"
#import "OWAddProjectController.h"

@interface OWProjectsController : UITableViewController <OWAddProjectDelegate>;

@property (strong, nonatomic) RKRedmine *account;
@property (strong, nonatomic) NSArray *projects;

@end
