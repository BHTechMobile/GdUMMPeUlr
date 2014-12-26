//
//  DealerAnnotation.m
//  Millenium
//
//  Created by Mr Lemon on 2/28/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerAnnotation.h"

@implementation DealerAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    
    return self;
}


@end
