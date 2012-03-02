//
//  OWIssueOverviewCell.h
//  Redstone
//
//  Created by Rodrigo Recio on 02/03/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OWIssueOverviewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *addedByAuthorLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UILabel *assignedToLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *dueLabel;
@property (strong, nonatomic) IBOutlet UILabel *doneRatioLabel;
@property (strong, nonatomic) IBOutlet UILabel *spentTimeLabel;

@end
