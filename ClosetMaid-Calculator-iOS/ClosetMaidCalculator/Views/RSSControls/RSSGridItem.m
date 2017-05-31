//
//  RSSGridItem.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/5/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSGridItem.h"
//#import "GenericDAO.h"
#import "CoreData/CoreData.h"
#import "RSSPickerButton.h"
//#import "RSSDetailsButton.h"

@implementation RSSGridItem


@synthesize label;
@synthesize title;
@synthesize fieldName;
@synthesize inputFieldInstance;
@synthesize dependencies;
@synthesize selectByParentValue;
@synthesize filterByParentValue;
@synthesize entity;
@synthesize depth;
@synthesize required;


#pragma mark - Initialization

- (id)initWithLabel:(NSString*)theLabelText andInputField:(UIView<RSSGridField>*) inputField
{
    self = [super init];
    if (self) {
        self.label = theLabelText;
        self.inputFieldInstance = inputField;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridItemFocused) name:@"gridItemFocused" object:inputFieldInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridItemBlured) name:@"gridItemBlured" object:inputFieldInstance];
    }
    return self;
}

-(void)reload
{
    if ([inputFieldInstance isKindOfClass:[RSSPickerButton class]])
    {
        //GenericDAO *entityTypeDAO = [NSClassFromString([entity stringByAppendingString:@"DAO"]) sharedInstance];
        // Add all managed objects
        //NSMutableArray* pickerViewItems = [[NSMutableArray alloc] init];
        //[pickerViewItems addObject:[RSSPickerViewItem blankItem]];
        //NSArray* entities = [[NSArray alloc] initWithArray:[entityTypeDAO getEntitiesByType:entity andByField:@"" withValues:nil]];
        //for (RSSManagedObject* currentEntity in entities)
        {
            //[pickerViewItems addObject:[currentEntity toPickerViewItem]];
        }
        //[(RSSPickerButton*)inputFieldInstance setPicklistValues:pickerViewItems];
    }
}

- (void)setEntity:(NSString *)theEntity
{
    self->entity = theEntity;
    //GenericDAO *entityTypeDAO = [NSClassFromString([entity stringByAppendingString:@"DAO"]) sharedInstance];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:NSManagedObjectContextDidSaveNotification object:entityTypeDAO.managedObjectContext];
}


- (void)setFrame:(CGRect)frame layout:(CGGridLayout)layout;
{
    for (UIView* view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    [self setFrame:frame];
    
    CGFloat labelWidth = self.frame.size.width * layout.labelWidth;
    CGFloat inputWidth = self.frame.size.width * layout.inputWidth;
    
    if ((![inputFieldInstance isKindOfClass:[RSSButton class]]))
        //&& (![inputFieldInstance isKindOfClass:[RSSDetailsButton class]]))// If button, do now show gradient
    {
        gradientLayer = [[CAGradientLayer alloc] init];
        [gradientLayer setBounds:[self bounds]];
        [gradientLayer setPosition:CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
        [gradientLayer setColors:[NSArray arrayWithObjects:
                                  (id)[[UIColor lightGrayColor]CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
        [gradientLayer setMasksToBounds:NO];
        [self.layer addSublayer:gradientLayer];
    }
    
    NSString* labelText = [NSString stringWithFormat:@"%@ ", self.label];
        
    if (self.required) {
        labelText = [NSString stringWithFormat:@" %@*", labelText];
    }
        
    currentLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 35)];
    [currentLabel setText:labelText];
    [currentLabel setTextAlignment:NSTextAlignmentRight];
    [currentLabel setFont:[UIFont systemFontOfSize:11]];
    [currentLabel setTextColor:[UIColor darkGrayColor]];
    [currentLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:currentLabel];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 1.5f;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowOffset = CGSizeMake(-2.0f, 2.0f);
        
    [(UIView*)inputFieldInstance setFrame:CGRectMake(labelWidth , 0, inputWidth, frame.size.height)];
    [self addSubview:(UIView*)inputFieldInstance];
}


#pragma mark - Color / uncolor logic

- (void) gridItemFocused {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:animation forKey:@"EaseOut"];
    
    [currentLabel setTextColor:[UIColor whiteColor]];
    [currentLabel setFont:[UIFont boldSystemFontOfSize:11]];
    
    CGRect layerRect = [gradientLayer bounds];
    [gradientLayer removeFromSuperlayer];
    // Change gradient
    gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:layerRect];
    [gradientLayer setPosition:CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[[UIColor blueColor]CGColor],(id)[[UIColor blueColor] CGColor], nil]];
    [gradientLayer setMasksToBounds:NO];
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void) gridItemBlured {
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:animation forKey:@"EaseOut"];
    
    [currentLabel setTextColor:[UIColor darkGrayColor]];
    [currentLabel setFont:[UIFont systemFontOfSize:11]];
    
    CGRect layerRect = [gradientLayer bounds];
    [gradientLayer removeFromSuperlayer];
    // Change gradient
    gradientLayer = [[CAGradientLayer alloc] init];
    [gradientLayer setBounds:layerRect];
    [gradientLayer setPosition:CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
    [gradientLayer setColors:[NSArray arrayWithObjects:
                              (id)[[UIColor lightGrayColor]CGColor],(id)[[UIColor lightGrayColor] CGColor], nil]];
    [gradientLayer setMasksToBounds:NO];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gridItemFocused"  object:inputFieldInstance];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gridItemBlured"  object:inputFieldInstance];
}

@end
