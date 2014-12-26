//
//  Product.h
//  Millenium
//
//  Created by duc le on 3/12/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * collectionId;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * translate;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * productId;

@end
