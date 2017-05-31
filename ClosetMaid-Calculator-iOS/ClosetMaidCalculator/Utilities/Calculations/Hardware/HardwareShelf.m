//
//  Shelf.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "HardwareShelf.h"


@implementation HardwareShelf

@synthesize quantity = _quantity;
@synthesize location = _location;
@synthesize shelvingLength = _shelvingLength;

- (id)init
{
    self = [super init];
    if (self) {
        _quantity = 0;
        _location = 1; // default wall-to-open
        _shelvingLength = 0;
    }
    return self;
}

@end
