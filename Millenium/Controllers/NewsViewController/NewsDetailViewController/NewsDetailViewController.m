//
//  NewsDetailViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ImageCell.h"
#import "TextViewCell.h"
#import "ShareSocialCell.h"
#import "UIImageView+WebCache.h"
#import "BackCell.h"
#import "TitleCell.h"
#import "NSString+TextSize.h"
#import "ETFoursquareImages.h"
#import "UIImageView+WebCache.h"

@interface NewsDetailViewController ()<ShareSocialCellDelegate,UIWebViewDelegate>
{
    float webViewHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) NSArray* imgURLArr;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* shareURL;
@property (nonatomic, strong) NSString* newsTitle;
@property (nonatomic, strong) NSString* videoURL;
@property (nonatomic, strong) UIImage* curImg;
@property (strong, nonatomic) IBOutlet UILabel *noticeLbl;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation NewsDetailViewController

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
    webViewHeight = -1;
    [self changeLang];
    //[self.titleLbl sizeToFit];
    // Do any additional setup after loading the view from its nib.
}

-(void)changeLang
{
    if(_isProductDetail)
        self.titleLbl.text = [SetupLanguage(kLang_ProductDetail) uppercaseString];
    else
        
        self.titleLbl.text = [SetupLanguage(kLang_NewsDetail) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];
    [_tblView reloadData];
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
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Public method

-(void)setDetailWithImageURLStr:(NSArray *)imgURLStr videoURL:(NSString *)videoURL content:(NSString *)content shareURL:(NSString *)url andTitle:(NSString *)title
{
    self.videoURL = videoURL;
    self.imgURLArr = imgURLStr;
    self.content = content;
    self.shareURL = url;
    self.newsTitle = title;
}

#pragma mark - UItableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* imgCellIden = @"ImageCell";
    //static NSString* txtViewCellIden = @"TextViewCell";
    static NSString* shareSocialCellIden = @"ShareSocialCell";
    static NSString* titleCellIden = @"TitleCell";
    
    if(indexPath.row == 0)
    {
        if(_videoURL == nil)
        {
            ImageCell* cell = [tableView dequeueReusableCellWithIdentifier:imgCellIden];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:imgCellIden owner:nil options:nil] objectAtIndex:0];
                if(_isProductDetail)
                {
                    [cell.etImagesView setImagesHeight:179];
                    [cell.etImagesView setImages:_imgURLArr];
                    [cell.etImagesView.pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
                    cell.imgView.hidden = NO;
                }else
                {
                    cell.etImagesView.hidden = YES;
                    NSString* urlImgStr = [_imgURLArr objectAtIndex:0];
                    [cell.imgView setImageWithURL:[NSURL URLWithString:urlImgStr] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            if(image) self.curImg = image;
                        
                    }];
                }
            }
            return cell;
        }else
        {
            NSString* textCellIden = [NSString stringWithFormat:@"TextViewCell_%d_%d",indexPath.section,indexPath.row];
            TextViewCell* cell = [tableView dequeueReusableCellWithIdentifier:textCellIden];

                if(cell == nil)
                {
                    UINib *nib = [UINib nibWithNibName:@"TextViewCell" bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:textCellIden];
                    cell = [tableView dequeueReusableCellWithIdentifier:textCellIden];
                    {
                        cell.txtView.hidden = YES;
                        
                        NSString *htmlContent = [NSString stringWithFormat:@"\
                                               <html>\
                                               <head>\
                                               <style type=\"text/css\">\
                                               iframe {position:absolute; top:50%%; margin-top:-130px;}\
                                               body {background-color:#000; margin:0;}\
                                               </style>\
                                               </head>\
                                               <body>\
                                               <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                               </body>\
                                               </html>", _videoURL];
                        
//                        [ce loadHTMLString:videoHTML baseURL:nil];
//                    NSString* htmlContent = [NSString stringWithFormat:@"\
//                                               <html>\
//                                               <body style='margin:0px;padding:0px;'>\
//                                               <script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>\
//                                               <script type='text/javascript'>\
//                                               function onYouTubeIframeAPIReady()\
//                                               {\
//                                               ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})\
//                                               }\
//                                               function onPlayerReady(a)\
//                                               { \
//                                               a.target.playVideo(); \
//                                               }\
//                                               </script>\
//                                               <iframe id='playerId' type='text/html' width='%d' height='%d' src='%@?enablejsapi=1&rel=0&playsinline=1&autoplay=0' frameborder='0'>\
//                                               </body>\
//                                               </html>", 320, 180,_videoURL];
                       // NSString *htmlContent =[NSString stringWithFormat:@"<iframe width=\"300\" height=\"180\"src=\"%@\"></iframe>",_videoURL];
                        //http://115.146.126.146/car/uploads//article//article_531547ca83ea4.mov
                        [cell.webView loadHTMLString:htmlContent baseURL:[NSURL URLWithString:_videoURL]];
                    
                        [cell.webView setDelegate:self];
                        cell.webView.tag = 1005;
                        cell.loadingIndicator.hidden = NO;
                        [cell.loadingIndicator startAnimating];
                    }
                }
            return cell;
        
        }
    }else if(indexPath.row == 1)
    {
        TitleCell* cell = [tableView dequeueReusableCellWithIdentifier:titleCellIden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:titleCellIden owner:nil options:nil] objectAtIndex:0];
        }
        
        if(_isProductDetail == NO)
        {
            cell.titleNewsLbl.text = _newsTitle;
            cell.priceLbl.hidden = cell.codeLbl.hidden  = cell.titleLbl.hidden = YES;
        }else{
            cell.titleNewsLbl.hidden = YES;
            cell.titleLbl.text = _newsTitle;
            cell.priceLbl.text = [NSString stringWithFormat:@"%@ THB*",_product.price];
            [_noticeLbl setHidden:NO];
            cell.codeLbl.text  = _product.code;
        }
        return cell;
        
    }else if(indexPath.row == 2)
    {
        NSString* textCellIden = [NSString stringWithFormat:@"TextViewCell_%d_%d",indexPath.section,indexPath.row];
        TextViewCell* cell = [tableView dequeueReusableCellWithIdentifier:textCellIden];
        if(cell == nil)
        {
            UINib *nib = [UINib nibWithNibName:@"TextViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:textCellIden];
            cell = [tableView dequeueReusableCellWithIdentifier:textCellIden];
        }
        if(_isProductDetail)
        {
            cell.webView.hidden = YES;
            cell.txtView.text = _content;
        }else
        {
            cell.txtView.hidden = YES;
            cell.webView.delegate = self;
            cell.webView.tag = 500;
            [cell.webView loadHTMLString:_content baseURL:nil];
        }
        return cell;
    } else
    {
        ShareSocialCell* cell = [tableView dequeueReusableCellWithIdentifier:shareSocialCellIden];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:shareSocialCellIden owner:nil options:nil] objectAtIndex:0];
            cell.delegate = self;
        }
        [cell.backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
        return cell;
    }
}

