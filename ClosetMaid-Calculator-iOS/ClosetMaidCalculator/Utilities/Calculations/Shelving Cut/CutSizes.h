//
//  CutSizes.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/15/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//


@interface CutSizes : NSObject

@property CGFloat waste;
@property (nonatomic, strong) NSMutableArray *cutSizes;

- (void)insertCut:(CGFloat)object;

@end
