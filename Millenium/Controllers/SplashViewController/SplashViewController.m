//
//  SplashViewController.m
//  Millenium
//
//  Created by duc le on 2/28/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SplashViewController.h"
#import "YLProgressBar.h"
#import "NewsListViewController.h"
#import "ServiceListViewController.h"
#import "CollectionListViewController.h"
#import "DealerListViewController.h"
#import "SOSViewController.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "MSSlideNavigationController.h"
#import "ModelManager.h"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet YLProgressBar *progress;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
@property (nonatomic, strong) MyTabbarController* tabbarViewController;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation MyTabbarController

-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}

@end

@implementation SplashViewController

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
//    if (gArrAllLogo.count==0) {
//        [imgSplash setImage:[UIImage imageNamed:@"Default@2x.png"]];
//    }
    
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//	NSLog(@"%@",docDir);
//    NSString *icon=[Util objectForKey:@"icon"];
//	NSString *pngFileIcon = [NSString stringWithFormat:@"%@/%@.png",docDir,icon];
//    [imgLogo setImage:[UIImage imageWithContentsOfFile:pngFileIcon]];
//    NSString *splash=[Util objectForKey:@"splash"];
//    NSString *fileSplash=[NSString stringWithFormat:@"%@/%@.png",docDir,splash];
//    [imgSplash setImage:[UIImage imageWithContentsOfFile:fileSplash]];
    // Do any additional setup after loading the view from its nib.
    if([[[UIApplication sharedApplication] delegate] window].frame.size.height > 480)
    {
       [imgSplash setImage:[UIImage imageNamed:@"Default-568h@2x"]];
        CGRect rect = _progress.frame;
        rect.origin.y += 34;
        _progress.frame = rect;
    }else {
         [imgSplash setImage:[UIImage imageNamed:@"Default@2x"]];
    }
        
        if(IS_IPHONE5)
    {
        
        CGRect rect = _tapBtn.frame;
        rect.origin.y -= 20;
        _tapBtn.frame = rect;
    }
    [self autoLogin];
    if (gArrAllNews.count==0) {
         [self autoGetNews];
    }
    if (gArrAllSOSInfo.count==0) {
        
         [self autoGetSOSInfo];
    }
    if (gArrAllCollection.count==0) {
        [self autoGetProduct];
    }
    if (gArrAllDealer.count==0) {
        [self autoGetDelear];
    }
   
}
-(void)autoGetNews{
    
   
    [ModelManager getNewsWithStart:0 limit:20 andSucess:^(NSArray *arrNews) {
        gArrAllNews=arrNews;
    } failure:^(NSError *error) {
    }];


}
-(void)autoGetDelear{

    [ModelManager getAllDealer:^(NSArray *arrDelear) {
        gArrAllDealer=arrDelear;
    } failure:^(NSError *err) {
        
    }];
//    [ModelManager getDealerByServiceId:@"86" andSuccess:^(NSArray *arrDelear) {
//        gArrAllDealer=arrDelear;
//    } failure:^(NSError *err) {
//        NSLog(@"err:%@",err);
//    }];
}
-(void)autoGetProduct{

   [ModelManager getCollection:^(NSArray *arrCollection) {
       gArrAllCollection=arrCollection;
   } failure:^(NSError *err) {
       
   }];


}
-(void)autoGetSOSInfo{
    
    [ModelManager getListSOSInfo:^(NSArray *arr) {
        gArrAllSOSInfo=arr;
    } failure:^(NSError *err) {
        NSLog(@"err:%@",err.description);
    }];
}

