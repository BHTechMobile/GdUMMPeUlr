//
//  MessageCell.h
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMessageType;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end
