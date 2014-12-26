//
//  BookingServiceViewController.m
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BookingServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "DealerListViewController.h"
#import "VehicleListViewController.h"
#import "MBProgressHUD.h"
#import "BookingHistoryViewController.h"
#import <EventKit/EventKit.h>
#import "NSString+TextSize.h"
#import "BookingSubAlertView.h"
#import "CXAlertView.h"
#import "Util.h"
#import "SlotTimeObj.h"

#import "CKCalendarView.h"

#import "CKCalendarEvent.h"

#import "NSCalendarCategories.h"

#define SLOT_8_30 0
#define SLOT_9_00 1
#define SLOT_9_30 2
#define SLOT_10_00 3
#define SLOT_10_30 4
#define SLOT_11_00 5
#define SLOT_11_30 6
#define SLOT_12_00 7
#define SLOT_12_30 8
#define SLOT_13_00 9
#define SLOT_13_30 10
#define SLOT_14_00 11
#define SLOT_14_30 12
#define SLOT_15_00 13
#define SLOT_15_30 14
#define SLOT_16_00 15
#define SLOT_16_30 16
#define SLOT_17_00 17


@interface BookingServiceViewController ()<UITextViewDelegate,DealerListViewControllerDelegate,VehicleListVCDelegate,UIAlertViewDelegate,CKCalendarViewDataSource, CKCalendarViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) CKCalendarView *calendarView;

@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic,strong) NSDateFormatter* dateFormater;
@property (nonatomic,strong) NSDateFormatter* timeFormater;
@property (nonatomic,strong) NSDateFormatter* dateFormatToSend;

@end

@implementation BookingServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serviceType = _selectedService.name;
    [_scrollView setContentSize:CGSizeMake(320, 520)];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.dateFormater =  [[NSDateFormatter alloc] init];
    [_dateFormater setDateStyle:NSDateFormatterMediumStyle];
    
    self.timeFormater = [[NSDateFormatter alloc] init];
    [_timeFormater setDateFormat:@"HH:mm"];
    
    self.dateFormatToSend = [[NSDateFormatter alloc] init];
    [_dateFormatToSend setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _datePicker.minimumDate = [NSDate date];
    _datePicker.date = [NSDate date];
    [self changeDate:nil];
    
    
    
    [self setUpBorderBtn];
    [self setupToolbar];
    if(_isEditBookingHistory == NO)
    {
        _serviceLanceLbl.text = _serviceType;
        [self loadDefaultCar];
        [self loadDefaultBranch];
    }else{
        [self loadDataFromBookingHisotory];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDefaultCar) name:kNotifi_UpdateDefaultCar object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCalendarBooking) name:kNotifi_UpdateCalendarBooking object:nil];
    
    [self setUpFont];
    [self changeLang];
    // Do any additional setup after loading the view from its nib.
    
    //set calendar view
    
    /* Prepare the events array */
    
    [self setEvents:[NSMutableArray new]];
    
    /* Calendar View */
    
    [self setCalendarView:[CKCalendarView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    
    [[self calendarView] setFrame:CGRectOffset([[self calendarView] frame], 0,0)];
    //    [[self view] addSubview:[self calendarView]];
    ////    [_scrollView addSubview:[self calendarView]];
    [_calView addSubview:[self calendarView]];
    
    if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"gregorian"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    }else if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"buddhist"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar] animated:NO];
    }
    
    //    [[[self calendarView] calendar] calendarIdentifier];
    [[self calendarView] setDisplayMode:CKCalendarViewModeMonth animated:NO];
    
    /* Mode Picker */
    
    NSArray *items = @[NSLocalizedString(@"Month", @"A title for the month view button."), NSLocalizedString(@"Week",@"A title for the week view button."), NSLocalizedString(@"Day", @"A title for the day view button.")];
    
    [self setModePicker:[[UISegmentedControl alloc] initWithItems:items]];
    [[self modePicker] setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[self modePicker] addTarget:self action:@selector(modeChangedUsingControl:) forControlEvents:UIControlEventValueChanged];
    [[self modePicker] setSelectedSegmentIndex:0];
    
    arrBtn = [[NSMutableArray alloc] init];
