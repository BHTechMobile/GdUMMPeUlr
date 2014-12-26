//
//  CarType.h
//  Millenium
//
//  Created by duc le on 3/17/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarType : NSManagedObject

@property (nonatomic, retain) NSString * modelDescription;
@property (nonatomic, retain) NSString * modelKey;

@end
