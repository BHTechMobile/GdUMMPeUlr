//
//  EditProfileCell.m
//  Millenium
//
//  Created by duc le on 2/27/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "EditProfileCell.h"

@implementation EditProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)profile:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToEditProfile)])
        [_delegate goToEditProfile];
}

- (IBAction)bookingHistory:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToBookingHistory)])
        [_delegate goToBookingHistory];
}

- (IBAction)goProfile:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToEditProfile)])
        [_delegate goToEditProfile];
}


- (IBAction)goBookingHistory:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(goToBookingHistory)])
        [_delegate goToBookingHistory];
}


@end
