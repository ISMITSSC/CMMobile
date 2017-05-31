//
//  CutCalculator.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/15/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutShelf.h"
#import "CutSizes.h"


@interface CutCalculator : NSObject

+ (NSArray *)performCutsFrom:(NSArray *)pairQuantityLength
                    withSize:(CGFloat)shelfSize
                     andType:(ShelvingCutShelving)shelfType
                      inUnit:(UnitOfMeasure)unitOfMeasurement;

@end
