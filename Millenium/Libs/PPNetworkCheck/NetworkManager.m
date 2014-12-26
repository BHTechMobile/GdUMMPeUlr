//
//  NetworkManager.m
//  Pincharts
//
//  Created by MAC on 11/14/13.
//
//

#import "NetworkManager.h"

@implementation NetworkManager

+(NetworkManager*)shareNetworkManager
{
    static NetworkManager* shareInstance;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken,^{
        shareInstance = [[NetworkManager alloc] init];
    });
    return shareInstance;
}

#pragma mark - Network Status

-(void)setupReachability
{
    if (_isSetup)
        return;
    else
        _isSetup = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    // check if a pathway to a random host exists
    //self.hostReach = [Reachability reachabilityWithHostName: @"www.google.com"] ;
    self.hostReach = [Reachability reachabilityForLocalWiFi];
    [_hostReach startNotifier];
    
    //Reachability *internetReach = [Reachability reachabilityForInternetConnection] ;
	//[internetReach startNotifier];
    
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    statusNetworkLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, 320, 20)];
//    statusNetworkLabel.textAlignment = NSTextAlignmentCenter;
//    statusNetworkLabel.textColor = [UIColor whiteColor];
//    statusNetworkLabel.text = @"Network Error!";
//    statusNetworkLabel.alpha = 0;
//    hasNetwork = YES;
//    [statusNetworkLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
//    [window addSubview:statusNetworkLabel];
    //[self checkNetworkStatus:nil];
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    Reachability* curReach ;
    if(notice != nil)
        curReach = [notice object];
    else
        curReach = _hostReach;
    NetworkStatus hostStatus = [curReach currentReachabilityStatus];
    hasNetwork = YES;
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            hasNetwork = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            break;
        }
    }
    
    
    if(hasNetwork==NO)
    {
//        [UIView animateWithDuration:0.5 animations:^{
//            statusNetworkLabel.alpha = 1;
//        }];
        if(networkStatusAlert == nil)
        {
            networkStatusAlert = [[UIAlertView alloc] initWithTitle:SetupLanguage(kLang_BMWCarService) message:SetupLanguage(KLang_ConnectServer) delegate:self cancelButtonTitle:SetupLanguage(kLang_OK) otherButtonTitles: nil];
            [networkStatusAlert show];
        }
    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            statusNetworkLabel.alpha = 0;
//        }];
        if(networkStatusAlert != nil)
        {
            [networkStatusAlert dismissWithClickedButtonIndex:-1 animated:YES];
            networkStatusAlert = nil;
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    alertView = nil;
}

@end
