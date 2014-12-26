//
//  SOSCell.h
//  Millenium
//
//  Created by Mr Lemon on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSOSName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;

@end
