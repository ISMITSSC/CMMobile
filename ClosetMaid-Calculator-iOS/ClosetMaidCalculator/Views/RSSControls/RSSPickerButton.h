//
//  RSSPickerButton.h
//  CRM360
//
//  Created by Ciprian Trusca on 11/15/11.
//  Copyright (c) 2011 RIDGID Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSPickerView.h"
#import "RSSGridField.h"
#import "RSSPickerView.h"
#import "RSSPickerViewDelegate.h"
#import "RSSPickerButtonAssociatedView.h"

@interface RSSPickerButton : UIButton <RSSGridField> {
    CALayer         *highlightLayer;
    CAGradientLayer *gradientLayer;
    CGRect applicationFrame;
    NSValue* defaultValue;
    BOOL pickerViewActive;
    
    BOOL pickerWithImage;
}

@property (assign, nonatomic) id<RSSPickerViewDelegate> delegate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) RSSPickerButtonAssociatedView* associatedView;
@property (nonatomic, strong) NSString* associatedEntityKey;
@property (nonatomic, strong) NSValue* defaultValue;

@property (nonatomic, strong) NSString* selectedId;
@property (nonatomic, strong) NSString* selectedValue;
@property (nonatomic, strong) NSString* previousSelectedValue;

//- (id)initWithAssociatedDatePickerTitle:(NSString*)associatedViewTitle initialDate:(NSDate*)date datePickerMode:(UIDatePickerMode) datePickerMode;
//- (id)initWithAssociatedDatePickerTitle:(NSString*)associatedViewTitle initialDate:(NSDate*)date datePickerMode:(UIDatePickerMode) datePickerMode minuteInterval:(int) minuteInterval;
//- (id)initWithAssociatedTableViewTitle:(NSString*)associatedViewTitle values:(NSMutableArray*)stringsOrPickerViewItems includeSearchBar:(BOOL)includeSearchBar;
- (id)initWithAssociatedPickerViewTitle:(NSString*)associatedViewTitle values:(NSArray*)stringsOrPickerViewItems;
//- (id)initWithAssociatedMultipleSelectionPickerViewTitle:(NSString *)associatedViewTitle values:(NSMutableArray *)stringsOrPickerViewItems;
- (void)setPicklistValues:(NSArray *) values;
- (BOOL)wasModified;
- (void)setPickerViewActive:(BOOL)isActive;
- (BOOL)isPickerViewActive;

- (void)pickerButtonClicked:(RSSPickerButton *)pickerButon;
- (void)setFrame:(CGRect)frame imageIcon:(NSString *)image highlightedImageIcon:(NSString *)highlightedImage;

@end


