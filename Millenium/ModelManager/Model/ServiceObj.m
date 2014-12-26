//
//  ServiceObj.m
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ServiceObj.h"

@implementation ServiceObj

-(void)copyFromProduct:(Collection *)collection
{
    self.name = collection.catName;
    self.categoryId = collection.categoryId;
    self.parentId  = collection.parentId;
    self.categoryName = collection.catName;
    self.parentName   = collection.parentName;
    self.image        = collection.image;
    if(collection.translation)
    {
        self.translation = [Util convertJSONToObject: [Validator getSafeString:collection.translation]];
    }
}

-(void)copyFromService:(Service *)service
{
    self.name  = service.name;
    self.categoryId = service.categoryId;
    self.categoryName = service.categoryName;
    self.parentId     = service.parentId;
    self.parentName   = service.parentName;
    self.description  = service.desctiptions;
    self.type         = service.type;
    self.level        = service.level;
    self.image        = service.image;
    self.telephone    = service.telephone;
    if (self.isFastLane!=nil) {
         self.isFastLane   = service.isFastLane;
    }
    else{
        self.isFastLane=@"";
    
    }
    
    if(service.translation)
    {
        self.translation = [Util convertJSONToObject: [Validator getSafeString:service.translation]];
    }
    
}

-(void)setDescription:(NSString *)description{
    _des = description;
}

-(NSString*)description{
    return _des;
}

@end
