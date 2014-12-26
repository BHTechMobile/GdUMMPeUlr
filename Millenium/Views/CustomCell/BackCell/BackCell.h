//
//  BackCell.h
//  Millenium
//
//  Created by duc le on 2/26/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackCellDelegate;
@interface BackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) id<BackCellDelegate> delegate;
@end

@protocol BackCellDelegate <NSObject>

-(void)backToList;

@end