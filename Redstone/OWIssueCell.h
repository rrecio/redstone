//
//  OWTarefaCell.h
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OWIssueCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *trackerLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *priorityLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *assignedToLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *dueLabel;
@end
