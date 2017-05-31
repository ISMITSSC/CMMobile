//
//  Utils.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "Utils.h"
#import "NSString+StringHelper.h"

@implementation Utils

+ (BOOL) isNullOrEmpty:(NSString *)text
{
    if (text != nil)
    {
        return [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEmpty];
    }
    return YES;
};

+ (NSString *) trimCheckNulls:(NSString *)text
{
    if (text != nil)
    {
        return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return @"";
};

+(NSArray*) namesFromString:(NSString*) textToSplit {
    
    textToSplit = [textToSplit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *chunks = [textToSplit componentsSeparatedByString: @" "];
    
    NSString *lastName = [chunks objectAtIndex:[chunks count]-1];
    
    NSRange rangeOfSubstring = [textToSplit rangeOfString:lastName];
    
    if(rangeOfSubstring.location == NSNotFound)
    {
        // error condition — the text '<a href' wasn't in 'string'
    }
    
    // return only that portion of 'string' up to where '<a href' was found
    NSString* firstName = [textToSplit substringToIndex:rangeOfSubstring.location];
    
    return [NSArray arrayWithObjects:firstName, lastName, nil];
}


@end
