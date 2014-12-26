//
//  NewsListCell.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NewsListCellDelegate;
@interface NewsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UITextView *txtView;

@property (weak, nonatomic) IBOutlet UILabel *shortLbl;

@property (weak, nonatomic) IBOutlet UIImageView *playImgView;

@property (weak, nonatomic) id<NewsListCellDelegate> delegate;

@end

@protocol NewsListCellDelegate <NSObject>

-(void)readMoreCell:(NewsListCell*)cell;

@end