//    [arrBtn addObject:_btnSlot1];
//    [arrBtn addObject:_btnSlot2];
//    [arrBtn addObject:_btnSlot3];
//    [arrBtn addObject:_btnSlot4];
//    [arrBtn addObject:_btnSlot5];
//    [arrBtn addObject:_btnSlot6];
//    [arrBtn addObject:_btnSlot7];
//    [arrBtn addObject:_btnSlot8];
//    [arrBtn addObject:_btnSlot9];
//    [arrBtn addObject:_btnSlot10];
//    [arrBtn addObject:_btnSlot11];
//    [arrBtn addObject:_btnSlot12];
//    [arrBtn addObject:_btnSlot13];
//    [arrBtn addObject:_btnSlot14];
//    [arrBtn addObject:_btnSlot15];
//    [arrBtn addObject:_btnSlot16];
//    [arrBtn addObject:_btnSlot17];
//    [arrBtn addObject:_btnSlot18];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"with : %f , height : %f",[[self calendarView] frame].size.width,[[self calendarView] frame].size.height);
    if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"gregorian"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    }else if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"buddhist"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar] animated:NO];
    }

}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date withAnimated:(BOOL)animated
{
    
}
- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date withAnimated:(BOOL)animated
{
    
    NSLog(@"date selected: %@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateSelected = [dateFormatter stringFromDate:date];
    dateRealitySelected = dateSelected;
    NSLog(@"date formatter : %@",dateSelected);
    NSString *dateNow = [dateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"%d",[dateSelected compare:dateNow]);
    if ([dateSelected compare:dateNow]  == NSOrderedAscending) {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Date_Selected) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
        //        [alert show];
        
    }else
    {
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
        dateStr =[dateFormatter stringFromDate:date];
        _dateLbl.text = [dateFormatter stringFromDate:date];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setCalendar:gregorianCalendar];
        
//        NSString *formattedDate = [dateFormatter stringFromDate:date];
        dateSelected = [dateFormatter stringFromDate:date];
        NSLog(@"%@", dateSelected);
        
        
        if (animated==NO) {
            
            if(_selectedDealder == nil)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Branch) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
                [alert show];
                return;
            }else
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [ModelManager getSlotTimeByDearlerId:self.selectedDealder.objId withDate:dateSelected andSuccess:^(NSMutableArray *arr) {
                    NSLog(@"arr slottime:%@",arr);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                   
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    [dateFormatter setCalendar:gregorianCalendar];
                    
                    NSString *dateNow = [dateFormatter stringFromDate:[NSDate date]];
                    
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *timeNow = [dateFormatter stringFromDate:[NSDate date]];
                    NSInteger couterArr=_addSlotTime.subviews.count;
                    for (int x=1; x<=couterArr; x++) {
                        [[_addSlotTime viewWithTag:x] removeFromSuperview];
                    }
                    NSInteger couter=0;
                    for (int i=0;i<arr.count;i++) {
                      
                        SlotTimeObj *STobj = [arr objectAtIndex:i];
                  
                     
                            UIButton *btn = [[UIButton alloc] init];
                            [btn setTitle:STobj.slotName forState:UIControlStateNormal];
                            btn.tag=i+1;
                            
                            [btn addTarget:self action:@selector(slotTimeSelected:) forControlEvents:UIControlEventTouchUpInside];
                            
                            float x=arr.count/4;
                            if (0<couter<x+1) {
                                NSInteger space=15*(i -(4*couter));
                                NSInteger wButtonSpace=(i -(4*couter))*60;
                                btn.frame=CGRectMake((wButtonSpace +space+20), couter*45 +15, 60, 30);
                            }
                            if (btn.tag%4==0) {
                                
                                couter++;
                            }
                      
                            [_addSlotTime addSubview:btn];
                            if ([STobj.available isEqualToString:@"1"]) {
                                if ([dateNow compare:dateSelected]== NSOrderedSame) {
                                    if ([timeNow compare:STobj.slotName] == NSOrderedAscending) {
                                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"SlotTimeBtn.png"]]  forState:UIControlStateNormal];
                                        [btn setEnabled:YES];
                                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        
                                    }else{
                                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"back_bg.png"]]  forState:UIControlStateNormal];
                                        [btn setEnabled:NO];
                                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    }
                                }else if ([dateNow compare:dateSelected]== NSOrderedAscending) {
                                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"SlotTimeBtn.png"]]  forState:UIControlStateNormal];
                                    [btn setEnabled:YES];
                                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                }
                                
                            } else if ([STobj.available isEqualToString:@"0"]) {
                                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"back_bg.png"]]  forState:UIControlStateNormal];
                                [btn setEnabled:NO];
                                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        }
                     
                    }
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [_slotTimeView setHidden:NO];
                    [_chooseDateView setHidden:YES];
                    
                } failure:^(NSError *err) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_ConnectServer) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }];
            }
        }
    }
    
}

