//
//  VehicleListViewController.h
//  Millenium
//
//  Created by duc le on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleObj.h"
#import "Common.h"
@class BaseViewController;
@protocol VehicleListVCDelegate;

@interface VehicleListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) id<VehicleListVCDelegate> delegate;

@property (assign, nonatomic) BOOL canEditVehicle;
@end

@protocol VehicleListVCDelegate <NSObject>

-(void)choosedVehicle:(VehicleObj*)vehicle;

@end