//
//  ServiceListViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceObj.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"

#import "ServiceListCell.h"

@class BaseViewController;

@interface ServiceListViewController : BaseViewController<ServiceCellDelegate>

@property (retain, nonatomic) NSMutableArray *arrRootService;
@property (retain,nonatomic) NSString *telephoneStr;
@end
