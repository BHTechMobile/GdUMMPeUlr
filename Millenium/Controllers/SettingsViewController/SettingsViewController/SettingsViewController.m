//
//  SettingsViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SettingsViewController.h"
#import "VehicleObj.h"
#import "DealerObj.h"
#import "Common.h"
#import "Toast+UIView.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "BaseViewController.h"
#import "RegisterVehicleViewController.h"

@interface SettingsViewController ()<UIAlertViewDelegate>
{
    VehicleObj *selectedVehicle;
    DealerObj *selectedDealder;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation SettingsViewController

@synthesize scrollViewMain,txtEmail,lblDefaultVehicle,txtFirstName,txtPhone,lblFavoriteBranch;




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
    [self setUpFont];
    //self.title = @"Settings";
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    [self changeLang];
    scrollViewMain.contentSize=CGSizeMake(320, 445);
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        CGRect frame= _languageSegment.frame;
        [_languageSegment setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35.0)];
//        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14], UITextAttributeFont, nil];
//        [_languageSegment setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    }
    
    if([[Util valueForKey:DefaultLang] isEqualToString:@"en"])
    {
        [_languageSegment setSelectedSegmentIndex:0];
    
    }else [_languageSegment setSelectedSegmentIndex:1];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillDefaultVehicle) name:kNotifi_UpdateDefaultCar object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpFont
{
    UIFont* boldFont = [Util customBoldFontWithSize:15.0];
    UIFont* regularFont = [Util customRegularFontWithSize:13.0];
    
    _nameLbl.font = _emailLbl.font = _telLbl.font = _defaultVehicle.font = _favoriteBranchLbl.font = boldFont;
    _nameLblTH.font = _mobileLblTH.font = _defaultVehicleLblTH.font = _favoriteBranchLblTH.font = regularFont;
    
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_EditProfile) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];

    [_saveBtn setTitle:SetupLanguage(kLang_Save) forState:UIControlStateNormal];
    [_addVehicle setTitle:SetupLanguage(kLang_AddVehicle) forState:UIControlStateNormal];
    [_fbBtn setTitle:SetupLanguage(kLang_ConnectToFacebook) forState:UIControlStateNormal];
    [_twBtn setTitle:SetupLanguage(kLang_ConnectToTwitter) forState:UIControlStateNormal];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    _languageLbl.text = SetupLanguage(kLang_Langugae);
    if ( ![Util valueForKey:KEY_FAVORITE_VEHICLE_ID]) {
         lblDefaultVehicle.text=SetupLanguage(kLang_SelectVehicle);
    }
    if (![Util valueForKey:KEY_DEFAULT_BRANCH]) {
        lblFavoriteBranch.text=SetupLanguage(kLang_SelectBranch);
    }
   
    
}

-(void)viewWillAppear:(BOOL)animated {
    if ([lblDefaultVehicle.text isEqual:nil]) {
        lblDefaultVehicle.text=SetupLanguage(kLang_SelectVehicle);
    }
	[super viewWillAppear:animated];
	keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
	[keyBoardController addToolbarToKeyboard];
    [self fillDefaultVehicle];
    [self fillUserInfo];
}
-(void)fillUserInfo{
    
    txtFirstName.text=[Util valueForKey:KEY_NAME];
    txtPhone.text=[Util valueForKey:KEY_PHONE];
    txtEmail.text=[Util valueForKey:KEY_EMAIL];
    
}
-(void)fillDefaultVehicle
{
  
    
    NSString* car_id = [Util valueForKey:KEY_FAVORITE_VEHICLE_ID];
    if(car_id && gArrMyCar)
    {
        VehicleObj* obj = [ModelManager getVehicleById:car_id];
        NSString* vehicleStr = [NSString stringWithFormat:@"%@ %@",obj.VINNumber,obj.vehicleModel];
        lblDefaultVehicle.text = [self stringByRemoveMillenium:vehicleStr];
        
    }
    else{
    
        lblDefaultVehicle.text=SetupLanguage(kLang_SelectVehicle);
    }
    if([Util valueForKey:KEY_DEFAULT_BRANCH])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [ModelManager getAllDealer:^(NSArray *arrDelear) {
            
            gArrAllDealer=arrDelear;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self checkDealerName];
        } failure:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self checkDealerName];
        }];
        
        
    }
    
}

