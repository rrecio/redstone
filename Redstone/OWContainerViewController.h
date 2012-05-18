//
//  OWContainerViewController.h
//  Redstone
//
//  Created by Tales Pinheiro De Andrade on 17/05/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWAccountsController;
@class OWTimeTrackController;

@interface OWContainerViewController : UIViewController

@property (strong, nonatomic) OWTimeTrackController *timeTrackerController;
@property (strong, nonatomic) OWAccountsController *accountsController;

- (id)initWithContentViewController:(UIViewController *)contentController;
@end
