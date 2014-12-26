//
//  NewsDetailViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProductObj.h"

@interface NewsDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) BOOL isProductDetail;
@property(nonatomic,strong) ProductObj* product;

-(void)setDetailWithImageURLStr:(NSArray*)imgURLArr videoURL:(NSString*)videoURL content:(NSString*)content shareURL:(NSString*)url andTitle:(NSString*)title;

@end
