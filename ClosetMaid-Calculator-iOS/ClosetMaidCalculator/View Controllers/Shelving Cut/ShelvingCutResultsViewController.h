//
//  ResultsViewController.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/12/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ShowResultsViewDelegate.h"
#import <MessageUI/MessageUI.h>


@interface ShelvingCutResultsViewController : UIViewController
<ShowResultsViewDelegate, MFMailComposeViewControllerDelegate>


- (id)initWithSize:(CGFloat)sizeOfShelf
           andType:(NSString *)typeOfShelf
          withCuts:(NSArray *)shelvingCuts
            inUnit:(UnitOfMeasure)unit;

@end
