//
//  BookingHistoryViewController.m
//  Millenium
//
//  Created by duc le on 2/27/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BookingHistoryViewController.h"
#import "BookingHistoryCell.h"
#import "NSString+TextSize.h"
#import "ModelManager.h"
#import "BookingHistoryObj.h"
#import "Toast+UIView.h"
#import "Validator.h"
#import "BaseViewController.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "BookingServiceViewController.h"

@interface BookingHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,BookingHistoryCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation BookingHistoryViewController

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
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    // Do any additional setup after loading the view from its nib.
    self.df = [[NSDateFormatter alloc] init];
    [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.shortDf = [[NSDateFormatter alloc] init];
    [_shortDf setDateFormat:@"dd/MM/yy, HH:mm"];
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    [self changeLang];
    
    [_tblView reloadData];
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager getBookingHistory:memberId success:^(NSArray *arr) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
        gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];
        
        [_tblView reloadData];
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *err) {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

    
    [_tblView addPullToRefreshWithActionHandler:^{
        [ModelManager getBookingHistory:memberId success:^(NSArray *arr) {
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
            arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
            gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];

            [_tblView reloadData];
            [_tblView.pullToRefreshView stopAnimating];
        } failure:^(NSError *err) {
            [_tblView.pullToRefreshView stopAnimating];
        }];
    }];
    if(gArrAllBookingHistory== nil)
        [_tblView triggerPullToRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kNotifi_UpdateBookingHistory object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_BookingHistory) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    [_titleLbl sizeToFit];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
}

-(void)update{
  //  [_tblView reloadData];
     NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    [ModelManager getBookingHistory:memberId success:^(NSArray *arr) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
        gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];
        
        [_tblView reloadData];
    } failure:^(NSError *err) {
        [_tblView reloadData];
    }];
}

