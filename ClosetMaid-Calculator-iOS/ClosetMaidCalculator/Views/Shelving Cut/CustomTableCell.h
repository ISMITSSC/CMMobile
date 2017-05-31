//
//  CustomPickersCell.h
//  ClosetMaidCalculator
//
//  Created by Sebastian Vancea on 1/4/13.
//  Copyright (c) 2013 Sebastian Vancea. All rights reserved.
//

#import "RSSPickerButton.h"
#import "CustomTextField.h"


@interface CustomTableCell : UITableViewCell

//@property (strong,nonatomic) RSSPickerButton *quantityTextField;
//@property (strong,nonatomic) RSSPickerButton *lengthTextField;
//
@property (strong,nonatomic) CustomTextField *quantityTextField;
@property (strong,nonatomic) CustomTextField *lengthTextField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
