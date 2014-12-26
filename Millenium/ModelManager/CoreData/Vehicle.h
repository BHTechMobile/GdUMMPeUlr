//
//  Vehicle.h
//  Millenium
//
//  Created by duc le on 3/10/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * vehicleId;
@property (nonatomic, retain) NSString * carImagePath;
@property (nonatomic, retain) NSString * plateNumber;
@property (nonatomic, retain) NSString * vinNumber;
@property (nonatomic, retain) NSString * vehicleModel;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * insurancePhoneNumber;
@property(nonatomic,retain) NSString *statusCar;

@end
