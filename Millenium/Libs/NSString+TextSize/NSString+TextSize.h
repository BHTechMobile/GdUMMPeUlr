//
//  NSString+TextSize.h
//  Millenium
//
//  Created by duc le on 2/28/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TextSize)

-(float)heightOfTextViewToFitWithFont:(UIFont*)font andWidth:(float)width;
-(NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index;
@end
