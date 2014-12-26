//
//  SelectInsuranceViewController.h
//  Millenium
//
//  Created by Mr Lemon on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonObj.h"
#import "InsuranceCell.h"

@interface SelectInsuranceViewController : UIViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblInsurance;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (retain, nonatomic) NSMutableArray *arrInsurance;

@end
