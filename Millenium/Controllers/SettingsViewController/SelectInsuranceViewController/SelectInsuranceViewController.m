//
//  SelectInsuranceViewController.m
//  Millenium
//
//  Created by Mr Lemon on 2/25/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "SelectInsuranceViewController.h"

@interface SelectInsuranceViewController ()

@end

@implementation SelectInsuranceViewController

@synthesize searchBar,tblInsurance,arrInsurance;


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
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.title=@"Select insurance";
    [self loadData];
}

-(void)loadData{
    
    
    arrInsurance=[[NSMutableArray alloc] init];
    CommonObj *objTemp;
    for (NSInteger i=0; i<20; i++) {
        
        objTemp=[[CommonObj alloc] init
                 ];
        objTemp.name=[NSString stringWithFormat:@"Insurance agency number  %d",i];
        [arrInsurance addObject:objTemp];
        
    }
    [tblInsurance reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrInsurance count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InsuranceCell";
    
    InsuranceCell *cell = (InsuranceCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InsuranceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    CommonObj *obj=[arrInsurance objectAtIndex:indexPath.row];
    cell.lblInsuranceName.text =obj.name;
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBarA{
    
    [searchBarA resignFirstResponder];
}

@end
