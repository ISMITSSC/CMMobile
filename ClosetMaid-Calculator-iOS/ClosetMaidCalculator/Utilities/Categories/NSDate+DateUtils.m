//
//  NSDate+DateUtils.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "Utils.h"

@implementation NSDate (DateHelper)


- (BOOL) isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    return NO;
}

- (NSString *) displayDefaultDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale: usLocale];
    return [dateFormat stringFromDate:self];
}

- (NSString *) displayDefaultDateTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale: usLocale];
    return [dateFormat stringFromDate:self];
}

- (NSString *) displayOnlyDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale: usLocale];
    return [dateFormat stringFromDate:self];
}

- (NSString *) displayDefaultTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale: usLocale];
    return [dateFormat stringFromDate:self];
}

- (NSString *) displayDateWithFormat:(NSString *) format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale: usLocale];
    return [dateFormat stringFromDate:self];
}

- (NSString *) displayStartDateAndEndDate:(NSDate *) endDate
{
    NSString *tempResult = [self displayDefaultDate];
    if (![[Utils trimCheckNulls:[endDate displayDefaultDate]]isEqual:@""])
    {
        tempResult = [tempResult stringByAppendingString:@" - "];
        tempResult = [tempResult stringByAppendingString:[Utils trimCheckNulls:[endDate displayDefaultDate]]];
    }
    return tempResult;
}

- (NSString *) displayStartDateTimeAndEndDateTime:(NSDate *) endDate
{
    NSString *tempResult = [self displayDefaultDateTime];
    tempResult = [tempResult stringByAppendingString:@" - "];
    tempResult = [tempResult stringByAppendingString:[Utils trimCheckNulls:[endDate displayDefaultDateTime]]];
    return tempResult;
}

- (NSString *) displayStartDateTimeAndEndDateTimeFormatted:(NSDate *) endDate
{
    NSString *tempResult;
    if ([self isToday])
    {
        tempResult = [self displayDefaultTime];
    } else
    {
        tempResult = [self displayDefaultDateTime];
    }
    tempResult = [tempResult stringByAppendingString:@" - "];
    
    if ([endDate isToday])
    {
        tempResult = [tempResult stringByAppendingString:[Utils trimCheckNulls:[endDate displayDefaultTime]]];
    } else
    {
        tempResult = [tempResult stringByAppendingString:[Utils trimCheckNulls:[endDate displayDefaultDateTime]]];
    }
    return tempResult;
}

+ (NSDate*) startOfToday
{
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:[NSDate date]];
    
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    return [calendar dateFromComponents:dateComponents];
}

+ (NSDate *)dateWithNoTime:(NSDate *)dateTime {
    if( dateTime == nil ) {
        dateTime = [NSDate date];
    }
    
    NSCalendar       *calendar   = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                             fromDate:dateTime];
    
    NSDate *dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

- (NSComparisonResult)compareDateOnly:(NSDate *)otherDate {
    NSUInteger dateFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *selfComponents = [gregorianCalendar components:dateFlags fromDate:self];
    NSDate *selfDateOnly = [gregorianCalendar dateFromComponents:selfComponents];
    
    NSDateComponents *otherCompents = [gregorianCalendar components:dateFlags fromDate:otherDate];
    NSDate *otherDateOnly = [gregorianCalendar dateFromComponents:otherCompents];
    return [selfDateOnly compare:otherDateOnly];
}


@end
