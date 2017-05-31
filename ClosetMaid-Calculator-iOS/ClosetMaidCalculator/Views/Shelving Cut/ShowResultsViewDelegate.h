//
//  ShowResultsViewDelegate.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/7/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShowResultsViewDelegate <NSObject>

@required

- (void)backButtonPush;
- (void)showEmailButtonPush;

@end
