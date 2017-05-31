//
//  ResponderLabel.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ResponderLabel.h"

@implementation ResponderLabel

@synthesize inputView, inputAccessoryView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 25,
                                                                           0,
                                                                           25,
                                                                           35)];
    rightArrow.image = [UIImage imageNamed:@"icon-RightArrow"];
    rightArrow.contentMode = UIViewContentModeCenter;
    [self addSubview:rightArrow];
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark - UIResponder overrides

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}


#pragma mark - Drawing

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = { 0, 5, 0, 5 };
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
