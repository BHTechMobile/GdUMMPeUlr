//
//  ModelManager.m
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "ModelManager.h"
#import "Common.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MagicalRecordShorthand.h"
#import "MagicalRecordHelpers.h"
#import "Global.h"

#import "VIN.h"
#import "CarType.h"
#import "News.h"
#import "SOSInfo.h"
#import "Vehicle.h"
#import "BookingHistory.h"
#import "Service.h"
#import "Dealer.h"
#import "Product.h"
#import "Collection.h"
#import "SlotTimeObj.h"
#import "UIImageView+WebCache.h"

@implementation ModelManager

+(ModelManager*)shareInstance
{
    static ModelManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
#pragma mark - SERVICE CALL


+(void)getInit:(NSString*)lastUpdatedDate andDownloadProgressDelegate:(UIView*)myProgressIndicator  withSuccess:(void (^)(BOOL))success
       failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_INIT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:lastUpdatedDate forKey:@"date"];
    [request setDownloadProgressDelegate:myProgressIndicator];
    __weak ASIFormDataRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        NSLog(@"=====result:%@",[[jsonDic objectForKey:@"result"]objectForKey:@"home_splash"]);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if([jsonDic[@"ok"] boolValue])
            {
                gArrAllLogo =[[NSMutableArray alloc]init];
                NSLog(@"success get service");
                NSArray* newsArr=[self parserListNews:[[jsonDic objectForKey:@"result"] objectForKey:@"news"]];
                UIImage *imgIcon=[self parserLogo:[[jsonDic objectForKey:@"result"]objectForKey:@"client_logo"]];
                [gArrAllLogo addObject:imgIcon];
                UIImage *imgSplash=[self parserSplash:[[jsonDic objectForKey:@"result"] objectForKey:@"home_splash"]];
                [gArrAllLogo addObject:imgSplash];
                gArrAllService=[self parserListService:[[jsonDic objectForKey:@"result"] objectForKey:@"services"]];
                gArrAllDealer=[self parserListDealer:[[jsonDic objectForKey:@"result"] objectForKey:@"dealers"]];
                gArrAllSOSInfo=[self parserListSOSInfo:[[jsonDic objectForKey:@"result"] objectForKey:@"sos"]];
                gArrAllCollection=[self parserListCollection:[[jsonDic objectForKey:@"result"] objectForKey:@"collections"]];
                NSArray* productArr=[self parserListProduct:[[jsonDic objectForKey:@"result"] objectForKey:@"products"]];
                [self parserListCarType:[[jsonDic objectForKey:@"result"]  objectForKey:@"car_type"]];
               // [self parserListVIN:[[jsonDic objectForKey:@"result"]  objectForKey:@"car_vin"]];
                
                [[ModelManager shareInstance] saveNewsToDB:newsArr];
                [[ModelManager shareInstance] saveSOSinfoToDB:gArrAllSOSInfo];
                [[ModelManager shareInstance] saveCollectionsToDB:gArrAllCollection];
                [[ModelManager shareInstance] saveProductToDB:productArr];
                [[ModelManager shareInstance] saveServiceToDB:gArrAllService];
                [[ModelManager shareInstance] saveDealerToDB:gArrAllDealer];
                
                NSDate* date = [NSDate date];
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* dateStr = [df stringFromDate:date];
                [Util setObject:dateStr forKey:LastUpdate];
                //df setf
                
                success(true);
            }
            else
            {
                [[ModelManager shareInstance] loadFromDB];
                if(failure)
                    failure(e);
            }
        }
    }];
    
    [request setFailedBlock:^{
        [[ModelManager shareInstance] loadFromDB];
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
}

+(void)login:(NSString*)email pushId:(NSString *)pushId osType:(NSString *)osType withSuccess:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{
    NSLog(@">>>>>>>>>>>>>>>>>>> device token:%@",pushId);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_LOGIN]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:pushId forKey:@"push_id"];
    [request setPostValue:osType forKey:@"os_type"];
    __weak ASIFormDataRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        }
        else {
            NSLog(@"Login Success");
            jsonDic= [jsonDic objectForKey:@"result"];
            if([jsonDic count]==0||!jsonDic[@"hasCars"])
            {
                gArrMyCar = [[ModelManager shareInstance] loadVehicleFromDB];
                if(failure)
                    failure(nil);
            }else{
                
                if(jsonDic&&[jsonDic count]>0)
                {
                    [Util setValue:[Validator getSafeString:[jsonDic valueForKey:@"email"]] forKey:KEY_EMAIL];
                    [Util setValue:[Validator getSafeString:[jsonDic valueForKey:@"tel"]] forKey:KEY_PHONE];
                    [Util setValue:[Validator getSafeString:[jsonDic valueForKey:@"name"]] forKey:KEY_NAME];
                    [Util setValue:[Validator getSafeString:[jsonDic valueForKey:@"memberId"]] forKey:KEY_MEMBER_ID];
                    
                }
                NSMutableArray *arrNews=[self parserListVehicle:[jsonDic objectForKey:@"hasCars"]];
                if(arrNews.count>0)
                    [[ModelManager shareInstance] saveVehicleToDB:arrNews];
                DebugLog(@"My car size : %d",[arrNews count]);
                if(success)
                    success(arrNews);
            }
        }
    }];
    
    [request setFailedBlock:^{
        gArrMyCar = [[ModelManager shareInstance] loadVehicleFromDB];
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
}


+(void)registerWithName:(NSString*)name email:(NSString*)email phone:(NSString*)phone vinNumber:(NSString*)vinNumber licensePlate:(NSString*)licensePlate andVehicleModel:(NSString*)vehicelModel pushId:(NSString*)pushId osType:(NSString*)osType withSuccess:(void (^)(NSDictionary*))success
                failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_REGISTER]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setRequestMethod:@"POST"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:email forKey:@"email"];
    [request setPostValue:phone forKey:@"tel"];
    [request setPostValue:pushId forKey:@"push_id"];
    [request setPostValue:osType forKey:@"os_type"];
    [request setPostValue:vinNumber forKey:@"VIN"];
    [request setPostValue:licensePlate forKey:@"license_plate"];
    [request setPostValue:vehicelModel forKey:@"model_description"];
    //[request setData:UIImagePNGRepresentation([UIImage imageNamed:@"ic_sos.png"]) forKey:@"photo"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            
            NSLog(@"success register car");
            success(jsonDic);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
    
}