#pragma mark - UITableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gArrAllBookingHistory.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookingHistoryObj* bookingHistory = [gArrAllBookingHistory objectAtIndex:indexPath.row];
    NSString* note = bookingHistory.note;
    float height = MAX([note heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:14.] andWidth:203.],32);
    
    return 90+height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIden = @"BookingHistoryCell";
    BookingHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIden];

    if(cell == nil)
    {
        cell =  [[[NSBundle mainBundle] loadNibNamed:cellIden owner:nil options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    BookingHistoryObj* bookingHistory = [gArrAllBookingHistory objectAtIndex:indexPath.row];
    
    cell.noteLbl.text = bookingHistory.note;
    VehicleObj* vehicle = [ModelManager getVehicleById:bookingHistory.car_id];
    if(vehicle)
        cell.vehicleLbl.text =[NSString stringWithFormat:@"%@ %@", [Validator getSafeString:vehicle.VINNumber],[Validator getSafeString:vehicle.vehicleModel]];
    else
        cell.vehicleLbl.text = @"Deleted Vehicle";
    cell.branchLbl.text = [Validator getSafeString:[ModelManager getDealerById:bookingHistory.dealer_id].name];
    if([cell.branch.text isEqualToString:@""]) cell.branch.text = @"Deleted Branch";
    cell.serviceTypeLbl.text = [Validator getSafeString:[ModelManager getServiceById:bookingHistory.service_id].name] ;
    
    if([cell.serviceTypeLbl.text isEqualToString:@""]) cell.serviceTypeLbl.text = @"Deleted Service";
    NSDate* bookingDate = [_df dateFromString:bookingHistory.date];
    if (![bookingHistory.slotTime isEqual:@""]) {
      if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"buddhist"]) {
          NSLog(@"date time:%@",bookingHistory.date);
          
          NSArray * dateArray = [[NSArray alloc] initWithArray:[bookingHistory.date componentsSeparatedByString:@"-"]];
          
          NSString *year=[dateArray objectAtIndex:0];
          NSInteger buddhistYear = [year integerValue] + 543;
          
          NSString * buddhistDate = [NSString stringWithFormat:@"%d-%@-%@", buddhistYear, [dateArray objectAtIndex:1], [dateArray objectAtIndex:2]];
          [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
          [_shortDf setDateFormat:@"dd/MM/yy, HH:mm"];
          NSDate* bookedBuddhistDate = [_df dateFromString:buddhistDate];
          cell.dateLbl.text= [_shortDf stringFromDate:bookedBuddhistDate];
        }

    }
    if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"gregorian"]){
         [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         [_shortDf setDateFormat:@"dd/MM/yy, HH:mm"];
        NSDate* bookingDate = [_df dateFromString:bookingHistory.date];
        cell.dateLbl.text = [_shortDf stringFromDate:bookingDate];
    }
   
    
    if ([[[NSCalendar currentCalendar] calendarIdentifier] isEqualToString:@"buddhist"]) {
        NSLog(@"date time:%@",bookingHistory.date);
        
        NSArray * dateArray = [[NSArray alloc] initWithArray:[bookingHistory.submitedTime componentsSeparatedByString:@"-"]];
        
        NSString *year=[dateArray objectAtIndex:0];
        NSInteger buddhistYear = [year integerValue] + 543;
        
        NSString * buddhistDate = [NSString stringWithFormat:@"%d-%@-%@", buddhistYear, [dateArray objectAtIndex:1], [dateArray objectAtIndex:2]];
        [_shortDf setDateFormat:@"dd/MM/yy, HH:mm"];
        NSDate* bookedBuddhistDate = [_df dateFromString:buddhistDate];
        cell._lbSubmitedTime.text=[_shortDf stringFromDate:bookedBuddhistDate];
    }
    else{
         NSDate* bookingSubmited = [_df dateFromString:bookingHistory.submitedTime];
        cell._lbSubmitedTime.text=[_shortDf stringFromDate:bookingSubmited];
    }
    
    NSString* statusProcess = @"Pending";
    switch ([bookingHistory.process intValue]) {
        case 1:
            statusProcess = @"New Request";
            break;
        case 2:
            statusProcess = @"Confirmed";
            break;
        case 4:
            statusProcess = @"Completed";
            break;
        case 5:
            statusProcess = @"Cancelled";
            break;
        default:
            break;
    }
    if([bookingHistory.process intValue]==2)
        cell.statusLbl.textColor = [UIColor greenColor];
    else
        cell.statusLbl.textColor = [UIColor redColor];
    cell.statusLbl.text = statusProcess;
    
    [cell setTitleByLang];
    
    if([bookingDate compare:[NSDate date]] == NSOrderedAscending)
        cell.editBtn.hidden = YES;
    else
        cell.editBtn.hidden = NO;
          if ([bookingHistory.service_id isEqual:@"86"]) {
               cell.editBtn.hidden=YES;
            }
    
    return cell;
}

#pragma mark - TableView Delegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookingHistoryObj* bookingHistory = [gArrAllBookingHistory objectAtIndex:indexPath.row];
    NSDate* bookingDate = [_df dateFromString:bookingHistory.date];
    if([bookingDate compare:[NSDate date]] == NSOrderedDescending)
        return YES;
    else
        return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        BookingHistoryObj* bookingHis = [gArrAllBookingHistory objectAtIndex:indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ModelManager removeEvent:bookingHis.objId withSuccess:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        } failure:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [Util showMessage:SetupLanguage(KLang_CanNotRemoveBooking) withTitle:SetupLanguage(kLang_BMWCarService)];
        }];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Booking history cell delegate

-(void)onEditBookingHistory:(BookingHistoryCell *)bkHisCell
{
    NSIndexPath*indexpath = [_tblView indexPathForCell:bkHisCell];
    BookingHistoryObj* bookingHis = [gArrAllBookingHistory objectAtIndex:indexpath.row];
    BookingServiceViewController* bkVC = [[BookingServiceViewController alloc] initWithNibName:@"BookingServiceViewController" bundle:nil];
    bkVC.isEditBookingHistory = YES;
    bkVC.bookingHistoryToEdit = bookingHis;
    [self.navigationController pushViewController:bkVC animated:YES];
}

@end
