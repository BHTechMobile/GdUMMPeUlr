//
//  CollectionListViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "CollectionListViewController.h"
#import "UIImageView+WebCache.h"
#import "CollecitonCategoryViewController.h"
#import "BaseViewController.h"

@interface CollectionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray* imgArr;
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) UIImage* selectedImg;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;

@end

@implementation CollectionListViewController

@synthesize arrRootCollection,tblView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    
}

-(void)initView
{
    _headerImgView.clipsToBounds = YES;
    //tblView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.navigationController.navigationBarHidden = YES;
    //self.title = @"Collection";
    _titleLbl.font = [Util customBoldFontWithSize:22.0];;
    [self changeLang];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self.tblView addPullToRefreshWithActionHandler:^{
        [self loadData];
    }];
    if(!gArrAllCollection||[gArrAllCollection count]==0)
        [tblView triggerPullToRefresh];
    else {
        arrRootCollection=[ModelManager getRootCollection:gArrAllCollection];
        [tblView reloadData];
    }
}
-(void)loadData
{
    [ModelManager getCollection:^(NSArray *arr) {
        gArrAllCollection=arr;
        arrRootCollection=[ModelManager getRootCollection:gArrAllCollection];
        [tblView reloadData];
        [self stopAnimatePullToRefresh];
        
    } failure:^(NSError *error) {
        [self stopAnimatePullToRefresh];
    }];
}

-(void)changeLang
{
    self.titleLbl.text = [SetupLanguage(kLang_Collection) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];
    self.tabBarItem.title = SetupLanguage(kLang_Collection);
    [tblView reloadData];
}

-(void)stopAnimatePullToRefresh{
    
    [tblView.pullToRefreshView stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - TableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrRootCollection count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* collectionCellIden = @"CollectionCell";
    CollectionCell* cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIden];
    if(cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:collectionCellIden owner:nil options:nil] objectAtIndex:0];
    
    ServiceObj *item=[arrRootCollection objectAtIndex:indexPath.row];
    if(![item.lang isEqualToString:[Util valueForKey:DefaultLang]] && item.translation != nil)
        cell.titleLbl.text = [[Validator getSafeString:item.translation[@"cateName"]] uppercaseString];
    else
        cell.titleLbl.text = [item.name uppercaseString];
    return cell;
}

#pragma mark - TableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ServiceObj *selectItem=[arrRootCollection objectAtIndex:indexPath.row];
    
    NSArray  *arrSubCollection=[ModelManager getSubCollection:gArrAllCollection andId:selectItem.categoryId];
//    NSArray *arrProduct = [gArrAllProduct filteredArrayUsingPredicate:[NSPredicate
//                                                                       predicateWithFormat:@"collectionId == %@", selectItem.categoryId]];
    if([arrSubCollection count]>0)
    {
        SubCollectionViewController *subCollectionVC=[[SubCollectionViewController alloc] initWithNibName:@"SubCollectionViewController" bundle:nil];
        subCollectionVC.selectedCollection=selectItem;
        subCollectionVC.arrSubCollection=arrSubCollection;
        //subCollectionVC.arrProduct = arrProduct;
        [self.navigationController pushViewController:subCollectionVC animated:YES];
        
    }
    else{
        
        CollecitonCategoryViewController* collectCategoryVC = [[CollecitonCategoryViewController alloc] initWithNibName:@"CollecitonCategoryViewController" bundle:nil];
        
        collectCategoryVC.selectCollection=selectItem;
        [self.navigationController pushViewController:collectCategoryVC animated:YES];
    }
}


@end
