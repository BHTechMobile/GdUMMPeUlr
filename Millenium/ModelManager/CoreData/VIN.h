//
//  VIN.h
//  Millenium
//
//  Created by duc le on 3/17/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VIN : NSManagedObject

@property (nonatomic, retain) NSString * endVIN;
@property (nonatomic, retain) NSString * modelKey;
@property (nonatomic, retain) NSString * startVIN;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * delFlag;

@end
