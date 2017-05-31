//
//  CutDrawPixels.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/18/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CutDrawPixels.h"


@implementation CutDrawPixels

@synthesize value;
@synthesize cutInPixels;
@synthesize count;
@synthesize isTiny;
@synthesize isDownRod;

- (id)init
{
    self = [super init];
    if (self) {
        value = 0;
        cutInPixels = 0;
        count = 1;
        isTiny = NO;
        isDownRod = NO;
    }
    return self;

}


@end
