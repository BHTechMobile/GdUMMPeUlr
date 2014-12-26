//
//  SOSViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerObj.h"
#import "SOSCell.h"
#import "SOSInfoObj.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "Util.h"
#import "Macros.h"

@class BaseViewController;
@interface SOSViewController : BaseViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblSOS;
@property (retain,nonatomic) NSMutableArray *arrSOS;


@end
