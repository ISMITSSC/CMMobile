//
//  MainViewController.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutCalculateViewController.h"
#import "ShelvingCutResultsViewController.h"
#import "ShelvingCutCalculatorView.h"
#import "CustomTableCell.h"
#import "ShelvingCutShelf.h"
#import "CutCalculator.h"
#import "NumberUtils.h"
#import "UIColor+ClosetMaid.h"


@interface ShelvingCutCalculateViewController ()
{
    CGRect applicationFrame;
    
    ShelvingCutCalculatorView *calculatorView;
    
    // data
    NSArray *shelvingSizesImperial;
    NSArray *shelvingSizesMetric;
    NSArray *shelvingTypes;
    CGFloat shelfSize;
    NSMutableArray *shelvingSections;
    
    // misc
    CGPoint scrollPoint;
    UITextField *activeTextField;
    UnitOfMeasure unitOfMeasurement;
    int noOfRows;
    BOOL emptyRowExists;
    
    CGFloat MIN_LENGTH;
    CGFloat MAX_LENGTH;
}

- (NSString *)trimUnitOfMeasure:(NSString *)toTrim;
- (NSString *)appendUnitOfMeasure:(NSString *)toAppend;
- (void)addTableViewRow;
- (void)removeLastTableViewRow;
- (void)reviewRowData;
- (BOOL)isEmptyRowContainingTextfield:(UITextField *)textField;
- (BOOL)isEmptyOtherTextFieldFromRowContainingTextfield:(UITextField *)textField;

@end


@implementation ShelvingCutCalculateViewController

@synthesize unitOfMeasurement;


/* ============================== */
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    // Custom initialization
    shelvingTypes = @[@"SuperSlide®, Close Mesh and Linen",
                      @"TotalSlide® and Shelf & Rod"];
    shelvingSizesImperial = @[@"48\"",
                              @"72\"",
                              @"96\"",
                              @"144\""];
    shelvingSizesMetric = @[@"121,92cm",
                            @"182,88cm",
                            @"243,84cm",
                            @"365,76cm"];
    
    calculatorView = [[ShelvingCutCalculatorView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 applicationFrame.size.width,
                                                                                 applicationFrame.size.height)
                                                      typesOfShelving:shelvingTypes
                                                shelvingSizesImperial:shelvingSizesImperial
                                                  shelvingSizesMetric:shelvingSizesMetric];
    [calculatorView updateViewForUnit:unitOfMeasurement];
    // data init
    MIN_LENGTH = (unitOfMeasurement == IMPERIAL) ? INCH_MIN_LENGTH : CM_MIN_LENGTH;
    MAX_LENGTH = (unitOfMeasurement == IMPERIAL) ? INCH_MAX_LENGTH : CM_MAX_LENGTH;
    shelfSize = (unitOfMeasurement == IMPERIAL) ? 48 : 121.92;
    shelvingSections = [[NSMutableArray alloc] init];
    // first row in table
    noOfRows = 1;
    [shelvingSections addObject:[[ShelvingCutShelf alloc] init]];
    calculatorView.delegate = self;
    self.view = calculatorView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* ============================== */
#pragma mark - Notifications

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Prepare scrollView for shifting
    calculatorView.scrollView.contentInset = UIEdgeInsetsMake(0,
                                                              0,
                                                              keyboardSize.height,
                                                              0);;
    calculatorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0,
                                                                       0,
                                                                       keyboardSize.height,
                                                                       0);
    
    
    // Actual Y value of the TableCell on the screen - so we shift only the smallest needed ammount
    //i.e. shift less for top cell, more for bottom cell in view
    CGPoint yActual = activeTextField.frame.origin;
    if ([activeTextField.superview.superview isKindOfClass:[CustomTableCell class]]) {
        CGPoint initialPoint = [activeTextField bounds].origin;
        yActual = [activeTextField convertPoint:initialPoint
                                         toView:nil];
    }
    yActual.y += activeTextField.frame.size.height;
    
    // Verify if keyboard hidex textfield; if so, scroll the view upwards
    CGRect aRect = calculatorView.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect,
                             yActual)) {
        scrollPoint = CGPointMake(0,
                                  yActual.y - keyboardSize.height - activeTextField.frame.size.height/2);
        [calculatorView.scrollView setContentOffset:scrollPoint
                                           animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.3];
    // Animate the reset
    calculatorView.scrollView.contentInset = UIEdgeInsetsZero;
    calculatorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [UIView commitAnimations];
}


