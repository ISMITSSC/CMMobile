//
//  ResultsViewController.m
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/12/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "ShelvingCutResultsViewController.h"
#import "ShelvingCutCalculateViewController.h"
#import "ShelvingCutResultsView.h"
#import "CutSizes.h"
#import "NumberUtils.h"


@interface ShelvingCutResultsViewController ()
{
    CGRect applicationFrame;
    
    ShelvingCutResultsView *resultsView;
    
    CGFloat shelfSize;
    NSString *shelfType;
    NSArray *shelfCuts;
    CGFloat totalWaste;
    
    UnitOfMeasure unitOfMeasurement;
}

- (NSString *)stringFromCut:(CutSizes *)aCut;
- (UIImage *)imageFromCutsDrawings;

@end

@implementation ShelvingCutResultsViewController


/* ============================== */
#pragma mark - Init

- (id)initWithSize:(CGFloat)sizeOfShelf
           andType:(NSString *)typeOfShelf
          withCuts:(NSArray *)shelvingCuts
            inUnit:(UnitOfMeasure)unit
{
    self = [super init];
    if (self) {
        applicationFrame = [[UIScreen mainScreen] applicationFrame];
        // Custom initialization
        resultsView = [[ShelvingCutResultsView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               applicationFrame.size.width,
                                                                               applicationFrame.size.height)];
        // init values for labels/drawings
        shelfSize = sizeOfShelf;
        shelfType = typeOfShelf;
        shelfCuts = shelvingCuts;
        unitOfMeasurement = unit;
        // calculate total waste
        totalWaste = 0;
        for (CutSizes *cut in shelfCuts) {
            totalWaste += cut.waste;
        }
        [resultsView updateViewWithCuts:[NSArray arrayWithArray:shelfCuts]
                          andTotalWaste:totalWaste
                                 inUnit:unitOfMeasurement
                                   size:shelfSize];
        // data init
        resultsView.delegate = self;
        // Transition animation
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}


/* ============================== */
#pragma mark - View lifecycle

- (void)loadView
{
    self.view = resultsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* ============================== */
#pragma mark - ShowResultsViewDelegate methods

- (void)backButtonPush
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (void)showEmailButtonPush
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"ClosetMaid Job number: "];
    
    NSString *unit = (unitOfMeasurement == IMPERIAL) ? @"\"" : @"cm";
        
    NSMutableString *messageBody = [NSMutableString stringWithFormat:@"Shelving Cut Calculator</br></br>"];
    [messageBody appendFormat:@"Type of Shelving: <span style='color:#ED1A2E;'>%@</span></br>", shelfType];
    [messageBody appendFormat:@"What You Will Need: <span style='color:#ED1A2E;'>%d - %@%@ Sections of Shelving</span></br>", shelfCuts.count, [NumberUtils formattedStringFromFloat:shelfSize], unit];
    [messageBody appendFormat:@"Total Excess Shelving: <span style='color:#ED1A2E;'>%.0f%@</span></br></br>", totalWaste, unit];
    [messageBody appendString:@"How To Cut It:</br></br>"];
    for (int i = 0; i < shelfCuts.count; i++) {
        NSMutableString *currentLine = [NSMutableString stringWithFormat:@"Shelf #%d: ", i];
        [currentLine appendString:[self stringFromCut:shelfCuts[i]]];
        [currentLine appendString:@"</br>"];
        [messageBody appendString:currentLine];
    }
    [mc setMessageBody:messageBody isHTML:YES];
    
    NSData *imageData = UIImagePNGRepresentation([self imageFromCutsDrawings]);
    [mc addAttachmentData:imageData
                 mimeType:@"image/png"
                 fileName:@"closetmaidCuts.png"];
    
    [self presentViewController:mc
                       animated:YES
                     completion:NULL];
}


/* ============================== */
#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    BOOL failed = NO;
    
    switch (result) {
        case MFMailComposeResultFailed:
            failed = YES;
            break;
            
        default:
            break;
    }
    
    if (failed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:error.localizedFailureReason
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
       [self dismissViewControllerAnimated:YES
                                completion:NULL];
    }
}


/* ============================== */
#pragma mark - Private methods

- (NSString *)stringFromCut:(CutSizes *)aCut
{
    NSMutableString *cutString = [NSMutableString stringWithString:@""];
    NSString *unit = (unitOfMeasurement == IMPERIAL) ? @"\"" : @"cm";
    
    NSArray *reversedCutSizes = [[aCut.cutSizes reverseObjectEnumerator] allObjects];
    
    for (int i = 0; i < reversedCutSizes.count; i++) {
        NSNumber *currentCut = reversedCutSizes[i];
        if (currentCut.floatValue < 0) {
            [cutString appendString:@"<span style='color:#ED1A2E;'>[ downrod ]</span>"];
        } else {
            [cutString appendFormat:@"[ %d%@ ]", currentCut.integerValue, unit];
        }
    }
    
    [cutString appendFormat:@"<span style='color:#AAAAAA;'>[ %@%@ waste ]</span>", [NumberUtils formattedStringFromFloat:aCut.waste], unit];
    
    return cutString;
}

- (UIImage *)imageFromCutsDrawings
{
    UIGraphicsBeginImageContext(resultsView.drawerView.contentSize);
    
    CGPoint savedContentOffset = resultsView.drawerView.contentOffset;
    CGRect savedFrame = resultsView.drawerView.frame;
    
    resultsView.drawerView.contentOffset = CGPointZero;
    resultsView.drawerView.frame = CGRectMake(0,
                                              0,
                                              resultsView.drawerView.contentSize.width,
                                              resultsView.drawerView.contentSize.height);
    
    [resultsView.drawerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    resultsView.drawerView.contentOffset = savedContentOffset;
    resultsView.drawerView.frame = savedFrame;
    
    UIImage *drawing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return drawing;
}

@end
