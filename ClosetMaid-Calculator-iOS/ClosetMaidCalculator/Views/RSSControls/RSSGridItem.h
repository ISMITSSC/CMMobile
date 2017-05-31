//
//  RSSGridItem.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/5/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSGridField.h"
#import <QuartzCore/QuartzCore.h>
//#import "RSSManagedObject+RSSPickerViewItem.h"

struct CGGridLayout {
    CGFloat labelWidth;
    CGFloat inputWidth;
};

@interface RSSGridItem : UIView
{
    CAGradientLayer *gradientLayer;
    UILabel* currentLabel;
}

typedef struct CGGridLayout CGGridLayout;

@property (nonatomic, strong)NSString* label;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* fieldName;
@property (nonatomic, strong)NSString* required;
@property (nonatomic, strong)NSMutableArray* dependencies;
@property (nonatomic, strong)UIView<RSSGridField>* inputFieldInstance;

@property (nonatomic, strong)NSString* selectByParentValue;
@property (nonatomic, strong)NSString* filterByParentValue;
@property (nonatomic, strong)NSString* entity;

@property (nonatomic)NSInteger depth;

- (id)initWithLabel:(NSString*)theLabelText andInputField:(UIView<RSSGridField>*) inputField;
- (void)setFrame:(CGRect)frame layout:(CGGridLayout)layout;

@end