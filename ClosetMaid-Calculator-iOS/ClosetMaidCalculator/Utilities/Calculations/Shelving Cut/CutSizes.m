//
//  CutSizes.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/15/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CutSizes.h"


@implementation CutSizes

- (id)init
{
    self = [super init];
    if (self) {
        _waste = 0;
        _cutSizes = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *  Always insert cuts bottom-to-top, because drawing is done top-to-bottom
 */
- (void)insertCut:(CGFloat)object
{
    [self.cutSizes insertObject:[NSNumber numberWithFloat:object]
                        atIndex:0];
}

@end
