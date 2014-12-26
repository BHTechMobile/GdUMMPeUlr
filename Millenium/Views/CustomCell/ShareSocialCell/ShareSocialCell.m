//
//  ShareSocialCell.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ShareSocialCell.h"

@implementation ShareSocialCell

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
   // _backBtn.titleLabel.font =  [Util customRegularFontWithSize:15.0];
}

- (IBAction)shareFB:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(shareFB)])
        [_delegate shareFB];
}

- (IBAction)shareTW:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(shareTW)])
        [_delegate shareTW];
}

- (IBAction)shareMail:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(shareMail)])
        [_delegate shareMail];
}

- (IBAction)backToList:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(backToList)])
        [_delegate backToList];
}

@end
