//
//  RegisterVehicleViewController.h
//  Millenium
//
//  Created by Mr Lemon on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ZBarReaderViewController.h"
#import "ZBarSDK.h"
//#import "SelectInsuranceViewController.h"
#import "UIKeyboardViewController.h"
#import "CustomizeTextField.h"
#import "VehicleObj.h"
@class BaseViewController;

@interface RegisterVehicleViewController : BaseViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,ZBarReaderDelegate,UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
    
    IBOutlet UIView *_descriptionVIN;

    IBOutlet UIView *viewAnpha;
}


@property (weak, nonatomic) IBOutlet CustomizeTextField *txtVINNumber;
@property (weak, nonatomic) IBOutlet CustomizeTextField *txtLicensePlateNumber;
@property (weak, nonatomic) IBOutlet CustomizeTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomizeTextField *txtPhoneNumber;

@property (weak, nonatomic) IBOutlet CustomizeTextField *txtVehicleModel;

@property (weak, nonatomic) IBOutlet CustomizeTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *inputYourVINLbl;
@property (weak, nonatomic) IBOutlet UILabel *inputYourVINLblTH;

@property (weak, nonatomic) IBOutlet UIButton *scanQRBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkVINLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicelModelLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicleModelLblTH;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *licensePlateLbl;
@property (weak, nonatomic) IBOutlet UILabel *licensePlateLblTH;

@property (weak, nonatomic) IBOutlet UILabel *telLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* tel;
@property (strong, nonatomic) NSString* name;


@property ( nonatomic) BOOL isEditVehicle;
@property (retain, nonatomic) VehicleObj *vehicleObj;
- (IBAction)onDescriptionVin:(id)sender;

- (IBAction)onScanQRCode:(id)sender;

- (IBAction)onCheckVIN:(id)sender;

- (IBAction)onRegisterVehicle:(id)sender;

- (IBAction)onBack:(id)sender;



@end
