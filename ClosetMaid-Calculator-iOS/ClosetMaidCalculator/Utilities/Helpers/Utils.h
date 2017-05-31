//
//  Utils.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//


@interface Utils : NSObject

+ (BOOL) isNullOrEmpty:(NSString *)text;
+ (NSString *) trimCheckNulls:(NSString *)text;
+ (NSArray*) namesFromString:(NSString*) textToSplit;

@end
