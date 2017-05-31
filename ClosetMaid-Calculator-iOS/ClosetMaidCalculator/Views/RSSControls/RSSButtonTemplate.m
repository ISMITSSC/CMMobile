//
//  RSSButtonTemplate.m
//  ENPContactSearch
//
//  Created by Vlad Manolache on 11/27/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//

#import "RSSButtonTemplate.h"

@implementation RSSButtonTemplate


@synthesize button;
@synthesize selected;
@synthesize isSelected;

@synthesize hitOffsetBottom, hitOffsetLeft, hitOffsetRight, hitOffsetTop;

#pragma mark - Initialization

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Add gesture recongnizer
        UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        recognizer.minimumPressDuration = 0.01;
        [self addGestureRecognizer:recognizer];
        
        // Initialize button
//        BOOL atLeastIOS6 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
//        if(atLeastIOS6)
            button = [UIButton buttonWithType:UIButtonTypeCustom];
//        else
//            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:button];
        
        // Initialize template appearance 
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // Set UIControl frame
        [self setFrame:frame];

        // Set button state
        self.selected = false;
        self.remainsHighlighted = false;
        [self setButtonNotHighlighted];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [highlightLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [gradientLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}


#pragma mark - Gesture handler logic

// Captures all touch events on this UIControl. Neends to call sendActionsForControlEvents to trigger the corresponding touch event.
-(void)handleGesture:(UIGestureRecognizer *) gestureRecognizer {
    if(gestureRecognizer.state == 1) {  // TouchStart
        if(button.selected == false) { // If the button wasn't highlighted, add highlight.
            [self setButtonHighlighted];
            button.selected = true;
        }
    }
    else if(gestureRecognizer.state == 2) { // TouchMove
        CGFloat width = [gestureRecognizer locationInView:self].x;
        CGFloat height = [gestureRecognizer locationInView:self].y;
        
        // If the mouse moves outside the button boundaries, remove the button highlight.
        if(!(width > self.bounds.origin.x && width < self.bounds.origin.x + self.bounds.size.width) ||
           !(height > self.bounds.origin.y && height < self.bounds.origin.y + self.bounds.size.height))
        {
            [self setButtonNotHighlighted];
            button.selected = false;
        }
        else {  // If the TouchMove event moves back over the button, highlight it.
            [self setButtonHighlighted];
            button.selected = true;
        }
    }
    else if(gestureRecognizer.state == 3) { // TouchEnd gesture
        CGFloat width = [gestureRecognizer locationInView:self].x;
        CGFloat height = [gestureRecognizer locationInView:self].y;
        
        // If user clicked inside the button
        if((width > self.bounds.origin.x - hitOffsetLeft && width < self.bounds.origin.x + self.bounds.size.width + hitOffsetLeft + hitOffsetRight) &&
           (height > self.bounds.origin.y - hitOffsetTop && height < self.bounds.origin.y + self.bounds.size.height + hitOffsetTop + hitOffsetBottom))
        {
            if(isSelected == true) {    // If the button was selected, remove selection and highlight.
                isSelected = false;
                [self setButtonNotHighlighted];
                button.selected = false;
            }
            else {  // If the button wasn't selected, select it and highlight it.
                isSelected = true;
                [self setButtonHighlighted];
                button.selected = true;
            }
            // User clicked inside the button event
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else {  // Click outside the button
            if(isSelected == true) { // If button is selected and user clicked outside, deselect the button.
                isSelected = false;
            }
            else {  // If button wasn't selected, remove highlight.
                [self setButtonNotHighlighted];
                button.selected = false;
            }
            // User clicked outside the button event
            [button sendActionsForControlEvents:UIControlEventTouchUpOutside];
        }
        
        if([self remainsHighlighted] == false)
            [self setButtonNotHighlighted];
    }
}

// Listens to events triggered by handleGesture method
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [button addTarget:target action:action forControlEvents:controlEvents];
}


#pragma mark - Button highlighted logic

-(void)setButtonHighlighted
{
    button.contentEdgeInsets = UIEdgeInsetsMake(1.0,1.0,-1.0,-1.0);
    [highlightLayer setHidden:NO];
}

-(void)setButtonNotHighlighted
{
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    [highlightLayer setHidden:YES];
    
    button.selected = false;
}


#pragma mark - Methods that hide the fact that button is member of RSSButtonTemplate

-(void)setTitleColor:(UIColor*)color forState:(UIControlState)state
{
    [button setTitleColor:color forState:state];
}

-(void)setTitle:(NSString*)title forState:(UIControlState)state
{
    [button setTitle:title forState:state];
}

-(UILabel*)titleLabel
{
    return button.titleLabel;
}


#pragma mark - RSSGridField methods

// RSSGridItem will not cauze crash if it contains a RSSButton and value or setValue methods are called.
-(id)value
{
    return @"RSSButton";
}

-(void)setValue:(id)theValue
{
    return;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    
    bounds = CGRectMake(bounds.origin.x - hitOffsetLeft,
                        bounds.origin.y - hitOffsetTop,
                        bounds.size.width + hitOffsetLeft + hitOffsetRight,
                        bounds.size.height + hitOffsetTop + hitOffsetBottom);
    
//    if (CGRectContainsPoint(bounds, point)) {
//
//    }
    
    return CGRectContainsPoint(bounds, point);
}


@end