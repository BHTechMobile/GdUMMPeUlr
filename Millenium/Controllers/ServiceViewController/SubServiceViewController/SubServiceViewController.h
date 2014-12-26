//
//  SubServiceViewController.h
//  Millenium
//
//  Created by duc le on 3/15/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceObj.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"

@class BaseViewController;

@interface SubServiceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) NSArray* subService;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
