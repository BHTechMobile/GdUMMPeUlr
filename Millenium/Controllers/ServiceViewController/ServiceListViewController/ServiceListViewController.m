//
//  ServiceListViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceListCell.h"
#import "UIImageView+WebCache.h"
#import "BookingServiceViewController.h"
#import "EditProfileCell.h"
#import "SettingsViewController.h"
#import "BookingHistoryViewController.h"
#import "NSString+TextSize.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "BaseViewController.h"
#import "SubServiceViewController.h"

@interface ServiceListViewController ()<UITableViewDelegate,UITableViewDataSource,EditProfileCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation ServiceListViewController

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
    self.navigationController.navigationBarHidden = YES;
    //self.title = @"Service";
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    [self changeLang];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [_tblView addPullToRefreshWithActionHandler:^{
        [ModelManager getService:^(NSArray *arr) {
            gArrAllService = arr;
            _arrRootService = [ModelManager getRootService:arr];
            [_tblView.pullToRefreshView stopAnimating];
            [_tblView reloadData];
        } failure:^(NSError *err) {
            [_tblView.pullToRefreshView stopAnimating];
        }];
    }];
    if(gArrAllService == nil)
        [_tblView triggerPullToRefresh];
    else{
        _arrRootService = [ModelManager getRootService:gArrAllService];
        [_tblView reloadData];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_Service) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    [_titleLbl sizeToFit];
    self.tabBarItem.title = SetupLanguage(kLang_Services);
    [_tblView reloadData];
}

#pragma mark - TableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 120;
    else
    {
        ServiceObj* service = [_arrRootService objectAtIndex:indexPath.row-1];
        float height = [service.description heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:13.] andWidth:300];
        //if(height > 50) height = 50;
        return height+150;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    if(memberId == nil)
    {
        [Util showMessage:SetupLanguage(kLang_YouHavetoRegister) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:2000];
        return;
    }
    if(indexPath.row == 0) return;
    ServiceObj* service = [_arrRootService objectAtIndex:indexPath.row-1];
    NSArray* arr = [ModelManager getSubService:gArrAllService andId:service.categoryId];
    if(arr.count>0)
    {
        SubServiceViewController* subServiceVC = [[SubServiceViewController alloc] initWithNibName:@"SubServiceViewController" bundle:nil];
        subServiceVC.subService = arr;
        [self.navigationController pushViewController:subServiceVC animated:YES];
        
    }else{
        BookingServiceViewController* bookingServiceVC = [[BookingServiceViewController alloc] initWithNibName:@"BookingServiceViewController" bundle:nil];
        
        bookingServiceVC.selectedService = service;
        [self.navigationController pushViewController:bookingServiceVC animated:YES];
    }
    
    
}

#pragma mark - TableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrRootService.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* serviceCellIden = @"ServiceListCell";
    static NSString* editProfileCell = @"EditProfileCell";
    if(indexPath.row >0)
    {
        ServiceListCell* cell = [tableView dequeueReusableCellWithIdentifier:serviceCellIden];
        cell.lblbookOnlien.text=SetupLanguage(KLang_BookOnline);
        [cell.lbl_callService setTitle:SetupLanguage(KLang_CallService) forState:UIControlStateNormal];
                if(cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:serviceCellIden owner:nil options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
        ServiceObj* service = [_arrRootService objectAtIndex:indexPath.row-1];
        if(![service.lang isEqualToString:[Util valueForKey:DefaultLang]] && service.translation != nil)
        {
            cell.desLbl.text = service.translation[@"description"];
            cell.serviceNameLbl.text = service.translation[@"cateName"];
            cell.telephoneLbl.text = service.translation[@"telephone"];
        }else
        {
            cell.desLbl.text = service.description;
            cell.serviceNameLbl.text = service.name;
            cell.telephoneLbl.text = service.telephone;
        }
        
        [cell.bookBtn setTitle:SetupLanguage(kLang_BookService) forState:UIControlStateNormal];
        return cell;
    }else
    {
        EditProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:editProfileCell];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:editProfileCell owner:nil options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
        [cell.editProfileBtn setTitle:SetupLanguage(kLang_EditProfile) forState:UIControlStateNormal];
        [cell.lblEditProfile setText:SetupLanguage(kLang_EditProfile )];
                                                  
        [cell.bookingHistoryBtn setTitle:SetupLanguage(kLang_BookingHistory) forState:UIControlStateNormal];
        [cell.lblBookingHistiry setText:SetupLanguage(kLang_BookingHistory)];
        
        return cell;
    }
}

#pragma mark - EditProfileCell Delegate

-(void)goToBookingHistory
{
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    if(memberId == nil)
    {
        [Util showMessage:SetupLanguage(kLang_YouHavetoRegister) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:2000];
        return;
    }
    
    BookingHistoryViewController* historyBookingVC = [[BookingHistoryViewController alloc] initWithNibName:@"BookingHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:historyBookingVC animated:YES];
    
}

-(void)goToEditProfile
{
    SettingsViewController* setttingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:setttingsVC animated:YES];
}

#pragma mark - Service Cell Delegate

-(void)serviceListCell:(ServiceListCell*)serviceCell bookOnlinePress:(UIButton *)button{
    NSLog(@"cell at index: %d", [_tblView indexPathForCell:serviceCell].row);
    
}
-(void)serviceListCell:(ServiceListCell *)service callServicePress:(NSString *)telephone{
    NSLog(@"cell at index: %d", [_tblView indexPathForCell:service].row);
    if([Util canDevicePlaceAPhoneCall])
    {
        [Util showMessage:SetupLanguage(KLang_SureToCall) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:1000];
        _telephoneStr = telephone;
    }else
        [Util showMessage:SetupLanguage(KLang_CanNotMakeCall) withTitle:SetupLanguage(kLang_BMWCarService)];
    
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2000)
    {
        if(buttonIndex==1)
        {
            [self goToEditProfile];
        }
    }else
    
    if(alertView.tag == 1000)
    {
        if(buttonIndex == 1)
        {
            NSString* phone = [NSString stringWithFormat:@"tel:%@",_telephoneStr];
            NSURL *phoneNumber = [[NSURL alloc] initWithString: phone];
            [[UIApplication sharedApplication] openURL: phoneNumber];
        }
    }
}



@end
