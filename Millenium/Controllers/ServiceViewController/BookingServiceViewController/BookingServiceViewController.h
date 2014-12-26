//
//  BookingServiceViewController.h
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerCell.h"
#import "DateCell.h"
#import "VehicleCell.h"
#import "DealerObj.h"
#import "VehicleObj.h"
#import "ServiceObj.h"
#import "DefaultCell.h"
#import "BaseViewController.h"
#import "MarqueeLabel.h"
#import "CKCalendarDelegate.h"
#import "CKCalendarDataSource.h"


@interface BookingServiceViewController : BaseViewController
{
    IBOutlet UIView *_datePickerView;
    IBOutlet UIView *_slotTimeView;
    IBOutlet UIView *_chooseDateView;
    IBOutlet UIView *_calView;
    IBOutlet UIView *serviceTypeView;
    IBOutlet UIButton *_btnSlot0;
    IBOutlet UIButton *_btnSlot1;
    IBOutlet UIButton *_btnSlot2;
    IBOutlet UIButton *_btnSlot3;
    IBOutlet UIButton *_btnSlot4;
    IBOutlet UIButton *_btnSlot5;
    IBOutlet UIButton *_btnSlot6;
    IBOutlet UIButton *_btnSlot7;
    IBOutlet UIButton *_btnSlot8;
    IBOutlet UIButton *_btnSlot9;
    IBOutlet UIButton *_btnSlot10;
    IBOutlet UIButton *_btnSlot11;
    IBOutlet UIButton *_btnSlot12;
    IBOutlet UIButton *_btnSlot13;
    IBOutlet UIButton *_btnSlot14;
    IBOutlet UIButton *_btnSlot15;
    IBOutlet UIButton *_btnSlot16;
    IBOutlet UIButton *_btnSlot17;
    IBOutlet UIButton *_btnSlot18;
    
    __weak IBOutlet UIView *_addSlotTime;
    NSMutableArray *arrBtn ;
    NSString *dateSelected;
    NSString *dateRealitySelected;
    
    NSString *timeSelected;
    NSString *dateStr;
    
}

@property (nonatomic, assign) id<CKCalendarViewDataSource> dataSource;
@property (nonatomic, assign) id<CKCalendarViewDelegate> delegate;

- (CKCalendarView *)calendarView;

@property(strong,nonatomic) BookingHistoryObj* bkHis;
@property(strong, nonatomic) NSString* serviceType;
@property(strong, nonatomic) NSString* headerImgURL;
@property(strong, nonatomic) DealerObj* selectedDealder;
@property(strong, nonatomic) NSDate* selectedDate;
@property(strong, nonatomic) VehicleObj* selectedVehicle;
@property(strong, nonatomic) ServiceObj* selectedService;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewSlotTime;

@property (weak, nonatomic) IBOutlet UIButton *vehicleBtn;
@property (weak, nonatomic) IBOutlet UIButton *branchBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceTypeBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UILabel *vehicleLbl;

@property (weak, nonatomic) IBOutlet UILabel *branchLbl;

@property (weak, nonatomic) IBOutlet UILabel *serviceLanceLbl;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *requestServiceLbl;
@property (weak, nonatomic) IBOutlet UITextView *infoTxtView;
@property (weak, nonatomic) IBOutlet UIButton *bookingBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *selectVehicleLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectBranchLbl;
@property (weak, nonatomic) IBOutlet UILabel *selectDateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLbl;
@property (weak, nonatomic) IBOutlet UIButton *requestBookingBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *selectVehicleLblTH;
@property (weak, nonatomic) IBOutlet UILabel *selectBranchLblTH;
@property (weak, nonatomic) IBOutlet UILabel *selectDateTimeLblTH;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLblTH;
@property (weak, nonatomic) IBOutlet UILabel *serviceNoteLblTH;

@property (assign, nonatomic) BOOL isEditBookingHistory;
@property (strong, nonatomic) BookingHistoryObj* bookingHistoryToEdit;


@end
