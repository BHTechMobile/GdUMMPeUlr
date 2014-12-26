//
//  EditProfileCell.h
//  Millenium
//
//  Created by duc le on 2/27/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditProfileCellDelegate;
@interface EditProfileCell : UITableViewCell

@property(nonatomic,weak) id<EditProfileCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookingHistoryBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblEditProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblBookingHistiry;

@end

@protocol EditProfileCellDelegate <NSObject>

-(void)goToEditProfile;
-(void)goToBookingHistory;

@end