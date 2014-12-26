//
//  SOSInfoObj.m
//  Millenium
//
//  Created by Mr Lemon on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SOSInfoObj.h"

@implementation SOSInfoObj

-(void)copyFromSOSInfo:(SOSInfo*)sosInfo
{
    self.phone = sosInfo.tel;
    self.name = sosInfo.name;
}

@end
