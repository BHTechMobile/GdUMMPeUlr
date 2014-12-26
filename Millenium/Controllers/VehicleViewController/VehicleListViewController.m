//
//  VehicleListViewController.m
//  Millenium
//
//  Created by duc le on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "VehicleListViewController.h"
#import "VehicleCell.h"
#import "UIImageView+WebCache.h"
#import "RegisterVehicleViewController.h"
#import "BaseViewController.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface VehicleListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isEditVehicle;
    UIBarButtonItem* bi;
    
}
@end

@implementation VehicleListViewController

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
    // Do any additional setup after loading the view from its nib.
    bi = [[UIBarButtonItem alloc]
                           initWithTitle:SetupLanguage(kLang_Edit) style:UIBarButtonItemStylePlain target:self action:@selector(setEdit:)];
    isEditVehicle = NO;
    bi.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = bi;
    _titleLbl.font = [Util customBoldFontWithSize:22.0];
    [self changeLang];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:KNotifi_reloadListVer object:Nil];
   
    
}
-(void)reloadTable{

    [_tblView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - edit function

-(void)setEdit:(UIBarButtonItem*)sender
{
    if([sender.title isEqualToString:SetupLanguage(kLang_Edit)])
    {
        sender.title = SetupLanguage(kLang_Done);
        isEditVehicle = YES;
    }
    else
    {
        sender.title = SetupLanguage(kLang_Edit);
        isEditVehicle = NO;
    }
}

- (IBAction)back:(id)sender
{
    if (_tblView.editing) {
        [_tblView setEditing:NO];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
   
}

-(void)changeLang
{
    _titleLbl.text = [SetupLanguage(kLang_MyVehicle) uppercaseString];
    CGRect rect = _titleLbl.frame;
    rect.size.width = 187.;_titleLbl.frame = rect;
    [_titleLbl sizeToFit];
    [_backBtn setTitle:SetupLanguage(kLang_Back) forState:UIControlStateNormal];
    NSString* title = bi.title;
    if([title isEqualToString:@"Done"]||[title isEqualToString:@"เสร็จ"])
        bi.title = SetupLanguage(kLang_Done);
    else bi.title = SetupLanguage(kLang_Edit);
    [_tblView reloadData];
}

#pragma mark - UITableView Datasource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gArrMyCar count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    VehicleObj *item=[gArrMyCar objectAtIndex:indexPath.row];
    
    if(item)
    {
    
        if ([item.statusCar isEqual:@"0"]) {
            _canEditVehicle=NO;
        }
        else _canEditVehicle=YES;
    }

    if(_canEditVehicle) return YES;
    else return NO;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* vehicleCellIden = @"VehicleCell";
    VehicleCell* cell = [tableView dequeueReusableCellWithIdentifier:vehicleCellIden];
    if(cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:vehicleCellIden owner:nil options:nil]objectAtIndex:0];
    
    VehicleObj *item=[gArrMyCar objectAtIndex:indexPath.row];
    
    if(item)
    {
        cell.plateNumberLbl.text=item.plateNumber;
        cell.VINLbl.text=item.VINNumber;
        cell.modelLbl.text = item.vehicleModel;
        if ([item.statusCar isEqual:@"0"]) {
            cell.statuslb.text=@"Deleted";
        }
        else{cell.statuslb.text=@"Active";}
    }
    [cell setTitleByLang];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    VehicleObj* vehicle = [gArrMyCar objectAtIndex:indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager updateStatusCar:vehicle.vehicleId withSuccess:^{
        NSLog(@"garrCar:%@",gArrMyCar);
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_UpdateDefaultCar object:nil];
        if ([vehicle.vehicleId isEqual:[Util objectForKey:KEY_FAVORITE_VEHICLE_ID]]) {
             [Util removeObjectForKey:KEY_FAVORITE_VEHICLE_ID];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } failure:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Util showMessage:@"Can not remove this car right now." withTitle:SetupLanguage(kLang_BMWCarService)];
    }];
}

#pragma mark - UITableView Delegate

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isEditVehicle)
    {
        RegisterVehicleViewController* editVehicleVC = [[RegisterVehicleViewController alloc] initWithNibName:@"RegisterVehicleViewController" bundle:nil];
        editVehicleVC.isEditVehicle=true;
        editVehicleVC.vehicleObj=[gArrMyCar objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:editVehicleVC animated:YES];
    }else
    {
        VehicleObj *obj=[gArrMyCar objectAtIndex:indexPath.row];
        if ([obj.statusCar isEqual:@"1"]) {
        if(_delegate && [_delegate respondsToSelector:@selector(choosedVehicle:)])
        {
          
            VehicleObj *obj=[gArrMyCar objectAtIndex:indexPath.row];
                [Util setValue:obj.vehicleId forKey:KEY_FAVORITE_VEHICLE_ID];
                [Util setValue:obj.plateNumber forKey:KEY_FAVORITE_VEHICLE];
                [_delegate choosedVehicle:obj];
        }
             [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:SetupLanguage(kLang_BMWCarService) message:@"Vehicle Deleted, you can choose other Vehicle" delegate:nil cancelButtonTitle:SetupLanguage(kLang_OK) otherButtonTitles: nil];
            [alert show];
            
            
        }
       
    }
}

@end
