//
//  AppDelegate.m
//  Millenium
//
//  Created by duc le on 2/19/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsListViewController.h"
#import "ServiceListViewController.h"
#import "CollectionListViewController.h"
#import "DealerListViewController.h"
#import "SOSViewController.h"
#import "SplashViewController.h"
#import "BookingServiceViewController.h"
#import "NetworkManager.h"
#import "Common.h"
#import "BookingHistory.h"
#import "MagicalRecordShorthand.h"
#import "MagicalRecordHelpers.h"
#import "MSSlideNavigationController.h"
#import <EventKit/EventKit.h>
#import "ModelManager.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:@"BMWCarService.sqlite"];
#ifdef __IPHONE_8_0
    //Right, that is the point
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                         |UIRemoteNotificationTypeSound
                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    if (launchOptions != nil)
	{
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (dictionary != nil)
                {
                    NSDictionary *apsDict  = [launchOptions valueForKey:@"aps"];
                    NSDictionary *alertDict  = [apsDict valueForKey:@"alert"];
                    if (alertDict) {
                        NSString *mess  = [alertDict valueForKey:@"message"];
                        NSLog(@"mess: %@", mess);
                    }
                  
            if(dictionary[@"aps"])
            {
                NSDictionary* data =[Util convertJSONToObject:[Validator getSafeString:[dictionary valueForKey:@"data"]]];
                if (data){
                    [self updateBookingHistoryWithDic:dictionary[@"aps"] needUpdateScree:NO];
                }
                }
		}
	}
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    if(![Util valueForKey:DefaultLang])
    {
        LocalizationSetLanguage(@"en_US");
        [Util setValue:@"en" forKey:DefaultLang];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLang) name:kNotifi_ChangeLange object:Nil];
    [[NetworkManager shareNetworkManager] setupReachability];
    [self createTabbar];
    [self initCoreLocation];
    [self.window makeKeyAndVisible];

    return YES;
}

-(void)createTabbar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [[UIToolbar appearance] setBarTintColor:[UIColor lightGrayColor]];
        [[UIToolbar appearance] setTintColor:[UIColor blackColor]];
    }
    else
    {
        [[UIToolbar appearance] setTintColor:[UIColor lightGrayColor]];
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    }

    SplashViewController* splashVC = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:Nil];
    self.naviVC = [[MyNavigationController alloc] initWithRootViewController:splashVC];
    _naviVC.navigationBarHidden = YES;
    self.window.rootViewController = _naviVC;
    
}

-(void)changeLang
{
    if(_tabbarViewController)
    {
        for(int i = 0 ; i <  _tabbarViewController.tabBar.items.count; i++)
        {
            UITabBarItem* item = [_tabbarViewController.tabBar.items objectAtIndex:i];
            switch (i) {
                case 0:
                    item.title = SetupLanguage(kLang_News);
                    break;
                case 1:
                    item.title = SetupLanguage(kLang_Services);
                    break;
                case 2:
                    item.title = SetupLanguage(kLang_Dealers);
                    break;
                case 3:
                    item.title = SetupLanguage(kLang_Collection);
                    break;
                case 4:
                    item.title = SetupLanguage(kLang_SOS);
                    break;
                default:
                    break;
            }
        }
    }
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
        return UIInterfaceOrientationMaskAll;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    [ModelManager getBookingHistory:memberId success:^(NSArray *arr) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
        gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_UpdateBookingHistory object:nil];
    } failure:^(NSError *err) {
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_UpdateCalendarBooking object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notification

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[[deviceToken description]
                        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                       stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    
	DebugLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>My token is: %@", token);
    NSLog(@"token : %@",token);
    [application openURL:[NSURL URLWithString:token]];
    [Util setValue:token forKey:MyToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	DebugLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@" dic of notification ZZZZZZZZZZZZZZ %@", userInfo);

    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        DebugLog(@"PUSH NOTIFICATION IN BACK GROUND");
        if(userInfo[@"aps"])
            [self updateBookingHistoryWithDic:userInfo[@"aps"] needUpdateScree:NO];
    }
    else
    {
        if(userInfo[@"aps"])
            [self updateBookingHistoryWithDic:userInfo[@"aps"] needUpdateScree:YES];
        DebugLog(@"PUSH NOTIFICATION IN FORCE GROUND");
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)updateBookingHistoryWithDic:(NSDictionary*)dic needUpdateScree:(BOOL)needUpdate
{
    if(dic[@"data"])
    {
        
        NSDictionary* data =[Util convertJSONToObject:[Validator getSafeString:[dic valueForKey:@"data"]]];
        if (data) {
            [Util showMessage:SetupLanguage(KLang_bookingHasUpdated) withTitle:SetupLanguage(kLang_BMWCarService)];
            NSString* bookId = [Validator getSafeString:data[@"id"]];
            [Util setObject:bookId forKey:@"book_id"];
            NSString* process  = [Validator getSafeString:data[@"process"]];
            BookingHistory* bookingHis = [BookingHistory findFirstByAttribute:@"bookingHistoryId" withValue:bookId];
            NSString *dateTime=[Validator getSafeString:data[@"book_date"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateTime];
            NSString *serviceType=[Validator getSafeString:data[@"message"]];
            if (![serviceType isEqual:@"Fast Lane Service"]) {
                if (dateTime) {
                    if ([process integerValue]!=5) {
                        EKEventStore *eventStore = [[EKEventStore alloc] init];
                        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                            granted=YES;
                            if (granted){
                                //---- codes here when user allow your app to access theirs' calendar.
                                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                                event.title     = [NSString stringWithFormat:@"%@ : %@",SetupLanguage(kLang_BookingService),serviceType];
                                
                                event.startDate = dateFromString;
                                event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
                                
                                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                                NSError *err;
                                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                                [Util setObject:event.eventIdentifier forKey:bookId];
                            }else
                            {
                                //----- codes here when user NOT allow your app to access the calendar.
                                
                                
                            }
                        }];
                        
                        NSString *topNavigation = [self.naviVC.visibleViewController description];
                        if ([topNavigation rangeOfString:[BookingServiceViewController description]].location == NSNotFound){
                            
                            BookingServiceViewController *vc=[[BookingServiceViewController alloc]initWithNibName:@"BookingServiceViewController" bundle:nil];
                            vc.isEditBookingHistory = YES;
                            vc.bookingHistoryToEdit = bookingHis;
                            NSLog(@"booking hist:%@",bookingHis.bookingHistoryId);
                            [self.naviVC pushViewController:vc animated:YES];
                            [Util setObject:bookingHis.bookingHistoryId forKey:@"bookingHisId"];
                            
                        }
                        
                    }
                    
                    
                }
                if ([process intValue]==5) {
                    
                    UIAlertView *ss=[[UIAlertView alloc]initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_ChangeEvent) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                    [ss show];
                    ss.tag=963;
                    
                }
                
            }
            if(bookingHis)
            {
                bookingHis.process = process;
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                if([process intValue]==5 )//cancelled
                {
                    NSString* eventIden = [Validator getSafeString:[Util valueForKey:bookingHis.bookingHistoryId]];
                    if (eventIden) {
                        DebugLog(@"event iden : %@",eventIden);
                        EKEventStore *eventStore = [[EKEventStore alloc] init];
                        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                            if(granted)
                            {
                                EKEvent *event = [eventStore eventWithIdentifier:eventIden];
                                [eventStore removeEvent:event span:EKSpanFutureEvents error:&error];
                                [Util removeObjectForKey:bookingHis.bookingHistoryId];
                            }
                        }];
                    }
                    
                }
                
                if(needUpdate)
                {
                    NSArray* arr =  [[ModelManager shareInstance] loadBookingHistoryFromDB];
                    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
                    arr = (NSMutableArray*)[arr  sortedArrayUsingDescriptors:@[sd]];
                    gArrAllBookingHistory = [NSMutableArray arrayWithArray:arr];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_UpdateBookingHistory object:nil];
                }
            }

        }
        else{
//            NSDictionary* alert =[Util convertJSONToObject:[Validator getSafeString:[dic valueForKey:@"alert"]]];
//                NSString* description = [alert  objectForKey:@"message"];
//                [[UIApplication sharedApplication] cancelAllLocalNotifications];
//                
//                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                localNotification.alertBody=@"";
//                localNotification.soundName=UILocalNotificationDefaultSoundName;
//                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
           }
    
        
    }
    /**
     
     */
}

