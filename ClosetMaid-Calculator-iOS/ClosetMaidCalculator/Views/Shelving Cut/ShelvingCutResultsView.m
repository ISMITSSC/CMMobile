//
//  ShowResultsView.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 12/18/12.
//  Copyright (c) 2012 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutResultsView.h"
#import "UIImageView+Custom.h"
#import "UIColor+ClosetMaid.h"
#import "RSSButton.h"
#import "ShelvingDrawer.h"
#import "CutSizes.h"
#import "NumberUtils.h"


@interface ShelvingCutResultsView ()
{
    CGRect appFrame;
    
    //controls
    UILabel *requirementLabel;
    UILabel *excessLabel;
    UILabel *cutOutLine;
    UILabel *cutOutLabel;
}

@end

@implementation ShelvingCutResultsView

@synthesize delegate;
@synthesize drawerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    appFrame = [[UIScreen mainScreen] applicationFrame];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // artworks
    UIImageView *logoArtwork = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"logo-ClosetMaid"];
    logoArtwork.frame = CGRectMake(LEFT_PADDING,
                                   10,
                                   logoArtwork.frame.size.width,
                                   logoArtwork.frame.size.height);
    [self addSubview:logoArtwork];
    UIImageView *shelfArtwork = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"art-Shelving"];
    shelfArtwork.frame = (CGRectMake(appFrame.size.width - shelfArtwork.frame.size.width,
                                     20,
                                     shelfArtwork.frame.size.width,
                                     shelfArtwork.frame.size.height));
    [self addSubview:shelfArtwork];
    
    // currentY - holds current Y axis position, so ui controls are relative to one another
    CGFloat currentY = logoArtwork.frame.size.height + 20;
    
    // "What You Will Need" label
    UILabel *needLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                                   currentY,
                                                                   appFrame.size.width / 2 - 30,
                                                                   20)];
    needLabel.backgroundColor = [UIColor whiteColor];
    needLabel.text = @"What You Will Need:";
    needLabel.textColor = [UIColor darkGrayColor];
    needLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:15];
    [self addSubview:needLabel];
    
    currentY += needLabel.frame.size.height + 1;

    // "<no> - <dimension><unit> Sections of Shelving Needed" label
    requirementLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + 2,
                                                                 currentY,
                                                                 appFrame.size.width / 2 + 50,
                                                                 25)];
    requirementLabel.backgroundColor = [UIColor clearColor];
    requirementLabel.textColor = [UIColor blackColor];
    requirementLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:15];
    [self addSubview:requirementLabel];
    
    currentY += requirementLabel.frame.size.height + 5;
    
    // "Excess Shelving" label
    excessLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                            currentY,
                                                            appFrame.size.width / 2 - 30,
                                                            20)];
    excessLabel.backgroundColor = [UIColor whiteColor];
    excessLabel.textColor = [UIColor darkGrayColor];
    excessLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:15];
    [self addSubview:excessLabel];
    
    currentY += excessLabel.frame.size.height + 10;
    
    // "How To Cut It" label
    UILabel *howToCutLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING,
                                                                       currentY,
                                                                       80,
                                                                       20)];
    howToCutLabel.backgroundColor = [UIColor whiteColor];
    howToCutLabel.text = @"How To Cut It:";
    howToCutLabel.textColor = [UIColor darkGrayColor];
    howToCutLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:15];
    [self addSubview:howToCutLabel];
    
    // "Cut Out Downrod Section" red line
    cutOutLine = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + howToCutLabel.frame.size.width + 5,
                                                           currentY + 12,
                                                           20,
                                                           2)];
    cutOutLine.backgroundColor = [UIColor closetMaidRedColor];
    [self addSubview:cutOutLine];
    
    // "Cut Out Downrod Section" label
    cutOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING + howToCutLabel.frame.size.width + cutOutLine.frame.size.width + 8,
                                                            currentY + 2,
                                                            60,
                                                            20)];
    cutOutLabel.backgroundColor = [UIColor whiteColor];
    cutOutLabel.text = @"Cut Out Downrod Section";
    cutOutLabel.textColor = [UIColor grayColor];
    cutOutLabel.textAlignment = NSTextAlignmentCenter;
    cutOutLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:12];
    [cutOutLabel sizeToFit];
    [self addSubview:cutOutLabel];
    
    cutOutLine.hidden = YES;
    cutOutLabel.hidden = YES;
    
    // Email button on the right
    RSSButton *emailButton = [[RSSButton alloc] initWithFrame:CGRectMake(appFrame.size.width - 110,
                                                                         logoArtwork.frame.size.height + 70,
                                                                         100,
                                                                         20)];
    emailButton.hitOffsetTop = 13;
    emailButton.hitOffsetBottom = 13;
    emailButton.backgroundColor = [UIColor closetMaidRedColor];
    emailButton.layer.cornerRadius = 3.0f;
    emailButton.titleLabel.textColor = [UIColor whiteColor];
    [emailButton setTitle:@"Email Cuts"
                 forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldCond"
                                                  size:14];
    [emailButton addTarget:self
                    action:@selector(showEmail)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emailButton];
    
    currentY += howToCutLabel.frame.size.height + 5;
    
    // SCANDAL - backbutton
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(appFrame.size.width - 60,
                                                                      10,
                                                                      50,
                                                                      30)];
    backButton.backgroundColor = [UIColor clearColor];
    UIImageView *backBtn = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"button-Back"];
    UIImageView *backBtnHighlighted = [[UIImageView alloc] initImageWithDeviceSpecificResolution:@"button-Back-Highlighted"];
    [backButton setImage:backBtn.image forState:UIControlStateNormal];
    [backButton setImage:backBtnHighlighted.image forState:UIControlStateHighlighted];
    [backButton addTarget:self
                   action:@selector(backButtonPush)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    // Shelf drawing container is a UIScrollView
    drawerView = [[UIScrollView alloc] initWithFrame:CGRectMake(LEFT_PADDING + 5,
                                                                currentY,
                                                                appFrame.size.width - 2 * LEFT_PADDING,
                                                                appFrame.size.height - currentY)];
    [self addSubview:drawerView];
}

