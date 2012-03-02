//
//  OWJournalCell.m
//  Redstone
//
//  Created by Rodrigo Recio on 02/03/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWJournalCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation OWJournalCell

@synthesize journal;

- (void)setJournal:(RKJournal *)aJournal
{
    journal = aJournal;
    
    CGFloat xOrig = 20;
    CGFloat yOrig = 20;
    CGFloat typeWidth = 80;
    CGFloat descWidth = 300;
    CGFloat height = 15;
    
    for (RKJournalDetail *detail in journal.details) {
        NSUInteger i = [journal.details indexOfObject:detail]+1;
        
        UILabel *detailType     = [[UILabel alloc] initWithFrame:CGRectMake(xOrig, (yOrig*i)+(height*(i-1)), typeWidth, height)];
        detailType.adjustsFontSizeToFitWidth = YES;
        detailType.font         = [UIFont boldSystemFontOfSize:13.0];
        detailType.backgroundColor = [UIColor clearColor];
        detailType.textAlignment = UITextAlignmentRight;
        detailType.text         = [self typeStringForDetail:detail];
        
        UILabel *detailDesc     = [[UILabel alloc] initWithFrame:CGRectMake((xOrig*2)+typeWidth, (yOrig*i)+(height*(i-1)), descWidth, height)];
        detailDesc.font         = [UIFont systemFontOfSize:13.0];
        detailDesc.backgroundColor = [UIColor clearColor];
        detailDesc.adjustsFontSizeToFitWidth = YES;
        detailDesc.text         = [self descStringForDetail:detail];
        
        [self.contentView addSubview:detailType];
        [self.contentView addSubview:detailDesc];
    }
    
    if (journal.notes != nil && ![journal.notes isEqualToString:@""] && ![journal.notes isEqualToString:@" "]) {
        NSLog(@"setting journal notes: '%@'", journal.notes);
        CGSize boundingSize = CGSizeMake(600.0, CGFLOAT_MAX);
        CGSize notesSize = [journal.notes sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];
        UILabel *notes          = [[UILabel alloc] initWithFrame:CGRectMake(xOrig, (yOrig*(journal.details.count+1))+(height*journal.details.count), notesSize.width, notesSize.height)];
        notes.font = [UIFont systemFontOfSize:14.0];
        notes.numberOfLines = 0;
        notes.lineBreakMode = UILineBreakModeWordWrap;
        notes.text              = journal.notes;
        notes.backgroundColor = [UIColor clearColor];
//        notes.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.contentView addSubview:notes];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *)descStringForDetail:(RKJournalDetail *)detail
{
    if ([detail.property isEqualToString:@"attachment"]) {
        if (detail.theNewValue) {
            return [detail.theNewValue stringByAppendingString:@" added"];
        } else if (detail.theOldValue) {
            return [detail.theOldValue stringByAppendingString:@" deleted"];
        }
    } else if ([detail.property isEqualToString:@"attr"]) {
        NSString *new = [self stringForValue:detail.theNewValue andAttribute:detail.property];
        NSString *old = [self stringForValue:detail.theOldValue andAttribute:detail.property];
        return [NSString stringWithFormat:@"changed from %@ to %@", old, new];
    }
    return nil;
}

- (NSString *)stringForValue:(NSString *)value andAttribute:(NSString *)attr
{
    return value;
}

- (NSString *)typeStringForDetail:(RKJournalDetail *)detail
{
    if ([detail.property isEqualToString:@"attachment"]) {
        return @"File";
    } else if ([detail.property isEqualToString:@"attr"]) {
        return [self attrStringForAttributeName:detail.name];
    }
    return nil;
}

- (NSString *)attrStringForAttributeName:(NSString *)name
{
    // traduzir pro nome certo
    return name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
