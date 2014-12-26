//
//  BookingHistoryObj.m
//  Millenium
//
//  Created by duc le on 3/5/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BookingHistoryObj.h"

@implementation BookingHistoryObj

-(void)copyFromBookingHistory:(BookingHistory*)bookingHIstory
{
    self.car_id = bookingHIstory.car_id;
    self.dealer_id = bookingHIstory.dealer_id;
    self.service_id = bookingHIstory.service_id;
    self.note       = bookingHIstory.note;
    self.status     = bookingHIstory.status;
    self.process    = bookingHIstory.process;
    self.date       = bookingHIstory.date;
    self.objId      = bookingHIstory.bookingHistoryId;
    self.submitedTime=bookingHIstory.submitedTime;
    self.slotTime=bookingHIstory.slotTime;

}


@end
