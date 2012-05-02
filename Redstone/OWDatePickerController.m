//
//  OWDatePickerController.m
//  
//
//  Created by Rodrigo Recio on 26/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWDatePickerController.h"

@interface OWDatePickerController ()

@end

@implementation OWDatePickerController

@synthesize datePicker, identifier, popoverController, delegate, valueChanged;

- (id)init
{
    self = [super init];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    self.view = datePicker;
    [self.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)valueChanged:(id)sender
{
    self.valueChanged = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.delegate datePickerController:self didSelectDate:self.datePicker.date];
}

@end
