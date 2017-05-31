//
//  WireShelvingPlanner.h
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//


@class Hardware;

@interface WireShelvingPlanner : NSObject

+ (Hardware *)hardwareFromShelves:(NSArray *)shelves withType:(NSInteger)type;

@end
