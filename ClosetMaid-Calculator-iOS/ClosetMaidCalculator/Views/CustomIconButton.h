//
//  CustomAddButton.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/9/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSButtonTemplate.h"

@interface CustomIconButton : UIButton

- (id)initWithFrame:(CGRect)frame imageIcon:(NSString *)image highlightedImageIcon:(NSString *)highlightedImage;

@end
