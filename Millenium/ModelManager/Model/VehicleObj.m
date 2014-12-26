//
//  DeviceObj.m
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "VehicleObj.h"

@implementation VehicleObj

-(void)copyFromVehicle:(Vehicle *)vehicle
{
    self.vehicleId = vehicle.vehicleId;
    self.vehicleModel = vehicle.vehicleModel;
    self.plateNumber  = vehicle.plateNumber;
    self.province     = vehicle.province;
    self.insurancePhoneNumber   = vehicle.insurancePhoneNumber;
    self.VINNumber    = vehicle.vinNumber;
    self.statusCar=vehicle.statusCar;
}

@end
