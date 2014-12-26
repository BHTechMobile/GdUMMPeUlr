//
//  VehicleCell.m
//  Millenium
//
//  Created by duc le on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "VehicleCell.h"
#import "Common.h"

@implementation VehicleCell

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
    UIFont* font = [Util customRegularFontWithSize:17.0];
    _plate.font = _model.font = _plateNumberLbl.font = _modelLbl.font = _VIN.font = _VINLbl.font = font;
}

-(void)setTitleByLang
{
    _plate.text = SetupLanguage(kLang_Plate);
    _model.text = SetupLanguage(kLang_Model);
    _status.text=SetupLanguage(kLang_Status);
    
}

@end
