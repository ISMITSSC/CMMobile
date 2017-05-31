//
//  RSSPickerViewDelegate.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSPickerButton;

@protocol RSSPickerViewDelegate <NSObject>

@optional
-(void) pickerButton:(RSSPickerButton*)thePickerButton didSelectValue:(NSValue*) theValue;
-(void) doneButtonClickedForPickerButton:(RSSPickerButton*)thePickerButton;

@end
