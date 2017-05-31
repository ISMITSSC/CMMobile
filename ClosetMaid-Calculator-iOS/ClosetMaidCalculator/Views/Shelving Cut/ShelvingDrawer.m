//
//  ShelvingDrawer.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/7/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ShelvingDrawer.h"
#import "UIColor+ClosetMaid.h"
#import "CutDrawPixels.h"

@implementation ShelvingDrawer

- (id)initWithFrame:(CGRect)frame drawCut:(NSArray *)cut onShelfSize:(CGFloat)size withWaste:(CGFloat)waste inUnit:(int)unit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        appFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        shelfCut = cut;
        shelfSize = size;
        shelfWaste = waste;
        unitMeasure = unit;
        
        objectHasDownRod = NO;
        
        // formatter for display with max 2 decimals
        formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 2;
        
        // compute pixels
        [self performCalculations];
    }
    return self;
}

- (void)performCalculations {
    CGFloat remainingShelfSize = shelfSize;
    
    // waste pixel calculations
    if (shelfWaste == 0) {
        wasteApproxPixels = 0;
    } else {
        wasteApproxPixels = appFrame.size.height * shelfWaste / shelfSize;
        if (wasteApproxPixels < MIN_WASTE_SIZE) {
            wasteApproxPixels = MIN_WASTE_SIZE;
        }
        remainingShelfSize -= shelfWaste;
    }
//    NSLog(@"NEW CUT");
//    NSLog(@"Remaining shelf size: %f", remainingShelfSize);
//    NSLog(@"Waste: %f", wasteApproxPixels);
    
    // cuts pixel calculation
    cutsApproxPixels = [[NSMutableArray alloc] initWithObjects: nil];
    NSNumber *tempCut = [[NSNumber alloc] init];
    NSNumber *bonusTempCut = [[NSNumber alloc] init];
    
    int i = 0;
    while (i < shelfCut.count) {
        CutDrawPixels *cutPixels = [[CutDrawPixels alloc] init];
        tempCut = [shelfCut objectAtIndex:i];
        if (i + 1 < shelfCut.count) {
            bonusTempCut = [shelfCut objectAtIndex:i + 1];
        } else {
            bonusTempCut = 0;
        }
        // pixel approximation
        cutPixels.value = tempCut.floatValue;
        cutPixels.cutInPixels = [self convertToPixels:fabsf(tempCut.floatValue) proportionalTo:remainingShelfSize];
        // downrod
        if (tempCut.floatValue < 0) {
            cutPixels.isDownRod = YES;
            objectHasDownRod = YES;
        } else {
            if (cutPixels.cutInPixels < MIN_CUT_SIZE) {
                while (bonusTempCut.floatValue == tempCut.floatValue) {
                    cutPixels.count++;
                    i++;
                    if (i + 1 < shelfCut.count) {
                        bonusTempCut = [shelfCut objectAtIndex:i + 1];
                    } else {
                        bonusTempCut = 0;
                    }
                }
                if (cutPixels.cutInPixels * cutPixels.count < MIN_CUT_SIZE) {
                    cutPixels.isTiny = YES;
                }
            }
        }
        
        cutPixels.cutInPixels *= cutPixels.count;
        if (cutPixels.cutInPixels != 0) {
            [cutsApproxPixels addObject:cutPixels];
        }
        i++;
        
        // print
//        NSLog(@"%f %f %d", cutPixels.value, cutPixels.cutInPixels, cutPixels.count);
    }

}

