//
//  SubCollectionViewController.m
//  Millenium
//
//  Created by Mr Lemon on 3/5/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SubCollectionViewController.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "CollectionListCell.h"
#import "NewsDetailViewController.h"
#import "Common.h"
#import "NSString+TextSize.h"

@interface SubCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation SubCollectionViewController

@synthesize lblTitle,imgHeader,tblView,arrSubCollection,selectedCollection;



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

    // Do any additional setup after loading the view from its nib.
    lblTitle.font = [Util customBoldFontWithSize:22.0];
  //  _backBtn.titleLabel.font = [Util customRegularFontWithSize:15.0];
    NSArray* arr = [[ModelManager shareInstance] loadProductFromDB];
    arr = [arr filteredArrayUsingPredicate:[NSPredicate
                                            predicateWithFormat:@"collectionId == %@", selectedCollection.categoryId]];
    self.arrProduct = arr;
    [self initView];
    [self changeLang];
}

-(void)initView
{
    if(selectedCollection)
    {
        [imgHeader setImageWithURL:[NSURL URLWithString:selectedCollection.image] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
        
        lblTitle.text=[selectedCollection.categoryName uppercaseString];

        [lblTitle sizeToFit];
        
        [tblView reloadData];
    }
    
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


#pragma mark - TableView Datasource

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return [arrSubCollection count];
    else
        return _arrProduct.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* collectionCellIden = @"CollectionCell";
    static NSString* productCellIden = @"CollectionListCell";
    if(indexPath.section==0)
    {
    CollectionCell* cell = [tableView dequeueReusableCellWithIdentifier:collectionCellIden];
    if(cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:collectionCellIden owner:nil options:nil] objectAtIndex:0];
    
    ServiceObj *item=[arrSubCollection objectAtIndex:indexPath.row];
    if(![item.lang isEqualToString:[Util valueForKey:DefaultLang]] && item.translation != nil)
        cell.titleLbl.text = [[Validator getSafeString:item.translation[@"cateName"]] uppercaseString];
    else
        cell.titleLbl.text = [item.name uppercaseString];
        return cell;
    }else
    {
        CollectionListCell* cell = [tableView dequeueReusableCellWithIdentifier:productCellIden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CollectionListCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        ProductObj *item=[_arrProduct objectAtIndex:indexPath.row];
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
    
}

#pragma mark - TableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 47;
    else
        return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ServiceObj *selectItem=[arrSubCollection objectAtIndex:indexPath.row];
        
        NSArray  *arrSubCollect=[ModelManager getSubCollection:gArrAllCollection andId:selectItem.categoryId];
        
        if([arrSubCollect count]>0)
        {
            SubCollectionViewController *subCollectionVC=[[SubCollectionViewController alloc] initWithNibName:@"SubCollectionViewController" bundle:nil];
            subCollectionVC.selectedCollection=selectItem;
            subCollectionVC.arrSubCollection=arrSubCollect;
            [self.navigationController pushViewController:subCollectionVC animated:YES];
            
        }
        else{
            
            CollecitonCategoryViewController* collectCategoryVC = [[CollecitonCategoryViewController alloc] initWithNibName:@"CollecitonCategoryViewController" bundle:nil];
            
            collectCategoryVC.selectCollection=selectItem;
            [self.navigationController pushViewController:collectCategoryVC animated:YES];
        }
    }else{
        ProductObj *item=[_arrProduct objectAtIndex:indexPath.row];
        
        NewsDetailViewController* newsDetailVC = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        [newsDetailVC setDetailWithImageURLStr:item.arrImage videoURL:nil content:item.description shareURL:nil andTitle:item.productName];
        
        newsDetailVC.isProductDetail = YES;
        newsDetailVC.product = item;
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

- (IBAction)onBackPress:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
