//
//  ServiceListCell.h
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceListCell;

@protocol ServiceCellDelegate <NSObject>;

-(void)serviceListCell:(ServiceListCell *)service bookOnlinePress:(UIButton *)button;
-(void)serviceListCell:(ServiceListCell *)service callServicePress:(NSString *)telephone;

@end

@interface ServiceListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *serviceNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *telephoneLbl;

@property (weak, nonatomic) IBOutlet UITextView *serviceDescriptionTxtView;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblbookOnlien;
@property (weak, nonatomic) IBOutlet UIButton *lbl_callService;

@property (weak, nonatomic) IBOutlet UILabel *desLbl;

@property (strong,nonatomic) id<ServiceCellDelegate> delegate;

@end
