//
//  RSSButton.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSButton.h"
#import "UIColor+ClosetMaid.h"

@implementation RSSButton

@synthesize button;
@synthesize selected;
@synthesize isSelected;

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self)
    {
        [self addHighlightLayer];   // Change to alter button appearance while in highlighted state.
        //[self addGradientLayer];    // Change to alter button appearance while in normal state.
    }
    return self;
}


#pragma mark - Button appearance customizations

// Add highlight layer. Will only be visible when button is pressed.
-(void)addHighlightLayer
{
    [highlightLayer removeFromSuperlayer];
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.3f].CGColor;
    highlightLayer.frame = CGRectMake(0, 0, super.frame.size.width, super.frame.size.height);
    highlightLayer.cornerRadius = 3.0f;
    highlightLayer.hidden = YES;
    highlightLayer.masksToBounds = NO;
    [super.button.layer insertSublayer:highlightLayer atIndex:0];
}

// Add button gradient. It will always be visible.
-(void)addGradientLayer
{
    [gradientLayer removeFromSuperlayer];
    gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.cornerRadius = 3.0f;
    [gradientLayer setFrame:CGRectMake(0, 0, super.frame.size.width, super.frame.size.height)];
    //UIColor* buttonColor1 = ([self isEnabled]) ?  [UIColor myBlueButtonColor0] : [UIColor myLightGrayColor3];
    //UIColor* buttonColor2 = ([self isEnabled]) ?  [UIColor myBlueButtonColor1] : [UIColor myLightGrayColor4];
    UIColor* buttonColor1 = ([self isEnabled]) ?  [UIColor closetMaidRedColor] : [UIColor lightGrayColor];
    UIColor* buttonColor2 = ([self isEnabled]) ?  [UIColor closetMaidRedColor] : [UIColor lightGrayColor];
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[buttonColor1 CGColor],(id)[buttonColor2 CGColor], nil]];
    [gradientLayer setMasksToBounds:NO];
    [super.button.layer insertSublayer:gradientLayer atIndex:0];
}

@end
