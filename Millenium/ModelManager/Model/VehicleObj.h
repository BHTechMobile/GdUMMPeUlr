//
//  DeviceObj.h
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"

@interface VehicleObj : NSObject


@property(strong, nonatomic) NSString* vehicleId;
@property(strong, nonatomic) NSString* carImagePath;
@property(strong, nonatomic) NSString* plateNumber;
@property(strong, nonatomic) NSString* VINNumber;
@property(strong, nonatomic) NSString* vehicleModel;
@property(strong, nonatomic) NSString* province;
@property(strong, nonatomic) NSString* insurancePhoneNumber;
@property(strong,nonatomic)  NSString *statusCar;

-(void)copyFromVehicle:(Vehicle*)vehicle;

@end
