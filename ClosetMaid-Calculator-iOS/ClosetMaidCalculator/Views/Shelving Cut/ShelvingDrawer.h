//
//  ShelvingDrawer.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/7/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShelvingDrawer : UIView {
    CGRect appFrame;

    NSArray *shelfCut;
    CGFloat shelfSize;
    CGFloat shelfWaste;
    int unitMeasure;
    
    // helper
    CGFloat wasteApproxPixels;
    NSMutableArray *cutsApproxPixels;
    BOOL objectHasDownRod;
    
    // misc
    NSNumberFormatter *formatter;
}

#define VERTICAL_LINE_WIDTH 3.0f
#define HORIZONTAL_LINE_WIDTH 1.0f
#define DESCRIPTION_LINE_WIDTH 1.5f

#define MIN_WASTE_SIZE 10
#define MIN_CUT_SIZE 24
#define MIN_CUT_NOBOX 8

#define BOX_WIDTH 38
#define BOX_HEIGHT 20

#define WASTE_FONT 10
#define BOX_FONT 15

- (id)initWithFrame:(CGRect)frame drawCut:(NSArray *)cut onShelfSize:(CGFloat)size withWaste:(CGFloat)waste inUnit:(int)unit;
- (BOOL)hasDownRod;

@end