#pragma mark - UItableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://image cell
        {
            if(_videoURL == nil)
            {
                if(_imgURLArr == nil || _imgURLArr.count == 0)
                    return 0;
            }
            return 200;
        }
        case 1://title cell
        {
            float height = [_newsTitle heightOfTextViewToFitWithFont:[Util customBoldFontWithSize:15.0] andWidth:300]-5;
            if(_isProductDetail)
                height+=20;
            return height;
        }
        case 2://content cell
        {
            if(_isProductDetail)
            {
                float height = [_content heightOfTextViewToFitWithFont:[UIFont fontWithName:@"Helvetica Neue" size:12.] andWidth:300];
                return height;
            }else
            {
                if(webViewHeight == -1) return 1;
                else return webViewHeight;
            }
        }
        case 3://share social cell
            return 50;
        default:
            return 44;
    }
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(webView.tag == 1005)//video cell
    {
        NSString *htmlLoaded=[webView stringByEvaluatingJavaScriptFromString:
                              @"document.body.innerHTML"];
        if ([htmlLoaded rangeOfString:@"https://www.youtube.com/"].location !=NSNotFound) {
            TextViewCell* cell = (TextViewCell*)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.loadingIndicator stopAnimating];
        }
       
    }else
    {
        if(webViewHeight!= -1) return;
        float  height= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        webViewHeight = MAX(height, 1);
        [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"webViewDidFinishLoad >>>>>>>>%@",[webView stringByEvaluatingJavaScriptFromString:
                 @"document.body.innerHTML"]);
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

#pragma mark - Share Social Delegate

-(void)shareFB
{
    UIImageView *imgThumbnail;
   
        if (_curImg ==nil) {
            if (_imgURLArr.count>0) {
                imgThumbnail = [[UIImageView alloc] init];
                [imgThumbnail setImageWithURL:[_imgURLArr objectAtIndex:0]];
                _curImg = [imgThumbnail image];
            }
            
        }
    
    
    [self postToFacebookWithText:_newsTitle andImage:_curImg andURL:_videoURL andDescription:_content];
}

-(void)shareTW
{
    UIImageView *imgThumbnail;
  
        if (_curImg ==nil) {
            if (_imgURLArr.count>0) {
                imgThumbnail = [[UIImageView alloc] init];
                [imgThumbnail setImageWithURL:[_imgURLArr objectAtIndex:0]];
                _curImg = [imgThumbnail image];
            }
            
        }
    [self postToTwitterWithText:_newsTitle andImage:_curImg andURL:_videoURL andDescription:_content];
}

-(void)shareMail
{
    [self openMailWithBody:_content andSubject:_newsTitle];
}

-(void)backToList
{

//    if(_isProductDetail)
        [self.navigationController popViewControllerAnimated:YES];
//    else
//    {
//        [UIView animateWithDuration:0.75
//                         animations:^{
//                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//                         }];
//        self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//        [self.navigationController popViewControllerAnimated:NO];
//    }
}

@end
