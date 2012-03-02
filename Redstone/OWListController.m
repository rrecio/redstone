//
//  OWListController.m
//  Redstone
//
//  Created by Rodrigo Recio on 25/02/12.
//  Copyright (c) 2012 Owera Software. All rights reserved.
//

#import "OWListController.h"

@interface OWListController ()

@end

@implementation OWListController
@synthesize picker;
@synthesize list;
@synthesize popoverController;
@synthesize delegate;
@synthesize identifier;
@synthesize selectedIndex;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[list objectAtIndex:row] name];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.delegate listController:self didSelectItemOnIndex:[self.picker selectedRowInComponent:0]];
}

@end
