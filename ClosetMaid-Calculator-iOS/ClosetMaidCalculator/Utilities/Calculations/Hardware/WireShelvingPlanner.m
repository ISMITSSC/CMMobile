//
//  WireShelvingPlanner.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "WireShelvingPlanner.h"
#import "Hardware.h"
#import "HardwareShelf.h"


@interface WireShelvingPlanner()

+ (NSInteger)largeEndCapsForType:(NSInteger)type
                        location:(NSInteger)location;
+ (NSInteger)smallEndCapsForType:(NSInteger)type
                        location:(NSInteger)location;
+ (NSInteger)supportBracketsForLocation:(NSInteger)location
                              shelfLength:(NSInteger)shelfLength;
+ (NSInteger)wallBracketsForLocation:(NSInteger)location;
+ (NSInteger)wallClipsForShelfLength:(NSInteger)shelfLength;

@end


@implementation WireShelvingPlanner


/* ============================== */
#pragma mark - Public class methods

+ (Hardware *)hardwareFromShelves:(NSArray *)shelves withType:(NSInteger)type
{
    Hardware *hardware = [[Hardware alloc] init];
    
    for (HardwareShelf *s in shelves) {
        hardware.largeEndCaps += s.quantity * [self largeEndCapsForType:type
                                                               location:s.location];
        hardware.smallEndCaps += s.quantity * [self smallEndCapsForType:type
                                                               location:s.location];
        hardware.supportBrackets +=  s.quantity * [self supportBracketsForLocation:s.location
                                                                       shelfLength:s.shelvingLength];
        hardware.wallBrackets += s.quantity * [self wallBracketsForLocation:s.location];
        hardware.wallClips += s.quantity * [self wallClipsForShelfLength:s.shelvingLength];
    }
    
    return hardware;
}


/* ============================== */
#pragma mark - Private class methods


+ (NSInteger)largeEndCapsForType:(NSInteger)type location:(NSInteger)location
{
    NSInteger caps;
    
    switch (type) {
        case SHELF_ROD_12:
            caps = 4;
            break;
            
        case SHELF_ROD_16:
            caps = 4;
            break;
            
        default:
            caps = 0;
            break;
    }
    
    return caps;
}

+ (NSInteger)smallEndCapsForType:(NSInteger)type location:(NSInteger)location
{
    NSInteger caps;
    
    switch (type) {
        case SUPERSLIDE_12:
            caps = 8;
            break;
            
        case SUPERSLIDE_16:
            caps = 10;
            break;
            
        case CLOSEMESH:
            caps = 10;
            break;
            
        case SHELF_ROD_12:
            caps = 4;
            break;
            
        case SHELF_ROD_16:
            caps = 6;
            break;
            
        default:
            caps = 0;
            break;
    }
    
    return caps;
}

+ (NSInteger)supportBracketsForLocation:(NSInteger)location shelfLength:(NSInteger)shelfLength
{
    NSInteger brackets = (shelfLength - 3) / 36;
    
    switch (location) {
        case WALL_TO_OPEN:
            brackets++;
            break;
            
        case OPEN_TO_OPEN:
            brackets += 2;
            break;
            
        default:
            break;
    }
    
    return brackets;
}

+ (NSInteger)wallBracketsForLocation:(NSInteger)location
{
    NSInteger brackets = 0;
    
    switch (location) {
        case WALL_TO_OPEN:
            brackets = 1;
            break;
            
        case WALL_TO_WALL:
            brackets = 2;
            break;
            
        default:
            break;
    }
    
    return brackets;
}

+ (NSInteger)wallClipsForShelfLength:(NSInteger)shelfLength
{
    NSInteger clips = ceilf((shelfLength - 4.0) / 12.0) + 1;
    
    clips = (clips < 3) ? 3 : clips;
    
    return clips;
}

@end
