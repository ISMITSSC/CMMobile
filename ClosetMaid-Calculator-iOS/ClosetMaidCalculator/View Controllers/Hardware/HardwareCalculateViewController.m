//
//  ViewController.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 4/29/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "HardwareCalculateViewController.h"
#import "WireShelvingPlanner.h"
#import "HardwareShelf.h"
#import "UIColor+ClosetMaid.h"
#import "RSSPickerView.h"
#import "RSSPickerButton.h"
#import "NumberUtils.h"
#import "HardwareResultsViewController.h"
#import "CustomIconButton.h"


@interface HardwareCalculateViewController ()
{
    CGRect applicationFrame;
    
    NSArray *typesOfShelving;
    NSArray *imperialTypesOfShelving;
    NSArray *metricTypesOfShelving;
    NSArray *shelfLocationTypes;
    NSArray *unitArray;
    
    NSMutableArray *shelvingSections;
    
    RSSPickerButton *shelfPickerButton;
    RSSPickerButton *unitPicker;
    
    CGSize previousKeyboardSize;
    
    CGFloat MIN_LENGTH;
    CGFloat MAX_LENGTH;
}

- (void)updateView;
- (void)addTableViewRow;
- (void)removeLastTableViewRow;
- (void)reviewRowData;
- (BOOL)isEmptyRowContainingTextfield:(UITextField *)textField;
- (BOOL)isEmptyOtherTextFieldFromRowContainingTextfield:(UITextField *)textField;
- (NSString *)trimUnitOfMeasure:(NSString *)toTrim;
- (NSString *)appendUnitOfMeasure:(NSString *)toAppend;
- (UIView *)activeTableViewResponder;

@end




@implementation HardwareCalculateViewController

@synthesize unitOfMeasurement;

@synthesize scrollView = _scrollView;
@synthesize shelfPickerView;
@synthesize shelvingTableView;


/* ============================== */
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    _scrollView.contentSize = _scrollView.frame.size;
    
    MIN_LENGTH = (unitOfMeasurement == IMPERIAL) ? INCH_MIN_LENGTH : CM_MIN_LENGTH;
    MAX_LENGTH = (unitOfMeasurement == IMPERIAL) ? INCH_MAX_LENGTH : CM_MAX_LENGTH;

    shelvingSections = [[NSMutableArray alloc] init];
    [shelvingSections addObject:[[HardwareShelf alloc] init]];
    imperialTypesOfShelving = @[@"12\" SuperSlide or Closemesh",
                                @"16\" SuperSlide or Closemesh",
                                @"20\" Closemesh",
                                @"12\" Shelf & Rod",
                                @"16\" Shelf & Rod"];
    metricTypesOfShelving = @[@"30,48cm SuperSlide or Closemesh",
                              @"40,64cm SuperSlide or Closemesh",
                              @"50,8cm Closemesh",
                              @"30,48cm Shelf & Rod",
                              @"40,64cm Shelf & Rod"];
    shelfLocationTypes = @[@"Wall-to-Wall",
                           @"Wall-to-Open",
                           @"Open-to-Open"];
    
    unitArray = @[@"Imperial", @"Metric"];
    typesOfShelving =  (unitOfMeasurement == IMPERIAL) ? imperialTypesOfShelving : metricTypesOfShelving;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    shelfPickerButton = [[RSSPickerButton alloc] initWithAssociatedPickerViewTitle:@"Choose shelf type"
                                                                            values:typesOfShelving];
    [shelfPickerButton setFrame:CGRectMake(0,
                                          0,
                                          300,
                                          35)
                      imageIcon:nil
           highlightedImageIcon:nil];
    shelfPickerButton.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
    [shelfPickerButton setTitle:typesOfShelving[0]
                       forState:UIControlStateNormal];
    shelfPickerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    shelfPickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shelfPickerButton setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
    shelfPickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                        size:14];
    [(RSSPickerView*)shelfPickerButton.associatedView setPickerItemFontSize:18];
    [shelfPickerView addSubview:shelfPickerButton];
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                                    shelvingTableView.frame.origin.y + shelvingTableView.frame.size.height - shelvingTableView.rowHeight,
                                                                    shelvingTableView.frame.size.width,
                                                                    shelvingTableView.rowHeight)];
    gradientView.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor],
                                                (id)[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor], nil];
    gradient.startPoint = CGPointMake(1.0f, -0.1f);
    gradient.endPoint = CGPointMake(1.0f, 0.8f);
    [gradientView.layer insertSublayer:gradient
                               atIndex:0];
    [self.scrollView addSubview:gradientView];
    
    CustomIconButton *clearButton = [[CustomIconButton alloc] initWithFrame:CGRectMake(applicationFrame.size.width - 15 - 35,
                                                                                       applicationFrame.size.height - 45,
                                                                                       35,
                                                                                       35)
                                                                  imageIcon:@"icon-Trash"
                                                       highlightedImageIcon:@"icon-Trash-Highlight"];
    [clearButton addTarget:self
                    action:@selector(clearRows)
          forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:clearButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShelvingTableView:nil];
    [self setScrollView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self setShelfPickerView:nil];
    [super viewDidUnload];
}