- (void)calendarView:(CKCalendarView *)calendarView frameCalendarView:(CGRect)frame
{
    //    NSLog(@"calendar will show with : %f, height : %f",frame.size.width,frame.size.height);
    //
    //    [serviceTypeView setFrame:CGRectMake(0, (_calView.frame.origin.y+frame.size.height)+10, serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
    
}

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

#pragma mark - function

-(IBAction)chooseTime:(id)sender{
    if ([_selectedService.isFastLane isEqualToString:@"1"]) {
        
        [_datePickerView setHidden:YES];
        
        [_chooseDateView setHidden:NO];
        [_slotTimeView setHidden:YES];
    }else{
        [_datePickerView setHidden:NO];
        [_slotTimeView setHidden:YES];
        [_chooseDateView setHidden:YES];
        //        [serviceTypeView setFrame:CGRectMake(0,300, serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
        //        [_scrollView setContentSize:CGSizeMake(320, 520)];
    }
    
}
-(IBAction)closeChooseDateView:(id)sender{
    
    [_chooseDateView setHidden:YES];
    [_slotTimeView setHidden:YES];
    [_datePickerView setHidden:YES];
    
}

-(IBAction)slotTimeSelected:(id)sender{
    NSLog(@"%d",[_addSlotTime subviews].count);
    

    UIButton *button=(UIButton *)[_addSlotTime viewWithTag:[sender tag]];
    NSLog(@"button tag:%d",[sender tag]);
       _dateLbl.text =[NSString stringWithFormat:@"%@ %@",dateStr,button.titleLabel.text];
    timeSelected = [NSString stringWithFormat:@"%@:00",button.titleLabel.text];
    NSLog(@"title selected : %@",timeSelected);
    [_slotTimeView setHidden:YES];
 
    
}

-(void)updateCalendarBooking{
    if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"gregorian"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] animated:NO];
    }else if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"buddhist"]) {
        [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSBuddhistCalendar] animated:NO];
    }
}

-(void)loadDefaultCar
{
    NSString* car_id = [Util valueForKey:KEY_FAVORITE_VEHICLE_ID];
    if(car_id && gArrMyCar)
    {
        VehicleObj* obj = [ModelManager getVehicleById:car_id];
        self.selectedVehicle = obj;
        NSString* vehicleStr = [NSString stringWithFormat:@"%@ %@",obj.VINNumber,obj.vehicleModel];
        _vehicleLbl.text = [self stringByRemoveMillenium:vehicleStr];
        
    }
    else{
        _vehicleLbl.text=SetupLanguage(kLang_SelectVehicle);
    }
}
-(NSArray*)sortDealerByDistance:(NSArray*)dealerArr
{
    
    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:gCurrentLatitude longitude:gCurrentLongitude];
    for(DealerObj* dealer in dealerArr)
    {
        if (!gIsEnableLocation || (gCurrentLatitude==0 && gCurrentLongitude==0) || (dealer.latitude== 0 && dealer.longitude==0))
            dealer.distance = 0;
        else{
            CLLocation *dealerLocation = [[CLLocation alloc] initWithLatitude:dealer.latitude longitude:dealer.longitude];
            dealer.distance = [currLocation distanceFromLocation:dealerLocation];
        }
    }
    
    if (!gIsEnableLocation || (gCurrentLatitude==0 && gCurrentLongitude==0))
    {
        return dealerArr;
    }else{
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
        return [dealerArr sortedArrayUsingDescriptors:@[sd]];
    }
    
}

