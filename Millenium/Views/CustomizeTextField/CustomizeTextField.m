//
//  CustomizeTextField.m
//  Xem Bóng Đá
//
//  Created by Mr.Lemon on 10/8/13.
//  Copyright (c) 2013 Fruity Solution. All rights reserved.
//

#import "CustomizeTextField.h"


@implementation CustomizeTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}


// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

@end