/* ============================== */
#pragma mark - CalculatorViewDelegate methods

- (void)homeButtonPushed
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (void)hideKeyboard
{
    [calculatorView endEditing:YES];
    [calculatorView.tableView setEditing:NO
                                animated:YES];
}

- (void)calculateCutsButtonPush
{
    [self hideKeyboard];
    
    NSString *type = calculatorView.shelfPickerButton.selectedValue;
    ShelvingCutShelving intType;
    if ([type isEqualToString:shelvingTypes[0]]) {
        intType = SUPERSLIDE;
    } else {
        intType = TOTALSLIDE;
    }
    
    // verify if quantity < 1000
    NSInteger totalQuantity = 0;
    BOOL noLengths = YES;
    for (ShelvingCutShelf *qlP in shelvingSections) {
        totalQuantity += qlP.quantity;
        if (qlP.lengthOf > 0) {
            noLengths = NO;
        }
    }
    
    if (noLengths || totalQuantity == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please specify at least one cut."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (totalQuantity > 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"The maximum allowed number of total cuts is 1000."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSArray *results = [CutCalculator performCutsFrom:shelvingSections
                                                 withSize:shelfSize
                                                  andType:intType
                                                   inUnit:unitOfMeasurement];
        
        ShelvingCutResultsViewController *resultController = [[ShelvingCutResultsViewController alloc] initWithSize:shelfSize
                                                                                                            andType:type
                                                                                                           withCuts:results
                                                                                                             inUnit:unitOfMeasurement];
        [self presentViewController:resultController
                           animated:YES
                         completion:nil];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [shelvingSections removeAllObjects];
        // first row in table
        noOfRows = 1;
        [shelvingSections addObject:[[ShelvingCutResultsViewController alloc] init]];
        [calculatorView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                                withRowAnimation:UITableViewRowAnimationFade];
    }
}


/* ============================== */
#pragma mark - RSSPickerViewDelegate methods

- (void)doneButtonClickedForPickerButton:(RSSPickerButton*)thePickerButton
{
    if (thePickerButton.tag == SIZE_PICKER_TAG) {
        NSString *tempText = [self trimUnitOfMeasure:thePickerButton.selectedValue];
        shelfSize = [[tempText stringByReplacingOccurrencesOfString:@","
                                                         withString:@"."] floatValue];
    }
}


