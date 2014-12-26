//
//  SubCollectionViewController.h
//  Millenium
//
//  Created by Mr Lemon on 3/5/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BaseViewController.h"
#import "CollectionCell.h"
#import "ServiceObj.h"
#import "CollecitonCategoryViewController.h"


@interface SubCollectionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (retain, nonatomic) ServiceObj  *selectedCollection;
@property (retain, nonatomic) NSArray  *arrSubCollection;
@property (retain, nonatomic) NSArray *arrProduct;

- (IBAction)onBackPress:(id)sender;

@end
