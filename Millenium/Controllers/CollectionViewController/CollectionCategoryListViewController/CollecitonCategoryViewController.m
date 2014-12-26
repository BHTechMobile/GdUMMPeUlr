//
//  CollecitonCategoryViewController.m
//  Millenium
//
//  Created by duc le on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "CollecitonCategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectionListCell.h"
#import "NewsDetailViewController.h"
#import "Common.h"
#import "NSString+TextSize.h"

@interface CollecitonCategoryViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation CollecitonCategoryViewController

@synthesize selectCollection,tblView,arrProduct;

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
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
  //  _backBtn.titleLabel.font = [Util customRegularFontWithSize:15.0];
    
    self.titleLbl.text = [selectCollection.name uppercaseString];
    [self.titleLbl sizeToFit];
    [self changeLang];
    [self initData];
    
}

-(void)initData{
    
    self.arrProduct = [[NSMutableArray alloc] init];
    // setup pull-to-refresh

    NSArray* arr = [[ModelManager shareInstance] loadProductFromDB];
    arr = [arr filteredArrayUsingPredicate:[NSPredicate
                                           predicateWithFormat:@"collectionId == %@", selectCollection.categoryId]];
    if(arr.count>0){
        self.arrProduct = [NSMutableArray arrayWithArray:arr];
        [tblView reloadData];
    }
    
    [self.tblView addPullToRefreshWithActionHandler:^{
        
        [ModelManager getProductByCollectionId:selectCollection.categoryId start:0 limit:20 andSucess:^(NSArray *arr) {
            self.arrProduct = [NSMutableArray arrayWithArray:arr];
            [tblView reloadData];
            [tblView.pullToRefreshView stopAnimating];
        } failure:^(NSError *err) {
            [tblView.pullToRefreshView stopAnimating];
        }];
        
    }];
    
    [self.tblView addInfiniteScrollingWithActionHandler:^{
        [ModelManager getProductByCollectionId:selectCollection.categoryId start:arrProduct.count limit:20 andSucess:^(NSArray *arr) {
            
            NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
            for(int i=0;i<arr.count;i++)
            {
                NSIndexPath* indexpath = [NSIndexPath indexPathForRow:arrProduct.count+i inSection:0];
                [indexPaths addObject:indexpath];
            }
            [arrProduct addObjectsFromArray:arr];
            
            [tblView beginUpdates];
            [tblView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [tblView endUpdates];
            
            [tblView.infiniteScrollingView stopAnimating];
            if(arr.count<20) tblView.showsInfiniteScrolling = NO;
        } failure:^(NSError *arr) {
            [tblView.infiniteScrollingView stopAnimating];
        }];
    }];
    
//    [tblView addPullToRefreshWithActionHandler:^{
//        
//        [self loadData];
//    }];
//    if(gArrAllProduct== nil && gArrAllProduct.count==0)
//        [tblView triggerPullToRefresh];
//    else{
//        arrProduct = [gArrAllProduct filteredArrayUsingPredicate:[NSPredicate
//                                                                  predicateWithFormat:@"collectionId == %@", selectCollection.categoryId]];
//        [tblView reloadData];
//    }
    
}
-(void)loadData
{
    
    [ModelManager getProductByCollectionId:selectCollection.categoryId start:0 limit:20 andSucess:^(NSMutableArray *arr) {
        arrProduct=arr;
        [tblView reloadData];
        [self stopAnimatePullToRefresh];
        if([arrProduct count]==0)
        {
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.];
            [self.view makeToast:@"No product found"];
            
        }
    } failure:^(NSError *error) {
        [self stopAnimatePullToRefresh];
    }];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stopAnimatePullToRefresh{
    
    [tblView.pullToRefreshView stopAnimating];
}

-(void)changeLang
{
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    [tblView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProduct.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdetifier = @"CollectionListCell";
    CollectionListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectionListCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ProductObj *item=[arrProduct objectAtIndex:indexPath.row];
    NSString *firstImage=@"";
    if(item.arrImage&&[item.arrImage count]>0)
    {
        firstImage=[item.arrImage objectAtIndex:0];
    }
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:firstImage] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    if(![item.lang isEqualToString:[Util valueForKey:DefaultLang]] && item.translate != nil)
    {
        cell.lblProductName.text = [Validator getSafeString:item.translate[@"product_name"]];
        cell.titleLbl.text = [Validator getSafeString:item.translate[@"description"]];
    }else{
        cell.lblProductName.text=item.productName;
        cell.titleLbl.text =item.description;
    }
    
    CGRect rect = cell.titleLbl.frame;
    rect.size.width = 170;
    
    float height = [cell.titleLbl.text heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:13.0] andWidth:170] ;
    if(height >= 54)
    {
        rect.size.height = 54;
        cell.titleLbl.frame = rect;
    }else
        [cell.titleLbl sizeToFit];
    
    
    return cell;
}

#pragma mark - UItableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductObj *item=[arrProduct objectAtIndex:indexPath.row];
    
    NewsDetailViewController* newsDetailVC = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    [newsDetailVC setDetailWithImageURLStr:item.arrImage videoURL:nil content:item.description shareURL:@"http://www.mercedes-benz.co.th/content/thailand/mpc/mpc_thailand_website/enng/home_mpc/passengercars/home/servicesandaccessories/genuine_partsandaccessories/Collection_2/Classic.html" andTitle:item.productName];
    
    newsDetailVC.isProductDetail = YES;
    newsDetailVC.product = item;
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
