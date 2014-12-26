//
//  DealerDetailViewController.h
//  Millenium
//
//  Created by Mr Lemon on 2/21/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BaseViewController.h"
#import "DealerObj.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "MessageCell.h"
#import "MessageObj.h"


@interface DealerDetailViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIView *viewInputMessage;

@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@property (weak, nonatomic) IBOutlet UITableView *tblMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
- (IBAction)onSendMessage:(id)sender;

@property (retain, nonatomic) NSMutableArray *arrMessage;
@property (retain, nonatomic) DealerObj *dealerSelected;

- (IBAction)onPhoneCall:(id)sender;

- (IBAction)onBack:(id)sender;

@end