-(void)loadDefaultBranch{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager getDealerByServiceId:_selectedService.categoryId andSuccess:^(NSArray *arr) {
        
        arr = [self sortDealerByDistance:arr];
        DealerObj *dealer;
        for (int i=0; i<arr.count; i++) {
            dealer=[arr objectAtIndex:i];
            NSString *string=[Util valueForKey:KEY_DEFAULT_BRANCH];
            if (![dealer.name isEqualToString:string]) {
                dealer =[arr objectAtIndex:0];
                NSString* dealerName = dealer.name;
                _branchLbl.text = dealerName;
                _selectedDealder=dealer;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
            else{
                NSString* dealerName = dealer.name;
                _branchLbl.text = dealerName;
                _selectedDealder=dealer;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                break;
            }
        }
    } failure:^(NSError *err) {
        NSLog(@"wtf");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
}
-(void)loadDataFromBookingHisotory
{
    if(gArrMyCar)
    {
        VehicleObj* obj = [ModelManager getVehicleById:_bookingHistoryToEdit.car_id];
        self.selectedVehicle = obj;
        NSString* vehicleStr = [NSString stringWithFormat:@"%@ %@",obj.VINNumber,obj.vehicleModel];
        _vehicleLbl.text = [self stringByRemoveMillenium:vehicleStr];
    }
    
    ServiceObj* service = [ModelManager getServiceById:_bookingHistoryToEdit.service_id];
    _serviceLanceLbl.text = service.name;
    self.serviceType = service.name;
    self.selectedService = service;
    
    DealerObj* dealer = [ModelManager getDealerById:_bookingHistoryToEdit.dealer_id];
    self.selectedDealder = dealer;
    NSString* dealerName = dealer.name;
    _branchLbl.text = dealerName;
    
    if(_bookingHistoryToEdit.note && ![_bookingHistoryToEdit.note isEqualToString:@""])
        _infoTxtView.text = _bookingHistoryToEdit.note;
    
    NSString* bookingDateStr = _bookingHistoryToEdit.date;
    NSDate* date = [_dateFormatToSend dateFromString:bookingDateStr];
    [_datePicker setDate:date];
    
}


-(void)setUpFont
{
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    
    UIFont* regularFont = [Util customRegularFontWithSize:11.0];
    UIFont* boldFont  = [Util customBoldFontWithSize:13.0];
    
    _selectBranchLbl.font = boldFont;
    _selectBranchLblTH.font = regularFont;
    _selectVehicleLbl.font = boldFont;
    _selectVehicleLblTH.font = regularFont;
    _selectDateTimeLbl.font = boldFont;
    _selectDateTimeLblTH.font = regularFont;
    _serviceTypeLbl.font = boldFont;
    _serviceTypeLblTH.font = regularFont;
    _requestServiceLbl.font = boldFont;
    _serviceNoteLblTH.font = regularFont;
    
    _vehicleLbl.font = _branchLbl.font = _serviceLanceLbl.font = [Util customBoldFontWithSize:13];
    //_vehicleLbl.font = boldFont;
    //_branchLbl.font = boldFont;
    //_serviceLanceLbl.font = boldFont;
    
    //_dateLbl.font = _timeLbl.font = boldFont;
    //_infoTxtView.font = [Util customRegularFontWithSize:14.0];
    
    //_requestBookingBtn.titleLabel.font = _backBtn.titleLabel.font = boldFont;
}

-(void)setUpBorderBtn
{
    _infoTxtView.layer.borderWidth = 1.0;
    _infoTxtView.layer.cornerRadius = 5.0f;
    _infoTxtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}

-(void)changeLang
{
    
    [_requestBookingBtn setTitle:SetupLanguage(kLang_RequestThisBooking) forState:UIControlStateNormal];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    
    _titleLbl.text = [SetupLanguage(kLang_Booking) uppercaseString];
    _dateLbl.text=SetupLanguage(kLang_SelectDateTime);
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    
    NSLocale *locale;
    if([[Util valueForKey:DefaultLang] isEqualToString:@"en"])
    {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }else{
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th_TH"];
    }
    [_dateFormater setLocale:locale];
    [_dateFormatToSend setLocale:locale];
    [_datePicker setLocale:locale];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backCalendarView:(id)sender
{
    [_chooseDateView setHidden:NO];
    [_slotTimeView setHidden:YES];
    
    //    [serviceTypeView setFrame:CGRectMake(0, (_calView.frame.origin.y+[[self calendarView] frame].size.height)+10, serviceTypeView.frame.size.width, serviceTypeView.frame.size.height)];
    //
    //    for (UIButton *btn in arrBtn) {
    //        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"SlotTimeBtn.png"]]  forState:UIControlStateNormal];
    //        [btn setEnabled:YES];
    //    }
}

#pragma mark - Toolbar Function

-(void)setupToolbar
{
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    keyboardToolbar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:SetupLanguage(kLang_Done)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(toolbarButtonTap:)];
    doneBarItem.tag=3;
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
    _infoTxtView.inputAccessoryView = keyboardToolbar;
}

-(void)toolbarButtonTap:(id)sender
{
    [_infoTxtView resignFirstResponder];
}

#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y+50);
    //    scrollPoint.y-=([[[UIApplication sharedApplication] delegate] window].frame.size.height-475);
    _scrollView.scrollEnabled = NO;
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _scrollView.scrollEnabled = YES;
    CGPoint point = [_scrollView contentOffset];
    point.y = textView.frame.origin.y-100;
    [_scrollView setContentOffset:point animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - VehicleListVCDelegate
-(void)choosedVehicle:(VehicleObj *)vehicle
{
    self.selectedVehicle = vehicle;
    //NSString* VINNumber = vehicle.plateNumber;
    NSString* vehicleStr = [NSString stringWithFormat:@"%@ %@",vehicle.VINNumber,vehicle.vehicleModel];
    _vehicleLbl.text = [self stringByRemoveMillenium:vehicleStr];
}

#pragma mark - DealerListVCDelegate

-(void)choosedDealer:(DealerObj *)dealer
{
    self.selectedDealder = dealer;
    NSString* dealerName = dealer.name;
    _branchLbl.text = dealerName;
}

#pragma mark - SelectedDateVCDelegate

- (IBAction)changeDate:(id)sender
{
    NSDate* date = [_datePicker date];
    NSString* dateStr = [_dateFormater stringFromDate:date];
    NSString* timeStr = [_timeFormater stringFromDate:date];
    _dateLbl.text=@"Select Date/Time";//[NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    _timeLbl.text = timeStr;
}


#pragma mark - IBAction function

- (IBAction)selectVehicle:(id)sender
{
    VehicleListViewController* vehicleVC = [[VehicleListViewController alloc] initWithNibName:@"VehicleListViewController" bundle:nil];
    vehicleVC.delegate = self;
    [self.navigationController pushViewController:vehicleVC animated:YES];
}

- (IBAction)selectBranch:(id)sender
{
    DealerListViewController* dealerVC = [[DealerListViewController alloc] initWithNibName:@"DealerListViewController" bundle:nil];
    dealerVC.delegate = self;
    dealerVC.isChoosingDealer = YES;
    dealerVC.serviceId = _selectedService.categoryId;
    [self.navigationController pushViewController:dealerVC animated:YES];
    
    //    ModelManager getDealerByServiceId:_selectedService.categoryId andSuccess:<#^(NSArray *)success#> failure:<#^(NSError *)failure#>
}

- (IBAction)selectServiceLance:(id)sender
{
    NSLog(@"What is this");
}

- (IBAction)booking:(id)sender
{
    
    NSLog(@"Booking done");
    if(_selectedVehicle == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Vehicle) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(_serviceType == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Service) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(_selectedDealder == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Branch) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_selectedService.isFastLane isEqualToString:@"1"]) {
        NSLog(@"date : %@ , time : %@",dateSelected,timeSelected);
        
        
        if(dateSelected == nil || [dateSelected isEqualToString:@"(null)"])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Date) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
            [alert show];
            return;
        }
        if(timeSelected == nil || [timeSelected isEqualToString:@"(null)"])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_Time) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    else{
        if([_datePicker date])
        {
            NSDate* date = [_datePicker date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
            NSInteger hour = [components hour];
            NSInteger minute = [components minute];
            if( hour < 8 || hour > 17 || (hour == 17 && minute >0))
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_YouhaveChoose_TimeServiceFrom8To17) delegate:nil cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
    }
    BookingSubAlertView* bookingSubView = [[[NSBundle mainBundle] loadNibNamed:@"BookingSubAlertView" owner:nil options:nil] objectAtIndex:0];
    
    NSString* vehicle = [NSString stringWithFormat:@"%@",_vehicleLbl.text];
    NSString* branch =  [NSString stringWithFormat:@"%@",_branchLbl.text];
    NSString* type =    [NSString stringWithFormat:@"%@",_serviceType];
    NSString* date =    _dateLbl.text;//[NSString stringWithFormat:@"%@ %@",dateSelected,timeSelected];
    
    bookingSubView.vehicleNameLbl.text = vehicle;
    bookingSubView.branchNameLbl.text = branch;
    bookingSubView.typeNameLbl.text = type;
    bookingSubView.dateNameLbl.text = date;
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        NSString* message = @"\n\n\n";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_ConfirmThisBooking) message:message delegate:self cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES), nil];
        bookingSubView.frame = CGRectMake(0, 33, bookingSubView.frame.size.width, bookingSubView.frame.size.height);
        [alert addSubview:bookingSubView];
        alert.tag = 1001;
        [alert show];
    }
    else
    {
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:SetupLanguage(kLang_ConfirmThisBooking) contentView:bookingSubView cancelButtonTitle:SetupLanguage(kLang_NO)];
        bookingSubView.frame = CGRectMake(30, 0, bookingSubView.frame.size.width, bookingSubView.frame.size.height);
        [alertView addButtonWithTitle:SetupLanguage(kLang_YES)
                                 type:CXAlertViewButtonTypeDefault
                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                  //code add Event
                                  [self addEvent];
                                  [alertView dismiss];
                              }];
        [alertView show];
    }
}


