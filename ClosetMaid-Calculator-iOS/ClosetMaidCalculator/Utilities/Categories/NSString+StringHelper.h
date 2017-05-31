//
//  NSString+StringHelper.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/9/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//


@interface NSString (StringHelper)

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size;

- (UILabel *)sizeCellLabelWithSystemFontOfSize:(CGFloat)size;

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size  widthConstrains:(CGFloat)maxWidthText;

+ (BOOL) isEmptyString:(NSString*) theString;

- (BOOL) isEmpty;

-(NSString*) capitalize;

- (NSString*) uncapitalize;

@end