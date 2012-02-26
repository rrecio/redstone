//
//  OWListController.h
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OWListDelegate;

@interface OWListController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic) NSArray *list;
@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) id<OWListDelegate> delegate;
@property (nonatomic) NSString *identifier;
@property NSUInteger selectedIndex;
@end

@protocol OWListDelegate <NSObject>

- (void)listController:(OWListController *)controller didSelectItemOnIndex:(NSUInteger)index;

@end
