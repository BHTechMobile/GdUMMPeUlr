//
//  SettingsViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterVehicleViewController.h"
#import "VehicleListViewController.h"
#import "DealerListViewController.h"
#import "UIKeyboardViewController.h"
#import "CustomizeTextField.h"

@class BaseViewController;

@interface SettingsViewController : BaseViewController<UITextFieldDelegate,DealerListViewControllerDelegate,VehicleListVCDelegate,UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
    BOOL saved;
}

@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *twBtn;

@property (weak, nonatomic) IBOutlet CustomizeTextField *txtFirstName;
@property (weak, nonatomic) IBOutlet CustomizeTextField *txtPhone;
@property (weak, nonatomic) IBOutlet CustomizeTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDefaultVehicle;

@property (weak, nonatomic) IBOutlet UILabel *lblFavoriteBranch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *telLbl;
@property (weak, nonatomic) IBOutlet UILabel *defaultVehicle;
@property (weak, nonatomic) IBOutlet UILabel *favoriteBranchLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addVehicle;
@property (weak, nonatomic) IBOutlet UILabel *languageLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegment;

@property (weak, nonatomic) IBOutlet UILabel *nameLblTH;
@property (weak, nonatomic) IBOutlet UILabel *mobileLblTH;
@property (weak, nonatomic) IBOutlet UILabel *defaultVehicleLblTH;

@property (weak, nonatomic) IBOutlet UILabel *favoriteBranchLblTH;


- (IBAction)onRegisterVehicle:(id)sender;
- (IBAction)onConnectFacebook:(id)sender;
- (IBAction)onConnectTwitter:(id)sender;
- (IBAction)onChooseDefaultVehicle:(id)sender;
- (IBAction)onChooseDefaultBranch:(id)sender;
- (IBAction)onBackClick:(id)sender;
- (IBAction)onSaveProfile:(id)sender;

@end
