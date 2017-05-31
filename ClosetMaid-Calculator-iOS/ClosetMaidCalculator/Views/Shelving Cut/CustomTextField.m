//
//  CustomTextField.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/9/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CustomTextField.h"
#import "UIColor+ClosetMaid.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.returnKeyType = UIReturnKeyDone;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
        self.textColor = [UIColor blackColor];
        self.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:18];
    }
    return self;
}

//- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text
//{
//    if ([text sizeWithFont:self.font].width > self.frame.size.width) {
//        while ([text sizeWithFont:self.font].width > self.frame.size.width) {
//            self.font = [self.font fontWithSize:self.font.pointSize - 1];
//        }
//    }
//    return YES;
//}

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
