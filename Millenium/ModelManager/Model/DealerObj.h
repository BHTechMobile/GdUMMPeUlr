//
//  DealerObj.h
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonObj.h"
#import "Dealer.h"

@interface DealerObj : CommonObj

@property(retain,nonatomic) NSString *address;
@property(retain,nonatomic) NSString *phone;
@property(retain,nonatomic) NSString *openingHour;
@property(retain,nonatomic) NSString *imageUrl;
@property(retain,nonatomic) NSString *email;
@property(retain,nonatomic) NSString *tranlation;
@property(retain,nonatomic) NSString *des;


@property(nonatomic) float  latitude;
@property(nonatomic) float  longitude;
@property(nonatomic) float  distance;

-(id)initWithId:(NSString*)dealerId name:(NSString*)dealName address:(NSString*)dealAddress andPhone:(NSString*)dealPhone;
-(void)copyFromDealer:(Dealer*)dealer;
-(void)setDescription:(NSString *)description;
-(NSString*)description;

@end
