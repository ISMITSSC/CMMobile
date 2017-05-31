//
//  CustomPickersCell.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/4/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CustomTableCell.h"
#import "UIColor+ClosetMaid.h"


@implementation CustomTableCell

@synthesize quantityTextField, lengthTextField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        quantityTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              70,
                                                                              35)];
        quantityTextField.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:16];
//        quantityTextField.placeholder = @"0";
        quantityTextField.tag = QUANTITY_TAG;
        quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:quantityTextField];
        
        lengthTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(75,
                                                                            0,
                                                                            self.contentView.frame.size.width - quantityTextField.frame.size.width - 35,
                                                                            35)];
        lengthTextField.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:16];
//        lengthTextField.placeholder = @"dimension";
        lengthTextField.tag = LENGTH_TAG;
        [self.contentView addSubview:lengthTextField];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // delete button handling
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.0f];
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
            CGRect newFrame = subView.frame;
            newFrame.origin.x = self.frame.size.width - 85;
            newFrame.origin.y = - 2;
            subView.frame = newFrame;
        }
    }
    [UIView commitAnimations];
}

/*
 *  Custom swipe-to-delete cell
 *      - applies a layer with the custom button above the native one
 *      - iOS 5 and below needs different or default implementation
 */
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    BOOL atLeastIOS6 = [[[UIDevice currentDevice] systemVersion] floatValue] > 5;
    if (atLeastIOS6) {
        if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
            for (UIView *subView in self.subviews) {
                if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                    UIView *deleteBtn = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 65,
                                                                                 35)];
                    deleteBtn.backgroundColor = self.lengthTextField.backgroundColor;
                    
                    RSSButton *delBtn = [[RSSButton alloc] initWithFrame:CGRectMake(10,
                                                                                    5,
                                                                                    50,
                                                                                    25)];
                    delBtn.backgroundColor = [UIColor closetMaidRedColor];
                    delBtn.layer.cornerRadius = 3.0f;
                    [delBtn setTitle:@"Delete" forState:UIControlStateNormal];
                    [delBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
                    delBtn.titleLabel.textColor = [UIColor whiteColor];
                    delBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    delBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:13];
                    [deleteBtn addSubview:delBtn];
                    
                    // insert custom button above
                    [[subView.subviews objectAtIndex:0] addSubview:deleteBtn];
                }
            }
        }
    }
}

- (void)test
{
    NSLog(@"deleted");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
