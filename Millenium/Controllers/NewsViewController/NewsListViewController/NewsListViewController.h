//
//  NewsListViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewsListViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray* newsArr;
@property (weak, nonatomic) IBOutlet UITableView *newsTblView;

@end
