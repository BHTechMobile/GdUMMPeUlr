//
//  SOSInfoObj.h
//  Millenium
//
//  Created by Mr Lemon on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "CommonObj.h"
#import "SOSInfo.h"

@interface SOSInfoObj : CommonObj

@property(retain,nonatomic) NSString *phone;
@property(retain,nonatomic) NSString *openingHour;

-(void)copyFromSOSInfo:(SOSInfo*)sosInfo;

@end
