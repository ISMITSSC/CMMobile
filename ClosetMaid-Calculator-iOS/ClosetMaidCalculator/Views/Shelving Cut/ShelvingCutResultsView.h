//
//  ShowResultsView.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowResultsViewDelegate.h"
#import "RSSButton.h"

@interface ShelvingCutResultsView : UIView


@property (nonatomic, weak) id<ShowResultsViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *drawerView;

- (void)updateViewWithCuts:(NSArray *)cuts andTotalWaste:(CGFloat)waste inUnit:(UnitOfMeasure)unitOfMeasure size:(CGFloat)size;

@end
