//
//  OWTarefaCell.m
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWTarefaCell.h"

@implementation OWTarefaCell
@synthesize authorLabel, assignedToLabel, statusLabel, priorityLabel, dueLabel, versionLabel;
@synthesize trackerLabel, indexLabel, startLabel, subjectLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
