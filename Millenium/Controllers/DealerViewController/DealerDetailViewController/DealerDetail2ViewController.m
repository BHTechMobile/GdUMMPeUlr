//
//  DealerDetail2ViewController.m
//  Millenium
//
//  Created by Mr Lemon on 3/4/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerDetail2ViewController.h"
#import "BaseViewController.h"
#import "Common.h"
#import <MessageUI/MessageUI.h>
#import "MailCompose.h"

@interface DealerDetail2ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@end

@implementation DealerDetail2ViewController

@synthesize lblAddress,lblAddressTitle,lblDealerNama,lblOpeningHours,lblPhone,viewExtraInfo,txtSendEmail;
@synthesize dealerSelected;
@synthesize mapView,arrAnnotation;



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
    [self  loadMapWithLatitude:gCurrentLatitude longitude:gCurrentLongitude];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
    
    [self setUpFont];
    [self changeLang];
    [self initView];
    [self setUpBorderBtn];
    [self setupToolbar];
    [txtSendEmail setDelegate:self];
}

-(void)setUpFont
{
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
   // _backBtn.titleLabel.font = [Util customRegularFontWithSize:15.0];
    UIFont* font = [Util customRegularFontWithSize:14.0];
    lblDealerNama.font = [Util customBoldFontWithSize:15.0];
    lblAddressTitle.font = font;
    lblAddress.font = font;
    _telBtn.titleLabel.font = _distanceLbl.font = font;
}
-(void)setUpBorderBtn
{
    txtSendEmail.layer.borderWidth = 1.0;
    txtSendEmail.layer.cornerRadius = 5.0f;
    txtSendEmail.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}
-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_DealerDetail) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    lblPhone.text= [NSString stringWithFormat:@"%@ : %@",SetupLanguage(kLang_Tel),dealerSelected.phone ];
    lblOpeningHours.text=[NSString stringWithFormat:@"%@: %@",SetupLanguage(kLang_OpeningHours),dealerSelected.openingHour];
    lblAddressTitle.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Address)];
}

-(void)initView{
    
    if(dealerSelected)
    {
        NSLog(@"data:%@",dealerSelected);
        lblAddress.text=dealerSelected.address;
        lblDealerNama.text=dealerSelected.name;
    
        [lblDealerNama setLineBreakMode:NSLineBreakByWordWrapping];
        [lblAddress setLineBreakMode:NSLineBreakByWordWrapping];
        
        [self setDistanceLabel];
        
        float heightName = [dealerSelected.name heightOfTextViewToFitWithFont:lblDealerNama.font andWidth:300];
        
        lblDealerNama.frame = CGRectMake(lblDealerNama.frame.origin.x, lblDealerNama.frame.origin.y, 300, heightName);
        
        float heightAddress = [dealerSelected.address heightOfTextViewToFitWithFont:lblAddress.font andWidth:lblAddress.frame.size.width]-16;
        heightAddress = MAX(heightAddress, 18);
        [lblAddress setFrame:CGRectMake(112, heightName+8, lblAddress.frame.size.width, heightAddress)];
        lblAddressTitle.frame = CGRectMake(lblAddressTitle.frame.origin.x, heightName+8, lblAddressTitle.frame.size.width, lblAddressTitle.frame.size.height);
        
        [viewExtraInfo setFrame:CGRectMake(0, heightAddress+heightName+10, 320, 300)];
        
        [self addPinsToMap:mapView data:gArrAllDealer];

    }
    
}

