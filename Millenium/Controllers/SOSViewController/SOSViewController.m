//
//  SOSViewController.m
//  Millenium
//
//  Created by Mr. Lemon on 2/24/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SOSViewController.h"
#import "BaseViewController.h"
#import "Common.h"

@interface SOSViewController ()
{
    NSInteger selectIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation SOSViewController

@synthesize tblSOS,arrSOS;

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
    _titleLbl.font = [Util customBoldFontWithSize:22.0];;
    [self changeLang];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
    
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_Emegency_Serivce) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    [tblSOS reloadData];
    self.tabBarItem.title = SetupLanguage(kLang_SOS);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    [tblSOS addPullToRefreshWithActionHandler:^{
        [self callAPI];
    }];
    if(!gArrAllSOSInfo||[gArrAllSOSInfo count]==0)
            [tblSOS triggerPullToRefresh];
    
}

-(void)callAPI{
    
    [ModelManager getListSOSInfo:^(NSArray *arr) {
        gArrAllSOSInfo=arr;
        [tblSOS reloadData];
        [tblSOS.pullToRefreshView stopAnimating];
        
    } failure:^(NSError *error) {
        [tblSOS.pullToRefreshView stopAnimating];
    }];
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [gArrAllSOSInfo count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SOSCell";
    
    SOSCell *cell = (SOSCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SOSCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell.btnCall addTarget:self action:@selector(onCall:) forControlEvents:UIControlEventTouchUpInside];
    }
    SOSInfoObj *obj=[gArrAllSOSInfo objectAtIndex:indexPath.row];
    
    cell.lblSOSName.text = obj.name;
    cell.lblPhone.text=obj.phone;
    
    cell.btnCall.tag=indexPath.row;
    
    [cell.btnCall setTitle:SetupLanguage(kLang_Call) forState:UIControlStateNormal];
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)onCall:(id)sender
{
    if([Util canDevicePlaceAPhoneCall])
    {
        selectIndex=((UIButton*)sender).tag;
        DebugLog(@"Click index  %d",selectIndex);
        [Util showMessage:SetupLanguage(KLang_CallEmergencyService) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:1];
    }else
        [Util showMessage:SetupLanguage(KLang_CanNotMakeCall) withTitle:SetupLanguage(kLang_BMWCarService)];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1)
    {
        NSString *phone=((DealerObj*)[gArrAllSOSInfo objectAtIndex:selectIndex]).phone;
        phone = [NSString stringWithFormat:@"tel:%@", phone];
        
        NSURL *phoneNumber = [[NSURL alloc] initWithString: phone];
        [[UIApplication sharedApplication] openURL: phoneNumber];
    }
}

@end
