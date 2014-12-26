//
//  ProductObj.m
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ProductObj.h"
#import "CommonObj.h"

@implementation ProductObj

-(void)copyFromProduct:(Product*)product
{
    self.objId = product.productId;
    self.productName = product.productName;
    self.collectionId = product.collectionId;
    self.description = product.descriptions;
    self.status     = product.status;
    self.price      = product.price;
    self.code       = product.code;
    if(product.image && ![product.image isEqualToString:@""])
    {
        NSArray* arr = [product.image componentsSeparatedByString:@";"];
        if(arr && arr.count>0)
            self.arrImage = [NSMutableArray arrayWithArray:arr];
    }
}

-(void)setDescription:(NSString *)description{
    _des = description;
}

-(NSString*)description{
    return _des;
}

@end