-(void)setDistanceLabel
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    [nf setMaximumFractionDigits:1];
    [nf setMinimumFractionDigits:1];
    [nf setLocale:usLocale];
    
    float distance = dealerSelected.distance;
    if(distance>=1000)
    {
        distance /= 1000;
        NSString *formattedNumberStr = [nf stringFromNumber:[NSNumber numberWithFloat:distance]];
        _distanceLbl.text = [NSString stringWithFormat:@"%@ km",formattedNumberStr];
    }else{
        NSString *formattedNumberStr = [nf stringFromNumber:[NSNumber numberWithFloat:distance]];
        _distanceLbl.text = [NSString stringWithFormat:@"%@ m",formattedNumberStr];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onBackPress:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //    return (YES);
    return (interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (IBAction)SendEmail:(id)sender {
    NSString *emailTitle=@"Message to dealer";
    NSArray *toRecipent=[NSArray arrayWithObject:dealerSelected.email];
    if ([MailCompose canSendMail]) {
        MailCompose *mail  = [[MailCompose alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:emailTitle];
        [mail setToRecipients:toRecipent];
        [mail setMessageBody:txtSendEmail.text isHTML:NO];
        [self presentViewController:mail animated:YES completion:NULL];
    } else {
        [Util showMessage:SetupLanguage(KLang_NoEmailAccount) withTitle:SetupLanguage(kLang_BMWCarService)];
    }
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [Util showMessage:@"Mail Cancelled" withTitle:@"Messenger"];
            break;
        case MFMailComposeResultSaved:
            [Util showMessage:@"Mail saved" withTitle:@"Messenger"];
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [Util showMessage:@"Mail sent" withTitle:@"Messenger"];
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            [Util showMessage:@"Mail sent failure" withTitle:@"Messenger"];
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)onCallPhone:(id)sender {
    
    if([Util canDevicePlaceAPhoneCall])
    {
        [Util showMessage:SetupLanguage(KLang_SureToCall) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:1000];
    }else
        [Util showMessage:SetupLanguage(KLang_CanNotMakeCall) withTitle:SetupLanguage(kLang_BMWCarService)];
    
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
                                                                   action:@selector(toolbarButtonTap1:)];
    doneBarItem.tag=3;
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
    txtSendEmail.inputAccessoryView = keyboardToolbar;
}

-(void)toolbarButtonTap1:(id)sender
{
    [txtSendEmail resignFirstResponder];
}


#pragma mark - TextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.frame=CGRectMake(10, 5, txtSendEmail.frame.size.width, txtSendEmail.frame.size.height+100);
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.frame=CGRectMake(11, 221, txtSendEmail.frame.size.width, txtSendEmail.frame.size.height -100);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000)
    {
        if(buttonIndex == 1)
        {
            NSString* phone = [NSString stringWithFormat:@"tel:%@", dealerSelected.phone];
            NSURL *phoneNumber = [[NSURL alloc] initWithString: phone];
            [[UIApplication sharedApplication] openURL: phoneNumber];
        }
    }
}

#pragma mark Map functions


-(void)loadMapWithLatitude:(double)lat longitude:(double)longi
{
    [mapView setDelegate:self];
    [self showUserLocation];
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    //if ([self.mapView isUserLocationVisible])
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(dealerSelected.latitude,dealerSelected.longitude), MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
}


- (void)addPinsToMap:(MKMapView *)mMapView data:(NSArray*)arrDeal{
    arrAnnotation=[[NSMutableArray alloc] init];
    //Clear current annotations on map
    //copy your annotations to an array
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithArray: mapView.annotations];
    //Remove the object userlocation
    [annotationsToRemove removeObject: mapView.userLocation];
    //Remove all annotations in the array from the mapView
    [mapView removeAnnotations: annotationsToRemove];
    
    
    DealerAnnotation *dealerPin;
    DealerObj *dealer;
    for (int y = 0; y < arrDeal.count; y++) {
        dealer=[arrDeal objectAtIndex:y];
        
        dealerPin=[[DealerAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(dealer.latitude, dealer.longitude)         placeName:dealer.name description:dealer.address];
        dealerPin.tag=y;
        [arrAnnotation addObject:dealerPin];
        [mapView addAnnotation:dealerPin];
        
    }
}


