//
//  ClosetMaidConstants.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 6/18/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClosetMaidConstants : NSObject

/* ======= */
/* GENERAL */
/* ======= */
typedef enum unitTypes {
    IMPERIAL,
    METRIC
} UnitOfMeasure;

extern NSInteger const LEFT_PADDING;

extern NSInteger const MAX_ROWS;

extern NSInteger const UNIT_PICKER_TAG;

extern CGFloat const INCH_MIN_LENGTH;
extern CGFloat const INCH_MAX_LENGTH;
extern CGFloat const CM_MIN_LENGTH;
extern CGFloat const CM_MAX_LENGTH;
/* ================================================== */


/* ============ */
/* SHELVING CUT */
/* ============ */
extern NSInteger const DRAWING_WIDTH;
extern NSInteger const DRAWING_HEIGHT;

typedef enum shelvingCutTypes {
    SUPERSLIDE,
    TOTALSLIDE
} ShelvingCutShelving;

typedef enum shelvingCutControlTags {
    SIZE_PICKER_TAG,
    DEFAULT_TAG,
    QUANTITY_TAG,
    LENGTH_TAG
} ShelvingCutTags;
/* ================================================== */

/* ======== */
/* HARDWARE */
/* ======== */
typedef enum hardwareShelvingTypes {
    SUPERSLIDE_12,
    SUPERSLIDE_16,
    CLOSEMESH,
    SHELF_ROD_12,
    SHELF_ROD_16
} HardwareShelving;

typedef enum hardwareShelfLocationTypes {
    WALL_TO_WALL,
    WALL_TO_OPEN,
    OPEN_TO_OPEN
} HardwareShelfLocation;

typedef enum hardwareControlTags {
    QUANTITY_FIELD = 201,
    LOCATION_FIELD = 202,
    LENGTH_FIELD = 203,
    HARDWARE_LABEL = 211,
    QUANTITY_LABEL = 212
} HardwareTags;
/* ================================================== */

@end
