//
//  MessageObj.h
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonObj.h"

@interface MessageObj : CommonObj

@property(retain,nonatomic) NSString *author;
@property(retain,nonatomic) NSString *dateCreated;


@end
