//
//  DealerCell.m
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerCell.h"

@implementation DealerCell

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
    _lblName.font = [Util customBoldFontWithSize:14.0];
    UIFont* font = [Util customRegularFontWithSize:12.0];
    _lblAddress.font = font;
    _lblAddressTitle.font = font;
    _lblOpeningHour.font = font;
    _lblOpeningTitle.font = font;
    _lblTelTitle.font = font;
    _lblPhone.font = font;
}

- (IBAction)call:(id)sender
{
    
    if(_delegate && [_delegate respondsToSelector:@selector(call:)])
    {
        [_delegate call:_lblPhone.text];
    }
}


@end