/***************************************************
 *  Public methods
 ***************************************************/
/*
 *  Update controls that display units + the switch button
 */
- (void)updateViewWithCuts:(NSArray *)cuts andTotalWaste:(CGFloat)waste inUnit:(UnitOfMeasure)unitOfMeasure size:(CGFloat)size
{    
    if (unitOfMeasure == IMPERIAL) {
        [self setNeedsLabel:cuts.count
                   withSize:[NSString stringWithFormat:@"%@", [NumberUtils formattedStringFromFloat:size]]
                    andUnit:@"\""];
        [self setExcessLabel:[NSString stringWithFormat:@"%@", [NumberUtils formattedStringFromFloat:waste]]
                     andUnit:@"\""];
    } else if (unitOfMeasure == METRIC) {
        [self setNeedsLabel:cuts.count
                   withSize:[NSString stringWithFormat:@"%@", [NumberUtils formattedStringFromFloat:size]]
                    andUnit:@"cm"];
        [self setExcessLabel:[NSString stringWithFormat:@"%@", [NumberUtils formattedStringFromFloat:waste]]
                     andUnit:@" cm"];
    }
    
    // drawings
    [self drawCuts:cuts onSize:size inUnit:unitOfMeasure];
}

/***************************************************
 *  Private methods
 ***************************************************/
- (void)setNeedsLabel:(int)number withSize:(NSString *)shelfSize andUnit:(NSString *)unit
{
    requirementLabel.text = [NSString stringWithFormat:@"%d - %@%@ Sections of Shelving", number, shelfSize, unit];
}

- (void)setExcessLabel:(NSString *)waste andUnit:(NSString *)unit
{
    excessLabel.text = [NSString stringWithFormat:@"Excess Shelving: %@%@", waste, unit];
    [excessLabel sizeToFit];
}

/*
 *  Create the ShelvingDrawer objects for each Section of Shelving
 */
- (void)drawCuts:(NSArray *)cuts onSize:(CGFloat)size inUnit:(UnitOfMeasure)unitOfMeasure
{
    // first clear
    for (UIView *v in drawerView.subviews) {
        [v removeFromSuperview];
    }
    
    // set content size
    int nrFrames = (cuts.count + 1) / 2;
    drawerView.contentSize = CGSizeMake(drawerView.frame.size.width, (DRAWING_HEIGHT + 15) * nrFrames - 10);
    
    // draw cuts.count views
    int i = 0;
    BOOL hasDownRod = NO;
    for (CutSizes *cut in cuts) {
        ShelvingDrawer *drawing = [[ShelvingDrawer alloc] initWithFrame:CGRectMake((DRAWING_WIDTH + 10) * (i % 2),
                                                                                   (DRAWING_HEIGHT + 15) * (i / 2),
                                                                                   DRAWING_WIDTH,
                                                                                   DRAWING_HEIGHT)
                                                                drawCut:cut.cutSizes
                                                            onShelfSize:size
                                                              withWaste:cut.waste
                                                                 inUnit:unitOfMeasure];
        [drawerView addSubview:drawing];
        i++;
        
        // Check for downrod to display appropriate label
        if (drawing.hasDownRod) {
            hasDownRod = YES;
        }
    }
    if (hasDownRod) {
        cutOutLine.hidden = NO;
        cutOutLabel.hidden = NO;
    } else {
        cutOutLine.hidden = YES;
        cutOutLabel.hidden = YES;
    }
}

/***************************************************
 *  Private selectors
 ***************************************************/
/*
 *  Selector method that passes a notification to change unit of measurement
 */
- (void)showEmail
{
    [delegate showEmailButtonPush];
}

/*
 *  Selector method that tells the delegate (presented ResultsViewController) to dismiss
 */
- (void)backButtonPush
{
    [delegate backButtonPush];
}

/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