+(void)getService:(void (^)(NSArray*))success
          failure:(void (^)(NSError *))failure{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_SERVICE]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get service");
                NSMutableArray *arrNews=[self parserListService:[jsonDic objectForKey:@"result"]];
                if(arrNews.count>0)
                    [[ModelManager shareInstance] saveServiceToDB:arrNews];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}

+(void)getSlotTimeByDearlerId:(NSString*)dealerId withDate:(NSString*)date andSuccess:(void (^)(NSMutableArray*))success
                    failure:(void (^)(NSError *))failure
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_TIME_SLOT]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setRequestMethod:@"POST"];
    [request setPostValue:dealerId forKey:@"dealerId"];
    [request setPostValue:date forKey:@"date"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        NSLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get dealer by service");
                NSMutableArray *arrNews=[self parserListSlotTime:[jsonDic objectForKey:@"result"]];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
}


+(void)getDealerByServiceId:(NSString*)serviceId andSuccess:(void (^)(NSArray*))success
                    failure:(void (^)(NSError *))failure
{
    
    NSLog(@"service id:%@",serviceId);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",BASE_URL,URL_GET_DEALER,serviceId]];
    NSLog(@"url : %@",[NSString stringWithFormat:@"%@%@/%@",BASE_URL,URL_GET_DEALER,serviceId]);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        //DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        NSLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get dealer by service");
                NSMutableArray *arrNews=[self parserListDealer:[jsonDic objectForKey:@"result"]];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}

+(void)getCollection:(void (^)(NSArray*))success
             failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_COLLECTION]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"Success get collection");
                NSMutableArray *arrNews=[self parserListCollection:[jsonDic objectForKey:@"result"]];
                if(arrNews.count>0)
                    [[ModelManager shareInstance] saveCollectionsToDB:arrNews];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
        gArrAllCollection=[[ModelManager shareInstance]loadCollectionFromDB];
    }];
    [request startAsynchronous];
}

+(void)getProductByCollectionId:(NSString*)collectionId start:(int)start limit:(int)limit andSucess:(void (^)(NSMutableArray*))success
                        failure:(void (^)(NSError *))failure
{
    NSString* startStr = [NSString stringWithFormat:@"%d",start];
    NSString* limitStr = [NSString stringWithFormat:@"%d",limit];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/%@/%@",BASE_URL,URL_GET_PRODUCT,collectionId,startStr,limitStr]];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get product by collection");
                NSMutableArray *arrProduct=[self parserListProduct:[jsonDic objectForKey:@"result"] ];
                if(arrProduct.count>0 && start< 40)
                    [[ModelManager shareInstance] saveProductToDB:arrProduct];
                if(success)
                    success(arrProduct);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
        gArrAllProduct=[[ModelManager shareInstance]loadProductFromDB];
        
    }];
    [request startAsynchronous];
    
}

+(void)getNewsWithStart:(int)start limit:(int)limit andSucess:(void (^)(NSArray*))success
       failure:(void (^)(NSError *))failure{
    
    NSString* startStr = [NSString stringWithFormat:@"%d",start];
    NSString* limitStr = [NSString stringWithFormat:@"%d",limit];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/%@",BASE_URL,URL_GET_NEWS,startStr,limitStr]];
    NSLog(@"url : %@",[NSString stringWithFormat:@"%@%@/%@/%@",BASE_URL,URL_GET_NEWS,startStr,limitStr]);
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];

    __weak ASIFormDataRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get news");
                NSMutableArray *arrNews=[self parserListNews:[jsonDic objectForKey:@"result"] ];
                if(arrNews.count>0 && start<20)
                    [[ModelManager shareInstance] saveNewsToDB:arrNews];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
        
    }];
    [request startAsynchronous];
    
}
+(void)addEventWithMemberId:(NSString*)memberId  cardId:(NSString*)carId dealerId:(NSString*)dealerId eventDate:(NSString*)eventDate serviceId:(NSString *)serviceId eventName:(NSString *)eventName andDetail:(NSString *)detail slotTime:(NSString*)slotTime success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_ADD_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:memberId forKey:@"memberId"];
    [request setPostValue:carId forKey:@"carId"];
    [request setPostValue:dealerId forKey:@"dealerId"];
    [request setPostValue:eventDate forKey:@"event_date"];
    [request setPostValue:serviceId forKey:@"serviceId"];
    [request setPostValue:eventName forKey:@"event_name"];
    [request setPostValue:detail forKey:@"detail"];
    [request setPostValue:slotTime forKey:@"slot_time"];
    __weak ASIHTTPRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success add event");
                NSMutableArray *arrNews=[self parserListBookingHistory:jsonDic[@"result"]];
                if(arrNews)
                    [[ModelManager shareInstance] saveBookingHistoryToDB:arrNews];
                NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
                NSArray* sortedArr = (NSMutableArray*)[arrNews  sortedArrayUsingDescriptors:@[sd]];
                gArrAllBookingHistory = [NSMutableArray arrayWithArray:sortedArr];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
}


+(void)updateEventWithEventId:(NSString*)eventId memberId:(NSString*)memberId  cardId:(NSString*)carId dealerId:(NSString*)dealerId eventDate:(NSString*)eventDate serviceId:(NSString*)serviceId eventName:(NSString*)eventName andDetail:(NSString*)detail slotTime:(NSString*)slotTime success:(void (^)(NSArray*))success
                      failure:(void (^)(NSError *))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_UPDATE_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:eventId forKey:@"eventId"];
    [request setPostValue:memberId forKey:@"memberId"];
    [request setPostValue:carId forKey:@"carId"];
    [request setPostValue:dealerId forKey:@"dealerId"];
    [request setPostValue:eventDate forKey:@"event_date"];
    [request setPostValue:serviceId forKey:@"serviceId"];
    [request setPostValue:eventName forKey:@"event_name"];
    [request setPostValue:detail forKey:@"detail"];
    [request setPostValue:slotTime forKey:@"slot_time"];
    __weak ASIHTTPRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success add event");
                NSMutableArray *arrNews=[self parserListBookingHistory:jsonDic[@"result"]];
                if(arrNews)
                    [[ModelManager shareInstance] saveBookingHistoryToDB:arrNews];
                NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
                NSArray* sortedArr = (NSMutableArray*)[arrNews  sortedArrayUsingDescriptors:@[sd]];
                gArrAllBookingHistory = [NSMutableArray arrayWithArray:sortedArr];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}

