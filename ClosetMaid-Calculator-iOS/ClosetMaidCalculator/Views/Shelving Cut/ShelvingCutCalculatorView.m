//
//  CalculatorView.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutCalculatorView.h"
#import "UIImageView+Custom.h"
#import "RSSPickerView.h"
#import "CustomIconButton.h"
#import "CustomTableCell.h"
#import "NumberUtils.h"
#import "UIColor+ClosetMaid.h"
#import <QuartzCore/QuartzCore.h>


@interface ShelvingCutCalculatorView ()
{
    CGRect appFrame;
    
    NSArray *valuesForPicker;
    NSArray *valuesForSizePicker;
    
    NSArray *inchSizes;
    NSArray *meterSizes;
    
    RSSPickerButton *unitPicker;
}

@end


@implementation ShelvingCutCalculatorView

@synthesize delegate;
@synthesize scrollView;
@synthesize tableView;
@synthesize shelfPickerButton;
@synthesize shelfSizePickerButton;

- (id)initWithFrame:(CGRect)frame typesOfShelving:(NSArray *)types shelvingSizesImperial:(NSArray *)imperialSizes shelvingSizesMetric:(NSArray *)metricSizes
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        valuesForPicker = types;
        valuesForSizePicker = imperialSizes;
        inchSizes = imperialSizes;
        meterSizes = metricSizes;
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    appFrame = [[UIScreen mainScreen] applicationFrame];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // We need a UIScrollView in order to move the screen up/down on keyboard appear/dissapear
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)];
    scrollView.contentSize = appFrame.size;
    
    UIButton *bgButton = [[UIButton alloc] initWithFrame:appFrame];
    bgButton.backgroundColor = [UIColor whiteColor];
    [bgButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bgButton];
    
    // artworks
    UIImageView *logoArtwork = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"logo-ClosetMaid"];
    logoArtwork.frame = CGRectMake(LEFT_PADDING,
                                   10,
                                   logoArtwork.frame.size.width,
                                   logoArtwork.frame.size.height);
    [scrollView addSubview:logoArtwork];
    
    UIImageView *shelfArtwork = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"art-Shelving"];
    shelfArtwork.frame = (CGRectMake(appFrame.size.width - shelfArtwork.frame.size.width,
                                     20,
                                     shelfArtwork.frame.size.width,
                                     shelfArtwork.frame.size.height));
    [scrollView addSubview:shelfArtwork];
    
    // currentY - holds current Y axis position, so ui controls are relative to one another
    CGFloat currentY = logoArtwork.frame.size.height + 50;

    // "Type of Shelving" label
    UILabel *shelvingTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + 2,
                                                                           currentY,
                                                                           appFrame.size.width / 2 - 30,
                                                                           20)];
    shelvingTypeLabel.backgroundColor = [UIColor whiteColor];
    shelvingTypeLabel.text = @"Type of Shelving:";
    shelvingTypeLabel.textColor = [UIColor darkGrayColor];
    shelvingTypeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:15];
    [scrollView addSubview:shelvingTypeLabel];
    
    currentY += shelvingTypeLabel.frame.size.height + 10;
    
    // "Type of Shelving" pickers
    shelfSizePickerButton = [[RSSPickerButton alloc] initWithAssociatedPickerViewTitle:@"Choose shelf size"
                                                                                values:valuesForSizePicker];
    [shelfSizePickerButton setFrame:CGRectMake(LEFT_PADDING,
                                               currentY,
                                               70,
                                               35)
                          imageIcon:nil
               highlightedImageIcon:nil];
    shelfSizePickerButton.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
    [shelfSizePickerButton setTitle:valuesForSizePicker[0]
                           forState:UIControlStateNormal];
    shelfSizePickerButton.selectedValue = valuesForSizePicker[0];
    shelfSizePickerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    shelfSizePickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shelfSizePickerButton setTitleColor:[UIColor blackColor]
                                forState:UIControlStateNormal];
    shelfSizePickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                            size:16];
    [(RSSPickerView*)shelfSizePickerButton.associatedView setPickerItemFontSize:18];
    shelfSizePickerButton.tag = SIZE_PICKER_TAG;
    [scrollView addSubview:shelfSizePickerButton];
    
    shelfPickerButton = [[RSSPickerButton alloc] initWithAssociatedPickerViewTitle:@"Choose shelf type"
                                                                            values:valuesForPicker];
    [shelfPickerButton setFrame:CGRectMake(LEFT_PADDING + shelfSizePickerButton.frame.size.width + 5,
                                           currentY,
                                           appFrame.size.width - shelfSizePickerButton.frame.size.width - 25,
                                           35)
                      imageIcon:nil
           highlightedImageIcon:nil];
    shelfPickerButton.backgroundColor = [UIColor closetMaidTextFieldGrayColor];
    [shelfPickerButton setTitle:[valuesForPicker objectAtIndex:0]
                       forState:UIControlStateNormal];
    shelfPickerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    shelfPickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shelfPickerButton setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
    shelfPickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                        size:14];
    [(RSSPickerView*)shelfPickerButton.associatedView setPickerItemFontSize:18];
    [scrollView addSubview:shelfPickerButton];
    
    currentY += shelfPickerButton.frame.size.height + 15;
    
    // "Add Shelving Sections Needed" label
    UILabel *sectionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + 2,
                                                                       currentY + 3,
                                                                       appFrame.size.width / 2 + 20,
                                                                       20)];
    sectionsLabel.backgroundColor = [UIColor whiteColor];
    sectionsLabel.text = @"Add Shelving Sections Needed:";
    sectionsLabel.textColor = [UIColor darkGrayColor];
    sectionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:15];
    [scrollView addSubview:sectionsLabel];
    
    // Calculate cuts button on the right
    RSSButton *calculateButton = [[RSSButton alloc] initWithFrame:CGRectMake(appFrame.size.width - 110,
                                                                             currentY,
                                                                             100,
                                                                             25)];
    calculateButton.hitOffsetTop = 13;
    calculateButton.hitOffsetBottom = 13;
    calculateButton.backgroundColor = [UIColor closetMaidRedColor];
    calculateButton.layer.cornerRadius = 3.0f;
    [calculateButton setTitle:@"Calculate Cuts"
                     forState:UIControlStateNormal];
    calculateButton.titleLabel.textColor = [UIColor whiteColor];
    calculateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                      size:15];
    [calculateButton addTarget:self
                        action:@selector(calculateCuts)
              forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:calculateButton];
    
    currentY += sectionsLabel.frame.size.height + 20;
    
    // "QUANTITY" label
    UILabel *quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + 2,
                                                                       currentY,
                                                                       85,
                                                                       15)];
    quantityLabel.backgroundColor = [UIColor clearColor];
    quantityLabel.text = @"QUANTITY";
    quantityLabel.textColor = [UIColor blackColor];
    quantityLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:10];
    [scrollView addSubview:quantityLabel];
    
    // "LENGTH" label
    UILabel *lengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + 90 + 2,
                                                                     currentY,
                                                                     appFrame.size.width - 120,
                                                                     15)];
    lengthLabel.backgroundColor = [UIColor clearColor];
    lengthLabel.text = @"LENGTH";
    lengthLabel.textColor = [UIColor blackColor];
    lengthLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:10];
    [scrollView addSubview:lengthLabel];
    
    currentY += quantityLabel.frame.size.height;
    
    // I think this is obvious
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                              currentY,
                                                              appFrame.size.width - 15,
                                                              appFrame.size.height - currentY - 10)
                                             style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = (CGFloat)40;
    // tap gesture below rows
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [tableView addGestureRecognizer:tap];
    // footer view in table
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           tableView.frame.size.width,
                                                                           tableView.rowHeight)]];
    [scrollView addSubview:tableView];
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                                    tableView.frame.origin.y + tableView.frame.size.height - tableView.rowHeight,
                                                                    tableView.frame.size.width,
                                                                    tableView.rowHeight)];
    gradientView.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor],
                                                (id)[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor], nil];
    gradient.startPoint = CGPointMake(1.0f, -0.1f);
    gradient.endPoint = CGPointMake(1.0f, 0.8f);
    [gradientView.layer insertSublayer:gradient
                               atIndex:0];
    [scrollView addSubview:gradientView];
    
    CustomIconButton *clearButton = [[CustomIconButton alloc] initWithFrame:CGRectMake(appFrame.size.width - 15 - 35,
                                                                                       appFrame.size.height - 45,
                                                                                       35,
                                                                                       35)
                                                                  imageIcon:@"icon-Trash"
                                                       highlightedImageIcon:@"icon-Trash-Highlight"];
    [clearButton addTarget:self
                    action:@selector(clearRows)
          forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:clearButton];
    
    // add scrollview to view
    [self addSubview:scrollView];
    
    UIButton *homeButton = [[UIButton alloc] initWithFrame:CGRectMake(250,
                                                                      10,
                                                                      60,
                                                                      29)];
    homeButton.backgroundColor = [UIColor clearColor];
    UIImageView *backBtn = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"button-Home"];
    [homeButton setImage:backBtn.image forState:UIControlStateNormal];
    [homeButton addTarget:self
                   action:@selector(homeButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:homeButton];
}

