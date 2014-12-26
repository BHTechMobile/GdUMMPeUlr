//
//  RegisterVehicleViewController.m
//  Millenium
//
//  Created by Mr Lemon on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "RegisterVehicleViewController.h"
#import "Common.h"
#import "Util.h"
#import "Validator.h"
#import "BaseViewController.h"

@interface RegisterVehicleViewController ()
{
    
    bool hasImage;
    NSData *imageData;
    bool isScanningQR;
}

@end

@implementation RegisterVehicleViewController

@synthesize txtLicensePlateNumber,txtVehicleModel,txtVINNumber,scrollViewMain,txtName,txtPhoneNumber,txtEmail;

@synthesize isEditVehicle,vehicleObj;


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
    
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Register Vehicle"];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self setUpFont];
    scrollViewMain.contentSize=CGSizeMake(320, 400);
    
    [self registerKeyboardNotification];
    
    [self  fillEditVehicle];
    [self changeLang];
}

-(void)setUpFont
{
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    UIFont* boldFont = [Util customBoldFontWithSize:15.0];
    UIFont* regularFont = [Util customRegularFontWithSize:13.0];
    
    _inputYourVINLbl.font = _vehicelModelLbl.font = _licensePlateLbl.font = boldFont;
    _inputYourVINLblTH.font = _vehicleModelLblTH.font = _licensePlateLblTH.font = regularFont;
}

-(void)changeLang
{
    
    _titleLbl.text = [SetupLanguage(kLang_AddVehicle) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];
    
    [_scanQRBtn setTitle:SetupLanguage(kLang_ScanQRCode) forState:UIControlStateNormal];
    [_checkVINLbl setTitle:SetupLanguage(kLang_CheckVIN) forState:UIControlStateNormal];
    
    _nameLbl.text = SetupLanguage(kLang_Name);
    _telLbl.text = SetupLanguage(kLang_Tel);
    _emailLbl.text = SetupLanguage(kLang_Email);
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    [_registerBtn setTitle:SetupLanguage(kLang_RegisterVehicle) forState:UIControlStateNormal];
}

-(void)fillEditVehicle
{
    if(isEditVehicle&&vehicleObj)
    {
        txtVehicleModel.text=vehicleObj.vehicleModel;
        txtVINNumber.text=vehicleObj.VINNumber;
        txtLicensePlateNumber.text=vehicleObj.plateNumber;
    }
}

-(void)saveUserInfo{
    
//    [Util setValue:txtEmail.text forKey:KEY_EMAIL];
//    [Util setValue:txtPhoneNumber.text forKey:KEY_PHONE];
//    [Util setValue:txtName.text forKey:KEY_NAME];
}


-(void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
	keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
	[keyBoardController addToolbarToKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkVIN:(NSString*)vinNumber
{

    if(![vinNumber isEqualToString:@""])
    {
        [ModelManager getVehicle:vinNumber success:^(NSDictionary *jsonDict) {
            if (!jsonDict) {
                [Util showMessage:SetupLanguage(KLang_VINNumberInvalid) withTitle:SetupLanguage(kLang_BMWCarService)];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else{
                NSDictionary *Dict=[jsonDict objectForKey:@"result"];
                if ([Dict count]==0) {
                    [Util showMessage:SetupLanguage(KLang_VINNumberInvalid)withTitle:SetupLanguage(kLang_BMWCarService)];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                else{
                        NSString *modelVeh=[Dict objectForKey:@"model_description"];
                    
                        if ([modelVeh isEqual:nil]) {
                
                                [Util showMessage:SetupLanguage(KLang_VINNumberInvalid) withTitle:SetupLanguage(kLang_BMWCarService)];
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                            }
                        else{
                           
                                txtVehicleModel.text=modelVeh;
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                            }
                    }
            }
        } failure:^(NSError *err) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }];
    }
    else{
        [Util showMessage:SetupLanguage(kLang_PleaseInputVIN) withTitle:SetupLanguage(KLang_Error)];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark FORM ACTIONS

- (IBAction)onChangeImage:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take New Photo", @"Choose Existing Photos", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
-(void)handleSingleTap{

    [viewAnpha setHidden:YES];
    [_descriptionVIN setHidden:YES];

}
- (IBAction)onDescriptionVin:(id)sender {
    [self.view endEditing:YES];
    [viewAnpha setHidden:NO];
    [viewAnpha setBackgroundColor:[UIColor blackColor]];
    [_descriptionVIN setHidden:NO];
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"descriptionVIN.jpg"]];
    [img setContentMode:UIViewContentModeScaleAspectFit];
    img.frame=CGRectMake(_descriptionVIN.frame.origin.x, _descriptionVIN.frame.origin.y, _descriptionVIN.frame.size.width, _descriptionVIN.frame.size.height);
    [_descriptionVIN addSubview:img];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap)];
    [viewAnpha addGestureRecognizer:singleFingerTap];
    

    
}

- (IBAction)onScanQRCode:(id)sender {
    
    [self  openScanner];
}

- (IBAction)onCheckVIN:(id)sender {
    
    [self  hideKeyboard];
    NSString
    *vinNumber=txtVINNumber.text;
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self checkVIN:vinNumber];
    
}

