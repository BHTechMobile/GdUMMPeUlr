//
//  SOSCell.m
//  Millenium
//
//  Created by Mr Lemon on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SOSCell.h"

@implementation SOSCell

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

-(void)awakeFromNib
{
    _lblSOSName.font = [Util customBoldFontWithSize:15.0];
    _lblPhone.font = [Util customBoldFontWithSize:15.0];
   // _btnCall.titleLabel.font = [Util customRegularFontWithSize:13.0];
}

@end
