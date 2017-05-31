//
//  MainViewController.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 6/18/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "MainViewController.h"
#import "ShelvingCutCalculateViewController.h"
#import "HardwareCalculateViewController.h"
#import "RSSPickerButton.h"


@interface MainViewController ()
{
    UnitOfMeasure unitOfMeasurement;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    NSArray *unitArray = @[@"Imperial", @"Metric"];
    unitOfMeasurement = IMPERIAL;
    
    RSSPickerButton *unitPicker = [[RSSPickerButton alloc] initWithAssociatedPickerViewTitle:@"Choose unit of measure"
                                                                                      values:unitArray];
    [unitPicker setFrame:CGRectMake(LEFT_PADDING,
                                    applicationFrame.size.height - 45,
                                    35,
                                    35)
               imageIcon:@"icon-Settings"
    highlightedImageIcon:@"icon-Settings-Highlight"];
    unitPicker.backgroundColor = [UIColor clearColor];
    [unitPicker setSelectedValue:unitArray[0]];
    [(RSSPickerView*)unitPicker.associatedView setPickerItemFontSize:18];
    unitPicker.tag = UNIT_PICKER_TAG;
    unitPicker.delegate = self;
    [self.view addSubview:unitPicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* ============================== */
#pragma mark - RSSPickerViewDelegate methods

- (void)doneButtonClickedForPickerButton:(RSSPickerButton*)thePickerButton
{
    if (thePickerButton.tag == UNIT_PICKER_TAG) {
        if ([thePickerButton wasModified]) {
            unitOfMeasurement = !unitOfMeasurement; // switch units
        }
    }
}


/* ============================== */
#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shelvingCutSegue"]) {
        ShelvingCutCalculateViewController *destVC = segue.destinationViewController;
        destVC.unitOfMeasurement = unitOfMeasurement;
    }
    if ([segue.identifier isEqualToString:@"hardwareSegue"]) {
        HardwareCalculateViewController *destVC = segue.destinationViewController;
        destVC.unitOfMeasurement = unitOfMeasurement;
    }
}

@end
