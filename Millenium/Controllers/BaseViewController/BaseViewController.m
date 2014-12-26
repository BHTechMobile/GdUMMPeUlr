//
//  BaseViewController.m
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "BaseViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface BaseViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation BaseViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLang) name:kNotifi_ChangeLange object:Nil];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [settingsButton setImage:[UIImage imageNamed:@"ic_settings.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
	// Do any additional setup after loading the view.
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
}

-(void)changeLang
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)goSettings
//{
//
//    SettingsViewController* settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:settingsVC];
//    [self.navigationController presentViewController:nav animated:YES completion:^{
//
//    }];
//}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - share Mail

- (void)openMailWithBody:(NSString*)body andSubject:(NSString*)subject
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *messageBody = body;
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:subject];
        [mc setMessageBody:messageBody isHTML:NO];
        
        // Present mail view controller on screen
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
            mc.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    
    else
        
    {
        
        NSString *recipients = @"mailto:";
        NSString *body = @"";
        
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString* msg = nil;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            msg = @"Mail saved: you saved the email message in the drafts folder.";
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            msg = @"Mail send: the email message is queued in the outbox. It is ready to send.";
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            msg = @"Mail failed: the email message was not saved or queued, possibly due to an error.";
            break;
        default:
            NSLog(@"Mail not sent.");
            msg  = @"Mail coundn't be sent by unknown error";
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - share TW

- (void)postToTwitterWithText:(NSString*)text andImage:(UIImage*)img andURL:(NSString*)url andDescription:(NSString *)description
{
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
                
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                NSLog(@"Tweet Sheet has been dismissed.");
            }];
        });
    };
    UITextView *textview=[[UITextView alloc]init];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    textview.attributedText = attributedString;
    description=textview.text;
    
    
    [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ \n %@", text,description]];
    
    if (url!=nil) {
        if (![tweetSheet addURL:[NSURL URLWithString:url]]){
            
            NSLog(@"Unable to add the URL!");
            
        }
        
        
    }
    else{
        if(img != nil)
            [tweetSheet addImage:img];
        
    }
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
        
        NSLog(@"Tweet sheet has been presented.");
        
    }];
}

#pragma mark - share FB
-(void)postToFacebookWithText:(NSString *)text andImage:(UIImage *)img andURL:(NSString *)url andDescription:(NSString *)description{
    SLComposeViewController *fbSheet = [SLComposeViewController
                                        composeViewControllerForServiceType:
                                        SLServiceTypeFacebook];
    fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
                
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                NSLog(@"Tweet Sheet has been dismissed.");
            }];
        });
    };
    UITextView *textview=[[UITextView alloc]init];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    textview.attributedText = attributedString;
    description=textview.text;
        [fbSheet setInitialText:[NSString stringWithFormat:@"%@ \n %@", text,description]];
   
    
    
    if (url!=nil) {
        if (![fbSheet addURL:[NSURL URLWithString:url]]){
            
            NSLog(@"Unable to add the URL!");
            
        }
    

    }
    else{
        if(img != nil)
            [fbSheet addImage:img];
    
    }
    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:fbSheet animated:NO completion:^{
        
        NSLog(@"Tweet sheet has been presented.");
        
    }];


}
//- (void)postToFacebookWithText:(NSString*)text andImage:(UIImage*)img andURL:(NSString*)url andDescription:(NSString *)description
//{
//    
//   }


@end
