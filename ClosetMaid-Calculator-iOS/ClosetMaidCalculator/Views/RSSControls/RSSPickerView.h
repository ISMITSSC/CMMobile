//
//  RSSPickerView.h
//  CRM360
//
//  Created by Lucian Muresan on 11/21/11.
//  Copyright (c) 2011 RIDGID Software Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSButton.h"
#import "RSSPickerViewDelegate.h"
#import "RSSPickerButtonAssociatedView.h"


@class RSSPickerButton;
@interface RSSPickerView : RSSPickerButtonAssociatedView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    RSSPickerButton* rssPickerButton;
    NSString* value;
    CGFloat pickerItemFontSize;
}

@property (nonatomic, strong) NSArray* picklistValues;
@property (nonatomic, strong) UIPickerView* pickerView;

- (id)initForButton:(UIButton*)button title:(NSString*)title andValues:(NSMutableArray*)values;
- (void) setValue:(NSString*) value;
- (void) setPickerItemFontSize:(CGFloat)fontSize;
- (void)reloadPicker;

@end
