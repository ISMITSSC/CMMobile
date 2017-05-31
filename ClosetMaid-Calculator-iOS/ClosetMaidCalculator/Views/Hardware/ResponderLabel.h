//
//  ResponderLabel.h
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/2/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClosetMaidLabel.h"

@interface ResponderLabel : ClosetMaidLabel;

@property (strong, nonatomic, readwrite) UIView *inputView;
@property (strong, nonatomic, readwrite) UIView *inputAccessoryView;

@end