/* ============================== */
#pragma mark - Actions

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)homeButtonPushed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)clearRows
{
    UIAlertView *clearAlert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                         message:@"Are you sure you want to clear the data?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                               otherButtonTitles:@"Yes", nil];
    [clearAlert show];
}


/* ============================== */
#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [shelvingSections removeAllObjects];
        // first row in table
        [shelvingSections addObject:[[HardwareShelf alloc] init]];
        [self.shelvingTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}


/* ============================== */
#pragma mark - UIPickerView delegate & datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return shelfLocationTypes.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITableViewCell *cellForPicker = [self.shelvingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pickerView.tag
                                                                                                      inSection:0]];
    ResponderLabel *locationLabel = (ResponderLabel *)[cellForPicker viewWithTag:LOCATION_FIELD];
    locationLabel.text = shelfLocationTypes[row];
    
    HardwareShelf *rowToEdit = shelvingSections[pickerView.tag];
    rowToEdit.location = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                     size:16];
        tView.textAlignment = UITextAlignmentCenter;
        tView.backgroundColor = [UIColor clearColor];
    }
    
    tView.text = shelfLocationTypes[row];
    
    return tView;
}


/* ============================== */
#pragma mark - UITableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shelvingSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShelvingCell"];
    
    HardwareShelf *shelf = shelvingSections[indexPath.row];
    
    UITextField *quantityTextField = (UITextField *)[cell viewWithTag:QUANTITY_FIELD];
    quantityTextField.text = shelf.quantity ? [NSString stringWithFormat:@"%d", shelf.quantity] : nil;
    
    ResponderLabel *locationLabel = (ResponderLabel *)[cell viewWithTag:LOCATION_FIELD];
    locationLabel.text = shelfLocationTypes[shelf.location];
    UIPickerView *locationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                                  applicationFrame.size.height - 150,
                                                                                  applicationFrame.size.width,
                                                                                  150)];
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    locationPicker.showsSelectionIndicator = YES;
    locationPicker.tag = indexPath.row;
    [locationPicker selectRow:shelf.location
                  inComponent:0
                     animated:NO];
    locationLabel.inputView = locationPicker;
    
    UITextField *lengthTextField = (UITextField *)[cell viewWithTag:LENGTH_FIELD];
    lengthTextField.text = shelf.shelvingLength ? [NSString stringWithFormat:@"%d\"", shelf.shelvingLength] : nil;
    
    return cell;
}

