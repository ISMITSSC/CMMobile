//
//  RSSPickerButtonAssociatedView.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSPickerButtonAssociatedView.h"
#import "RSSPickerButton.h"
#import "UIColor+ClosetMaid.h"

@implementation RSSPickerButtonAssociatedView

@synthesize delegate;
@synthesize fadeView;

- (id)initForButton:(RSSPickerButton*)button withView:(UIView *)insideView title:(NSString *)theTitle {
    
    CGFloat titleBarHeight = 40;
    
    CGRect frame = CGRectMake(insideView.frame.origin.x, insideView.frame.origin.y-titleBarHeight, insideView.frame.size.width, insideView.frame.size.height+titleBarHeight);
    
    self = [super initWithFrame:frame];
    if (self) {
        applicationFrame = [[UIScreen mainScreen] applicationFrame];
        pickerButton = button;
        //[self setFrame:applicationFrame];
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        
        UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0,frame.origin.y,applicationFrame.size.width,40)];
        //CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        //[gradientLayer setBounds:[titleBg bounds]];
        //[gradientLayer setPosition:CGPointMake([titleBg bounds].size.width/2, [titleBg bounds].size.height/2)];
        //[gradientLayer setColors:[NSArray arrayWithObjects:
        //                          (id)[[UIColor myHeaderBlueColor2]CGColor],(id)[[UIColor myHeaderBlueColor3] CGColor], nil]];
        //[[titleBg layer] insertSublayer:gradientLayer atIndex:0];
        titleBg.backgroundColor = [UIColor darkGrayColor];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:16];
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.frame = CGRectMake(15, 0, 150, 40);
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.text = theTitle;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        //titleLabel.minimumScaleFactor = 10;
        [titleBg addSubview:titleLabel];
        
        doneButton =  [[RSSButton alloc] initWithFrame:CGRectMake(245, 7.5, 60, 25)];
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setBackgroundColor:[UIColor closetMaidRedColor]];
        doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:15];
        [doneButton.layer setCornerRadius:3];
        [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleBg addSubview:doneButton];
        [self addSubview:titleBg];
        [self addSubview:insideView];
    }
    
    return self;
}

- (void)doneButtonClicked:(id)sender
{
    [self->pickerButton setHighlighted:NO];
    [self->pickerButton setPickerViewActive:NO];
    [self.superview endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    if (fadeView)
    {
        fadeView.alpha = 0;
    }
    [UIView setAnimationDuration:0.3];
    [self setFrame:CGRectMake(0,20 + applicationFrame.size.height,applicationFrame.size.width,applicationFrame.size.height)];
    [UIView commitAnimations];
    
    if ([delegate respondsToSelector:@selector(doneButtonClickedForPickerButton:)]){
        [delegate doneButtonClickedForPickerButton:self->pickerButton];
    }
    
}
@end
