//
//  NSDictionary+Custom.h
//  ENPContactSearch
//
//  Created by roemerson on 11/21/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Custom)

+ (NSMutableDictionary *) dictionaryByMerging: (NSMutableDictionary *) dict1 with: (NSMutableDictionary *) dict2;
- (NSMutableDictionary *) dictionaryByMergingWith: (NSMutableDictionary *) dict;
- (NSArray *)allKeysSorted;

@end
