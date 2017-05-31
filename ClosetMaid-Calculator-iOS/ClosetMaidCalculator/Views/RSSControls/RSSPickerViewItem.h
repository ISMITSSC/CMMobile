//
//  RSSPickerViewItem.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/8/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSPickerViewItem : NSObject

@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* value;

+ (RSSPickerViewItem *) blankItem;

@end
