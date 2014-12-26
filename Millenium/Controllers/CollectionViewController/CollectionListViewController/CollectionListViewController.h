//
//  CollectionListViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CollectionCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "ServiceObj.h"
#import "SubCollectionViewController.h"


@interface CollectionListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (retain, nonatomic) NSMutableArray *arrRootCollection;


@end
