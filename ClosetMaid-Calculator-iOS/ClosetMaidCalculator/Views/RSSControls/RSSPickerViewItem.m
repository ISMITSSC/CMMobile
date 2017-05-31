//
//  RSSPickerViewItem.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSPickerViewItem.h"

@implementation RSSPickerViewItem

@synthesize label;
@synthesize value;

+(RSSPickerViewItem*) blankItem {
    RSSPickerViewItem* result = [[RSSPickerViewItem alloc] init];
    result.label = @"";
    result.value = @"";
    
    return result;
}

@end
