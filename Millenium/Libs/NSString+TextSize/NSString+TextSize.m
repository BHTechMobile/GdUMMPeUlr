//
//  NSString+TextSize.m
//  Millenium
//
//  Created by duc le on 2/28/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

-(float)heightOfTextViewToFitWithFont:(UIFont *)font andWidth:(float)width
{
    CGSize size;
    if(font==nil)
        font = [UIFont fontWithName:@"Helvetica Neue" size:12.];
    CGSize maxSize = CGSizeMake(width, FLT_MAX);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
        [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [self length])];
        size = [attrStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    }else
    {
        size = [self sizeWithFont:font
                    constrainedToSize:maxSize
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
    return size.height+16;
}

-(NSString*)stringByAddingSpace:(NSString*)stringToAddSpace spaceCount:(NSInteger)spaceCount atIndex:(NSInteger)index{
    NSString *result = [NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0],stringToAddSpace];
    return result;
}

@end
