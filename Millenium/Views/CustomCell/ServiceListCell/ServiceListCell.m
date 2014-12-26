//
//  ServiceListCell.m
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ServiceListCell.h"

@implementation ServiceListCell

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
    _serviceNameLbl.font = [Util customBoldFontWithSize:16.0];
    _desLbl.font = [Util customRegularFontWithSize:13.0];
}

- (IBAction)bookService:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(serviceListCell:bookOnlinePress:)]) {
        [_delegate serviceListCell:self bookOnlinePress:sender];
    }
}

- (IBAction)callService:(NSString *)telephone;
{
    if (_delegate && [_delegate respondsToSelector:@selector(serviceListCell:callServicePress:)]) {
        [_delegate serviceListCell:self callServicePress:_telephoneLbl.text];
    }
}


@end