+(void)getBookingHistory:(NSString*)memberId success:(void (^)(NSArray*))success
                 failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_BOOKING_HISTORY]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:memberId forKey:@"memberId"];
    
    __weak ASIFormDataRequest *request_ = request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get news");
                NSMutableArray *arrNews=[self parserListBookingHistory:jsonDic[@"result"]];
                if(arrNews)
                    [[ModelManager shareInstance] saveBookingHistoryToDB:arrNews];
                if(success)
                       success(arrNews);
            }
            else
            {
                NSArray* arr = [[ModelManager shareInstance] loadBookingHistoryFromDB];
                if(success)
                    success(arr);
            }
        }
    }];
    [request setFailedBlock:^{
//        NSError *error =[request_ error];
//        if(failure)
//            failure(error);
        
        NSArray* arr = [[ModelManager shareInstance] loadBookingHistoryFromDB];
        if(success)
            success(arr);
    }];
    [request startAsynchronous];
}

+(void)getListSOSInfo:(void (^)(NSArray*))success
              failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_LIST_SOS_INFO]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    __weak ASIHTTPRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get service");
                NSMutableArray *arrNews=[self parserListSOSInfo:[jsonDic objectForKey:@"result"]];
                if(arrNews.count>0)
                    [[ModelManager shareInstance] saveSOSinfoToDB:arrNews];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}
+(void)getQuickDealer:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_QUICK_DEALER]];
    __block ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        //DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
        NSLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get dealer Quick service");
                NSMutableArray *arrNews=[self parserListDealer:[jsonDic objectForKey:@"result"]];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];


}
+(void)getAllDealer:(void (^)(NSArray*))success
            failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_LIST_ALL_DEALER ]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    __weak ASIHTTPRequest *request_ = request;
    
    [request setCompletionBlock:^{
        
        // Use when fetching text data
        NSError *e = nil;
        
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
		
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get service");
                NSMutableArray *arrNews=[self parserListDealer:[jsonDic objectForKey:@"result"]];
                if(arrNews.count>0)
                    [[ModelManager shareInstance] saveDealerToDB:arrNews];
                if(success)
                    success(arrNews);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
        [[ModelManager shareInstance]loadDelearFromDB];
    }];
    [request startAsynchronous];
}

+(void)getVehicle:(NSString*)VINnumber success:(void (^)(NSDictionary*))success
          failure:(void (^)(NSError *))failure{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GET_CAR]];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    [request setPostValue:VINnumber forKey:@"VIN"];
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        
        NSError *e = nil;
        
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        
		
        DebugLog(@"Server response dict: %@", jsonDic);
        
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            if(jsonDic[@"result"])
            {
                NSLog(@"success get car");
                success(jsonDic);
            }
            else if(failure)
                failure(e);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
    
    
}

//+(void)getCar:(NSString *)vinNumber
+(void)addCar:(NSString*)memberId vinNumber:(NSString*)vinNumber licensePlate:(NSString*)licensePlate andVehicleModel:(NSString*)vehicelModel withSuccess:(void (^)(NSDictionary*))success
      failure:(void (^)(NSError *))failure{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_ADD_CAR]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:memberId forKey:@"memberId"];
    [request setPostValue:vinNumber forKey:@"VIN"];
    [request setPostValue:licensePlate forKey:@"license_plate"];
    [request setPostValue:vehicelModel forKey:@"model_description"];
    
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            success(jsonDic);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}
+(void)updateStatusCar:(NSString*)carId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_UPDATESTATUS_CAR]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:carId forKey:@"carId"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            [Vehicle deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"vehicleId == %@",carId]];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            gArrMyCar = [[ModelManager shareInstance] loadVehicleFromDB];
            if (gArrMyCar.count==0) {
                gArrMyCar=nil;
            }

            success();
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];


}
+(void)removeCar:(NSString*)carId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_REMOVE_CAR]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:carId forKey:@"carId"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        DebugLog(@"Server response string: %@", responseString);
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            
            [Vehicle deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"vehicleId == %@",carId]];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            gArrMyCar = [[ModelManager shareInstance] loadVehicleFromDB];
            if (gArrMyCar.count==0) {
                gArrMyCar=nil;
            }
            success();
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}


+(void)removeEvent:(NSString*)bookingHistoryId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_REMOVE_EVENT]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:bookingHistoryId forKey:@"eventId"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            [BookingHistory deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"bookingHistoryId == %@",bookingHistoryId]];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
            gArrAllBookingHistory = [NSMutableArray arrayWithArray:[[ModelManager shareInstance] loadBookingHistoryFromDB]];
            
            success();
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}

+(void)updateProfileWithMemberId:(NSString *)memberId name:(NSString *)name tel:(NSString *)tel address:(NSString *)address withSuccess:(void (^)())success failure:(void(^)(NSError*))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_UPDATE_PROFILE]];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:USER_NAME];
    [request setPassword:PASSWORD];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:memberId forKey:@"memberId"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:tel forKey:@"tel"];
    
    __weak ASIFormDataRequest *request_ = request;
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *e = nil;
        //        NSString *responseString = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
        DebugLog(@"Server response dict: %@", jsonDic);
        if (!jsonDic) {
            NSLog(@"Error parsing JSON: %@", e);
            if(failure)
                failure(e);
        } else {
            success();
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request_ error];
        if(failure)
            failure(error);
    }];
    [request startAsynchronous];
}

+(void)deleteAllData
{
    [BookingHistory deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    [Vehicle deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    [Util setValue:nil forKey:KEY_MEMBER_ID];
    [Util setValue:nil forKey:KEY_FAVORITE_VEHICLE];
    [Util setValue:nil forKey:KEY_FAVORITE_VEHICLE_ID];
    [Util setValue:nil forKey:KEY_DEFAULT_BRANCH];
    [Util setValue:nil forKey:KEY_DEFAULT_BRANCH_ID];
}

#pragma mark - PARSER FUNCTIONS

+(NSMutableArray*)parserListNews:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    
    NewsObj *tempobj;
    
    NSDictionary *dicTemp;
    @try {
        
        NSDictionary *tranlateDict;
        NSDictionary *imageDict;
        NSDictionary *videoDict;
        
        if(arrDict)
            
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[NewsObj alloc] init];
                tempobj.publicId=[Validator getSafeString:[dicTemp valueForKey:@"public_id"]];
                tempobj.code=[Validator getSafeString:[dicTemp valueForKey:@"code"]];
                tempobj.title=[Validator getSafeString:[dicTemp valueForKey:@"title"]];
                tempobj.mediaType=[Validator getSafeString:[dicTemp valueForKey:@"media_type"]];
                tempobj.lang = [Validator getSafeString:[dicTemp valueForKey:@"lang"]];
                
                imageDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"image_url"]]];
                tempobj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[Validator getSafeString:[imageDict objectForKey:@"real_name"]]];
                UIImageView *imgView=[[UIImageView alloc]init];
                [imgView setImageWithURL:[NSURL URLWithString:tempobj.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if(image) imgView.image = image;
                    
                }];
                //

