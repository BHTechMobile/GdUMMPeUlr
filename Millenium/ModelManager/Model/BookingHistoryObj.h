//
//  BookingHistoryObj.h
//  Millenium
//
//  Created by duc le on 3/5/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookingHistory.h"
#import "CommonObj.h"

@interface BookingHistoryObj : CommonObj

@property(nonatomic,strong) NSString* dealer_id;
@property(nonatomic,strong) NSString* service_id;
@property(nonatomic,strong) NSString* car_id;

@property(nonatomic,strong) NSString* note;
@property(nonatomic,strong) NSString* date;
@property(nonatomic,strong) NSString* status;
@property(nonatomic,strong) NSString* process;
@property(nonatomic,strong) NSString *submitedTime;
@property(nonatomic,strong) NSString *slotTime;

-(void)copyFromBookingHistory:(BookingHistory*)bookingHIstory;

@end
