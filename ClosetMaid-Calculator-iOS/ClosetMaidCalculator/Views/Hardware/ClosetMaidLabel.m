//
//  ClosetMaidLabel.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 4/29/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ClosetMaidLabel.h"

@implementation ClosetMaidLabel

@synthesize fontName;

- (void)awakeFromNib
{
    self.font = [UIFont fontWithName:self.fontName size:self.font.pointSize];
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
