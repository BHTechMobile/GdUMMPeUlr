//
//  DealerCell.h
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DealerCellDelegate;

@interface DealerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblOpeningHour;
@property (weak, nonatomic) IBOutlet UILabel *lblOpeningTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTelTitle;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;


@property (weak, nonatomic) id<DealerCellDelegate> delegate;

@end

@protocol DealerCellDelegate <NSObject>

-(void)call:(NSString*)tel;

@end
