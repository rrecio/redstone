//
//  OWDatePickerController.m
//  Redstone
//
//  Created by Rodrigo Recio on 26/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWDatePickerController.h"

@interface OWDatePickerController ()

@end

@implementation OWDatePickerController

@synthesize datePicker, identifier, popoverController, delegate, valueChanged;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
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
