//
//  AppDelegate.h
//  Millenium
//
//  Created by duc le on 2/19/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Global.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController* tabbarViewController;
@property (strong, nonatomic) UINavigationController* naviVC;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@interface MyNavigationController : UINavigationController;

@end