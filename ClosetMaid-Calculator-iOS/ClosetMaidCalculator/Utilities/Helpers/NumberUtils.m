//
//  NumberFormatterUtils.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/8/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "NumberUtils.h"

@implementation NumberUtils

+ (NSDecimalNumber *)localizedDecimalNumberWithString:(NSString *)text
{
    return [NSDecimalNumber decimalNumberWithString:text locale:[NSLocale currentLocale]];
}

+ (NSString *)formattedStringFromInt:(NSInteger)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 0;
    
    return [formatter stringFromNumber:[NSNumber numberWithInteger:number]];
}

+ (NSString *)formattedStringFromFloat:(CGFloat)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 2;
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
}

+ (NSString *)formattedStringFromNSNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 2;
    
    return [formatter stringFromNumber:number];
}

@end