-(bool)checkRequiredField{
    
    if([txtFirstName.text isEqualToString:@""]||[txtEmail.text isEqualToString:@""]||[txtPhone.text isEqualToString:@""])
    {
        [Util showMessage:SetupLanguage(KLang_InputAllField) withTitle:SetupLanguage(kLang_BMWCarService)];
        return false;
    }
//    else
//        if(![Util isValidEmail:txtEmail.text])
//    {
//        [Util showMessage:@"Invalid email address" withTitle:@"Error"];
//        return false;
//        
//    }
    else
        return true;
}

#pragma mark FORM ACTIONS

- (IBAction)changeLanguage:(id)sender
{
    int selectedIndex = _languageSegment.selectedSegmentIndex;
    if(selectedIndex == 0)
    {
        [Util setValue:@"en" forKey:DefaultLang];
        LocalizationSetLanguage(@"en");
    }
    else
    {
        [Util setValue:@"th" forKey:DefaultLang];
        LocalizationSetLanguage(@"th");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_ChangeLange object:Nil];
}


- (IBAction)onRegisterVehicle:(id)sender {
    [self.view endEditing:YES];
    if([self checkRequiredField])
    {
        if([self saveProfile:nil])
        {
            RegisterVehicleViewController *vc=[[RegisterVehicleViewController alloc] initWithNibName:@"RegisterVehicleViewController" bundle:nil];
            
            vc.name = [NSString stringWithString:txtFirstName.text];
            vc.email = [NSString stringWithString:txtEmail.text];
            vc.tel = [NSString stringWithString:txtPhone.text];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

- (IBAction)onConnectFacebook:(id)sender {
    
    SLComposeViewController *fbSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [self presentViewController:fbSheet animated:YES completion:nil];
}

- (IBAction)onConnectTwitter:(id)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)onChooseDefaultVehicle:(id)sender {
    [self.view endEditing:YES];
        [self saveProfile:sender];
  //  if (!saved) {
        [self refreshListCar];
   // }
    if(gArrMyCar&&[gArrMyCar count]>0)
    {
        
        VehicleListViewController* vehicleVC = [[VehicleListViewController alloc] initWithNibName:@"VehicleListViewController" bundle:nil];
        vehicleVC.delegate = self;
        vehicleVC.canEditVehicle = YES;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vehicleVC animated:YES];
    }
    else
    {
//        [Util showMessage:SetupLanguage(kLang_YouHaveNoVehicle) withTitle:SetupLanguage(kLang_BMWCarService)];
        RegisterVehicleViewController *vc=[[RegisterVehicleViewController alloc]initWithNibName:@"RegisterVehicleViewController" bundle:nil];
        vc.name = [NSString stringWithString:txtFirstName.text];
        vc.email = [NSString stringWithString:txtEmail.text];
        vc.tel = [NSString stringWithString:txtPhone.text];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onChooseDefaultBranch:(id)sender {
    [self.view endEditing:YES];
    [self saveProfile:sender];
    if (!saved) {
        [self refreshListCar];
    }
    DealerListViewController* dealerVC = [[DealerListViewController alloc] initWithNibName:@"DealerListViewController" bundle:nil];
    dealerVC.delegate = self;
    dealerVC.isChoosingFavouriteDealer = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:dealerVC animated:YES];
}

- (IBAction)onBackClick:(id)sender {
    [self saveProfile:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSaveProfile:(id)sender {
    
    [self saveProfile:sender];
    if (!saved) {
        [self refreshListCar];
    }
    
}

-(BOOL)saveProfile:(id)sender
{
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    NSString* name = [Util valueForKey:KEY_NAME];
    NSString* email = [Util valueForKey:KEY_EMAIL];
    NSString* phone = [Util valueForKey:KEY_PHONE];
    [self refreshListCar];
    if([name isEqualToString:txtFirstName.text ]&& [email isEqualToString:txtEmail.text] && [phone isEqualToString:txtPhone.text])
    {
        if(sender)
            [self.view makeToast:SetupLanguage(KLang_Savedlocalsuccessfully)];
        return YES;
    }
    
    if(memberId == nil)
    {
        [Util setValue:txtFirstName.text forKey:KEY_NAME];
        [Util setValue:txtEmail.text forKey:KEY_EMAIL];
        [Util setValue:txtPhone.text forKey:KEY_PHONE];
        if(sender)
            [self.view makeToast:SetupLanguage(KLang_Savedlocalsuccessfully)];
        return YES;
    }
    
    if(sender)// on save button
    {
        if([email isEqualToString:txtEmail.text])
        {
            START_LOADING;
            [ModelManager updateProfileWithMemberId:memberId name:txtFirstName.text tel:txtPhone.text address:@"" withSuccess:^{
                STOP_LOADING;
                [Util setValue:txtFirstName.text forKey:KEY_NAME];
                [Util setValue:txtEmail.text forKey:KEY_EMAIL];
                [Util setValue:txtPhone.text forKey:KEY_PHONE];
                [self.view makeToast:SetupLanguage(KLang_ServerSuccessfully)];
            } failure:^(NSError *err) {
                STOP_LOADING;
                [Util showMessage:SetupLanguage(KLang_CanNotUpdateProfile) withTitle:SetupLanguage(kLang_BMWCarService)];
            }];
            return YES;
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_UseNewEmail)delegate:self cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles: SetupLanguage(kLang_YES),nil];
            alert.tag = 1001;
            [alert show];
            return NO;
        }
    }else{// on add car
        if([email isEqualToString:txtEmail.text])
        {
            START_LOADING;
            [ModelManager updateProfileWithMemberId:memberId name:txtFirstName.text tel:txtPhone.text address:@"" withSuccess:^{
                STOP_LOADING;
                [Util setValue:txtFirstName.text forKey:KEY_NAME];
                [Util setValue:txtEmail.text forKey:KEY_EMAIL];
                [Util setValue:txtPhone.text forKey:KEY_PHONE];
                [self.view makeToast:SetupLanguage(KLang_ServerSuccessfully)];
            } failure:^(NSError *err) {
                STOP_LOADING;
                [Util showMessage:SetupLanguage(KLang_CanNotUpdateProfile) withTitle:SetupLanguage(kLang_BMWCarService)];
            }];
            return NO;
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_UseNewEmail) delegate:self cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles: SetupLanguage(kLang_YES), nil];
            alert.tag = 1001;
            [alert show];
            return NO;
        }
    }
    
}
-(void)checkDealerName{
    for(DealerObj* dealer in gArrAllDealer){
    
        NSLog(@"dealer name:%@",dealer.name);
        NSString *dealerName=dealer.name;
        NSString* branchName =  [Util valueForKey:KEY_DEFAULT_BRANCH];
        if ([dealerName isEqualToString:branchName]) {
            lblFavoriteBranch.text= branchName;
            break;
        }
        else{
        
            lblFavoriteBranch.text=SetupLanguage(kLang_SelectBranch);
        }
    }

}
#pragma mark - VehicleListVCDelegate
-(void)choosedVehicle:(VehicleObj *)vehicle
{
    selectedVehicle = vehicle;
    lblDefaultVehicle.text = [NSString stringWithFormat:@"%@ %@",vehicle.VINNumber,vehicle.vehicleModel];
}