//                
//                videoDict = [Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"video_url"]]];
//                NSString* videoUrl = [Validator getSafeString:[videoDict objectForKey:@"real_name"]];
//                if([videoUrl isEqualToString:@""]) tempobj.videoUrl = @"";
//                else
//                    tempobj.videoUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,videoUrl];
                tempobj.videoUrl = [dicTemp objectForKey:@"video_url"];
                tranlateDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"translation"]]];
                if(tranlateDict != nil && tranlateDict.allValues.count>0)
                tempobj.tranlation = [Util convertJSONToObject: [Validator getSafeString:[[tranlateDict allValues] objectAtIndex:0]]];
                
                
                tempobj.description=[Validator getSafeString:[dicTemp valueForKey:@"description"]];
                tempobj.shortDescription=[Validator getSafeString:[dicTemp valueForKey:@"short"]];
                
                
                tempobj.createdTime=[Validator getSafeString:[dicTemp valueForKey:@"createdTime"]];
                tempobj.updatedTime=[Validator getSafeString:[dicTemp valueForKey:@"updatedTime"]];
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser news error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
}

+(NSMutableArray*)parserListSlotTime:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    
    SlotTimeObj *tempobj;
    
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[SlotTimeObj alloc] init];
                tempobj.dealerSlotId=[Validator getSafeString:[dicTemp valueForKey:@"dealer_slot_id"]];
                tempobj.slotName=[Validator getSafeString:[dicTemp valueForKey:@"slot_name"]];
                tempobj.dealerId=[Validator getSafeString:[dicTemp valueForKey:@"dealer_id"]];
                tempobj.available=[Validator getSafeString:[dicTemp valueForKey:@"available"]];
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser dealer error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
}

