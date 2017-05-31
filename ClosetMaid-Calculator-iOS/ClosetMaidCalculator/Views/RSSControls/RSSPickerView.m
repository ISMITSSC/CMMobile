//
//  RSSPickerView.m
//  CRM360
//
//  Created by Lucian Muresan on 11/21/11.
//  Copyright (c) 2011 RIDGID Software Solutions. All rights reserved.
//

#import "RSSPickerView.h"
#import "RSSPickerButton.h"
#import "RSSPickerViewItem.h"

@implementation RSSPickerView

@synthesize pickerView;
@synthesize picklistValues;

- (id)initForButton:(RSSPickerButton*)button title:(NSString*)title andValues:(NSMutableArray*)values
{
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    self.picklistValues = values;
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,(applicationFrame.size.height - 180),applicationFrame.size.width, 180)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [pickerView setShowsSelectionIndicator:YES];
    self->pickerButton = button;
    self = [super initForButton:button withView:pickerView title:title];
    return self;
}

- (void)reloadPicker {
    [pickerView reloadAllComponents];
}

-(void) setValue:(NSString*) theValue {
    [pickerButton setTitle:value forState:UIControlStateNormal];
    if (theValue!=nil) {
        int selIndex = 0;
        for (RSSPickerViewItem* gridPickerViewItem in picklistValues)
        {
            if ([gridPickerViewItem value] && ([[gridPickerViewItem value] isEqualToString:theValue]))
            {
                selIndex = [picklistValues indexOfObject:gridPickerViewItem];
            }
        }
        [pickerView selectRow:selIndex inComponent:0 animated:YES];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self->pickerButton isPickerViewActive])
    {
        id currentItem = [picklistValues objectAtIndex:row];
        
        NSString* currentItemLabel = nil;
        NSString* currentItemValue = nil;
        
        if ([currentItem isKindOfClass:[RSSPickerViewItem class]]){
            currentItemLabel =  [(RSSPickerViewItem*) currentItem label];
            currentItemValue =  (NSString*)[(RSSPickerViewItem*) currentItem value];
        } else {
            currentItemLabel = currentItem;
            currentItemValue= currentItem;
        }
        
        [pickerButton setTitle:currentItemLabel forState:UIControlStateNormal];
        [pickerButton setSelectedValue:currentItemValue];
    }else
    {
        int selIndex = 0;
        for (RSSPickerViewItem* gridPickerViewItem in picklistValues)
        {
            if ([gridPickerViewItem value] && ([[gridPickerViewItem value] isEqualToString:[self->pickerButton previousSelectedValue]]))
            {
                selIndex = [picklistValues indexOfObject:gridPickerViewItem];
            }
        }
        [self->pickerView selectRow:selIndex inComponent:0 animated:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return picklistValues.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    id currentItem = [picklistValues objectAtIndex:row];
    
    if ([currentItem isKindOfClass:[RSSPickerViewItem class]]){
        return [(RSSPickerViewItem*) currentItem label];
    } else{
        return [picklistValues objectAtIndex:row];
    }
}

- (void) setPickerItemFontSize:(CGFloat)fontSize {
    pickerItemFontSize = fontSize;
}

- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-BoldCond" size:pickerItemFontSize]];
    }
    [pickerLabel setText:[picklistValues objectAtIndex:row]];
    
    return pickerLabel;
}

@end
