//
//  TableCellValuePairs.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/4/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//


@interface ShelvingCutShelf : NSObject

@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger lengthOf;

- (id)initWithQuantity:(NSInteger)quant
             andLength:(NSInteger)leng;

@end
