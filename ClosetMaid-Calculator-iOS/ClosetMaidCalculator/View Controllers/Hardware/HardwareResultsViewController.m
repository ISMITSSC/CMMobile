//
//  ResultViewController.m
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/8/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "HardwareResultsViewController.h"
#import "NumberUtils.h"
#import "ClosetMaidLabel.h"
#import "Hardware.h"
#import <QuartzCore/QuartzCore.h>


@interface HardwareResultsViewController ()
{
    NSMutableArray *hardwareArray;
    NSMutableArray *quantityArray;
}

- (UIImage *)imageFromTable;

@end


@implementation HardwareResultsViewController

@synthesize hardware;
@synthesize resultsTableView;


/* ============================== */
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    int fromEnd = 0;
    
    hardwareArray = [NSMutableArray arrayWithCapacity:5];
    quantityArray = [NSMutableArray arrayWithCapacity:5];
    
    [hardwareArray addObject:@"Wall Clips"];
    [quantityArray addObject:[NumberUtils formattedStringFromInt:self.hardware.wallClips]];
    
    
    if (self.hardware.wallBrackets > 0) {
        [hardwareArray insertObject:@"Wall Brackets"
                            atIndex:0];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.wallBrackets]
                            atIndex:0];
    } else {
        [hardwareArray addObject:@"Wall Brackets"];
        [quantityArray addObject:[NumberUtils formattedStringFromInt:self.hardware.wallBrackets]];
        fromEnd++;
    }
    
    if (self.hardware.supportBrackets > 0) {
        [hardwareArray insertObject:@"Support Brackets"
                            atIndex:0];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.supportBrackets]
                            atIndex:0];
    } else {
        [hardwareArray insertObject:@"Support Brackets" atIndex:hardwareArray.count - fromEnd];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.supportBrackets]
                            atIndex:quantityArray.count - fromEnd];
        fromEnd++;
    }
    
    if (self.hardware.smallEndCaps > 0) {
        [hardwareArray insertObject:@"Small End Caps"
                            atIndex:0];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.smallEndCaps]
                            atIndex:0];
    } else {
        [hardwareArray insertObject:@"Small End Caps"
                            atIndex:hardwareArray.count - fromEnd];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.smallEndCaps]
                            atIndex:quantityArray.count - fromEnd];
        fromEnd++;
    }
    
    if (self.hardware.largeEndCaps > 0) {
        [hardwareArray insertObject:@"Large End Caps"
                            atIndex:0];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.largeEndCaps]
                            atIndex:0];
    } else {
        [hardwareArray insertObject:@"Large End Caps"
                            atIndex:hardwareArray.count - fromEnd];
        [quantityArray insertObject:[NumberUtils formattedStringFromInt:self.hardware.largeEndCaps]
                            atIndex:quantityArray.count - fromEnd];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setResultsTableView:nil];
    [super viewDidUnload];
}


/* ============================== */
#pragma mark - Actions

- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (IBAction)showEmail:(id)sender {
    NSString *subject = @"ClosetMaid Job number: ";
    
    NSMutableString *messageBody = [NSMutableString stringWithFormat:@"Hardware Calculator</br></br>"];
    [messageBody appendFormat:@"What You Will Need:"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:subject];
    [mc setMessageBody:messageBody isHTML:YES];
    NSData *imageData = UIImagePNGRepresentation([self imageFromTable]);
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
#pragma mark - UITableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsCell"];
    
    UILabel *itemName = (UILabel *)[cell viewWithTag:HARDWARE_LABEL];
    UILabel *itemQuantity = (UILabel *)[cell viewWithTag:QUANTITY_LABEL];
    
    itemName.text = [hardwareArray objectAtIndex:indexPath.row];
    itemQuantity.text = [quantityArray objectAtIndex:indexPath.row];
 
    return cell;
}


/* ============================== */
#pragma mark - UITableView delegate & datasource

- (UIImage *)imageFromTable
{
    UIGraphicsBeginImageContext(resultsTableView.contentSize);
    
    [resultsTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *drawing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return drawing;
}

@end
