//
//  BookingHistory.h
//  Millenium
//
//  Created by duc le on 3/17/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookingHistory : NSManagedObject

@property (nonatomic, retain) NSString * car_id;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * dealer_id;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * process;
@property (nonatomic, retain) NSString * service_id;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * bookingHistoryId;
@property (nonatomic,retain)  NSString * submitedTime;
@property (nonatomic,retain)  NSString * slotTime;

@end