#pragma mark INIT LOCATION MANAGER


-(void)initCoreLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_location) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        gIsEnableLocation = NO;
    }
    else
    {
        gIsEnableLocation = YES;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLHeadingFilterNone;
        gCurrentLatitude = gCurrentLongitude = 0;
//        self.locationManager.purpose = @"To calculate the distance to dealer";
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag==963) {
         NSString *bookId= [Util valueForKey:@"book_id"];
        if (buttonIndex==0) {
            NSLog(@"edit");
            BookingHistory* bookingHis =[BookingHistory findFirstByAttribute:@"bookingHistoryId" withValue:bookId];

            if (bookingHis) {
                NSString* eventIden = [Validator getSafeString:[Util valueForKey:bookingHis.bookingHistoryId]];
                if (eventIden) {
                    EKEventStore *eventStore = [[EKEventStore alloc] init];
                    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                        if(granted)
                        {
                            EKEvent *event = [eventStore eventWithIdentifier:eventIden];
                            
                            [eventStore removeEvent:event span:EKSpanFutureEvents error:&error];
                            [Util removeObjectForKey:bookingHis.bookingHistoryId];
                        }
                    }];
                    
                    NSString *topNavigation = [self.naviVC.visibleViewController description];
                    if ([topNavigation rangeOfString:[BookingServiceViewController description]].location == NSNotFound){
                    
                        BookingServiceViewController *vc=[[BookingServiceViewController alloc]initWithNibName:@"BookingServiceViewController" bundle:nil];
                        vc.isEditBookingHistory = YES;
                        vc.bookingHistoryToEdit = bookingHis;
                        NSLog(@"booking hist:%@",bookingHis.bookingHistoryId);
                        [self.naviVC pushViewController:vc animated:YES];
                        [Util setObject:bookingHis.bookingHistoryId forKey:@"bookingHisId"];
                    
                    }
                   
                }
          
                      }
            
        }
        else{
            NSLog(@"edit");
            BookingHistory* bookingHis =[BookingHistory findFirstByAttribute:@"bookingHistoryId" withValue:bookId];
            
            if (bookingHis) {
                NSString* eventIden = [Validator getSafeString:[Util valueForKey:bookingHis.bookingHistoryId]];
                if (eventIden) {
                    EKEventStore *eventStore = [[EKEventStore alloc] init];
                    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                        if(granted)
                        {
                            EKEvent *event = [eventStore eventWithIdentifier:eventIden];
                            
                            [eventStore removeEvent:event span:EKSpanFutureEvents error:&error];
                            [Util removeObjectForKey:bookingHis.bookingHistoryId];
                        }
                    }];
                }
            }
        }
        
    }


}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    gCurrentLatitude = location.coordinate.latitude;
    gCurrentLongitude = location.coordinate.longitude;
    
    [self.locationManager stopUpdatingLocation];
}

@end

@implementation MyNavigationController

- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}
@end
