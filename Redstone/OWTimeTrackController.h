//
//  OWTimeTrackController.h
//  Redstone
//
//  Created by Tales Pinheiro De Andrade on 06/05/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWListController.h"
#import "OWIssueUpdateController.h"

@interface OWTimeTrackController : UIViewController <OWListDelegate, OWIssueUpdateDelegate>
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) UIButton *taskButton;
@property (strong, nonatomic) UILabel  *timeLabel;

- (void)play:(id)sender;
- (void)stop:(id)sender;
- (void)task:(id)sender;
@end
