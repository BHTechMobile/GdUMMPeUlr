//
//  DealerListViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerListViewController.h"
#import "Toast+UIView.h"
#import "BaseViewController.h"
#import "Common.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f


@interface DealerListViewController ()<DealerCellDelegate,UIAlertViewDelegate>

{
    DealerAnnotation *selectedAnnotation;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) NSArray* dealerByServiceIdArr;

@end

@implementation DealerListViewController

@synthesize tblDealer,mapView,arrAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{

// [tblDealer reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [tblDealer reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
   // [tblDealer reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
   //  [tblDealer reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    
    _nf = [[NSNumberFormatter alloc] init];
    [_nf setNumberStyle:NSNumberFormatterDecimalStyle];
    [_nf setMaximumFractionDigits:1];
    [_nf setMinimumFractionDigits:1];
    [_nf setLocale:usLocale];
    //self.title = @"Dealers";
    // Do any additional setup after loading the view from its nib.
    if(_isChoosingDealer||_isChoosingFavouriteDealer)
    {
        [mapView setFrame:CGRectZero];
        CGRect rect = tblDealer.frame;
        tblDealer.frame = CGRectMake(rect.origin.x, rect.origin.y
                                     , rect.size.width, rect.size.height-53);
    }else{
        [self  loadMapWithLatitude:gCurrentLatitude longitude:gCurrentLongitude];
        NSLog(@"%f %f",gCurrentLatitude,gCurrentLongitude);
        _backBtn.hidden = YES;
    }
    [self initView];
    [self changeLang];

    
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_Dealers) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    self.tabBarItem.title = SetupLanguage(kLang_Dealers);
    [tblDealer reloadData];
}
-(void)initView
{
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.tblDealer addPullToRefreshWithActionHandler:^{
        [self loadData];
    }];
    if(_isChoosingDealer)
        [tblDealer triggerPullToRefresh];
    else{
        if((!gArrAllDealer||[gArrAllDealer count]==0))
            [tblDealer triggerPullToRefresh];
        else{
            if (_isChoosingFavouriteDealer) {
                [ModelManager getQuickDealer:^(NSArray *arrDelear) {
                    gArrAllDealer=arrDelear;
                    gArrAllDealer = [self sortDealerByDistance:gArrAllDealer];
                    [tblDealer reloadData];
                } failure:^(NSError *err) {
                   //  gArrAllDealer=nil;
                }];

            }
            else{
                [ModelManager getAllDealer:^(NSArray *arrDelear) {
                    gArrAllDealer=arrDelear;
                    gArrAllDealer = [self sortDealerByDistance:gArrAllDealer];
                    [tblDealer reloadData];
                } failure:^(NSError *err) {
                    //gArrAllDealer=nil;
                }];
            }
        }
    }
    
}
-(void)loadData
{
    
    if(_isChoosingDealer)
    {
        [ModelManager getDealerByServiceId:_serviceId andSuccess:^(NSArray *arr) {
            arr = [self sortDealerByDistance:arr];
            self.dealerByServiceIdArr = arr;
            [tblDealer reloadData];
            [tblDealer.pullToRefreshView stopAnimating];
        } failure:^(NSError *err) {
            [tblDealer.pullToRefreshView stopAnimating];
        }];
    }else
        if (_isChoosingFavouriteDealer) {
            [ModelManager getQuickDealer:^(NSArray *arr) {
                arr = [self sortDealerByDistance:arr];
                gArrAllDealer=arr;
                [tblDealer reloadData];
              //  [self addPinsToMap:mapView data:gArrAllDealer];
                [tblDealer.pullToRefreshView stopAnimating];
                
            } failure:^(NSError *error) {
                [tblDealer.pullToRefreshView stopAnimating];
               //  gArrAllDealer=nil;
            }];
        }
        else{
        
            [ModelManager getAllDealer:^(NSArray *arr) {
                arr = [self sortDealerByDistance:arr];
                gArrAllDealer=arr;
                [tblDealer reloadData];
                [self addPinsToMap:mapView data:gArrAllDealer];
                [tblDealer.pullToRefreshView stopAnimating];
                
            } failure:^(NSError *error) {
                [tblDealer.pullToRefreshView stopAnimating];
            }];

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

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - DealerCellDelegate

-(void)call:(NSString *)tel
{
    if(_isChoosingDealer || _isChoosingFavouriteDealer) return;
    if([Util canDevicePlaceAPhoneCall])
    {
        self.selectedTel = tel;
        [Util showMessage:SetupLanguage(KLang_CallEmergencyService) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:1000];
    }else
        [Util showMessage:SetupLanguage(KLang_CanNotMakeCall) withTitle:SetupLanguage(kLang_BMWCarService)];
    
}


#pragma mark Map functions


-(void)loadMapWithLatitude:(double)lat longitude:(double)longi
{
    
    [mapView setDelegate:self];
    [self showUserLocation];
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
        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.location.coordinate, MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isChoosingDealer)
        return [_dealerByServiceIdArr count];
    else
        return [gArrAllDealer count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self loadData];
    static NSString *simpleTableIdentifier = @"DealerCell";
    NSLog(@"index path:%ld",(long)indexPath.row);
    DealerCell *cell = (DealerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    DealerObj *obj;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        if(_isChoosingDealer)
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            obj=[_dealerByServiceIdArr objectAtIndex:indexPath.row];
        }else
            obj=[gArrAllDealer objectAtIndex:indexPath.row];
        cell.delegate = self;
    }
    
    
    cell.lblPhone.text = [NSString stringWithFormat:@"%@", obj.phone];
    cell.lblTelTitle.text = SetupLanguage(kLang_Tel);
    cell.lblOpeningHour.text = [NSString stringWithFormat:@"%@",obj.openingHour];
    cell.lblOpeningTitle.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_OpeningHours)];
    cell.lblAddressTitle.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Address)];
    
    float distance = obj.distance;
    if(distance>=1000)
    {
        distance /= 1000;
        NSString *formattedNumberStr = [_nf stringFromNumber:[NSNumber numberWithFloat:distance]];
        cell.distanceLbl.text = [NSString stringWithFormat:@"%@ km",formattedNumberStr];
    }else{
        NSString *formattedNumberStr = [_nf stringFromNumber:[NSNumber numberWithFloat:distance]];
        cell.distanceLbl.text = [NSString stringWithFormat:@"%@ m",formattedNumberStr];
    }
        
    //[cell.lblName setLineBreakMode:NSLineBreakByWordWrapping];
    //[cell.lblName setNumberOfLines:0];
    //[cell.lblName setFont:[Util customBoldFontWithSize:14.]];
    
    cell.lblAddress.text = obj.address;
    cell.lblName.text = obj.name;
    
    
    float heightName = 30;//[obj.name heightOfTextViewToFitWithFont:[Util customBoldFontWithSize:14.] andWidth:300];
    float heightAddress = [obj.address heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:12.] andWidth:175] -16;
    heightAddress = MAX(heightAddress, 18);
    
    [cell.lblAddress setFrame:CGRectMake(112, heightName, 175, heightAddress)];
    cell.lblAddressTitle.frame = CGRectMake(cell.lblAddressTitle.frame.origin.x, heightName, cell.lblAddressTitle.frame.size.width, cell.lblAddressTitle.frame.size.height);
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DealerObj *dealerObj;
    if(_isChoosingDealer)
        dealerObj=[_dealerByServiceIdArr objectAtIndex:indexPath.row];
    else
        dealerObj=[gArrAllDealer objectAtIndex:indexPath.row];
    //NSString *name =dealerObj.name;
    NSString *address =dealerObj.address;
    
    float heightName = 21;
    float heightAddress = [address heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:12.0] andWidth:175];
    float rowHeight=heightName+heightAddress+40;
    
    //DebugLog(@"Cell height  %f",rowHeight);
    
    return rowHeight;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isChoosingDealer||_isChoosingFavouriteDealer)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(choosedDealer:)])
        {
            
            DealerObj *dealerObj;
            dealerObj=[_dealerByServiceIdArr objectAtIndex:indexPath.row];
            if(_isChoosingFavouriteDealer)
                dealerObj=[gArrAllDealer objectAtIndex:indexPath.row];
            [_delegate choosedDealer:dealerObj];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        DealerDetail2ViewController *vc=[[DealerDetail2ViewController alloc] initWithNibName:@"DealerDetail2ViewController" bundle:nil];
        
        vc.dealerSelected=[gArrAllDealer objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000)
    {
        if(buttonIndex == 0) self.selectedTel = nil;
        else{
            NSString* phone = [NSString stringWithFormat:@"tel:%@", self.selectedTel];
            NSURL *phoneNumber = [[NSURL alloc] initWithString: phone];
            [[UIApplication sharedApplication] openURL: phoneNumber];
            self.selectedTel = nil;
        }
    }
}

@end