/***************************************************
 *  Public methods
 ***************************************************/
/*
 *  Update controls that display units + the switch button AND perform conversions
 */
- (void)updateViewForUnit:(UnitOfMeasure)unitOfMeasure
{
    NSString *tempText;
    int indexOfCurrent = 0;

    if (unitOfMeasure == IMPERIAL) {
        // CONVERT CM TO INCH
        // change picker values
//        indexOfCurrent = [meterSizes indexOfObject:shelfSizePickerButton.selectedValue];
        [(RSSPickerView *)shelfSizePickerButton.associatedView setPicklistValues:inchSizes];
        [shelfSizePickerButton setTitle:inchSizes[indexOfCurrent]
                               forState:UIControlStateNormal];
        shelfSizePickerButton.selectedValue = inchSizes[0];
        shelfSizePickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                                size:16];
        [(RSSPickerView *)shelfSizePickerButton.associatedView reloadPicker];
        // table text fields
        for (UIView *v in self.tableView.subviews) {
            if ([v isKindOfClass:[CustomTableCell class]]) {
                CustomTextField *tempField = [(CustomTableCell *)v lengthTextField];
                if (tempField.text.length > 0) {
                    tempText = [tempField.text substringToIndex:tempField.text.length - 2];
                    tempField.text = [NSString stringWithFormat:@"%@\"", [NumberUtils formattedStringFromInt:tempText.integerValue]];
                }
            }
        }
    } else if (unitOfMeasure == METRIC) {
        // CONVERT INCH TO CM
//        indexOfCurrent = [inchSizes indexOfObject:shelfSizePickerButton.selectedValue];
        [(RSSPickerView *)shelfSizePickerButton.associatedView setPicklistValues:meterSizes];
        [shelfSizePickerButton setTitle:meterSizes[indexOfCurrent]
                               forState:UIControlStateNormal];
        shelfSizePickerButton.selectedValue = meterSizes[0];
        shelfSizePickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                                size:12];
        [(RSSPickerView *)shelfSizePickerButton.associatedView reloadPicker];
        // table text fields
        for (UIView *v in self.tableView.subviews) {
            if ([v isKindOfClass:[CustomTableCell class]]) {
                CustomTextField *tempField = [(CustomTableCell *)v lengthTextField];
                if (tempField.text.length > 0) {
                    tempText = [tempField.text substringToIndex:tempField.text.length - 1];
                    tempField.text = [NSString stringWithFormat:@"%@cm", [NumberUtils formattedStringFromInt:tempText.integerValue]];
                }
            }
        }

    }
}


/***************************************************
 *  Custom getters / setters
 ***************************************************/
/*
 *  Overridden delegate setter;
 *  - sets the delegate of the controls that need it (i.e. textfields & tableview)
 *  - setter is called from MainViewController
 *  - done this way to keep a better encapsulation of the view from the viewcontroller
 */
- (void)setDelegate:(id<CalculatorViewDelegate>)del
{
    tableView.delegate = del;
    tableView.dataSource = del;
    shelfSizePickerButton.delegate = del;
    unitPicker.delegate = del;
    delegate = del;
}

/***************************************************
 *  Private selectors
 ***************************************************/

- (void)homeButtonPushed
{
    [delegate homeButtonPushed];
}

- (void)hideKeyboard
{
    [delegate hideKeyboard];
}

- (void)switchUnit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchUnit" object:nil];
}

- (void)calculateCuts
{
    [delegate calculateCutsButtonPush];
}

- (void)clearRows
{
    [delegate clearRows];
}

- (void)openSettings
{
    [unitPicker pickerButtonClicked:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
