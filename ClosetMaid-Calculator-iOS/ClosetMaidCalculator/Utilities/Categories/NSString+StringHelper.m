//
//  NSString+StringHelper.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/9/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//


@implementation NSString (StringHelper)


- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size  {
    //Calculate the expected size based on the font and linebreak mode of the label
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.4 - 10;
    CGFloat maxHeight = 9999;
    CGSize maximumLabelSize = CGSizeMake(maxWidth, maxHeight);
    
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    
    return expectedLabelSize.height + 10;
}

- (UILabel *) sizeCellLabelWithSystemFontOfSize:(CGFloat)size {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat height = [self textHeightForSystemFontOfSize:size] + 10.0;
    CGRect frame = CGRectMake(10.0f, 10.0f, width, height);
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.backgroundColor = [UIColor clearColor];
    cellLabel.textAlignment = NSTextAlignmentLeft;
    cellLabel.font = [UIFont systemFontOfSize:size];
    
    cellLabel.text = self;
    cellLabel.numberOfLines = 0;
    [cellLabel sizeToFit];
    return cellLabel;
}

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size  widthConstrains:(CGFloat)maxWidthText {
    
    CGFloat maxWidth = maxWidthText;
    CGFloat maxHeight = 9999;
    CGSize maximumLabelSize = CGSizeMake(maxWidth, maxHeight);
    
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByCharWrapping];
    
    return expectedLabelSize.height;
}

+  (BOOL) isEmptyString:(NSString*) theString {
    return (theString == nil) || [[theString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet ]] isEqualToString:@""];
}

-(BOOL) isEmpty {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

-(NSString*) uncapitalize {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] lowercaseString]];
}

-(NSString*) capitalize {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}


@end