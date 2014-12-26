//
//  NetworkManager.h
//  Pincharts
//
//  Created by MAC on 11/14/13.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkManager : NSObject<UIAlertViewDelegate>
{
    UILabel* statusNetworkLabel;
    BOOL hasNetwork;
    BOOL _isSetup;
    UIAlertView* networkStatusAlert;
}

@property (nonatomic, strong) Reachability* hostReach;

+(NetworkManager*)shareNetworkManager;
-(void)setupReachability;
@end
