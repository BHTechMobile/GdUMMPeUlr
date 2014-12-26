//
//  Util.m
//
//
//  Created by Dang Luu on 12/1/11.
//  Copyright 2011 4G SECURE., Ltd. All rights reserved.
//

#import "Util.h"
//#import "NSString+Extension.h"
//#import "NSDate+Additions.h"
#import "Macros.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define kCalendarType NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit

@implementation Util

+ (Util *)sharedUtil {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)dealloc {
    self.progressView = nil;
    [super dealloc];
}

+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

+(BOOL)isConnectNetwork{
    
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
    
}

#pragma mark Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:SetupLanguage(kLang_OK) otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES), nil];
    [alert show];
    [alert release];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:SetupLanguage(kLang_NO) otherButtonTitles:SetupLanguage(kLang_YES), nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];
    [alert release];
}

#pragma mark Date functions
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:dateFormat];
    NSDate *ret = [formatter dateFromString:dateString];
    [formatter release];
    return ret;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    return ret;
}

+ (NSString *)stringFromDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *utcDate = [formatter dateFromString:dateString];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    return [formatter stringFromDate:utcDate];
}

+ (NSDate*)convertTwitterDateToNSDate:(NSString*)created_at
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
	
	NSDate *convertedDate = [dateFormatter dateFromString:created_at];
	[dateFormatter release];
	
    return convertedDate;
}

+ (NSString *)stringFromDateRelative:(NSDate*)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle: NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
	[dateFormatter setDoesRelativeDateFormatting:YES];
	
	NSString *result = [dateFormatter stringFromDate:date];
	
	return result;
}

#pragma mark Loading View
- (MBProgressHUD *)progressView
{
    if (!_progressView) {
        _progressView = [[MBProgressHUD alloc] initWithView:[Util appDelegate].window];
        _progressView.animationType = MBProgressHUDAnimationFade;
        _progressView.dimBackground = NO;
		[[Util appDelegate].window addSubview:_progressView];
    }
    return _progressView;
}

- (void)showLoadingView {
    [self hideLoadingView];
    [self showLoadingViewWithTitle:@""];
}

- (void)showLoadingViewWithTitle:(NSString *)title
{
    [self hideLoadingView];
    self.progressView.labelText = title;
    [self.progressView show:NO];
}

- (void)hideLoadingView {
    [self.progressView hide:NO];
}

#pragma mark NSUserDefaults functions
+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKeyPath:keyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (id)valueForKeyPath:(NSString *)keyPath
{
    return [[NSUserDefaults standardUserDefaults] valueForKeyPath:keyPath];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark JSON functions
+ (id)convertJSONToObject:(NSString*)str {
    
	NSError *error = nil;
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *responseDict;
	
	if (data) {
		responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
	} else {
		responseDict = nil;
	}
	
	return responseDict;
}

+(NSString*)convertDictionaryToString:(NSDictionary*)dict{
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    NSString *jsonString=@"";
    if (!jsonData) {
        NSLog(@"Error %@", error);
    } else {
        jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@&quot;JSON OUTPUT: %@&quot;,JSONString);
    }
    return jsonString;
}

+ (NSString *)convertObjectToJSON:(id)obj {
    
    NSError *error = nil;
	NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
	
	if (error) {
		return @"";
	}
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (id)getJSONObjectFromFile:(NSString *)file {
	NSString *textPAth = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
	
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPAth encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
	
	id returnData = [Util convertJSONToObject:content];
	return returnData;
}

#pragma mark Other stuff
//+ (NSString *)getXIB:(Class)fromClass
//{
//	NSString *className = NSStringFromClass(fromClass);
//
//    if (IS_IPAD()) {
//		className = [className stringByAppendingString:IPAD_XIB_POSTFIX];
//	} else {
//
//	}
//	return className;
//}

+ (UIImage *)imageWithUIView:(UIView *)view
{
    CGSize screenShotSize = view.bounds.size;
	
	UIGraphicsBeginImageContext(screenShotSize);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
    [view.layer renderInContext:contextRef];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    // return the image
    return img;
}


-(void)slideUpView:(UIView*)view offset:(CGFloat)offset{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = view.frame;
    rect.origin.y -= offset;
    rect.size.height += offset;
    view.frame = rect;
    
    [UIView commitAnimations];
}
-(void)slideDownView:(UIView*)view offset:(CGFloat)offset
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = view.frame;
    rect.origin.y += offset;
    rect.size.height -= offset;
    view.frame = rect;
    [UIView commitAnimations];
    
}


#pragma mark UTILITY FUNCTIONS

+(BOOL)isValidEmail:(NSString*)emailAddress
{
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

#pragma mark Font

+(UIFont*)customRegularFontWithSize:(float)size
{
    return [UIFont fontWithName:@"BMWTypeGlobalPro-Regular" size:size];
}
+(UIFont*)customBoldFontWithSize:(float)size
{
    return [UIFont fontWithName:@"BMWTypeGlobalPro-Bold" size:size];
}
+(UIFont*)customLigthWithSize:(float)size
{
    return [UIFont fontWithName:@"BMWTypeGlobalPro-Light" size:size];
}

+(BOOL)canDevicePlaceAPhoneCall {
    /*
     
     Returns YES if the device can place a phone call
     
     */
    
    // Check if the device can place a phone call
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        // Device supports phone calls, lets confirm it can place one right now
//        CTTelephonyNetworkInfo *netInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
//        CTCarrier *carrier = [netInfo subscriberCellularProvider];
//        NSString *mnc = [carrier mobileNetworkCode];
//        if (([mnc length] == 0) || ([mnc isEqualToString:@"65535"])) {
//            // Device cannot place a call at this time.  SIM might be removed.
//            return NO;
//        } else {
//            // Device can place a phone call
//            return YES;
//        }
        return YES;
    } else {
        // Device does not support phone calls
        return  NO;
    }
}

@end
