//
//  Dealer.h
//  Millenium
//
//  Created by duc le on 3/14/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dealer : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longtitude;
@property (nonatomic, retain) NSString * openingHour;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * dealerId;
@property (nonatomic, retain) NSString * dealerName;

@end
