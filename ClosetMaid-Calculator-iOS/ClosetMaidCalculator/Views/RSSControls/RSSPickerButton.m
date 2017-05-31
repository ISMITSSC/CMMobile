//
//  RSSPickerButton.m
//  CRM360
//
//  Created by Ciprian Trusca on 11/15/11.
//  Copyright (c) 2011 RIDGID Software Solutions. All rights reserved.
//

#import "RSSPickerButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ClosetMaid.h"
//#import "RSSTablePickerView.h"
//#import "RSSDatePicker.h"
//#import "RSSMultipleSelectPickerView.h"
#import "RSSGridItem.h"
#import "RSSPickerViewItem.h"
#import "UIImageView+Custom.h"


@implementation RSSPickerButton


@synthesize title;
@synthesize associatedView;
@synthesize associatedEntityKey;
@synthesize selectedId;
@synthesize selectedValue;
@synthesize previousSelectedValue;


#pragma mark - Initializations

-(id)init
{
    if (self = [super initWithFrame:CGRectZero]){
        
		[self setTitleColor: [UIColor darkGrayColor] forState: UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        
        applicationFrame = [[UIScreen mainScreen] applicationFrame];
        //        UIColor* lightGray = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        //        UIColor *darkGray = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
        //[button.layer setBorderWidth:1.0];
        //[button.layer setBorderColor:[[UIColor grayColor] CGColor]];
        //self.backgroundColor = lightGray;
        // self.titleLabel.textColor = [UIColor blueColor];
        //  [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        // [button setTitleColor:darkGray forState:UIControlStateNormal];
        // [button addTarget:self action:@selector(pickerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pickerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // extra stuff cause someone made a shitty class
        [self addTarget:self action:@selector(setHighlightColor) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(clearHighlightColor) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(clearHighlightColor) forControlEvents:UIControlEventTouchUpInside];
        
        //        gradientLayer = [[CAGradientLayer alloc] init];
        //        [gradientLayer setBounds:[self bounds]];
        //        [gradientLayer setPosition:CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
        //        [gradientLayer setColors:[NSArray arrayWithObjects:
        //                                  (id)[[UIColor myLightGrayColor1]CGColor],(id)[[UIColor myLightGrayColor2] CGColor], nil]];
        //        [[self layer] insertSublayer:gradientLayer atIndex:0];
        // [self addSubview:leftView];
        
        
        // [self setTitle:@"WTF" forState:UIControlStateNormal];
        //  [self setTitle:@"Test" forState:UIControlStateNormal];
        //  [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        button.contentEdgeInsets = UIEdgeInsetsMake(0, width + 7, 0, width + 7);
        //        [self addHighlightLayer];
        pickerWithImage = NO;
    }
    
    return self;
}

- (void)addRightImage
{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-RightArrow.png"]];
    CGFloat height = logo.image.size.height;
    CGFloat width = logo.image.size.width;
    [logo setFrame:CGRectMake(self.frame.size.width - width - 3, (self.frame.size.height - height)/2 - 0.5, width, height)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,width + 7)];
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:logo];
}

-(void)setHighlightColor
{
    if (!pickerWithImage) {
        [self setBackgroundColor:[UIColor closetMaidTextFieldFocusGrayColor]];
    }
}

-(void)clearHighlightColor
{
    if (!pickerWithImage) {
        [self setBackgroundColor:[UIColor closetMaidTextFieldGrayColor]];
    }
}

- (void)addHighlightLayer {
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor closetMaidTextFieldFocusGrayColor].CGColor;
    highlightLayer.frame = self.bounds;
    //highlightLayer.cornerRadius = 6.0f;
    highlightLayer.hidden = YES;
    [self.layer addSublayer:highlightLayer];
}

