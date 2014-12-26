//
//  BookingHistoryCell.m
//  Millenium
//
//  Created by duc le on 2/27/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BookingHistoryCell.h"
#import "Common.h"

@implementation BookingHistoryCell

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
    UIFont* boldfont = [Util customBoldFontWithSize:16.0];
    UIFont* regFont  = [Util customRegularFontWithSize:14.0];
    
    _branch.font = _branchLbl.font = _type.font = _serviceTypeLbl.font = _note.font = _noteLbl.font = _date.font = _dateLbl.font = _status.font = _statusLbl.font = regFont;
    _vehicleLbl.font = boldfont;
}

-(void)setTitleByLang
{
    _branch.text =[NSString stringWithFormat:@"%@:", SetupLanguage(kLang_Branch)];
    _type.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Type)];
    _note.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Note)];
    _date.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Date)];
    _status.text = [NSString stringWithFormat:@"%@:",SetupLanguage(kLang_Status)];
}

- (IBAction)onEdit:(id)sender
{
    if(_delegate)
    {
        [_delegate onEditBookingHistory:self];
    }
}


@end
