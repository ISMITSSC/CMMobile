//
//  CutCalculator.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/15/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CutCalculator.h"


@implementation CutCalculator

/*
 *  Cut represents the big shelf
 *  cut represents the small cuts that the Cut shelf should be cut into
 */
+ (NSArray *)performCutsFrom:(NSArray *)pairQuantityLength
                    withSize:(CGFloat)shelfSize
                     andType:(ShelvingCutShelving)shelfType
                      inUnit:(UnitOfMeasure)unitOfMeasurement
{
    // non-empty pairQuantityLength please
    if (pairQuantityLength.count == 0) {
        return nil;
    }
    
    NSMutableArray *cuts = [[NSMutableArray alloc] init];
    
    // helper data
    BOOL cutsDone, cutInProgress;
    int i, j;
    NSInteger quantityAtI, quantityAtJ;
    NSInteger lengthOfAtI, lengthOfAtJ;
    NSDecimalNumber* totalL = [[NSDecimalNumber alloc] initWithFloat:0];
    CGFloat mod;
    ShelvingCutShelf *replacement;
    // this is entirely stupid but needed for the algorithm below
    CGFloat cmProduct6 = 6 * 2.54;
    CGFloat cmProduct12 = 2 * cmProduct6;
    
    // sort pairs  in descending order by length
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lengthOf"
                                                                     ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    // copy initial array with buffer
    NSMutableArray *sortedQLPair = [[NSMutableArray alloc] init];
    
    for (ShelvingCutShelf *pair in [pairQuantityLength sortedArrayUsingDescriptors:sortDescriptors]) {
        [sortedQLPair addObject:[[ShelvingCutShelf alloc] initWithQuantity:pair.quantity
                                                                   andLength:pair.lengthOf]];
    }
    
    cutsDone = NO;
    i = 0;
    while (!cutsDone) {
        // start next cut i.e. new CutSizes element
        quantityAtI = [[sortedQLPair objectAtIndex:i] quantity];
        
        if (quantityAtI > 0) {
            CutSizes *cut = [[CutSizes alloc] init];
            lengthOfAtI = [[sortedQLPair objectAtIndex:i] lengthOf];
            totalL = [[NSDecimalNumber alloc] initWithFloat:lengthOfAtI];
            
            // (-1 at downrods for second type)
            if (shelfType == TOTALSLIDE) {
                if (unitOfMeasurement == IMPERIAL) {
                    mod = fmodf(totalL.floatValue - 6, 12);
                    if (mod >= 0 && mod < 1) {
                        if (totalL.floatValue + 1 <= shelfSize) {
                            // -1
                            totalL = [totalL decimalNumberByAdding:[[NSDecimalNumber alloc] initWithInt:1]];
                            [cut insertCut:-1];
                        }
                    }
                } else {
                    mod = fmodf(totalL.floatValue - cmProduct6, cmProduct12);
                    if (mod >= 0 && mod < 2.54) {
                        if (totalL.floatValue + 2.54 <= shelfSize) {
                            // -2.54
                            totalL = [totalL decimalNumberByAdding:[[NSDecimalNumber alloc] initWithFloat:2.54]];
                            [cut insertCut:-2.54];
                        }
                    }
                }
            }
            // add cut dimension
            [cut insertCut:lengthOfAtI];
            
            replacement = [sortedQLPair objectAtIndex:i];
            quantityAtI = --replacement.quantity; // quantity of this cut dimension to be cut --
            
            // continue adding cuts to this Cut, starting from current i (until quantity = 0)
            cutInProgress = YES;
            j = i;
            while (j < sortedQLPair.count) {
                quantityAtJ = [[sortedQLPair objectAtIndex:j] quantity];
                lengthOfAtJ = [[sortedQLPair objectAtIndex:j] lengthOf];
                
                if (quantityAtJ > 0 && totalL.floatValue + lengthOfAtJ <= shelfSize) {
                    totalL = [totalL decimalNumberByAdding:[[NSDecimalNumber alloc] initWithFloat:lengthOfAtJ]];
                    
                    // (-1 at downrods for second type)
                    if (shelfType == TOTALSLIDE) {
                        if (unitOfMeasurement == IMPERIAL) {
                            mod = fmodf(totalL.floatValue - 6, 12);
                            if (mod >= 0 && mod < 1) {
                                if (totalL.floatValue + 1 <= shelfSize) {
                                    // -1
                                    totalL = [totalL decimalNumberByAdding:[[NSDecimalNumber alloc] initWithInt:1]];
                                    [cut insertCut:-1];
                                }
                            }
                        } else {
                            
                            mod = fmodf(totalL.floatValue - cmProduct6, cmProduct12);
                            if (mod >= 0 && mod < 2.54) {
                                if (totalL.floatValue + 2.54 <= shelfSize) {
                                    // -2.54
                                    totalL = [totalL decimalNumberByAdding:[[NSDecimalNumber alloc] initWithFloat:2.54]];
                                    [cut insertCut:-2.54];
                                }
                            }
                        }
                    }
                    // add cut dimension
                    [cut insertCut:lengthOfAtJ];
                    
                    replacement = [sortedQLPair objectAtIndex:j];
                    replacement.quantity--; // quantity of this cut dimension to be cut --
                } else { // quantityAtJ = 0, so next j
                    j++;
                }
            }
            
            // cut is done
            cut.waste = shelfSize - totalL.floatValue; // set waste for cut
            [cuts insertObject:cut atIndex:cuts.count];
        } else { // if quantityAtI = 0, move to next cut dimension, if no more dimensions cutsDone = true
            BOOL nextI = YES;
            while (nextI) { // find next i with quantity != 0
                i++;
                if (i == sortedQLPair.count) {
                    cutsDone = YES;
                    break;
                } else {
                    quantityAtI = [[sortedQLPair objectAtIndex:i] quantity];
                    if (quantityAtI != 0) {
                        nextI = NO;
                    }
                }
            }
        }
    }
    
    return cuts;
}

@end
