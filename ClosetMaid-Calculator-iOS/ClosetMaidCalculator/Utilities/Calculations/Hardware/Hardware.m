//
//  Hardware.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/10/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "Hardware.h"


@implementation Hardware

@synthesize largeEndCaps = _largeEndCaps;
@synthesize smallEndCaps = _smallEndCaps;
@synthesize supportBrackets = _supportBrackets;
@synthesize wallBrackets = _wallBrackets;
@synthesize wallClips = _wallClips;

- (id)init
{
    self = [super init];
    if (self) {
        _largeEndCaps = 0;
        _smallEndCaps = 0;
        _supportBrackets = 0;
        _wallBrackets = 0;
        _wallClips = 0;
    }
    return self;
}

@end