- (void)tableView:(UITableView *)someTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete ) {
        if (indexPath.row < shelvingSections.count) {
            UITableViewCell *cell = (UITableViewCell *)[someTableView cellForRowAtIndexPath:indexPath];
            UITextField *quantityTextField = (UITextField *)[cell viewWithTag:QUANTITY_FIELD];
            UITextField *lengthTextField = (UITextField *)[cell viewWithTag:LENGTH_FIELD];
            if (shelvingSections.count > 1) {
                if (quantityTextField.backgroundColor != [UIColor closetMaidTextFieldGrayColor] ||
                    lengthTextField.backgroundColor != [UIColor closetMaidTextFieldGrayColor]) {
                    [self.view endEditing:YES];
                }
                [someTableView beginUpdates];
                // Delete the data
                HardwareShelf *rowToEdit = shelvingSections[indexPath.row];
                [shelvingSections removeObject:rowToEdit];
                // Delete the table cell
                [self.shelvingTableView deleteRowsAtIndexPaths:@[indexPath]
                                              withRowAnimation:UITableViewRowAnimationFade];
                // Decrement number of rows (for alert message)
                [someTableView endUpdates];
            } else {
                // Delete the data
                HardwareShelf *rowToEdit = shelvingSections[indexPath.row];
                rowToEdit.quantity = 0;
                rowToEdit.shelvingLength = 0;
                quantityTextField.text = @"";
                lengthTextField.text = @"";
            }
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    UITextField *quantityTextField = (UITextField *)[cell viewWithTag:QUANTITY_FIELD];
//    UITextField *lengthTextField = (UITextField *)[cell viewWithTag:LENGTH_FIELD];
//    if ((quantityTextField.text.length > 0) && (lengthTextField.text.length > 0)) {
//        return UITableViewCellEditingStyleDelete;
//    }
    return UITableViewCellEditingStyleNone;
}


/* ============================== */
#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self isEmptyRowContainingTextfield:textField] && (string.length > 0)) {
        [self addTableViewRow];
    }
    
    NSString *proposedNewString = [[textField text] stringByReplacingCharactersInRange:range
                                                                            withString:string];
    
    if ((proposedNewString.length == 0) && [self isEmptyOtherTextFieldFromRowContainingTextfield:textField] && (shelvingSections.count > 1)) {
        [self removeLastTableViewRow];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField.tag == LENGTH_FIELD) &&
        (textField.text.integerValue > 0))
    {
        textField.text = [self trimUnitOfMeasure:textField.text];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    textField.backgroundColor = [UIColor closetMaidTextFieldFocusGrayColor];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    textField.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
    [UIView commitAnimations];
    
    UITableViewCell *cell;
    NSIndexPath *indexPath;
    HardwareShelf *rowToEdit;
    
    switch (textField.tag) {
        case QUANTITY_FIELD: {
            cell = (UITableViewCell *)textField.superview.superview;
            indexPath = [self.shelvingTableView indexPathForCell:cell];
            rowToEdit = shelvingSections[indexPath.row];
            
            if (([textField.text isEqualToString:@""] && rowToEdit.quantity != 0) || [textField.text isEqualToString:@"0"]) {
                rowToEdit.quantity = 0;
            } else {
                rowToEdit.quantity = textField.text.integerValue;
            }

            break;
        }
            
        case LENGTH_FIELD: {
            BOOL error = NO;
            NSDecimalNumber* lengthDecimalNumber = [NumberUtils localizedDecimalNumberWithString:textField.text];
            cell = (UITableViewCell *)textField.superview.superview;
            indexPath = [self.shelvingTableView indexPathForCell:cell];
            rowToEdit = shelvingSections[indexPath.row];
            
            // if length in tablecell outside allowed limits alert + modify
            if ((lengthDecimalNumber.integerValue != 0) && ((lengthDecimalNumber.integerValue > MAX_LENGTH) ||
                                                            (lengthDecimalNumber.integerValue < MIN_LENGTH))) {
                NSString *message = [NSString stringWithFormat:@"The specified length does not fall within the expected range (%.0f - %.0f)", MIN_LENGTH, MAX_LENGTH];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
                [alert show];
                
                NSInteger defaultTo = (lengthDecimalNumber.integerValue > MAX_LENGTH) ? MAX_LENGTH : MIN_LENGTH;
                textField.text = [self appendUnitOfMeasure:[NumberUtils formattedStringFromInt:defaultTo]];
                rowToEdit.shelvingLength = defaultTo;
                error = YES;
            }
            // verify if quantity was changed or just focused then unfocused
            // don't replace value in codebehind if no change
            // done this to maintain consistent value after conversion and keep UI clean i.e. 2 decimals
            if (!error && textField.text.length > 0) {
                if (![textField.text isEqualToString:[NumberUtils formattedStringFromInt:rowToEdit.shelvingLength]]) {
                    rowToEdit.shelvingLength = lengthDecimalNumber.integerValue;
                }
                textField.text = [NumberUtils formattedStringFromNSNumber:lengthDecimalNumber];
                if ([textField.text isEqualToString:@"NaN"]) {
                    textField.text = @"0";
                    rowToEdit.shelvingLength = 0;
                }
                textField.text = [self appendUnitOfMeasure:textField.text];
            } else {
//                if (rowToEdit.shelvingLength <= 0) {
                    rowToEdit.shelvingLength = 0;
//                }
            }
            
            break;
        }
            
        default:
            break;
    }
}


/* ============================== */
#pragma mark - Notifications - Keyboard
/*
 *  UIKeyboardWillShowNotification
 *  Shifts the view above the keyboard + make it scrollable
 */
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    UIView *activeResponder = [self activeTableViewResponder];
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (activeResponder) {
        // Prepare scrollView for shifting
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        
        // Actual Y value of the TableCell on the screen - so we shift only the smallest needed ammount
        //i.e. shift less for top cell, more for bottom cell in view
        CGPoint origin = activeResponder.frame.origin;
        if ([activeResponder.superview.superview isKindOfClass:[UITableViewCell class]]) {
            CGPoint initialPoint = activeResponder.bounds.origin;
            origin = [activeResponder convertPoint:initialPoint
                                            toView:nil];
        }
        origin.y += activeResponder.frame.size.height;
        
        // Verify if keyboard hidex textfield; if so, scroll the view upwards
        CGRect aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        if (!CGRectContainsPoint(aRect, origin)) {
            CGPoint scrollPoint = CGPointMake(0,
                                              origin.y - keyboardSize.height - activeResponder.frame.size.height / 2);
            [self.scrollView setContentOffset:scrollPoint
                                     animated:YES];
        }
    }
    
    activeResponder = nil;
    previousKeyboardSize = keyboardSize;
}

