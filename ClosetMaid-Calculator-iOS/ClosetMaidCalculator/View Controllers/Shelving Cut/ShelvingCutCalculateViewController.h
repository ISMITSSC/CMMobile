//
//  MainViewController.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import "CalculatorViewDelegate.h"


@interface ShelvingCutCalculateViewController : UIViewController
<CalculatorViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) UnitOfMeasure unitOfMeasurement;

@end