+(NSMutableArray*)parserListDealer:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    
    DealerObj *tempobj;
    
    NSDictionary *dicTemp;
    NSString *gpsString;
    NSArray *arrCooordinate;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[DealerObj alloc] init];
                tempobj.objId=[Validator getSafeString:[dicTemp valueForKey:@"dealer_id"]];
                tempobj.name=[Validator getSafeString:[dicTemp valueForKey:@"dealer_name"]];
                tempobj.address=[Validator getSafeString:[dicTemp valueForKey:@"address"]];
                tempobj.phone=[Validator getSafeString:[dicTemp valueForKey:@"tel"]];
                tempobj.openingHour=[Validator getSafeString:[dicTemp valueForKey:@"open_hours"]];
                tempobj.email=[Validator getSafeString:[dicTemp valueForKey:@"email"]];
                tempobj.description=[Validator getSafeString:[dicTemp valueForKey:@"description"]];
                gpsString=[Validator getSafeString:[dicTemp valueForKey:@"GPS"]];
                arrCooordinate=[gpsString componentsSeparatedByString:@":"];
                if([arrCooordinate count]==2)
                {
                    tempobj.latitude= [ Validator getSafeFloat:[arrCooordinate objectAtIndex:0]];
                    tempobj.longitude=[ Validator getSafeFloat:[arrCooordinate objectAtIndex:1]];
                }else{
                    tempobj.latitude = 0.0;
                    tempobj.longitude = 0.0;
                }
                tempobj.imageUrl=[Validator getSafeString:[dicTemp valueForKey:@"image"]];
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser dealer error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
    
}
+(UIImage *)parserSplash:(NSDictionary *)arrDict{
    NSLog(@"Dict:%@",arrDict);
    // dicTemp=[arrDict objectAtIndex:0];
    
    NSString *Name=[arrDict objectForKey:@"client_name"];
    NSString *link=[arrDict objectForKey:@"real_name"];
    NSString *linkBase=[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,link];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:linkBase]]];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
    if (image) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir,Name];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data1 writeToFile:pngFilePath atomically:YES];
        [Util setObject:Name forKey:@"splash"];
        
    }
	
    if (image) {
         return image;
    }
    else{
        UIImage *img=[UIImage imageNamed:@""];
        return img;
    }
    
    
    
}
+(UIImage *)parserLogo:(NSDictionary *)arrDict{
    NSLog(@"Dict:%@",arrDict);
    // dicTemp=[arrDict objectAtIndex:0];
    NSString *Name=[arrDict objectForKey:@"client_name"];
    NSString *link=[arrDict objectForKey:@"real_name"];
    NSString *linkBase=[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,link];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:linkBase]]];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
    if (image) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir,Name];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data1 writeToFile:pngFilePath atomically:YES];
        [Util setObject:Name forKey:@"iconName"];
    }
	if (image) {
        return image;
    }
    else{
        UIImage *img=[UIImage imageNamed:@""];
        return img;
    }
    
    
    
    
}
+(NSMutableArray*)parserListProduct:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    
    ProductObj *tempobj;
    
    NSDictionary *dicTemp;
    @try {
        NSDictionary *tranlateDict;
        NSDictionary *tempImageItemDict;
        NSArray *imageArrDict;
        NSMutableArray *imageArr;
        
        
        if(arrDict)
            
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[ProductObj alloc] init];
                tempobj.objId=[Validator getSafeString:[dicTemp valueForKey:@"product_id"]];
                tempobj.name=[Validator getSafeString:[dicTemp valueForKey:@"product_name"]];
                tempobj.collectionId=[Validator getSafeString:[dicTemp valueForKey:@"collection_id"]];
                tempobj.description=[Validator getSafeString:[dicTemp valueForKey:@"description"]];
                tempobj.productName=[Validator getSafeString:[dicTemp valueForKey:@"product_name"]];
                tempobj.status=[Validator getSafeString:[dicTemp valueForKey:@"status"]];
                tempobj.lang = [Validator getSafeString:[dicTemp valueForKey:@"lang"]];
                tempobj.price = [Validator getSafeString:[dicTemp valueForKey:@"price"]];
                tempobj.code  = [Validator getSafeString:[dicTemp valueForKey:@"code"]];
                
                imageArrDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"image"]]];
                if([tempobj.objId isEqualToString:@"38"])
                {
                    NSLog(@"xxxx");
                }
                imageArr=[[NSMutableArray alloc] init];
                for (int y=0; y<[imageArrDict count]; y++) {
                    tempImageItemDict=[Util convertJSONToObject:[imageArrDict objectAtIndex:y]];
                    NSLog(@"link img:%@",[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[tempImageItemDict valueForKey:@"real_name"]]]);
                    UIImageView *imgView=[[UIImageView alloc]init];
                    NSLog(@">>>>>imgImage:%@",[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[tempImageItemDict valueForKey:@"real_name"]]]);
                    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[tempImageItemDict valueForKey:@"real_name"]]]] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        if(image) imgView.image = image;
                        
                    }];
                    [imageArr addObject:[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[tempImageItemDict valueForKey:@"real_name"]]]];
                }
                
                tempobj.arrImage=imageArr;
                //                DebugLog(@"Image array : %@",tempobj.arrImage);
                
                tranlateDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"translation"]]];
                if(tranlateDict && tranlateDict.allValues.count>0)
                tempobj.translate= [Util convertJSONToObject: [Validator getSafeString: [[tranlateDict allValues] objectAtIndex:0]]];
                
                [arrResult addObject:tempobj];
                
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser product error %@",exception.description);
    }
    @finally {
        
    }
    return arrResult;
    
    
    
}
+(NSMutableArray*)parserListService:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    ServiceObj *tempobj;
    
    NSDictionary *dicTemp;
    @try {
        NSDictionary *tranlateDict;
        NSDictionary *imageDict;
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[ServiceObj alloc] init];
                tempobj.name=[Validator getSafeString:[dicTemp valueForKey:@"cateName"]];
                tempobj.categoryId=[Validator getSafeString:[dicTemp valueForKey:@"categoryId"]];
                tempobj.categoryName=[Validator getSafeString:[dicTemp valueForKey:@"cateName"]];
                tempobj.parentId=[Validator getSafeString:[dicTemp valueForKey:@"parentId"]];
                tempobj.parentName=[Validator getSafeString:[dicTemp valueForKey:@"parentName"]];
                tempobj.description = [Validator getSafeString:[dicTemp valueForKey:@"description"]];
                
                tempobj.type=[Validator getSafeString:[dicTemp valueForKey:@"type"]];
                tempobj.level=[Validator getSafeString:[dicTemp valueForKey:@"level"]];
                
                imageDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"image"]]];
                tempobj.image=[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[imageDict  valueForKey:@"real_name"]]];
                
                tempobj.telephone = [Validator getSafeString:[dicTemp valueForKey:@"telephone"]];
                if ([Validator getSafeString:[dicTemp valueForKey:@"is_fastlane"]]!=nil) {
                    tempobj.isFastLane = [Validator getSafeString:[dicTemp valueForKey:@"is_fastlane"]];
                }
                
                
                tranlateDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"translation"]]];
                if(tranlateDict != nil && tranlateDict.allValues.count>0)
                    tempobj.translation = [[tranlateDict allValues] objectAtIndex:0];
                
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        
        DebugLog(@"Parser service error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
    
}
+(NSMutableArray*)parserListCollection:(NSArray*)arrDict{
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    ServiceObj *tempobj;
    
    NSDictionary *dicTemp;
    @try {
        NSDictionary *tranlateDict;
        NSDictionary *imageDict;
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[ServiceObj alloc] init];
                tempobj.name=[Validator getSafeString:[dicTemp valueForKey:@"cateName"]];
                tempobj.categoryId=[Validator getSafeString:[dicTemp valueForKey:@"categoryId"]];
                tempobj.categoryName=[Validator getSafeString:[dicTemp valueForKey:@"cateName"]];

                tempobj.parentId=[Validator getSafeString:[dicTemp valueForKey:@"parentId"]];
                tempobj.parentName=[Validator getSafeString:[dicTemp valueForKey:@"parentName"]];
                
                tempobj.type=[Validator getSafeString:[dicTemp valueForKey:@"type"]];
                tempobj.level=[Validator getSafeString:[dicTemp valueForKey:@"level"]];
                
                imageDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"image"]]];
                
                tempobj.image=[NSString stringWithFormat:@"%@%@" ,IMAGE_BASE_URL,[Validator getSafeString:[imageDict  valueForKey:@"real_name"]]];
                
                tranlateDict=[Util convertJSONToObject:[Validator getSafeString:[dicTemp valueForKey:@"translation"]]];
                if(tranlateDict && tranlateDict.allKeys.count>0)
                tempobj.translation = [Util convertJSONToObject: [Validator getSafeString:[[tranlateDict allValues] objectAtIndex:0]]];
                
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        
        DebugLog(@"Parser collection error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
    
}

+(NSMutableArray*)parserListVehicle:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    VehicleObj *tempobj;
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[VehicleObj alloc] init];
                
                tempobj.vehicleId=[Validator getSafeString:[dicTemp valueForKey:@"car_id"]];
                tempobj.vehicleModel=[Validator getSafeString:[dicTemp valueForKey:@"model_description"]];
                tempobj.plateNumber=[Validator getSafeString:[dicTemp valueForKey:@"license_plate"]];
                tempobj.province=[Validator getSafeString:[dicTemp valueForKey:@"province"]];
                tempobj.insurancePhoneNumber=[Validator getSafeString:[dicTemp valueForKey:@"insurance_number"]];
                tempobj.VINNumber=[Validator getSafeString:[dicTemp valueForKey:@"VIN"]];
                tempobj.statusCar=[Validator getSafeString:[dicTemp valueForKeyPath:@"status"]];
                if ([tempobj.statusCar isEqual:KEY_ACTIVE]) {
                    [arrResult addObject:tempobj];
                }
                
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser vehicle error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
    
}
+(NSMutableArray*)parserListSOSInfo:(NSArray*)arrDict{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    SOSInfoObj *tempobj;
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                tempobj=[[SOSInfoObj alloc] init];
                tempobj.objId=[Validator getSafeString:[dicTemp valueForKey:@"id"]];
                tempobj.name=[Validator getSafeString:[dicTemp valueForKey:@"name"]];
                tempobj.phone=[Validator getSafeString:[dicTemp valueForKey:@"tel"]];
                
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser sos info error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
}

