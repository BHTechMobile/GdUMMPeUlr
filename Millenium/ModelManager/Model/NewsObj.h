//
//  NewsObj.h
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface NewsObj : NSObject

@property(retain,nonatomic) NSString *publicId;
@property(retain,nonatomic) NSString *code;
@property(retain,nonatomic) NSString *title;
@property(retain,nonatomic) NSString *mediaType;
@property(retain,nonatomic) NSString *imageUrl;
@property(retain,nonatomic) NSString *videoUrl;
@property(retain,nonatomic) NSString *shortDescription;
@property(retain,nonatomic) NSString *des;
@property(retain,nonatomic) NSString * lang;
@property(retain,nonatomic) NSDictionary *tranlation;
@property(retain,nonatomic) NSString *createdTime;
@property(retain,nonatomic) NSString *updatedTime;

-(void)copyFromNews:(News*)news;
-(void)setDescription:(NSString *)description;
-(NSString*)description;

@end
