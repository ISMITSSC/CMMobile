//
//  CalculatorView.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewDelegate.h"
#import "CustomTextField.h"
#import "RSSPickerButton.h"

@interface ShelvingCutCalculatorView : UIView

@property (nonatomic, weak) id<CalculatorViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RSSPickerButton *shelfPickerButton;
@property (nonatomic, strong) RSSPickerButton *shelfSizePickerButton;

- (id)initWithFrame:(CGRect)frame typesOfShelving:(NSArray *)types shelvingSizesImperial:(NSArray *)imperialSizes shelvingSizesMetric:(NSArray *)metricSizes;

- (void)updateViewForUnit:(UnitOfMeasure)unitOfMeasure;

@end
