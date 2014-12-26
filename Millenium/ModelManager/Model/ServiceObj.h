//
//  ServiceObj.h
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Collection.h"

@interface ServiceObj : CommonObj

@property(retain,nonatomic) NSString *categoryId;
@property(retain,nonatomic) NSString *categoryName;
@property(retain,nonatomic) NSString *des;
@property(retain,nonatomic) NSString *image;
@property(retain,nonatomic) NSString *type;
@property(retain,nonatomic) NSString *parentId;
@property(retain,nonatomic) NSString *level;
@property(retain,nonatomic) NSString *lang;
@property(retain,nonatomic) NSDictionary *translation;
@property(retain,nonatomic) NSString *parentName;
@property(retain,nonatomic) NSString *telephone;
@property(retain,nonatomic) NSString *isFastLane;

-(void)copyFromService:(Service*)service;
-(void)copyFromProduct:(Collection*)collection;
-(void)setDescription:(NSString *)description;
-(NSString*)description;

@end
