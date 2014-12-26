//
//  TitleCell.m
//  Millenium
//
//  Created by duc le on 3/4/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

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
   _titleNewsLbl.font =  _titleLbl.font  = [Util customBoldFontWithSize:15.0];
    _codeLbl.font   = _priceLbl.font    = [Util customBoldFontWithSize:13.0];
}

@end
