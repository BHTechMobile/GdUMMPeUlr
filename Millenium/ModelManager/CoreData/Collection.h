//
//  Collection.h
//  Millenium
//
//  Created by duc le on 3/12/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Collection : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * catName;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) NSString * translation;

@end
