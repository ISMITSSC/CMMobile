//
//  RSSButtonTemplate.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 11/27/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RSSGridField.h"

@interface RSSButtonTemplate : UIControl<RSSGridField>
{
    CAGradientLayer *highlightLayer;
    CAGradientLayer *gradientLayer;
}

@property(nonatomic, strong)UIButton* button;
@property BOOL isSelected;
@property BOOL remainsHighlighted;

@property CGFloat hitOffsetTop;    /**<extenion of top active hit area */
@property CGFloat hitOffsetBottom; /**<extenion of bottom active hit area */
@property CGFloat hitOffsetLeft;   /**<extenion of left active hit area */
@property CGFloat hitOffsetRight;  /**<extenion of right active hit area */

-(id)initWithFrame:(CGRect)frame;
-(void)setTitle:(NSString*)title forState:(UIControlState)state;
-(UILabel*)titleLabel;

-(void)setButtonHighlighted;
-(void)setButtonNotHighlighted;
-(void)setTitleColor:(UIColor*)color forState:(UIControlState)state;

@end
