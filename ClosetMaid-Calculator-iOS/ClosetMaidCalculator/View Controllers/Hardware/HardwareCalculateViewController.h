//
//  ViewController.h
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 4/29/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ResponderLabel.h"
#import "RSSPickerViewDelegate.h"


@interface HardwareCalculateViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource,
UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate,
UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *shelvingTableView;
@property (strong, nonatomic) IBOutlet UIView *shelfPickerView;

@property (nonatomic, assign) UnitOfMeasure unitOfMeasurement;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)homeButtonPushed:(id)sender;

@end
