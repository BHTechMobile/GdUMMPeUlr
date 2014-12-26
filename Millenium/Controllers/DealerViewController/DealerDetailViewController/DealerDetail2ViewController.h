//
//  DealerDetail2ViewController.h
//  Millenium
//
//  Created by Mr Lemon on 3/4/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//


#import "DealerObj.h"
#import "DealerAnnotation.h"
#import "NSString+TextSize.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@class BaseViewController;

@interface DealerDetail2ViewController : BaseViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate,MKMapViewDelegate,UIActionSheetDelegate>
{
    DealerAnnotation *selectedAnnotation;
}

@property (strong, nonatomic) IBOutlet UITextView *txtSendEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDealerNama;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblOpeningHours;

@property (weak, nonatomic) IBOutlet UIView *viewExtraInfo;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) NSMutableArray *arrAnnotation;

@property (retain, nonatomic) DealerObj *dealerSelected;

- (IBAction)onCallPhone:(id)sender;
- (IBAction)onBackPress:(id)sender;
- (IBAction)SendEmail:(id)sender;

@end
