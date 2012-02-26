//
//  OWDatePickerController.h
//  Redstone
//
//  Created by Rodrigo Recio on 26/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OWDatePickerControllerDelegate;

@interface OWDatePickerController : UIViewController
@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) id<OWDatePickerControllerDelegate> delegate;
@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) NSString *identifier;
@property BOOL valueChanged;
@end

@protocol OWDatePickerControllerDelegate <NSObject>;
- (void)datePickerController:(OWDatePickerController *)controller didSelectDate:(NSDate *)date;
@end
