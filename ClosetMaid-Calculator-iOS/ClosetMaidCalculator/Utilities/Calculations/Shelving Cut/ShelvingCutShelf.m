//
//  TableCellValuePairs.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/4/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutShelf.h"


@implementation ShelvingCutShelf

- (id)initWithQuantity:(NSInteger)quant andLength:(NSInteger)leng {
    self = [super init];
    if (self) {
        _quantity = quant;
        _lengthOf = leng;
    }
    
    return self;
}

@end
