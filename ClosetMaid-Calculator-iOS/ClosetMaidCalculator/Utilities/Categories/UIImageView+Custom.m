//
//  UIImageView+Custom.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 11/1/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "UIImageView+Custom.h"

@implementation UIImageView(Custom)


- (UIImageView*) initImageWithDeviceSpecificResolution:(NSString*) imageName {
    
    // If Iphone 4 or earlier
    if([[UIScreen mainScreen] bounds].size.height <= 480.0) {
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
    else // Iphone 5
    {
        UIImage* retinaImage = [UIImage imageNamed:[imageName stringByReplacingOccurrencesOfString:@"." withString:@"-568h."]];
        if(retinaImage) // If retina image found.
            return [[UIImageView alloc] initWithImage:retinaImage];
        else    // Otherwise, use normal sized image.
            return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    }
}

@end