/* ============================== */
#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self isEmptyRowContainingTextfield:textField] && (string.length > 0)) {
        [self addTableViewRow];
    }
    
    NSString *proposedNewString = [[textField text] stringByReplacingCharactersInRange:range
                                                                            withString:string];
    
    if ((proposedNewString.length == 0) && [self isEmptyOtherTextFieldFromRowContainingTextfield:textField] && (noOfRows > 1)) {
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
    activeTextField = textField;
    // Remove unit of measure
    if ((textField.tag == LENGTH_TAG) && (textField.text.length > 0)) {
        textField.text = [self trimUnitOfMeasure:textField.text];
    }
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    textField.backgroundColor = [UIColor closetMaidTextFieldFocusGrayColor];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    textField.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
    [UIView commitAnimations];
    
    CustomTableCell *cell;
    NSIndexPath *indexPath;
    ShelvingCutShelf *rowToEdit;
    
    switch (textField.tag) {
        case QUANTITY_TAG:
            cell = (CustomTableCell *)textField.superview.superview;
            indexPath = [calculatorView.tableView indexPathForCell:cell];
            rowToEdit = [shelvingSections objectAtIndex:indexPath.row];
            
            if (([textField.text isEqualToString:@""] && rowToEdit.quantity != 0) || [textField.text isEqualToString:@"0"]) {
                rowToEdit.quantity = 0;
            } else {
                rowToEdit.quantity = textField.text.integerValue;
            }
            
            break;
            
        case LENGTH_TAG: {
            BOOL error = NO;
            NSDecimalNumber* lengthDecimalNumber = [NSDecimalNumber decimalNumberWithString:textField.text
                                                                                     locale:[NSLocale currentLocale]];
            cell = (CustomTableCell *)textField.superview.superview;
            indexPath = [calculatorView.tableView indexPathForCell:cell];
            rowToEdit = shelvingSections[indexPath.row];
            // if length in tablecell > shelf size alert + modify
            if (lengthDecimalNumber.integerValue > shelfSize) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"The specified length does not fall within the expected range."
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
                rowToEdit.lengthOf = shelfSize;
                textField.text = [self appendUnitOfMeasure:[NumberUtils formattedStringFromInt:rowToEdit.lengthOf]];
                error = YES;
            }
            // verify if quantity was changed or just focused then unfocused
            // don't replace value in codebehind if no change
            // done this to maintain consistent value after conversion and keep UI clean i.e. 2 decimals
            if (!error && textField.text.length > 0) {
                if (![textField.text isEqualToString:[NumberUtils formattedStringFromInt:rowToEdit.lengthOf]]) {
                    rowToEdit.lengthOf = lengthDecimalNumber.integerValue;
                }
                textField.text = [NumberUtils formattedStringFromNSNumber:lengthDecimalNumber];
                if ([textField.text isEqualToString:@"NaN"]) {
                    textField.text = @"0";
                    rowToEdit.lengthOf = 0;
                }
                textField.text = [self appendUnitOfMeasure:textField.text];
            } else {
//                if (rowToEdit.lengthOf <= 0) {
                    rowToEdit.lengthOf = 0;
//                }
            }
            break;
        }
            
        default:
            break;
    }
}