+(void)parserListVIN:(NSArray*)arrDict
{
    [VIN  deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                VIN*tempobj = [VIN createEntity];
                
                tempobj.objectId=[Validator getSafeString:[dicTemp valueForKey:@"id"]];
                tempobj.startVIN=[Validator getSafeString:[dicTemp valueForKey:@"start_vin"]];
                tempobj.endVIN=[Validator getSafeString:[dicTemp valueForKey:@"end_vin"]];
                tempobj.modelKey =[Validator getSafeString:[dicTemp valueForKey:@"model"]];
                tempobj.delFlag=[Validator getSafeString:[dicTemp valueForKey:@"del_flag"]];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser vehicle error %@",exception.reason);
    }
    @finally {
        
    }

}

+(void)parserListCarType:(NSArray*)arrDict
{

    [CarType deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                CarType*tempobj = [CarType createEntity];
                
                tempobj.modelKey=[Validator getSafeString:[dicTemp valueForKey:@"type_key"]];
                tempobj.modelDescription=[Validator getSafeString:[dicTemp valueForKey:@"model_description"]];
                [[NSManagedObjectContext MR_defaultContext] MR_save];
                
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser vehicle error %@",exception.reason);
    }
    @finally {
        
    }
}


+(NSMutableArray*)parserListBookingHistory:(NSArray*)arrDict
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    NSDictionary *dicTemp;
    @try {
        if(arrDict)
            for (NSInteger i=0; i<[arrDict count]; i++) {
                
                dicTemp=[arrDict objectAtIndex:i];
                BookingHistoryObj*tempobj = [[BookingHistoryObj alloc] init];
                
                tempobj.car_id=[Validator getSafeString:[dicTemp valueForKey:@"car_id"]];
                tempobj.dealer_id=[Validator getSafeString:[dicTemp valueForKey:@"dealer_id"]];
                tempobj.service_id=[Validator getSafeString:[dicTemp valueForKey:@"service_id"]];
                tempobj.note =[Validator getSafeString:[dicTemp valueForKey:@"detail"]];
                tempobj.objId=[Validator getSafeString:[dicTemp valueForKey:@"id"]];
                tempobj.status=[Validator getSafeString:[dicTemp valueForKey:@"status"]];
                tempobj.process = [Validator getSafeString:[dicTemp valueForKey:@"process"]];
                tempobj.date =[Validator getSafeString:[dicTemp valueForKey:@"event_date"]];
                tempobj.submitedTime=[Validator getSafeString:[dicTemp valueForKey:@"createdTime"]];
                tempobj.slotTime=[Validator getSafeString:[dicTemp valueForKey:@"slot_time"]];
                [arrResult addObject:tempobj];
            }
    }
    @catch (NSException *exception) {
        DebugLog(@"Parser vehicle error %@",exception.reason);
    }
    @finally {
        
    }
    return arrResult;
}

+(NSMutableArray*)getRootCollection:(NSArray*)arrAllCollection{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    if(arrAllCollection)
    {
        for (ServiceObj *item in arrAllCollection) {
            if([item.parentId isEqualToString:@""]||[item.parentId isEqualToString:@"0"])
                [arrResult addObject:item];
        }
    }
    
    return arrResult;
    
}

+(NSMutableArray*)getSubCollection:(NSArray*)arrAllCollecion andId:(NSString*)collectionid{
    
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    if(arrAllCollecion)
    {
        for (ServiceObj *item in arrAllCollecion) {
            if([item.parentId isEqualToString:collectionid])
                [arrResult addObject:item];
        }
    }
    
    return arrResult;
    
}

+(NSMutableArray*)getRootService:(NSArray*)arrAllService
{
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    if(arrAllService)
    {
        for (ServiceObj *item in arrAllService) {
            if([item.parentId isEqualToString:@""]||[item.parentId isEqualToString:@"0"])
                [arrResult addObject:item];
        }
    }
    return arrResult;
}

+(NSMutableArray*)getSubService:(NSArray*)arrAllService andId:(NSString*)serviceId
{
    NSMutableArray *arrResult=[[NSMutableArray alloc] init];
    
    if(arrAllService)
    {
        for (ServiceObj *item in arrAllService) {
            if([item.parentId isEqualToString:serviceId])
                [arrResult addObject:item];
        }
    }
    
    return arrResult;
}

#pragma mark - Load From DB

-(void)loadFromDB
{
    gArrAllSOSInfo = [[ModelManager shareInstance] loadSOSinfoFromDB];
    gArrAllCollection = [[ModelManager shareInstance] loadCollectionFromDB];
    gArrAllDealer     = [[ModelManager shareInstance] loadDelearFromDB];
    gArrAllService    = [[ModelManager shareInstance] loadServiceFromDB];
}

-(NSArray*)loadNewsFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    NewsObj *tempobj;
    NSArray* newsArr = [News findAll];
    newsArr = [newsArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int publicId1 = [((News*)obj1).publicId integerValue];
        int publicId2 = [((News*)obj2).publicId integerValue];
        if(publicId1>publicId2) return (NSComparisonResult)NSOrderedAscending;
        else return (NSComparisonResult)NSOrderedDescending;
    }];
    if(newsArr)
    {
        for (NSInteger i=0; i<[newsArr count]; i++) {
            News* news = [newsArr objectAtIndex:i];
        
            tempobj = [[NewsObj alloc] init];
            [tempobj copyFromNews:news];
            
            [arrResult addObject:tempobj];
        }
    }

    return arrResult;
}

