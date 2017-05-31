//
//  ClosetMaidTextField.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ClosetMaidTextField.h"

@implementation ClosetMaidTextField

@synthesize fontName;

- (void)awakeFromNib
{
    self.font = [UIFont fontWithName:self.fontName size:self.font.pointSize];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.clearButtonMode != UITextFieldViewModeNever) {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 7, 0, 25));
    }
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
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