- (void)setHighlighted:(BOOL)highlight {
    //    if (highlight)
    //    {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"gridItemFocused" object:self userInfo:nil];
    //    }else
    //    {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"gridItemBlured" object:self userInfo:nil];
    //    }
    //    highlightLayer.hidden = !highlight;
    [super setHighlighted:highlight];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    highlightLayer.frame = self.bounds;
    [gradientLayer setBounds:[self bounds]];
    [gradientLayer setPosition:CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
}

-(id)initWithAssociatedPickerViewTitle:(NSString *)associatedViewTitle values:(NSMutableArray *)stringsOrPickerViewItems{
    if(self = [self init])
    {
        id currentItem = [stringsOrPickerViewItems objectAtIndex:0];
        
        NSString* currentItemLabel;
        NSString* currentItemValue;
        
        if ([currentItem isKindOfClass:[RSSPickerViewItem class]]){
            currentItemLabel = [(RSSPickerViewItem*)currentItem label];
            currentItemValue = [(RSSPickerViewItem*)currentItem value];
        } else {
            currentItemLabel = currentItem;
            currentItemValue = currentItem;
        }
        
        //   [self setTitle:currentItemLabel  forState:UIControlStateNormal];
        self->title = associatedViewTitle;
        self->selectedId = currentItemLabel;    // Item Id
        self->selectedValue = (NSString*)currentItemValue;  // Item values
        associatedView = [[RSSPickerView alloc] initForButton:self title:associatedViewTitle andValues:stringsOrPickerViewItems];
    }
    return self;
}

//-(id)initWithAssociatedDatePickerTitle:(NSString*)associatedViewTitle initialDate:(NSDate*)date datePickerMode:(UIDatePickerMode) datePickerMode
//{
//    if(self = [self init])
//    {
//        associatedView = [[RSSDatePicker alloc] initForButton:self title:associatedViewTitle initialDate:date datePickerMode:datePickerMode ];
//    }
//    return self;
//}
//
//-(id)initWithAssociatedDatePickerTitle:(NSString*)associatedViewTitle initialDate:(NSDate*)date datePickerMode:(UIDatePickerMode) datePickerMode minuteInterval:(int) minuteInterval
//{
//    if(self = [self init])
//    {
//        associatedView = [[RSSDatePicker alloc] initForButton:self title:associatedViewTitle initialDate:date datePickerMode:datePickerMode];
//        [(RSSDatePicker*)associatedView setMinuteInterval:minuteInterval];
//    }
//    return self;
//}

-(id)initWithAssociatedTableViewTitle:(NSString*)associatedViewTitle values:(NSMutableArray*)stringsOrPickerViewItems includeSearchBar:(BOOL)includeSearchBar
{
    if(self = [self init])
    {
        //associatedView = [[RSSTablePickerView alloc] initForButton:self title:associatedViewTitle andValues:stringsOrPickerViewItems includeSearchBar:includeSearchBar];
    }
    return self;
}

//-(id)initWithAssociatedMultipleSelectionPickerViewTitle:(NSString *)associatedViewTitle values:(NSMutableArray *)stringsOrPickerViewItems
//{
//    if(self = [self init])
//    {
//        [self setTitle:[stringsOrPickerViewItems objectAtIndex:0]  forState:UIControlStateNormal];
//        associatedView = [[RSSMultipleSelectPickerView alloc] initForButton:self title:associatedViewTitle andValues:stringsOrPickerViewItems];
//    }
//    return self;
//}

- (void)setFrame:(CGRect)frame imageIcon:(NSString *)image highlightedImageIcon:(NSString *)highlightedImage
{
    self.frame = frame;
    if (self) {
        // Initialization code
        if (image) {
            UIImageView *imageView = [[UIImageView alloc] initImageWithDeviceSpecificResolution:image];
            [self setImage:imageView.image
                  forState:UIControlStateNormal];
            if (highlightedImage) {
                UIImageView *highlightedImageView = [[UIImageView alloc] initImageWithDeviceSpecificResolution:highlightedImage];
                [self setImage:highlightedImageView.image
                      forState:UIControlStateHighlighted];
            }
            pickerWithImage = YES;
        } else {
            [self addRightImage];
        }
    }
}


#pragma mark - Check if another item was selected

// If another item was selected, return YES. Otherwise NO.
- (BOOL) wasModified
{
    if ((previousSelectedValue == nil) && ([self selectedValue] == nil))
    {
        return NO;
    }
    return !([[self previousSelectedValue] isEqualToString:[self selectedValue]]);
}


#pragma mark - Get and Set the selected value

// Get the currently selected value
- (id) value {
//    if([associatedView isKindOfClass:[RSSTablePickerView class]]) { // If RSSTablePickerView
//        return   [(RSSTablePickerView*) associatedView selectedValue];
//    }
//    else if ([associatedView isKindOfClass:[RSSDatePicker class]]) {// If RSSDatePicker
//        return [(RSSDatePicker*)associatedView selectedDate];
//    }
//    else if ([associatedView isKindOfClass:[RSSMultipleSelectPickerView class]]) { // If RSSMultipleSelectPickerView
//        return [(RSSMultipleSelectPickerView*) associatedView selectedValues];
//    }
//    else
        if ([associatedView isKindOfClass:[RSSPickerView class]]) { // If RSSPickerView
        return self->selectedValue;
    }
    
    return nil;
}

// Set the currently selected value
-(void) setValue:(NSString*)anEntityValue
{
//    if([associatedView isKindOfClass:[RSSTablePickerView class]]) { // If RSSTablePickerView
//        [(RSSTablePickerView*)associatedView setSelectedValue:anEntityValue];
//    }
//    else  if ([associatedView  isKindOfClass:[RSSDatePicker class]]) { // If RSSDatePicker
//        //[(RSSDatePicker*)associatedView setDate:anEntityValue];
//    }
//    else if ([associatedView isKindOfClass:[RSSMultipleSelectPickerView class]]) { // If RSSMultipleSelectedPickerView
//        [(RSSMultipleSelectPickerView*)associatedView setValue:anEntityValue];
//    }
//    else
        if ([associatedView isKindOfClass:[RSSPickerView class]]) { // If RSSPickerView
        [(RSSPickerView*)associatedView setValue:anEntityValue];
    }
    [self setPreviousSelectedValue:[self selectedValue]];
    self->selectedValue = anEntityValue;
}


#pragma mark - Set picklist values

- (void) setPicklistValues:(NSMutableArray *) picklistValues
{
//    if ([associatedView isKindOfClass:[RSSTablePickerView class]])
//    {
//        [(RSSTablePickerView*)associatedView setPicklistValues:picklistValues];
//        [[(RSSTablePickerView*)associatedView tableView] reloadData];
//        id firstItem = [picklistValues objectAtIndex:0];
//        NSString* currentTitle;
//        if ([firstItem isKindOfClass:[RSSPickerViewItem class]]){
//            currentTitle = [firstItem label];
//        } else {
//            currentTitle = firstItem;
//        }
//        
//        [self setTitle:currentTitle forState:UIControlStateNormal];
//    } else
    {
        [(RSSPickerView*)associatedView setPicklistValues:picklistValues];
        [(UIPickerView*)[(RSSPickerView*)associatedView pickerView] reloadAllComponents];
        
        id firstItem = [picklistValues objectAtIndex:0];
        NSString* currentTitle;
        if ([firstItem isKindOfClass:[RSSPickerViewItem class]]){
            currentTitle = [firstItem label];
        } else {
            currentTitle = firstItem;
        }
        
        [self setTitle:currentTitle forState:UIControlStateNormal];
    }
}

- (BOOL)isPickerViewActive
{
    return self->pickerViewActive;
}

- (void)setPickerViewActive:(BOOL)isActive
{
    self->pickerViewActive = isActive;
}

#pragma mark - Picker Button logic

- (void)pickerButtonClicked:(RSSPickerButton *)pickerButon
{
    UIView *rootView = self;
    while ([rootView superview])
    {
        rootView = [rootView superview];
    }
    [rootView endEditing:YES];
    
    [self setPickerViewActive:YES];
    
#pragma TODO: make this more objectual
    if ([self.superview isKindOfClass:[RSSGridItem class]]){
        [self.superview.superview endEditing:YES];
    }
    
    [self setHighlighted:YES];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *fadeView = [[UIView alloc] initWithFrame:CGRectMake(0,20,applicationFrame.size.width,applicationFrame.size.height)];
    fadeView.backgroundColor = [UIColor blackColor];
    fadeView.alpha = 0;
    [window addSubview:fadeView];
    [UIView beginAnimations:nil context:NULL];
    fadeView.alpha = 0.65;
    
    [window insertSubview:associatedView atIndex:1];
    [window insertSubview:fadeView atIndex:1];
    [associatedView setFadeView:fadeView];
    [associatedView setFrame:CGRectMake(0,applicationFrame.size.height,applicationFrame.size.width,applicationFrame.size.height)];
    [UIView setAnimationDuration:0.3];
    [associatedView setFrame:applicationFrame];
    [UIView commitAnimations];
    [self setPreviousSelectedValue:[self selectedValue]];
}

-(id<RSSPickerViewDelegate>) delegate {
    return [associatedView delegate];
}

-(void) setDelegate:(id<RSSPickerViewDelegate>)delegate {
    [associatedView setDelegate:delegate];
}

-(void) setDefaultValue:(NSValue *)theDefaultValue {
    self->defaultValue = theDefaultValue;
    [self setValue:theDefaultValue];
}

-(NSValue*) defaultValue {
    return self->defaultValue;
}

@end
