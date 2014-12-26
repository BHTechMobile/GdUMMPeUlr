//
//  News.h
//  Millenium
//
//  Created by duc le on 3/11/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * descriptions;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * publicId;
@property (nonatomic, retain) NSString * shortDescriptions;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSString * lang;

@end
