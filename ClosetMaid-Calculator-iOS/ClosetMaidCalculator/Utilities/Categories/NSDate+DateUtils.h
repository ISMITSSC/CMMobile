//
//  NSDate+DateUtils.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//


@interface NSDate (DateUtils)

- (BOOL) isToday;
- (NSString *) displayDefaultDate;
- (NSString *) displayDefaultDateTime;
- (NSString *) displayDefaultTime;
- (NSString *) displayDateWithFormat:(NSString *) format;
- (NSString *) displayStartDateAndEndDate:(NSDate *) endDate;
- (NSString *) displayStartDateTimeAndEndDateTime:(NSDate *) endDate;
- (NSString *) displayStartDateTimeAndEndDateTimeFormatted:(NSDate *) endDate;
+ (NSDate*) startOfToday;
- (NSString *) displayOnlyDate;
+ (NSDate *)dateWithNoTime:(NSDate *)dateTime;
- (NSComparisonResult)compareDateOnly:(NSDate *)otherDate;

@end
