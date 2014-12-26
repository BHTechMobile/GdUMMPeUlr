//
//  CollectionCell.m
//  Millenium
//
//  Created by duc le on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

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
    _titleLbl.font = [Util customBoldFontWithSize:18.0];
}

@end
