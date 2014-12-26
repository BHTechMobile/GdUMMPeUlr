//
//  DealerObj.m
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerObj.h"

@implementation DealerObj

-(id)initWithId:(NSString*)dealerId name:(NSString*)dealName address:(NSString*)dealAddress andPhone:(NSString*)dealPhone{
    
    self=[super init];
    if(self)
    {
        self.objId=dealerId;
        self.name=dealName;
        self.address=dealAddress;
        self.phone=dealPhone;
    }
    return self;
}

-(void)copyFromDealer:(Dealer*)dealer
{
    self.objId = dealer.dealerId;
    self.name  = dealer.dealerName;
    self.address = dealer.address;
    self.phone   = dealer.phone;
    self.openingHour = dealer.openingHour;
    self.email       = dealer.email;
    self.description = dealer.descriptions;
    self.latitude    = [dealer.latitude floatValue];
    self.longitude   = [dealer.longtitude floatValue];
    self.imageUrl    = dealer.imageUrl;
    
}

-(void)setDescription:(NSString *)description{
    _des = description;
}

-(NSString*)description{
    return _des;
}


@end
