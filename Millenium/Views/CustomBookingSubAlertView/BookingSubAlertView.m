//
//  BookingSubAlertView.m
//  Millenium
//
//  Created by duc le on 3/2/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BookingSubAlertView.h"
#import "Common.h"

@implementation BookingSubAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
     if(SYSTEM_VERSION_LESS_THAN(@"7.0"))
     {
         _vehicleLbl.textColor = [UIColor whiteColor];
         _vehicleNameLbl.textColor = [UIColor whiteColor];
         _branchLbl.textColor = [UIColor whiteColor];
         _branchNameLbl.textColor = [UIColor whiteColor];
         _typeLbl.textColor = [UIColor whiteColor];
         _typeNameLbl.textColor = [UIColor whiteColor];
         _dateLbl.textColor = [UIColor whiteColor];
         _dateNameLbl.textColor = [UIColor whiteColor];
     }
}

@end
