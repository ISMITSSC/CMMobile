//
//  CustomAddButton.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/9/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "CustomIconButton.h"
#import "UIImageView+Custom.h"

@implementation CustomIconButton

- (id)initWithFrame:(CGRect)frame imageIcon:(NSString *)image highlightedImageIcon:(NSString *)highlightedImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initImageWithDeviceSpecificResolution:image];
        [self setImage:imageView.image
              forState:UIControlStateNormal];
        if (highlightedImage) {
            UIImageView *highlightedImageView = [[UIImageView alloc] initImageWithDeviceSpecificResolution:highlightedImage];
            [self setImage:highlightedImageView.image
                  forState:UIControlStateHighlighted];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
