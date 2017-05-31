//
//  RSSPickerButtonAssociatedView.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSButton.h"
#import "RSSPickerViewDelegate.h"

@class RSSPickerButton;
@interface RSSPickerButtonAssociatedView : UIView {
    UILabel* titleLabel;
    RSSButton* doneButton;
    RSSPickerButton* pickerButton;
    CGRect applicationFrame;
}

@property (nonatomic, assign) id<RSSPickerViewDelegate> delegate;
@property (nonatomic, strong) UIView *fadeView;

- (id)initForButton:(RSSPickerButton*)button withView:(UIView*)insideView title:(NSString*)title;
- (void)doneButtonClicked:(id)sender;

@end
