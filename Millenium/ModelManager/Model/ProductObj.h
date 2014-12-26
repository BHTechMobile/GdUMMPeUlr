//
//  ProductObj.h
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface ProductObj : CommonObj

@property(retain,nonatomic) NSString *productName;
@property(retain,nonatomic) NSString *collectionId;
@property(retain,nonatomic) NSString *des;
@property(retain,nonatomic) NSMutableArray *arrImage;
@property(retain,nonatomic) NSDictionary *translate;
@property(retain,nonatomic) NSString* lang;
@property(retain,nonatomic) NSString *status;
@property(retain,nonatomic) NSString *code;
@property(retain,nonatomic) NSString *price;

-(void)copyFromProduct:(Product*)product;
-(void)setDescription:(NSString *)description;
-(NSString*)description;

@end