#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1001)// confirm booking alert
    {
        if(buttonIndex == 0) return;
        [self addEvent];
        
    }else if(alertView.tag == 1002)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 1003)
    {
        if(buttonIndex == 0)
        {
            self.bkHis = nil;
            [self alertWaitingConfirm];
        }else
        {
            if(_bkHis)
            {
                NSString* dateStr = [NSString stringWithFormat:@"%@ %@",dateRealitySelected,timeSelected];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dateFromString = [[NSDate alloc] init];
                dateFromString = [dateFormatter dateFromString:dateStr];
                
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    granted=YES;
                    if (granted){
                        //---- codes here when user allow your app to access theirs' calendar.
                        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                        event.title     = [NSString stringWithFormat:@"%@ : %@",SetupLanguage(kLang_BookingService),_serviceType];
                        
                        event.startDate = dateFromString;
                        event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
                        
                        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                        NSError *err;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                        [Util setObject:event.eventIdentifier forKey:_bkHis.objId];
                        self.bkHis = nil;
                        [self performSelectorOnMainThread:@selector(alertWaitingConfirm) withObject:nil waitUntilDone:NO];
                    }else
                    {
                        //----- codes here when user NOT allow your app to access the calendar.
                        [self performSelectorOnMainThread:@selector(alertWaitingConfirm) withObject:nil waitUntilDone:NO];
                    }
                }];
            }else{
                [self performSelectorOnMainThread:@selector(alertWaitingConfirm) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

-(void)addEvent
{
    NSLog(@"add Event to Calender");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* memberID = [Util valueForKey:KEY_MEMBER_ID];
    
    NSString* dateString = [NSString stringWithFormat:@"%@ %@",dateSelected,timeSelected];
    
    NSString* dateStringDevice ;
    
    NSString*timeSlot=@"";
    if ([_selectedService.isFastLane isEqualToString:@"1"]) {
        dateString = dateSelected;
        timeSlot = [timeSelected substringWithRange:NSMakeRange(0, 5)];
    }else{
        NSDate* date = [_datePicker date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateRealitySelected =[dateFormatter stringFromDate:date];
        
         [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
        dateSelected = [dateFormatter stringFromDate:date];
        
        timeSelected = [_timeFormater stringFromDate:date];
        dateString = [NSString stringWithFormat:@"%@ %@",dateSelected,timeSelected];
        dateStringDevice = [NSString stringWithFormat:@"%@ %@",dateRealitySelected,timeSelected];
        timeSlot =@"";
    }
    
    
    
    if(_bookingHistoryToEdit)
    {
        [ModelManager updateEventWithEventId:_bookingHistoryToEdit.objId memberId:memberID cardId:_selectedVehicle.vehicleId dealerId:_selectedDealder.objId eventDate:dateString serviceId:_selectedService.categoryId eventName:_selectedService.name andDetail:_infoTxtView.text slotTime:timeSlot success:^(NSArray *arr) {
            
            
            NSString* eventIden = [Validator getSafeString:[Util valueForKey:_bookingHistoryToEdit.objId]];
            DebugLog(@"event iden : %@",eventIden);
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                granted=YES;
                if(granted)
                {
                    EKEvent *event = [eventStore eventWithIdentifier:eventIden];
                    [eventStore removeEvent:event span:EKSpanFutureEvents error:&error];
                    [Util removeObjectForKey:_bookingHistoryToEdit.objId];
                }
            }];
            
            if(arr.count>0)
            {
                BookingHistoryObj*bkHis = arr[0];
                self.bkHis = bkHis;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_UpdateBookingHistory object:nil];
            [self hideHUD];
        } failure:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Util showMessage:SetupLanguage(KLang_EditBookingFailure) withTitle:SetupLanguage(kLang_BMWCarService)];
        }];
        
    }else{
        [ModelManager addEventWithMemberId:memberID cardId:_selectedVehicle.vehicleId dealerId:_selectedDealder.objId eventDate:dateString serviceId:_selectedService.categoryId eventName:_selectedService.name andDetail:_infoTxtView.text slotTime:timeSlot success:^(NSArray *arr) {
            
            if ([_selectedService.isFastLane isEqualToString:@"1"]) {
                NSLog(@"addd Event >>>>>>>>>>>>>>>>>>>>>>>>>>");
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    granted=YES;
                    if(granted)
                    {
                        
                        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                        event.title     = [NSString stringWithFormat:@"%@ : %@",SetupLanguage(kLang_BookingService),self.serviceType];
                        event.location=_selectedDealder.address;
                        event.notes=[NSString stringWithFormat:@"Car Model: %@ \nLicense plate: %@ \nDealer Tel: %@", _selectedVehicle.vehicleModel, _selectedVehicle.plateNumber,_selectedDealder.phone];
                        NSString *eventDate = [NSString stringWithFormat:@"%@ %@:00",dateRealitySelected,timeSlot];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        //                            [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm a"];
                        event.startDate = [dateFormatter dateFromString:eventDate];
                        event.endDate   = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:event.startDate];
                        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                        NSError *err;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                        NSLog(@"error>>>>>>add Event>>>>>>>>>>:%@",err);
                    }
                }];
            }
            
            
            
            if(arr.count>0)
            {
                BookingHistoryObj*bkHis = arr[0];
                self.bkHis = bkHis;
            }
            [self hideHUD];
        } failure:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Util showMessage:SetupLanguage(KLang_BookingFailure) withTitle:SetupLanguage(kLang_BMWCarService)];
        }];
    }
    
}
-(void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _infoTxtView.text = @"";
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_DoYouWantAddCalendar) delegate:self cancelButtonTitle:SetupLanguage(kLang_Cancel) otherButtonTitles:SetupLanguage(kLang_OK), nil];
    alert.tag = 1003;
    if (![_selectedService.isFastLane isEqualToString:@"1"]) {
        
        [alert show];
    }else{
        [self alertSendSuccess];
    }
}

-(void)alertWaitingConfirm
{
    
    if (![_selectedService.isFastLane isEqualToString:@"1"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_PleaseWaitConfirm) delegate:self cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
    }
}

-(void)alertSendSuccess
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_BookingSent) delegate:self cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles:nil];
    alert.tag = 1002;
    [alert show];
    
    UIAlertView* alertAddEvent = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(kLang_addEventSuccess) delegate:self cancelButtonTitle:SetupLanguage(kLang_YES) otherButtonTitles:nil];
    [alertAddEvent show];
}

-(NSString*)stringByRemoveMillenium:(NSString*)branchName
{
    branchName = [branchName stringByReplacingOccurrencesOfString:@"Millennium Auto Co., Ltd." withString:@""];
    branchName =
    [[branchName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]]
     componentsJoinedByString:@""];
    branchName = [branchName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return branchName;
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {

}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell " forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
@end
