//
//  NumberFormatterUtils.h
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/8/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberUtils : NSObject

+ (NSDecimalNumber *)localizedDecimalNumberWithString:(NSString *)text;

+ (NSString *)formattedStringFromInt:(NSInteger)number;

+ (NSString *)formattedStringFromFloat:(CGFloat)number;

+ (NSString *)formattedStringFromNSNumber:(NSNumber *)number;

@end