#pragma mark - DealerListVCDelegate

-(void)choosedDealer:(DealerObj *)dealer
{
    selectedDealder = dealer;
    
    NSString* dealerName = dealer.name;
    
    [Util setValue:dealer.name forKey:KEY_DEFAULT_BRANCH];
    [Util setValue:dealer.objId forKey:KEY_DEFAULT_BRANCH_ID];
    
    lblFavoriteBranch.text = dealerName;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        if(buttonIndex==1)
        {
            [ModelManager deleteAllData];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [Util setValue:txtFirstName.text forKey:KEY_NAME];
            [Util setValue:txtEmail.text forKey:KEY_EMAIL];
            [Util setValue:txtPhone.text forKey:KEY_PHONE];
            lblDefaultVehicle.text = SetupLanguage(kLang_SelectVehicle);
            lblFavoriteBranch.text = SetupLanguage(kLang_SelectBranch);;
            [self fillDefaultVehicle];
            [self fillUserInfo];
            gArrMyCar=nil;
            [self refreshListCar];
            saved=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotifi_reloadListVer object:nil];
            

            
        }else{
            txtEmail.text = [Util valueForKey:KEY_EMAIL];
        }
    }
}
-(void)refreshListCar{
    
    NSString* pushId = [Validator getSafeString:[Util valueForKey:MyToken]];
    
    [ModelManager login:[Util valueForKey:KEY_EMAIL] pushId:pushId osType:@"ios" withSuccess:^(NSMutableArray *arr) {
        STOP_LOADING;
        gArrMyCar=arr;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [ModelManager getBookingHistory:[Util valueForKey:KEY_EMAIL] success:^(NSArray *arr) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
        gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];
    } failure:^(NSError *err) {
    }];
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

@end
