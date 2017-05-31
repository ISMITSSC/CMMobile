//
//  ResultViewController.h
//  ClosetMaidShelfCount
//
//  Created by Sebastian Vancea on 5/8/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@class Hardware;
@class ClosetMaidLabel;

@interface HardwareResultsViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,
MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) Hardware *hardware;

@property (strong, nonatomic) IBOutlet UITableView *resultsTableView;

- (IBAction)goBack:(id)sender;
- (IBAction)showEmail:(id)sender;

@end