- (IBAction)onRegisterVehicle:(id)sender {
    
    if([self checkRequiredField])
    {
        [self  hideKeyboard];
        //if([self checkVIN:txtVINNumber.text] == NO) return;
        START_LOADING;
        NSString *memberId=[Util valueForKey:KEY_MEMBER_ID];
        if(memberId&&![memberId isEqualToString:@""])
        {
            
            //Add new car for an exist member
            
            [ModelManager addCar:memberId vinNumber:txtVINNumber.text licensePlate:txtLicensePlateNumber.text andVehicleModel:txtVehicleModel.text  withSuccess:^(NSDictionary *jsonDic) {
                
                
                if(![jsonDic valueForKey:@"ok"])
                {
                    STOP_LOADING;
                    [Util showMessage:[jsonDic valueForKey:@"serror"] withTitle:SetupLanguage(kLang_BMWCarService)];
                }
                else
                {
                    @try {
                        
                        NSDictionary *dic=[jsonDic objectForKey:@"result"];
                        if(dic)
                        {
                            //[self saveUserInfo];
                            [Util setValue:[Validator getSafeString:[dic valueForKey:@"memberId"]] forKey:KEY_MEMBER_ID];
                            
                            [self refreshListCar];
                        }
                        
                    }
                    @catch (NSException *exception) {
                        STOP_LOADING;
                        DebugLog(@"Error : %@",exception.reason);
                    }
                    @finally {
                        //[self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
                
            } failure:^(NSError *error) {
                STOP_LOADING;
            }];
        }
        else{
            
            //Register new user with car
            NSString* pushId = [Validator getSafeString:[Util valueForKey:MyToken]];
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>device token:%@",pushId);
            if([pushId isEqualToString:@""]) pushId = @"a";
            [ModelManager registerWithName:_name email:_email phone:_tel vinNumber:txtVINNumber.text licensePlate:txtLicensePlateNumber.text andVehicleModel:txtVehicleModel.text pushId:pushId osType:@"ios" withSuccess:^(NSDictionary *jsonDic) {
                
                STOP_LOADING;
                if(![jsonDic valueForKey:@"ok"])
                {
                    
                    [Util showMessage:[jsonDic valueForKey:@"serror"] withTitle:SetupLanguage(kLang_BMWCarService)];
                    
                }
                else
                {
                    @try {
                        
                        NSDictionary *dic=[jsonDic objectForKey:@"result"];
                        if(dic)
                        {
                            [self saveUserInfo];
                            [Util setValue:[Validator getSafeString:[dic valueForKey:@"memberId"]] forKey:KEY_MEMBER_ID];
                            if(dic[@"hasCars"])
                            {
                                NSArray* arr = dic[@"hasCars"];
                                if([arr isKindOfClass:[NSArray class]])
                                {
                                    gArrMyCar=[ModelManager parserListVehicle:arr];
                                    if(gArrMyCar)
                                        [[ModelManager shareInstance] saveVehicleToDB:gArrMyCar];

                                    if(gArrMyCar.count == 1)
                                    {
                                        VehicleObj* vehicle = [gArrMyCar objectAtIndex:0];
                                        [Util setValue:vehicle.vehicleId forKey:KEY_FAVORITE_VEHICLE_ID];
                                        [Util setValue:vehicle.plateNumber forKey:KEY_FAVORITE_VEHICLE];
                                        //[self.navigationController popViewControllerAnimated:YES];
                                    }
                                }
                            }
                        }else{
                            
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
                
            } failure:^(NSError *error) {
                STOP_LOADING;
                
            }];
        }
    }
    
}


-(void)refreshListCar{
    
    NSString* pushId = [Validator getSafeString:[Util valueForKey:MyToken]];
    
    [ModelManager login:[Util valueForKey:KEY_EMAIL] pushId:pushId osType:@"ios" withSuccess:^(NSMutableArray *arr) {
        STOP_LOADING;
        gArrMyCar=arr;
        if(gArrMyCar.count >= 1)
        {
            for (int i=0; i<gArrMyCar.count; i++) {
                VehicleObj* vehicle = [gArrMyCar objectAtIndex:i];
                if ([vehicle.statusCar isEqual:@"1"]) {
                    [Util setValue:vehicle.vehicleId forKey:KEY_FAVORITE_VEHICLE_ID];
                    [Util setValue:vehicle.plateNumber forKey:KEY_FAVORITE_VEHICLE];
                }
               
            }
           
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        STOP_LOADING;
        [Util showMessage:SetupLanguage(KLang_AddVehicleError) withTitle:SetupLanguage(kLang_BMWCarService)];
        //[self.navigationController popViewControllerAnimated:YES];
    }];
}

-(bool)checkRequiredField{
    
    if([txtLicensePlateNumber.text isEqualToString:@""]||[txtVINNumber.text isEqualToString:@""] || [txtVehicleModel.text isEqualToString:@""] || txtVINNumber.text == nil)
    {
        [Util showMessage:SetupLanguage(KLang_InputAllField) withTitle:SetupLanguage(kLang_BMWCarService)];
        return false;
    }
    else
        return true;
}

- (IBAction)onBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard
{
    
    [txtVehicleModel resignFirstResponder];
    [txtPhoneNumber resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtVINNumber resignFirstResponder];
    [txtName resignFirstResponder];
    [txtLicensePlateNumber resignFirstResponder];
    
}
#pragma mark ActionSheetDelegate method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0: // Take photo
        {
            if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES)){
                
                UIImagePickerController   *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
                isScanningQR=false;
            }
            break;
        }
        case 1: // Choose exist photo
        {
            
            if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary] == YES)){
                UIImagePickerController   *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
                isScanningQR=false;
            }
            
            break;
        }
        others:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //get video
    
    //    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if(!isScanningQR)
    {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        imageData = UIImageJPEGRepresentation([self scaleAndRotateImage:image], 0.0) ;
        
        hasImage=TRUE;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        // ADD: get the decode results
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            // EXAMPLE: just grab the first barcode
            break;
        
        // EXAMPLE: do something useful with the barcode data
        DebugLog(@"Scan result : %@",symbol.data);
        
        txtVINNumber.text=symbol.data;
        
        //    resultText.text = symbol.data;
        
        // EXAMPLE: do something useful with the barcode image
        //    resultImage.image =
        //    [info objectForKey: UIImagePickerControllerOriginalImage];
        
        // ADD: dismiss the controller (NB dismiss from the *reader*!)
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    
    
}

-(UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 200; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
#pragma mark EditText Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark KEYBOARD MANAGER

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow: (NSNotification *)notification

{
    //    scrollViewMain.frame=CGRectMake(0,scrollViewMain.frame.origin.y, 320, scrollViewMain.frame.size.height-240);
    
    //    [[Util sharedUtil] slideUpView:self.view offset:180];
}

- (void)keyboardWillHide:(NSNotification *)notification

{
    
    //    [[Util sharedUtil] slideDownView:self.view offset:180];
    //    scrollViewMain.frame=CGRectMake(0,scrollViewMain.frame.origin.y, 320, scrollViewMain.frame.size.height+240);
    
}

#pragma  mark SCANNER FUNCTIONS

-(void)openScanner{
    
    isScanningQR=true;
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
    
}



@end
