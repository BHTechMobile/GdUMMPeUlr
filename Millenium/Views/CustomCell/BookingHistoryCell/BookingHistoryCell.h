//
//  BookingHistoryCell.h
//  Millenium
//
//  Created by duc le on 2/27/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookingHistoryCellDelegate;
@interface BookingHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *vehicleLbl;
@property (weak, nonatomic) IBOutlet UILabel *branchLbl;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UITextView *noteTxtView;
@property (weak, nonatomic) IBOutlet UILabel *noteLbl;
@property (strong, nonatomic) IBOutlet UILabel *_lbSubmitedTime;

@property (weak, nonatomic) IBOutlet UILabel *branch;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) id<BookingHistoryCellDelegate> delegate;

-(void)setTitleByLang;

@end

@protocol BookingHistoryCellDelegate

-(void)onEditBookingHistory:(BookingHistoryCell*)bkHisCell;

@end