/*
 *  UIKeyboardWillHideNotification
 *  Restore default view
 */
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // Animate the reset
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

/* ============================== */
#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showResults"]) {
        if ((shelvingSections.count <= 1) &&
            ([(HardwareShelf *)shelvingSections[0] quantity] == 0) &&
            ([(HardwareShelf *)shelvingSections[0] shelvingLength] == 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please specify at least one shelf."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showResults"]) {
        HardwareResultsViewController *destViewController = segue.destinationViewController;
        destViewController.hardware = [WireShelvingPlanner hardwareFromShelves:shelvingSections
                                                                      withType:[typesOfShelving indexOfObject:shelfPickerButton.selectedValue]];
    }
}



/* ============================== */
#pragma mark - Private methods

- (void)updateView
{
    for (UIView *v in self.shelvingTableView.subviews) {
        if ([v isKindOfClass:[UITableViewCell class]]) {
            UITextField *lengthTextField = (UITextField *)[v viewWithTag:LENGTH_FIELD];
            if (lengthTextField.text.length > 0) {
                lengthTextField.text = [self appendUnitOfMeasure:[self trimUnitOfMeasure:lengthTextField.text]];
            }
        }
    }
}

- (void)addTableViewRow
{
    if (shelvingSections.count < MAX_ROWS) {
        // Add new shelving object to the array on last position
        [shelvingSections addObject:[[HardwareShelf alloc] init]];
        // Insert cell in table
        [shelvingTableView beginUpdates];
        [shelvingTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:shelvingSections.count - 1
                                                                                              inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationFade];
        [shelvingTableView endUpdates];
        // Scroll table to bottom
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:shelvingSections.count - 1
                                                inSection:0];
        [shelvingTableView scrollToRowAtIndexPath:ipath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
    } else {
        NSString* alertMessage = [NSString stringWithFormat:@"The maximum allowed number of rows is %i.", MAX_ROWS];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)removeLastTableViewRow
{
    [shelvingTableView beginUpdates];
    NSIndexPath *lastRowIndexPath = [NSIndexPath indexPathForRow:shelvingSections.count - 1
                                                       inSection:0];
    // Delete the data
    HardwareShelf *rowToEdit = [shelvingSections objectAtIndex:lastRowIndexPath.row];
    [shelvingSections removeObject:rowToEdit];
    // Delete the table cell
    [shelvingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:lastRowIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
    // Decrement number of rows (for alert message)
    [shelvingTableView endUpdates];
}

- (void)reviewRowData
{
    BOOL wasModified = NO;
    
//    for (UIView *v in calculatorView.tableView.subviews) {
//        if ([v isKindOfClass:[CustomTableCell class]]) {
//            CustomTextField *tempField = [(CustomTableCell *)v lengthTextField];
//            if (tempField.text.integerValue > shelfSize) {
//                tempField.text = [self appendUnitOfMeasure:[NumberUtils formattedStringFromInt:shelfSize]];
//                wasModified = YES;
//            }
//        }
//    }
    
    if (wasModified) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Some rows were updated for the new shelving length."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)isEmptyRowContainingTextfield:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    if (([[(UITextField *)[cell viewWithTag:QUANTITY_FIELD] text] length] == 0) && ([[(UITextField *)[cell viewWithTag:LENGTH_FIELD] text] length] == 0))
        return YES;
    else
        return NO;
}

- (BOOL)isEmptyOtherTextFieldFromRowContainingTextfield:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    if (textField.tag == QUANTITY_FIELD) {
        if ([[(UITextField *)[cell viewWithTag:LENGTH_FIELD] text] length] == 0) {
            return YES;
        }
    }
    if (textField.tag == LENGTH_FIELD) {
        if ([[(UITextField *)[cell viewWithTag:QUANTITY_FIELD] text] length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)trimUnitOfMeasure:(NSString *)toTrim
{
    if (unitOfMeasurement == IMPERIAL) {
        return [toTrim substringToIndex:toTrim.length - 2];
    } else {
        return [toTrim substringToIndex:toTrim.length - 1];
    }
}

- (NSString *)appendUnitOfMeasure:(NSString *)toAppend
{
    if (unitOfMeasurement == IMPERIAL) {
        return [NSString stringWithFormat:@"%@\"", toAppend];
    } else {
        return [NSString stringWithFormat:@"%@cm", toAppend];
    }
    
}

- (UIView *)activeTableViewResponder
{
    NSArray *subViews = [self.shelvingTableView subviews];
    for (id cell in subViews) {
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *aCell = cell;
            NSArray *cellSubViews = aCell.contentView.subviews;
            for (UIView *responder in cellSubViews) {
                if ([responder isFirstResponder]) {
                    return responder;
                }
            }
        }
    }
    
    return nil;
}

@end
