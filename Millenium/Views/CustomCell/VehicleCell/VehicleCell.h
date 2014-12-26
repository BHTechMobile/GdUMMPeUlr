//
//  VehicleCell.h
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *plateNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *VINLbl;
@property (weak, nonatomic) IBOutlet UILabel *modelLbl;


@property (weak, nonatomic) IBOutlet UILabel *plate;
@property (weak, nonatomic) IBOutlet UILabel *VIN;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;

-(void)setTitleByLang;

@end
