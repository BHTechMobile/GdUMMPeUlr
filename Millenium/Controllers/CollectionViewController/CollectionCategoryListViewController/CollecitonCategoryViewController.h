//
//  CollecitonCategoryViewController.h
//  Millenium
//
//  Created by duc le on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ServiceObj.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "Toast+UIView.h"

@interface CollecitonCategoryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (nonatomic,retain) ServiceObj *selectCollection;
@property (nonatomic,retain) NSMutableArray *arrProduct;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end