/* ============================== */
#pragma mark - UITableViewDelegate & DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shelvingSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)someTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentfier = @"cell";
    
    CustomTableCell *cell = [someTableView dequeueReusableCellWithIdentifier:cellIdentfier];
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithReuseIdentifier:cellIdentfier];
        cell.quantityTextField.delegate = self;
        cell.lengthTextField.delegate = self;
        
        // bug-fix for swipe animation when Delete button dissapears
        cell.textLabel.text = @"this is crazy";
        cell.textLabel.hidden = YES;
    }
    
    // Prepare cell for reuse
    cell.quantityTextField.text = nil;
    cell.lengthTextField.text = nil;
    
    // Display values if cell was used before
    NSInteger quantAtIndex = [(ShelvingCutShelf *)shelvingSections[indexPath.row] quantity];
    NSInteger lengtAtIndex = [(ShelvingCutShelf *)shelvingSections[indexPath.row] lengthOf];
    if (quantAtIndex != 0) {
        cell.quantityTextField.text = [NSString stringWithFormat:@"%d", quantAtIndex];
    }
    if (lengtAtIndex != 0) {
        // Format displayed value for max 2 decimals and no 0 decimals
        if (unitOfMeasurement == IMPERIAL) {
            cell.lengthTextField.text = [NSString stringWithFormat:@"%@%@", [NumberUtils formattedStringFromInt:lengtAtIndex], @"\""];
        } else {
            cell.lengthTextField.text = [NSString stringWithFormat:@"%@%@", [NumberUtils formattedStringFromInt:lengtAtIndex], @"cm"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)someTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete ) {
        if (indexPath.row < shelvingSections.count) {
            CustomTableCell *cell = (CustomTableCell *)[someTableView cellForRowAtIndexPath:indexPath];
            if (noOfRows > 1) {
                if (cell.quantityTextField.backgroundColor != [UIColor closetMaidTextFieldGrayColor] ||
                    cell.lengthTextField.backgroundColor != [UIColor closetMaidTextFieldGrayColor]) {
                    [self hideKeyboard];
                }
                [someTableView beginUpdates];
                // Delete the data
                ShelvingCutShelf *rowToEdit = shelvingSections[indexPath.row];
                [shelvingSections removeObject:rowToEdit];
                // Delete the table cell
                [calculatorView.tableView deleteRowsAtIndexPaths:@[indexPath]
                                                withRowAnimation:UITableViewRowAnimationFade];
                // Decrement number of rows (for alert message)
                noOfRows--;
                [someTableView endUpdates];
            } else {
                // Delete the data
                ShelvingCutShelf *rowToEdit = shelvingSections[indexPath.row];
                rowToEdit.quantity = 0;
                rowToEdit.lengthOf = 0;
                cell.quantityTextField.text = @"";
                cell.lengthTextField.text = @"";
            }
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableCell *cell = (CustomTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ((cell.quantityTextField.text.length > 0) && (cell.lengthTextField.text.length > 0)) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


/* ============================== */
#pragma mark - Private methods

- (void)addTableViewRow
{
    if (noOfRows < MAX_ROWS) {
        noOfRows++;
        // Add new shelving object to the array on last position
        ShelvingCutShelf *newPair = [[ShelvingCutShelf alloc] initWithQuantity:0
                                                                     andLength:0];
        [shelvingSections addObject:newPair];
        // Insert cell in table
        [calculatorView.tableView beginUpdates];
        [calculatorView.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:shelvingSections.count - 1
                                                                                                     inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationFade];
        [calculatorView.tableView endUpdates];
        // Scroll table to bottom
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:shelvingSections.count - 1
                                                inSection:0];
        [calculatorView.tableView scrollToRowAtIndexPath:ipath
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
    [calculatorView.tableView beginUpdates];
    NSIndexPath *lastRowIndexPath = [NSIndexPath indexPathForRow:noOfRows - 1
                                                       inSection:0];
    // Delete the data
    ShelvingCutShelf *rowToEdit = [shelvingSections objectAtIndex:lastRowIndexPath.row];
    [shelvingSections removeObject:rowToEdit];
    // Delete the table cell
    [calculatorView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:lastRowIndexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
    // Decrement number of rows (for alert message)
    noOfRows--;
    [calculatorView.tableView endUpdates];
}

- (void)reviewRowData
{
    BOOL wasModified = NO;
    
    for (UIView *v in calculatorView.tableView.subviews) {
        if ([v isKindOfClass:[CustomTableCell class]]) {
            CustomTextField *tempField = [(CustomTableCell *)v lengthTextField];
            if (tempField.text.integerValue > shelfSize) {
                tempField.text = [self appendUnitOfMeasure:[NumberUtils formattedStringFromInt:shelfSize]];
                wasModified = YES;
            }
        }
    }
    
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
    CustomTableCell *cell = (CustomTableCell *)textField.superview.superview;
    
    if ((cell.quantityTextField.text.length == 0) && (cell.lengthTextField.text.length == 0))
        return YES;
    else
        return NO;
}

- (BOOL)isEmptyOtherTextFieldFromRowContainingTextfield:(UITextField *)textField
{
    CustomTableCell *cell = (CustomTableCell *)textField.superview.superview;
    
    if (textField.tag == QUANTITY_TAG) {
        if (cell.lengthTextField.text.length == 0) {
            return YES;
        }
    }
    if (textField.tag == LENGTH_TAG) {
        if (cell.quantityTextField.text.length == 0) {
            return YES;
        }
    }

    return NO;
}

- (NSString *)trimUnitOfMeasure:(NSString *)toTrim
{
    if (unitOfMeasurement == IMPERIAL) {
        return [toTrim substringToIndex:toTrim.length - 1];
    } else {
        return [toTrim substringToIndex:toTrim.length - 2];
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


@end