-(NSArray*)loadCollectionFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    ServiceObj *tempobj;
    NSArray* collectionArr = [Collection findAll];
    
    if(collectionArr)
    {
        for (NSInteger i=0; i<[collectionArr count]; i++) {
            Collection* colleciton = [collectionArr objectAtIndex:i];
            
            tempobj = [[ServiceObj alloc] init];
            [tempobj copyFromProduct:colleciton];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

-(NSArray*)loadProductFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    ProductObj *tempobj;
    NSArray* productArr = [Product findAll];
    
    if(productArr)
    {
        for (NSInteger i=0; i<[productArr count]; i++) {
            Product* product = [productArr objectAtIndex:i];
            
            tempobj = [[ProductObj alloc] init];
            [tempobj copyFromProduct:product];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

-(NSArray*)loadSOSinfoFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    SOSInfoObj *tempobj;
    NSArray* sosArr = [SOSInfo findAll];
    
    if(sosArr)
    {
        for (NSInteger i=0; i<[sosArr count]; i++) {
            SOSInfo* sosInfo = [sosArr objectAtIndex:i];
            
            tempobj = [[SOSInfoObj alloc] init];
            [tempobj copyFromSOSInfo:sosInfo];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

-(NSArray*)loadDelearFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    DealerObj *tempobj;
    NSArray* dealerArr = [Dealer findAll];
    
    if(dealerArr)
    {
        for (NSInteger i=0; i<[dealerArr count]; i++) {
            Dealer* dealer = [dealerArr objectAtIndex:i];
            
            tempobj = [[DealerObj alloc] init];
            [tempobj copyFromDealer:dealer];
            
            [arrResult addObject:tempobj];
        }
    }
    
    return arrResult;
}

-(NSArray*)loadServiceFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    ServiceObj *tempobj;
    NSArray* serviceArr = [Service findAll];
    
    if(serviceArr)
    {
        for (NSInteger i=0; i<[serviceArr count]; i++) {
            Service* service = [serviceArr objectAtIndex:i];
            
            tempobj = [[ServiceObj alloc] init];
            [tempobj copyFromService:service];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

-(NSArray*)loadBookingHistoryFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    BookingHistoryObj *tempobj;
    NSArray* bookHistoryArr = [BookingHistory findAll];
    
    if(bookHistoryArr)
    {
        for (NSInteger i=0; i<[bookHistoryArr count]; i++) {
            BookingHistory* bookingHistory = [bookHistoryArr objectAtIndex:i];
            
            tempobj = [[BookingHistoryObj alloc] init];
            [tempobj copyFromBookingHistory:bookingHistory];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

-(NSArray*)loadVehicleFromDB
{
    NSMutableArray *arrResult=[[NSMutableArray alloc]init];
    VehicleObj *tempobj;
    NSArray* vehicelArr = [Vehicle findAll];
    
    if(vehicelArr)
    {
        for (NSInteger i=0; i<[vehicelArr count]; i++) {
            Vehicle* vehicle = [vehicelArr objectAtIndex:i];
            
            tempobj = [[VehicleObj alloc] init];
            [tempobj copyFromVehicle:vehicle];
            
            [arrResult addObject:tempobj];
        }
    }
    return arrResult;
}

#pragma mark - Save To Data Base Function

-(void)saveNewsToDB:(NSArray*)newsArr
{
    @try {
        for(int i = 0; i < newsArr.count; i++)
        {
            NewsObj* newsObj = [newsArr objectAtIndex:i];
            News* news;
            news = [News findFirstByAttribute:@"publicId" withValue:newsObj.publicId];
            if(news == nil)
            {
                news = [News createEntity];
                news.publicId = newsObj.publicId;
            }
            
            news.code     = newsObj.code;
            news.title    = newsObj.title;
            news.mediaType = newsObj.mediaType;
            news.lang      = newsObj.lang;
            news.imageUrl  = newsObj.imageUrl;
            news.videoUrl  = newsObj.videoUrl;
            
            news.descriptions = newsObj.description;
            news.shortDescriptions = newsObj.shortDescription;
            news.createTime   = newsObj.createdTime;
            news.updateTime   = newsObj.updatedTime;
            if(newsObj.tranlation)
                news.translation  = [Util convertObjectToJSON:newsObj.tranlation];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
        
        if([News countOfEntities]>=20)
        {
            NSArray* arr = [News findAll];
            
            //News* news = arr[2];
            //NSString* publicId = news.publicId;
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                int publicId1 = [((News*)obj1).publicId integerValue];
                int publicId2 = [((News*)obj2).publicId integerValue];
                if(publicId1>publicId2) return (NSComparisonResult)NSOrderedAscending;
                else return (NSComparisonResult)NSOrderedDescending;
            }];
            for(int i=20;i<arr.count;i++)
            {
                News* news = arr[i];
                [news deleteEntity];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveCollectionsToDB:(NSArray*)collecitonsArr
{
    [Collection deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    @try {
        for(int i = 0; i < collecitonsArr.count; i++)
        {
            ServiceObj* tempObj = [collecitonsArr objectAtIndex:i];
            Collection* collection = [Collection createEntity];
            
            collection.catName  = tempObj.name;
            collection.categoryId   = tempObj.categoryId;
            collection.catName      = tempObj.categoryName;
            collection.parentId     = tempObj.parentId;
            collection.parentName   = tempObj.parentName;
            
            collection.image        = tempObj.image;
            if(tempObj.translation)
                collection.translation  = [Util convertObjectToJSON:tempObj.translation];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveProductToDB:(NSArray*)productArr
{
    @try {
        for(int i = 0; i < productArr.count; i++)
        {
            ProductObj* tempObj = [productArr objectAtIndex:i];
            Product* product;
            product = [Product findFirstByAttribute:@"productId" withValue:tempObj.objId];
            if(product ==nil)
            {
                product = [Product createEntity];
                product.productId = tempObj.objId;
            }
            product.productName = tempObj.productName;
            product.collectionId = tempObj.collectionId;
            product.descriptions = tempObj.description;
            product.status = tempObj.status;
            product.price = tempObj.price;
            product.code = tempObj.code;
            
            if(tempObj.arrImage)
            {
                NSString* imgStr = @"";
                for (int i = 0; i < tempObj.arrImage.count;i++)
                {
                    if(i==tempObj.arrImage.count-1)
                        imgStr = [imgStr stringByAppendingString:[tempObj.arrImage objectAtIndex:i]];
                    else
                        imgStr = [imgStr stringByAppendingFormat:@"%@;",[tempObj.arrImage objectAtIndex:i]];
                }
                product.image = imgStr;
            }
            
            if(tempObj.translate)
                product.translate = [Util convertObjectToJSON:tempObj.translate];
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
        
//        if([Product countOfEntities]>=40)
//        {
//            NSArray* arr = [Product findAll];
//            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                int publicId1 = [((Product*)obj1).productId integerValue];
//                int publicId2 = [((Product*)obj2).productId integerValue];
//                if(publicId1>publicId2) return (NSComparisonResult)NSOrderedAscending;
//                else return (NSComparisonResult)NSOrderedDescending;
//            }];
//            for(int i=40;i<arr.count;i++)
//            {
//                Product* product = arr[i];
//                [product deleteEntity];
//            }
//            [[NSManagedObjectContext MR_defaultContext] MR_save];
//        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}


-(void)saveDealerToDB:(NSArray*)dealerArr
{
    [Dealer deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    
    @try {
        for(int i = 0; i < dealerArr.count; i++)
        {
            DealerObj* tempObj = [dealerArr objectAtIndex:i];
            Dealer* dealer = [Dealer createEntity];
            dealer.dealerId = tempObj.objId;
            dealer.dealerName   = tempObj.name;
            dealer.address  = tempObj.address;
            dealer.phone    = tempObj.phone;
            dealer.openingHour = tempObj.openingHour;
            dealer.email       = tempObj.email;
            dealer.descriptions = tempObj.description;
            dealer.latitude = [NSString stringWithFormat:@"%f", tempObj.latitude];
            dealer.longtitude = [NSString stringWithFormat:@"%f",tempObj.longitude];
            dealer.imageUrl = tempObj.imageUrl;
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveSOSinfoToDB:(NSArray*)sosInfoArr
{
    [SOSInfo deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    @try {
        for(int i = 0; i < sosInfoArr.count; i++)
        {
            SOSInfoObj* tempObj = [sosInfoArr objectAtIndex:i];
            SOSInfo* sosInfo = [SOSInfo createEntity];
            sosInfo.sosId = tempObj.objId;
            sosInfo.name     = tempObj.name;
            sosInfo.tel      = tempObj.phone;
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveServiceToDB:(NSArray*)serviceArr
{
    [Service deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    @try {
        for(int i = 0; i < serviceArr.count; i++)
        {
            ServiceObj* tempObj = [serviceArr objectAtIndex:i];
            Service* service = [Service createEntity];
            service.name = tempObj.name;
            service.categoryId  = tempObj.categoryId;
            service.categoryName    = tempObj.categoryName;
            service.parentId    = tempObj.parentId;
            service.parentName  = tempObj.parentName;
            service.desctiptions    = tempObj.description;
            service.type        = tempObj.type;
            service.level       = tempObj.level;
            service.image       = tempObj.image;
            service.telephone   = tempObj.telephone;
            service.isFastLane=tempObj.isFastLane;

            if(tempObj.translation)
                service.translation  = [Util convertObjectToJSON:tempObj.translation];
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveBookingHistoryToDB:(NSArray*)bookingHistoryArr
{
    [BookingHistory deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    @try {
        for(int i = 0; i < bookingHistoryArr.count; i++)
        {
            BookingHistoryObj* tempObj = [bookingHistoryArr objectAtIndex:i];
            BookingHistory* bookingHistory = [BookingHistory createEntity];
            
            bookingHistory.car_id = tempObj.car_id;
            bookingHistory.dealer_id = tempObj.dealer_id;
            bookingHistory.service_id = tempObj.service_id;
            bookingHistory.note     = tempObj.note;
            bookingHistory.status   = tempObj.status;
            bookingHistory.bookingHistoryId = tempObj.objId;
            bookingHistory.date     = tempObj.date;
            bookingHistory.process  = tempObj.process;
            bookingHistory.submitedTime=tempObj.submitedTime;
            bookingHistory.slotTime=tempObj.slotTime;
            
            [[NSManagedObjectContext MR_defaultContext] MR_save];
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

-(void)saveVehicleToDB:(NSArray*)vehicleArr
{
    [Vehicle deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    @try {
        for(int i = 0; i < vehicleArr.count; i++)
        {
            VehicleObj* tempObj = [vehicleArr objectAtIndex:i];
            Vehicle* vehicle = [Vehicle createEntity];
            vehicle.vehicleId   = tempObj.vehicleId;
            vehicle.vehicleModel    = tempObj.vehicleModel;
            vehicle.plateNumber     = tempObj.plateNumber;
            vehicle.province        = tempObj.province;
            vehicle.insurancePhoneNumber    = tempObj.insurancePhoneNumber;
            vehicle.vinNumber       = tempObj.VINNumber;
            if ([tempObj.statusCar isEqual:KEY_ACTIVE]) {
                vehicle.statusCar=tempObj.statusCar;
                
                [[NSManagedObjectContext MR_defaultContext] MR_save];
            }
           
        }
    }
    @catch (NSException *exception) {
        DebugLog(@"save to DB exception : %@",exception);
    }
    @finally {
        
    }
}

#pragma mark find FUNCTIONS

+(VehicleObj*)getVehicleById:(NSString*)car_id
{
    if(gArrMyCar == nil || gArrMyCar.count == 0) return nil;
    NSArray* arr = [gArrMyCar filteredArrayUsingPredicate:[NSPredicate
                                          predicateWithFormat:@"vehicleId == %@", car_id]];
    if (arr && arr.count > 0) {
        return [arr objectAtIndex:0];
    }else
        return nil;
}
+(DealerObj*)getDealerById:(NSString*)dealer_id
{
    if(gArrAllDealer == nil || gArrAllDealer.count == 0) return nil;
    NSArray* arr = [gArrAllDealer filteredArrayUsingPredicate:[NSPredicate
                                                                   predicateWithFormat:@"objId == %@", dealer_id]] ;
    if (arr && arr.count > 0) {
        return [arr objectAtIndex:0];
    }else
        return nil;

}
+(ServiceObj*)getServiceById:(NSString*)service_id
{
    if(gArrAllService == nil || gArrAllService.count == 0) return nil;
    NSArray* arr = [gArrAllService filteredArrayUsingPredicate:[NSPredicate
                                                                   predicateWithFormat:@"categoryId == %@", service_id]] ;
    if (arr && arr.count > 0) {
        return [arr objectAtIndex:0];
    }else
        return nil;
}

+(NSString*)getModelDescriptionByVIN:(NSString*)vinNumber
{
    NSString* modelKey = @"";
    NSArray* VINArr = [VIN findAll];
    for ( VIN* vin in VINArr)
    {
        if([vinNumber compare:vin.endVIN] != NSOrderedDescending)
        {
            if([vinNumber compare:vin.startVIN] != NSOrderedAscending)
            {
                modelKey = vin.modelKey;
                CarType* carType = [CarType findFirstByAttribute:@"modelKey" withValue:modelKey];
                if(carType)
                    return [Validator getSafeString:carType.modelDescription];
                break;
            }
        }
    }
    return modelKey;
}

@end
