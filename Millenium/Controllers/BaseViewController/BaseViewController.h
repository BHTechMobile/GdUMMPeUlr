//
//  BaseViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SettingsViewController.h"
#import "Macros.h"
#import "Common.h"

@interface BaseViewController : UIViewController

- (void)openMailWithBody:(NSString*)body andSubject:(NSString*)subject;
- (void)postToTwitterWithText:(NSString*)text andImage:(UIImage*)img andURL:(NSString*)url andDescription:(NSString *)description;
- (void)postToFacebookWithText:(NSString*)text andImage:(UIImage*)img andURL:(NSString*)url andDescription:(NSString *)description;
-(void)changeLang;

@end
