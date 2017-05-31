//
//  CalculatorViewDelegate.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/21/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSPickerViewDelegate.h"

@protocol CalculatorViewDelegate <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, RSSPickerViewDelegate>

@required

- (void)homeButtonPushed;
- (void)hideKeyboard;
- (void)calculateCutsButtonPush;
- (void)clearRows;

@end
