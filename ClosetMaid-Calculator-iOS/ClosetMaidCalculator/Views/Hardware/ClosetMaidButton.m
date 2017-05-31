//
//  ClosetMaidButton.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 6/14/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ClosetMaidButton.h"
#import <QuartzCore/QuartzCore.h>

@interface ClosetMaidButton ()
{
    CAGradientLayer *highlightLayer;
}

@end

@implementation ClosetMaidButton

- (void)awakeFromNib
{
    self.titleLabel.font = [UIFont fontWithName:self.fontName size:self.titleLabel.font.pointSize];
    self.layer.cornerRadius = self.borderRadius.floatValue;
    
    [self addTarget:self action:@selector(setButtonHighlighted) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(setButtonHighlighted) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(setButtonNotHighlighted) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(setButtonNotHighlighted) forControlEvents:UIControlEventTouchUpInside];
    
    [self addHighlightLayer];
//    [self addtar]
}

-(void)addHighlightLayer
{
    [highlightLayer removeFromSuperlayer];
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.3f].CGColor;
    highlightLayer.frame = CGRectMake(0, 0, super.frame.size.width, super.frame.size.height);
    highlightLayer.cornerRadius = 3.0f;
    highlightLayer.hidden = YES;
    highlightLayer.masksToBounds = NO;
    [super.layer insertSublayer:highlightLayer atIndex:0];
}

-(void)setButtonHighlighted
{
    self.contentEdgeInsets = UIEdgeInsetsMake(1.0,1.0,-1.0,-1.0);
    [highlightLayer setHidden:NO];
}

-(void)setButtonNotHighlighted
{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    [highlightLayer setHidden:YES];
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