- (void)addPinsToMap:(MKMapView *)mMapView amount:(int)howMany {
    
    //First we need to calculate the corners of the map so we get the points
    CGPoint nePoint = CGPointMake(mMapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
    CGPoint swPoint = CGPointMake((mMapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
    //
    //    //Then transform those point into lat,lng values
    CLLocationCoordinate2D neCoord = [mMapView convertPoint:nePoint toCoordinateFromView:mapView];
    CLLocationCoordinate2D swCoord = [mMapView convertPoint:swPoint toCoordinateFromView:mapView];
    
    // Display random pin around user's location
    arrAnnotation=[[NSMutableArray alloc] init];
    DealerAnnotation *dealerPin;
    for (int y = 0; y < howMany; y++) {
        
        double latRange = [self randomFloatBetween:neCoord.latitude andBig:swCoord.latitude];
        double longRange = [self randomFloatBetween:neCoord.longitude andBig:swCoord.longitude];
        // Add new waypoint to map
        
        dealerPin=[[DealerAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(latRange, longRange)         placeName:@"Benz Pranam 3 Co. Ltd." description:@"487 Rama 3 Road, Bangkok"];
        dealerPin.tag=y;
        [arrAnnotation addObject:dealerPin];
        [mapView addAnnotation:dealerPin];
        
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[DealerAnnotation class]])
        {
        NSLog(@"clicked annotation %d",((DealerAnnotation*)annotation).tag);
        selectedAnnotation=[arrAnnotation objectAtIndex:((DealerAnnotation*)annotation).tag];
        
        [self showActionSheetMapPin];
        }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        {
        return nil;
        }
    else
        {// try to dequeue an existing pin view first
            static NSString *dealerAnnotationIdentifier = @"dealerAnnotationIdentifier";
            
            MKPinAnnotationView *pinView =
            (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:dealerAnnotationIdentifier];
            if (pinView == nil)
                {
                // if an existing pin view was not available, create one
                MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                      initWithAnnotation:annotation reuseIdentifier:dealerAnnotationIdentifier];
                customPinView.pinColor = MKPinAnnotationColorRed;
                //            customPinView.image=[UIImage imageNamed:@"ic_pin.png"];
                customPinView.animatesDrop = NO;
                customPinView.canShowCallout = YES;
                //            customPinView.calloutOffset = CGPointMake(2, 0);
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                customPinView.rightCalloutAccessoryView = rightButton;
                
                return customPinView;
                }
            else
                {
                pinView.annotation = annotation;
                }
            return pinView;
        }
}


/**
 * Random numbers
 *
 * @version $Revision: 0.1
 */
-(double)randomFloatBetween:(double)smallNumber andBig:(double)bigNumber {
    double diff = bigNumber - smallNumber;
    return (((double) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}//end

-(double)randomFloatAround:(double)number
{
    //    arc4random();
    
    NSInteger numberRandomBetWeen= arc4random()%8;
    
    double ran=(double) (((numberRandomBetWeen*10000.0f)) / 250000.0f) - 0.02;
    return   ran/10.0f+number;
}



-(void)showUserLocation{
    
    [mapView setShowsUserLocation:YES];
    [mapView.userLocation addObserver:self
                           forKeyPath:@"location"
                              options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                              context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    //if ([self.mapView isUserLocationVisible])
    {
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(dealerSelected.latitude,dealerSelected.longitude), MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
    
    
    }
}

#pragma mark ActionSheet delegate and functions

-(void)showActionSheetMapPin{
    
    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]];
    UIActionSheet *sheet;
    if (canHandle) {
        // Google maps installed
        sheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SetupLanguage(kLang_Cancel) destructiveButtonTitle:nil otherButtonTitles:SetupLanguage(kLang_DirectFromCur),SetupLanguage(kLang_OpenInAppleMap),SetupLanguage(kLang_OpenInGoogleMap), nil];
    } else {
        // Use Apple maps?
        sheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:SetupLanguage(kLang_Cancel) destructiveButtonTitle:nil otherButtonTitles:SetupLanguage(kLang_DirectFromCur),SetupLanguage(kLang_OpenInAppleMap), nil];
    }
    
    [sheet showFromTabBar:self.tabBarController.tabBar];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0)
        {
        [self showDirection:selectedAnnotation];
        }
    else if(buttonIndex==1)
        {
        [self showPointOnMap:selectedAnnotation];
        }else{
            [self showPointInGoogleMaps:selectedAnnotation];
        }
    
}

-(void)showDirection:(DealerAnnotation*)resObj
{
    NSString* versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending)
        nativeMapScheme = @"maps.google.com";
    double userLatitude;
    double userLongitude;
    if (gIsEnableLocation)
        {
        userLatitude = gCurrentLatitude;
        userLongitude = gCurrentLongitude;
        }
    else
        {
        userLatitude = 48.8564;
        userLongitude = 2.3522;
        }
    NSString* url = [NSString stringWithFormat: @"http://%@/maps?saddr=%f,%f&daddr=%f,%f", nativeMapScheme, userLatitude, userLongitude, resObj.coordinate.latitude, resObj.coordinate.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)showPointOnMap:(DealerAnnotation*)resObj
{
    NSString* versionNum = [[UIDevice currentDevice] systemVersion];
    NSString *nativeMapScheme = @"maps.apple.com";
    if ([versionNum compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending)
        nativeMapScheme = @"maps.google.com";
    double userLatitude;
    double userLongitude;
    if (gIsEnableLocation)
        {
        userLatitude = gCurrentLatitude;
        userLongitude = gCurrentLongitude;
        }
    else
        {
        userLatitude = 48.8564;
        userLongitude = 2.3522;
        }
    NSString* url = [NSString stringWithFormat: @"http://%@/maps?q=%f,%f", nativeMapScheme, resObj.coordinate.latitude, resObj.coordinate.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)showPointInGoogleMaps:(DealerAnnotation*)dealer
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",dealer.coordinate.latitude,dealer.coordinate.longitude]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@"Google Maps app is not installed");
        //left as an exercise for the reader: open the Google Maps mobile website instead!
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