- (CGFloat)convertToPixels:(CGFloat)item proportionalTo:(CGFloat)size
{
    return (appFrame.size.height - wasteApproxPixels) * item / size;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat yVerticalLines = 0;
    CGFloat yHorizontalLines = 2.5f;
    CGFloat yDescription = DESCRIPTION_LINE_WIDTH / 2;
    
    // WASTE DRAWING
    if (shelfWaste != 0) {
        // gray vertical lines
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(context, VERTICAL_LINE_WIDTH);
        // 1
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 3, yVerticalLines);
        CGContextAddLineToPoint(context, 3, wasteApproxPixels);
        CGContextStrokePath(context);
        // 2
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 - 12, yVerticalLines);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 - 12, wasteApproxPixels);
        CGContextStrokePath(context);
        // 3
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 - 7, yVerticalLines);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 - 7, wasteApproxPixels);
        CGContextStrokePath(context);
        
        // gray horizontal lines
        CGContextSetLineWidth(context, HORIZONTAL_LINE_WIDTH);
        //
        while (yHorizontalLines < wasteApproxPixels) {
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0, yHorizontalLines);
            CGContextAddLineToPoint(context, appFrame.size.width / 2 - 7, yHorizontalLines);
            CGContextStrokePath(context);
            yHorizontalLines += 2.0f;
        }
        
        // gray description lines
        CGContextSetLineWidth(context, DESCRIPTION_LINE_WIDTH);
        // horizontal
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 - 4, yDescription);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, yDescription);
        CGContextStrokePath(context);
        // vertical
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 + 8, yDescription);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, wasteApproxPixels);
        CGContextStrokePath(context);
        
        // gray description text
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:WASTE_FONT];
        NSString *wasteString;
        if (unitMeasure == IMPERIAL) {
            wasteString = [NSString stringWithFormat:@"%@%@ %@", [formatter stringFromNumber:[NSNumber numberWithFloat:shelfWaste]], @"\"", @"Waste"];
        } else {
            wasteString = [NSString stringWithFormat:@"%@%@ %@", [formatter stringFromNumber:[NSNumber numberWithFloat:shelfWaste]], @"cm", @"Waste"];
        }
        CGPoint point;
        CGSize stringWasteBoundingBox = [wasteString sizeWithFont:font];
        if (stringWasteBoundingBox.width > appFrame.size.width / 2 - 10) {
            point = CGPointMake(appFrame.size.width - stringWasteBoundingBox.width, wasteApproxPixels / 2 - 7);
        } else {
            point = CGPointMake(appFrame.size.width / 2 + 10, wasteApproxPixels / 2 - 7);
        }
        [wasteString drawAtPoint:point withFont:font];
        
        yDescription = yVerticalLines = wasteApproxPixels;
    }
    
    // CUT DRAWING
    // black + ifred vertical + horizontal lines
    for (CutDrawPixels *cutPixel in cutsApproxPixels) {
        CGFloat yOfCurrentCut = cutPixel.cutInPixels;
        // vertical lines
        if (cutPixel.isDownRod) {
            CGContextSetStrokeColorWithColor(context, [UIColor closetMaidRedColor].CGColor);
        } else {
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        }
        CGContextSetLineWidth(context, VERTICAL_LINE_WIDTH);
        //1
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 3, yVerticalLines);
        CGContextAddLineToPoint(context, 3, yVerticalLines + yOfCurrentCut);
        CGContextStrokePath(context);
        //2
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 - 12, yVerticalLines);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 - 12, yVerticalLines + yOfCurrentCut);
        CGContextStrokePath(context);
        //3
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, appFrame.size.width / 2 - 7, yVerticalLines);
        CGContextAddLineToPoint(context, appFrame.size.width / 2 - 7, yVerticalLines + yOfCurrentCut);
        CGContextStrokePath(context);
        yVerticalLines += yOfCurrentCut;
        
        // horizontal lines
        if (cutPixel.isDownRod) {
            CGContextSetLineWidth(context, HORIZONTAL_LINE_WIDTH + 1.0f);
        } else {
            CGContextSetLineWidth(context, HORIZONTAL_LINE_WIDTH);
        }
        do {
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0, yHorizontalLines);
            CGContextAddLineToPoint(context, appFrame.size.width / 2 - 7, yHorizontalLines);
            CGContextStrokePath(context);
            yHorizontalLines += 2.0f;
        } while (yHorizontalLines < yVerticalLines - HORIZONTAL_LINE_WIDTH);
