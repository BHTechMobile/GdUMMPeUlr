//
//  SubServiceViewController.m
//  Millenium
//
//  Created by duc le on 3/15/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SubServiceViewController.h"
#import "BaseViewController.h"
#import "ServiceListCell.h"
#import "BookingServiceViewController.h"
#import "NSString+TextSize.h"

@interface SubServiceViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SubServiceViewController

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
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    _backBtn.titleLabel.font = [Util customRegularFontWithSize:15.0];
    [self changeLang];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_Services) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [self.titleLbl sizeToFit];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    self.tabBarItem.title = SetupLanguage(kLang_Services);
    [_tblView reloadData];
}

#pragma mark - TableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        ServiceObj* service = [_subService objectAtIndex:indexPath.row];
        float height = [service.description heightOfTextViewToFitWithFont:[Util customRegularFontWithSize:13.] andWidth:300];
        if(height > 50) height = 50;
        return height+65;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* memberId = [Util valueForKey:KEY_MEMBER_ID];
    if(memberId == nil)
    {
        [Util showMessage:SetupLanguage(kLang_YouHavetoRegister) withTitle:SetupLanguage(kLang_BMWCarService) cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES) delegate:self andTag:1000];
        return;
    }
    
    ServiceObj* service = [_subService objectAtIndex:indexPath.row];
    NSArray* arr = [ModelManager getSubService:gArrAllService andId:service.categoryId];
    if(arr.count>0)
    {
        SubServiceViewController* subServiceVC = [[SubServiceViewController alloc] initWithNibName:@"SubServiceViewController" bundle:nil];
        subServiceVC.subService = arr;
        [self.navigationController pushViewController:subServiceVC animated:YES];
        
    }else{
        BookingServiceViewController* bookingServiceVC = [[BookingServiceViewController alloc] initWithNibName:@"BookingServiceViewController" bundle:nil];
        bookingServiceVC.selectedService = service;
        [self.navigationController pushViewController:bookingServiceVC animated:YES];
    }
}

#pragma mark - TableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subService.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* serviceCellIden = @"ServiceListCell";

    ServiceListCell* cell = [tableView dequeueReusableCellWithIdentifier:serviceCellIden];
    if(cell == nil) cell = [[[NSBundle mainBundle] loadNibNamed:serviceCellIden owner:nil options:nil] objectAtIndex:0];
    ServiceObj* service = [_subService objectAtIndex:indexPath.row];
    if(![service.lang isEqualToString:[Util valueForKey:DefaultLang]] && service.translation != nil)
    {
        cell.desLbl.text = service.translation[@"description"];
        cell.serviceNameLbl.text = service.translation[@"cateName"];
    }else
    {
        cell.desLbl.text = service.description;
        cell.serviceNameLbl.text = service.name;
    }
    
    [cell.bookBtn setTitle:SetupLanguage(kLang_BookService) forState:UIControlStateNormal];
    return cell;

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