-(void)autoLogin
{
    
    NSString *email=[Util valueForKey:KEY_EMAIL];
    if(email&&![email isEqualToString:@""])
    {
        NSString* pushId = [Validator getSafeString:[Util valueForKey:MyToken]];
        
        [ModelManager login:[Util valueForKey:KEY_EMAIL] pushId:pushId osType:@"ios" withSuccess:^(NSMutableArray *arrMyCar) {
            
            gArrMyCar=arrMyCar;
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.25 blue:0.25 alpha:0.9];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *icon=[Util objectForKey:@"iconName"];
	NSString *pngFileIcon = [NSString stringWithFormat:@"%@/%@.png",docDir,icon];
    if ([UIImage imageWithContentsOfFile:pngFileIcon]==nil) {
        if(IS_IPHONE5)
        {
            [imgSplash setImage:[UIImage imageNamed:@"Default-568h@2x"]];
        }else{
            [imgSplash setImage:[UIImage imageNamed:@"Default@2x"]];
        }
    }
    else{
        [imgLogo setImage:[UIImage imageWithContentsOfFile:pngFileIcon]];
        NSString *splash=[Util objectForKey:@"splash"];
        NSString *fileSplash=[NSString stringWithFormat:@"%@/%@.png",docDir,splash];
        if (IS_IPHONE5) {
             [imgSplash setImage:[UIImage imageWithContentsOfFile:fileSplash]];
        }
        else{
             [imgSplash setImage:[UIImage imageNamed:@"Default@2x"]];
        }
       
    }
   
    [self initFlatRainbowProgressBar];
    NSString* lastUpdate = [Validator getSafeString:[Util valueForKey:LastUpdate]];
    [ModelManager getInit:lastUpdate andDownloadProgressDelegate:_progress withSuccess:^(BOOL iscomplete) {

        _progress.hidden = YES;
        [self pushToTabbar];
       // [self performSelector:@selector(pushToTabbar) withObject:nil afterDelay:20];
    } failure:^(NSError *err) {

        _progress.hidden = YES;
        [self pushToTabbar];
        //[self performSelector:@selector(pushToTabbar) withObject:nil afterDelay:20];
    }];
    if (gArrAllLogo!=nil) {
        [imgLogo setImage:[gArrAllLogo objectAtIndex:0]];
        [imgSplash setImage:[gArrAllLogo objectAtIndex:1]];
    }
}

- (void)initFlatRainbowProgressBar
{
    NSArray *tintColors = @[[UIColor colorWithRed:33/255.0f green:180/255.0f blue:162/255.0f alpha:1.0f],
                            [UIColor colorWithRed:3/255.0f green:137/255.0f blue:166/255.0f alpha:1.0f],
                            [UIColor colorWithRed:91/255.0f green:63/255.0f blue:150/255.0f alpha:1.0f],
                            [UIColor colorWithRed:87/255.0f green:26/255.0f blue:70/255.0f alpha:1.0f],
                            [UIColor colorWithRed:126/255.0f green:26/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:149/255.0f green:37/255.0f blue:36/255.0f alpha:1.0f],
                            [UIColor colorWithRed:228/255.0f green:69/255.0f blue:39/255.0f alpha:1.0f],
                            [UIColor colorWithRed:245/255.0f green:166/255.0f blue:35/255.0f alpha:1.0f],
                            [UIColor colorWithRed:165/255.0f green:202/255.0f blue:60/255.0f alpha:1.0f],
                            [UIColor colorWithRed:202/255.0f green:217/255.0f blue:54/255.0f alpha:1.0f],
                            [UIColor colorWithRed:111/255.0f green:188/255.0f blue:84/255.0f alpha:1.0f]];
    
    _progress.type               = YLProgressBarTypeFlat;
    _progress.progressTintColors = tintColors;
    _progress.hideStripes        = YES;
    _progress.behavior           = YLProgressBarBehaviorDefault;
    _progress.progress = 0.0;

}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Tabbar function

-(void)pushToTabbar
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _tapBtn.alpha = 1;
    } completion:^(BOOL finished) {
        _imgView.userInteractionEnabled = YES;
    }];
    [self loadTabbar];
    
    //[self goMainScreen];
}


- (IBAction)goTabbar:(id)sender
{
    [self goMainScreen];
    
}
-(void)goMainScreen{
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    
    [[self navigationController].view.layer addAnimation:transition forKey:kCATransition];
    [[self navigationController] pushViewController:_tabbarViewController animated:NO];
}

