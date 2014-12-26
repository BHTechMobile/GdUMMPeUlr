//
//  BackCell.m
//  Millenium
//
//  Created by duc le on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BackCell.h"

@implementation BackCell

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

- (IBAction)back:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(backToList)])
        [_delegate backToList];
}

@end
