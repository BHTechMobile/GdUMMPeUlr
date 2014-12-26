//
//  DealerDetailViewController.m
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "DealerDetailViewController.h"

@interface DealerDetailViewController ()

@end

@implementation DealerDetailViewController


@synthesize tblMessage,txtComment,lblPhone,lblName,lblAddress,viewHeader,dealerSelected,arrMessage,viewInputMessage;


CGRect  origiFrame;
BOOL keyboardToolbarShouldHide;

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
    self.title = @"Dealer Detail";
    
    [self initView];
    
    [self  registerKeyboardNotification];
    
    [self loadData];
    
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    
}

-(void)initView{
    
    origiFrame=viewInputMessage.frame;
    
    if(dealerSelected)
    {
        lblAddress.text=dealerSelected.address;
        lblName.text=dealerSelected.name;
        lblPhone.text=dealerSelected.phone;
    }
    
    [tblMessage addPullToRefreshWithActionHandler:^{
        [tblMessage reloadData];
        [self performSelector:@selector(stopAnimatePullToRefresh) withObject:nil afterDelay:1.0];
    }];
    
    [self loadData];
    
}


-(void)loadData
{
    arrMessage=[[NSMutableArray alloc] init];
    
    MessageObj *msg=[[MessageObj alloc] init];
    msg.author=@"John";
    msg.name=@"Please help me...";
    [arrMessage addObject:msg];
    
    [tblMessage reloadData];
    
    
}
-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)stopAnimatePullToRefresh {
    
    [tblMessage.pullToRefreshView stopAnimating];
}

-(void)loadListMessage{
    
    [tblMessage reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendMessage:(id)sender {
    
    MessageObj *msg=[[MessageObj alloc] init];
    msg.author=@"John";
    msg.name=txtComment.text;
    if(![msg.name isEqualToString:@""])
        [arrMessage addObject:msg];
    
    [tblMessage reloadData];
    
    
    [txtComment  setText:@""];
    [txtComment resignFirstResponder];
}


#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMessage count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessageCell";
    
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    MessageObj *obj=[arrMessage objectAtIndex:indexPath.row];
    cell.lblContent.text=obj.name;
    
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
    //    [[Util sharedUtil] slideUpView:viewInputMessage offset:254];
    
    //    viewInputMessage.frame=CGRectMake(0, 254, 320, 50);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
    //    [[Util sharedUtil] slideDownView:viewInputMessage offset:254];
    
}

#pragma mark Keyboard Notification

-(void) keyboardWillShow: (NSNotification *)notification

{
    NSDictionary* userInfo = [notification userInfo];
    
    CGRect beginFrame, endFrame;
    
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&beginFrame];
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    // get the animation curve and duration since we will use the same for they toolbar
    
    UIViewAnimationCurve animationCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    NSTimeInterval animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // add the keyboard to uiview and sync with the keyboard up animation
    
    
    // set the frame to be in sync with the keyboard
    
    viewInputMessage.frame = CGRectMake(beginFrame.origin.x,
                                        
                                        beginFrame.origin.y-  viewInputMessage.frame.size.height- 60,
                                        
                                        viewInputMessage.frame.size.width,
                                        
                                        viewInputMessage.frame.size.height);
    
    [UIView animateWithDuration:animationDuration
     
                          delay:0
     
                        options:0
     
                     animations:^{
                         
                         [UIView setAnimationCurve:animationCurve]; // make sure to use the same animation curve as the keyboard’s
                         
                         // move with the keyboard
                         
                         viewInputMessage.alpha = 1.0;
                         
                         viewInputMessage.frame = CGRectMake(endFrame.origin.x,
                                                             
                                                             endFrame.origin.y- viewInputMessage.frame.size.height ,
                                                             
                                                             viewInputMessage.frame.size.width,
                                                             
                                                             viewInputMessage.frame.size.height);
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         if( finished )
                             
                             keyboardToolbarShouldHide = YES;
                         
                     }
     
     ];
    
}

- (void)keyboardWillHide:(NSNotification *)notification

{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    
    viewInputMessage.frame=CGRectMake(0,SCREEN_HEIGHT_PORTRAIT- 110 , 320, 60);
    
    [UIView commitAnimations];
    
}
- (IBAction)onPhoneCall:(id)sender {
    if([Util canDevicePlaceAPhoneCall])
    {
        NSURL *phoneNumber = [[NSURL alloc] initWithString: @"tel:2-2222-2222"];
        [[UIApplication sharedApplication] openURL: phoneNumber];
    }else
        [Util showMessage:SetupLanguage(KLang_CanNotMakeCall) withTitle:SetupLanguage(kLang_BMWCarService)];
}

- (IBAction)onBack:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

@end
