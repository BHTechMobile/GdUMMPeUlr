//
//  ShareSocialCell.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareSocialCellDelegate;
@interface ShareSocialCell : UITableViewCell

@property (nonatomic, weak) id<ShareSocialCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@protocol ShareSocialCellDelegate <NSObject>

-(void)shareFB;
-(void)shareTW;
-(void)shareMail;
-(void)backToList;

@end
