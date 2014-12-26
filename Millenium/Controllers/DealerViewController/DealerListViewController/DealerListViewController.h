//
//  DealerListViewController.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerObj.h"
#import "DealerDetailViewController.h"
#import "DealerCell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import <MapKit/MapKit.h>
#import "DealerAnnotation.h"
#import "NSString+TextSize.h"
#import "DealerDetail2ViewController.h"

@protocol DealerListViewControllerDelegate;
@class BaseViewController;

@interface DealerListViewController : BaseViewController<MKMapViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblDealer;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (retain, nonatomic) NSMutableArray *arrAnnotation;
@property (weak, nonatomic) id<DealerListViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isChoosingDealer;
@property (assign, nonatomic) BOOL isChoosingFavouriteDealer;
@property (nonatomic, strong) NSString* serviceId;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSNumberFormatter* nf;
@property (nonatomic, strong) NSString* selectedTel;

@end

@protocol DealerListViewControllerDelegate <NSObject>

-(void)choosedDealer:(DealerObj*)dealer;

@end


