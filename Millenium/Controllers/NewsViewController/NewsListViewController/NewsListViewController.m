//
//  NewsListViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "NewsListViewController.h"
#import "CollectionListCell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "NewsDetailViewController.h"
#import "NewsListCell.h"
#import "ModelManager.h"
#import "Global.h"
#import "NewsObj.h"
#import "NSString+TextSize.h"

@interface NewsListViewController ()<UITableViewDataSource,UITableViewDelegate,NewsListCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

//@property (nonatomic, strong) NSArray* imgArr;
//@property (nonatomic, strong) NSArray* titleArr;
//@property (nonatomic, strong) NSArray* shortArr;


@end

@implementation NewsListViewController

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
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    //self.title = @"News";
    [self changeLang];
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.newsArr = [[NSMutableArray alloc] init];
    // setup pull-to-refresh
    if(gArrAllNews == nil || gArrAllNews.count==0)
    {
        NSArray* arr = [[ModelManager shareInstance] loadNewsFromDB];
        if(arr.count>0)
        {
            self.newsArr = [NSMutableArray arrayWithArray:arr];
        }
    }else
        self.newsArr = [NSMutableArray arrayWithArray:gArrAllNews];
    
    [self.newsTblView addPullToRefreshWithActionHandler:^{
        
        [ModelManager getNewsWithStart:0 limit:20 andSucess:^(NSArray *arr) {
            self.newsArr = [NSMutableArray arrayWithArray:arr];
            [_newsTblView reloadData];
            [_newsTblView.pullToRefreshView stopAnimating];
        } failure:^(NSError *arr) {
            [_newsTblView.pullToRefreshView stopAnimating];
        }];
        
    }];
    
    [self.newsTblView addInfiniteScrollingWithActionHandler:^{
        [ModelManager getNewsWithStart:_newsArr.count limit:20 andSucess:^(NSArray *arr) {
            
            NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
            for(int i=0;i<arr.count;i++)
            {
                NSIndexPath* indexpath = [NSIndexPath indexPathForRow:_newsArr.count+i inSection:0];
                [indexPaths addObject:indexpath];
            }
            [_newsArr addObjectsFromArray:arr];
            
            [_newsTblView beginUpdates];
            [_newsTblView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [_newsTblView endUpdates];
            
            [_newsTblView.infiniteScrollingView stopAnimating];
            if(arr.count<20) _newsTblView.showsInfiniteScrolling = NO;
        } failure:^(NSError *arr) {
            [_newsTblView.infiniteScrollingView stopAnimating];
        }];
    }];
    
    if(_newsArr.count==0)
        [_newsTblView triggerPullToRefresh];
    // Do any additional setup after loading the view from its nib.
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
    //decide number of origination to supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
}

-(void)changeLang
{
    self.titleLbl.text = [SetupLanguage(kLang_News) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    self.tabBarItem.title = SetupLanguage(kLang_News);
}

#pragma mark - TableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsArr.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdetifier = @"NewsListCell";
    NewsListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:nil options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    NewsObj* news = [_newsArr objectAtIndex:indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:news.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    if([[news.mediaType lowercaseString] isEqualToString:@"image"])
        cell.playImgView.hidden = YES;
    else cell.playImgView.hidden = NO;
    if(![news.lang isEqualToString:[Util valueForKey:DefaultLang]] && news.tranlation != nil)
    {
        cell.titleLbl.text = [Validator getSafeString:news.tranlation[@"title"]];
        cell.shortLbl.text = [Validator getSafeString:news.tranlation[@"short"]];
    }else
    {
        cell.titleLbl.text = news.title;
        cell.shortLbl.text = news.shortDescription;
    }
    
    CGRect rect = cell.shortLbl.frame;
    rect.size.width = 135;

    float height = [news.shortDescription heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:12.0] andWidth:135] ;
    if(height > 51)
    {
        rect.size.height = 51;
        cell.shortLbl.frame = rect;
    }else
        [cell.shortLbl sizeToFit];
    return cell;
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController* newsDetailVC = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    
    NewsObj* news = [_newsArr objectAtIndex:indexPath.row];
    //news.videoUrl = @"http://115.146.126.146/car/uploads//article///article_531547ca83ea4.mov";
    
    NSString* des,*title;
    if(![news.lang isEqualToString:[Util valueForKey:DefaultLang]] && news.tranlation != nil)
    {
        title = [Validator getSafeString:news.tranlation[@"title"]];
        des = [Validator getSafeString:news.tranlation[@"description"]];
    }else
    {
        title = news.title;
        des = news.description;
    }
    
    if([[news.mediaType lowercaseString] isEqualToString:@"image"])
    {
        [newsDetailVC setDetailWithImageURLStr:[NSArray arrayWithObject:news.imageUrl] videoURL:nil content:news.description shareURL:@"" andTitle:news.title];
    }else
    {
        [newsDetailVC setDetailWithImageURLStr:[NSArray arrayWithObject:news.imageUrl] videoURL:news.videoUrl content:news.description shareURL:@"" andTitle:news.title];
    }
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController pushViewController:newsDetailVC animated:NO];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//                     }];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
}

#pragma mark LOADMORE CELL Delegate

-(void)readMoreCell:(NewsListCell*)cell{
}

@end
