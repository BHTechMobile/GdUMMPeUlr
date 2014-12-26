//
//  DealerAnnotation.h
//  Millenium
//
//  Created by Mr Lemon on 2/28/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface DealerAnnotation : NSObject <MKAnnotation>

@property (nonatomic,readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic,readwrite) NSString *titleStr;
@property (nonatomic,readwrite) NSString *subtitleStr;
@property (nonatomic) NSInteger tag;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;

@end
