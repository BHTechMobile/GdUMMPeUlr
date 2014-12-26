//
//  Service.h
//  Millenium
//
//  Created by duc le on 3/14/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Service : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * desctiptions;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * isFastLane;

@end
