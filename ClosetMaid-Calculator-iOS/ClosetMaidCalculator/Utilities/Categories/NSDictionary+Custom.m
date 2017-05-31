//
//  NSDictionary+Custom.m
//  ENPContactSearch
//
//  Created by roemerson on 11/21/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "NSDictionary+Custom.h"
#import "NSString+StringHelper.h"

@implementation NSMutableDictionary (Custom)

+ (NSMutableDictionary *) dictionaryByMerging: (NSMutableDictionary *) dict1 with: (NSMutableDictionary *) dict2 {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    
    [dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
//        if ([dict1 objectForKey:key]) {
//            if ([obj isKindOfClass:[NSDictionary class]]) {
//                NSMutableDictionary * newVal = [[dict1 objectForKey: key] dictionaryByMergingWith: (NSMutableDictionary *) obj];
//                [result setObject: newVal forKey: key];
//            } else {
//                [result setObject: obj forKey: key];
//            }
//        }
        [result setObject: obj forKey: key];
    }];
    
    return [result mutableCopy];
}

- (NSMutableDictionary *) dictionaryByMergingWith: (NSMutableDictionary *) dict {
    return [[self class] dictionaryByMerging: self with: dict];
}

- (NSArray *)allKeysSorted
{
    return [[super allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


@end