//        {
//            CGContextBeginPath(context);
//            CGContextMoveToPoint(context, 0, yHorizontalLines);
//            CGContextAddLineToPoint(context, appFrame.size.width / 2 - 7, yHorizontalLines);
//            CGContextStrokePath(context);
//            yHorizontalLines += 2.0f;
//        }
//        NSLog(@"Pixels: %f; Actual lineY: %f", yVerticalLines, yHorizontalLines);
    }
    
    // RED DRAWING
    
    // red description
    CGContextSetStrokeColorWithColor(context, [UIColor closetMaidRedColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor closetMaidRedColor].CGColor);
    CGContextSetLineWidth(context, DESCRIPTION_LINE_WIDTH);
    UIBezierPath *roundRectDrawing;
    for (CutDrawPixels *cutPixel in cutsApproxPixels) {
        CGFloat yOfCurrentCut = cutPixel.cutInPixels;
        
        if (!cutPixel.isDownRod) {
            // horizontal top line
            CGContextBeginPath(context);
            if (yDescription != DESCRIPTION_LINE_WIDTH / 2) {
                CGContextMoveToPoint(context, appFrame.size.width / 2 - 4, yDescription - DESCRIPTION_LINE_WIDTH / 2);
                CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, yDescription - DESCRIPTION_LINE_WIDTH / 2);
            } else {
                CGContextMoveToPoint(context, appFrame.size.width / 2 - 4, yDescription);
                CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, yDescription);
            }
            CGContextStrokePath(context);
            // horizontal bottom line
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, appFrame.size.width / 2 - 4, yDescription + yOfCurrentCut - DESCRIPTION_LINE_WIDTH);
            CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, yDescription + yOfCurrentCut - DESCRIPTION_LINE_WIDTH);
            CGContextStrokePath(context);
            // vertical line
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, appFrame.size.width / 2 + 8, yDescription - DESCRIPTION_LINE_WIDTH / 2);
            CGContextAddLineToPoint(context, appFrame.size.width / 2 + 8, yDescription + yOfCurrentCut - DESCRIPTION_LINE_WIDTH);// / 2);
            CGContextStrokePath(context);
            
            // box text
            NSString *thisCutDimensionString;
            if (cutPixel.count > 1) {
                if (unitMeasure == IMPERIAL) {
                    thisCutDimensionString = [NSString stringWithFormat:@"%d x %@%@", cutPixel.count, [formatter stringFromNumber:[NSNumber numberWithFloat:cutPixel.value]], @"\""];
                } else {
                    thisCutDimensionString = [NSString stringWithFormat:@"%d x %@%@", cutPixel.count, [formatter stringFromNumber:[NSNumber numberWithFloat:cutPixel.value]], @"cm"];
                }
            } else {
                if (unitMeasure == IMPERIAL) {
                    thisCutDimensionString = [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithFloat:cutPixel.value]], @"\""];
                } else {
                    thisCutDimensionString = [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithFloat:cutPixel.value]], @"cm"];
                }
            }
            UIFont *thisFont = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:BOX_FONT];
            CGSize stringBoundingBox = [thisCutDimensionString sizeWithFont:thisFont];
            
            if (cutPixel.cutInPixels < MIN_CUT_SIZE) {
                // no red box
                [[UIColor closetMaidRedColor] setFill];
                // gray description text
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:BOX_FONT];
                CGPoint point;
                CGSize stringWasteBoundingBox = [thisCutDimensionString sizeWithFont:font];
                if (cutPixel.cutInPixels > MIN_CUT_NOBOX) {
                    if (stringWasteBoundingBox.width > appFrame.size.width / 2 - 10) {
                        point = CGPointMake(appFrame.size.width - stringWasteBoundingBox.width, yDescription + (yOfCurrentCut - stringWasteBoundingBox.height) / 2);
                    } else {
                        point = CGPointMake(appFrame.size.width / 2 + 10, yDescription + (yOfCurrentCut - stringWasteBoundingBox.height) / 2);
                    }
                    [thisCutDimensionString drawAtPoint:point withFont:font];
                }
            } else {
                // red box
                CGFloat xRect = appFrame.size.width / 2 + 2;
                CGFloat yRect = yDescription + (yOfCurrentCut - BOX_HEIGHT) / 2;
                CGFloat extraBoxWidth = 0;
                // get width of text and check if it's in box bounds
                // check box size for smaller cut sizes
                if (stringBoundingBox.width > BOX_WIDTH) {
                    extraBoxWidth = stringBoundingBox.width - BOX_WIDTH + 4;
                }
                roundRectDrawing = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(xRect - extraBoxWidth,
                                                                                      yRect,
                                                                                      BOX_WIDTH + extraBoxWidth,
                                                                                      BOX_HEIGHT) cornerRadius:3.0f];
                [[UIColor closetMaidRedColor] setFill];
                [roundRectDrawing fill];
                
                // white text
                [[UIColor whiteColor] setFill];
                xRect -= extraBoxWidth;
                xRect += (roundRectDrawing.bounds.size.width - stringBoundingBox.width) / 2;
                [self drawText:thisCutDimensionString atX:xRect atY:yRect + 1 withFont:thisFont];
            }
        }
        
        yDescription += yOfCurrentCut;
    };
}

- (void)drawText:(NSString *)text atX:(CGFloat)l atY:(CGFloat)r withFont:(UIFont *)f
{
    CGPoint point = CGPointMake(l, r);
    [text drawAtPoint:point withFont:f];
}

/*
 * Helper method
 */
- (BOOL)hasDownRod {
    return objectHasDownRod;
}

@end