-(void)loadTabbar
{
    UIFont* font = [Util customBoldFontWithSize:10.0];
    NewsListViewController *newsListViewController = [[NewsListViewController alloc]
                                                      initWithNibName:[NSString stringWithFormat:@"NewsListViewController"]
                                                      bundle:nil];
    newsListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:SetupLanguage(kLang_News) image:[UIImage imageNamed:@"ic_news.png"] tag:0];
    [newsListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_news_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_news.png"]];
    newsListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_news_select.png"];
    [newsListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               FS_UICOLOR_RGB(28, 105, 212), UITextAttributeTextColor,
                                                               //                                                          [UIColor colorWithWhite:0.0 alpha:0.3], UITextAttributeTextShadowColor,
                                                               //                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                               font,UITextAttributeFont,
                                                               nil] forState:UIControlStateSelected];
    [newsListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               FS_UICOLOR_RGB(146, 146, 146), UITextAttributeTextColor,
                                                               font,UITextAttributeFont,
                                                               nil] forState:UIControlStateNormal];
    MSSlideNavigationController* newsNaviVC = [[MSSlideNavigationController alloc] initWithRootViewController:newsListViewController];
    
    ServiceListViewController *serviceListViewController = [[ServiceListViewController alloc]
                                                            initWithNibName:[NSString stringWithFormat:@"ServiceListViewController"]
                                                            bundle:nil];
    serviceListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:SetupLanguage(kLang_Services) image:[UIImage imageNamed:@"ic_services.png"] tag:1];
    [serviceListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_services_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_services.png"]];
    serviceListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_services_select.png"];
    [serviceListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  FS_UICOLOR_RGB(28, 105, 212), UITextAttributeTextColor,
                                                                  font, UITextAttributeFont,
                                                                  nil] forState:UIControlStateSelected];
    [serviceListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  FS_UICOLOR_RGB(146, 146, 146), UITextAttributeTextColor,
                                                                  font,UITextAttributeFont,
                                                                  nil] forState:UIControlStateNormal];
    UINavigationController* servicesNaviVC = [[UINavigationController alloc] initWithRootViewController:serviceListViewController];
    
    CollectionListViewController *collectionListViewController = [[CollectionListViewController alloc]
                                                                  initWithNibName:[NSString stringWithFormat:@"CollectionListViewController"]
                                                                  bundle:nil];
    collectionListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:SetupLanguage(kLang_Collection) image:[UIImage imageNamed:@"ic_collections.png"] tag:2];
    [collectionListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_collections_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_collections.png"]];
    collectionListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_collections_select.png"];
    [collectionListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     FS_UICOLOR_RGB(28, 105, 212), UITextAttributeTextColor,
                                                                     nil] forState:UIControlStateSelected];
    [collectionListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     FS_UICOLOR_RGB(146, 146, 146), UITextAttributeTextColor,
                                                                     font, UITextAttributeFont,
                                                                     nil] forState:UIControlStateNormal];
    MSSlideNavigationController* collectionsNaviVC = [[MSSlideNavigationController alloc] initWithRootViewController:collectionListViewController];
    
    DealerListViewController *dealerListViewController = [[DealerListViewController alloc]
                                                          initWithNibName:[NSString stringWithFormat:@"DealerListViewController"]
                                                          bundle:nil];
    dealerListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:SetupLanguage(kLang_Dealers) image:[UIImage imageNamed:@"ic_dealers.png"] tag:3];
    [dealerListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_dealers_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_dealers.png"]];
    dealerListViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_dealers_select.png"];
    [dealerListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 FS_UICOLOR_RGB(28, 105, 212), UITextAttributeTextColor,
                                                                 font, UITextAttributeFont,
                                                                 nil] forState:UIControlStateSelected];
    [dealerListViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 FS_UICOLOR_RGB(146, 146, 146), UITextAttributeTextColor,
                                                                 font, UITextAttributeFont,
                                                                 nil] forState:UIControlStateNormal];
    MSSlideNavigationController* dealderNaviVC = [[MSSlideNavigationController alloc] initWithRootViewController:dealerListViewController];
    
    SOSViewController *sosViewController = [[SOSViewController alloc]
                                            initWithNibName:[NSString stringWithFormat:@"SOSViewController"]
                                            bundle:nil];
    sosViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:SetupLanguage(kLang_SOS) image:[UIImage imageNamed:@"ic_sos.png"] tag:4];
    
    [sosViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_sos_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_sos.png"]];
    sosViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_sos_select.png"];
    [sosViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          FS_UICOLOR_RGB(28, 105, 212), UITextAttributeTextColor,
                                                          font, UITextAttributeFont,
                                                          nil] forState:UIControlStateSelected];
    [sosViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          FS_UICOLOR_RGB(146, 146, 146), UITextAttributeTextColor,
                                                          font, UITextAttributeFont,
                                                          nil] forState:UIControlStateNormal];
    MSSlideNavigationController* sosNaviVC = [[MSSlideNavigationController alloc] initWithRootViewController:sosViewController];
    self.tabbarViewController = [[MyTabbarController alloc] init];
    //[self.tabbarViewController.tabBar setBackgroundImage:[UIImage imageNamed:@"bg_tab.png"]];
    
    NSArray *listNavigationController = @[newsNaviVC,servicesNaviVC,dealderNaviVC,collectionsNaviVC,sosNaviVC];
    for(UINavigationController* naviVC in listNavigationController)
        naviVC.navigationBarHidden = YES;
    _tabbarViewController.viewControllers = listNavigationController;
    [_tabbarViewController setSelectedIndex:1];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tabbarViewController = _tabbarViewController;
//    [self goTabbar:nil];
}



@end
