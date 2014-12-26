//
//  ModelManager.h
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Validator.h"
#import "NewsObj.h"
#import "SOSInfoObj.h"
#import "DealerObj.h"
#import "CommonObj.h"
#import "VehicleObj.h"
#import "Util.h"
#import "ProductObj.h"
#import "ServiceObj.h"
#import "BookingHistoryObj.h"

@interface ModelManager : NSObject


+(ModelManager*)shareInstance;

#pragma mark  API CALL

+(void)getInit:(NSString*)lastUpdatedDate andDownloadProgressDelegate:(UIView*)myProgressIndicator withSuccess:(void (^)(BOOL))success
       failure:(void (^)(NSError *))failure;
+(void)login:(NSString*)email pushId:(NSString*)pushId osType:(NSString*)osType withSuccess:(void (^)(NSMutableArray*))success
     failure:(void (^)(NSError *))failure;


+(void)registerWithName:(NSString*)name email:(NSString*)email phone:(NSString*)phone vinNumber:(NSString*)vinNumber licensePlate:(NSString*)licensePlate andVehicleModel:(NSString*)vehicelModel pushId:(NSString*)pushId osType:(NSString*)osType withSuccess:(void (^)(NSDictionary*))success
                failure:(void (^)(NSError *))failure;

+(void)getService:(void (^)(NSArray*))success
          failure:(void (^)(NSError *))failure;

+(void)getSlotTimeByDearlerId:(NSString*)dealerId withDate:(NSString*)date andSuccess:(void (^)(NSMutableArray*))success
                      failure:(void (^)(NSError *))failure;

+(void)getDealerByServiceId:(NSString*)serviceId andSuccess:(void (^)(NSArray*))success
                    failure:(void (^)(NSError *))failure;

+(void)getCollection:(void (^)(NSArray*))success
             failure:(void (^)(NSError *))failure;

+(void)getProductByCollectionId:(NSString*)collectionId start:(int)start limit:(int)limit andSucess:(void (^)(NSMutableArray*))success
                        failure:(void (^)(NSError *))failure;

+(void)getNewsWithStart:(int)start limit:(int)limit andSucess:(void (^)(NSArray*))success
       failure:(void (^)(NSError *))failure;

+(void)addEventWithMemberId:(NSString*)memberId  cardId:(NSString*)carId dealerId:(NSString*)dealerId eventDate:(NSString*)eventDate serviceId:(NSString *)serviceId eventName:(NSString *)eventName andDetail:(NSString *)detail slotTime:(NSString*)slotTime success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

+(void)updateEventWithEventId:(NSString*)eventId memberId:(NSString*)memberId  cardId:(NSString*)carId dealerId:(NSString*)dealerId eventDate:(NSString*)eventDate serviceId:(NSString*)serviceId eventName:(NSString*)eventName andDetail:(NSString*)detail slotTime:(NSString*)slotTime success:(void (^)(NSArray*))success
                      failure:(void (^)(NSError *))failure;

+(void)getBookingHistory:(NSString*)memberId success:(void (^)(NSArray*))success
                 failure:(void (^)(NSError *))failure;

+(void)getListSOSInfo:(void (^)(NSArray*))success
       failure:(void (^)(NSError *))failure;

+(void)getAllDealer:(void (^)(NSArray*))success
              failure:(void (^)(NSError *))failure;


+(void)getQuickDealer:(void (^)(NSArray*))success
            failure:(void (^)(NSError *))failure;
+(void)getVehicle:(NSString*)VINnumber success:(void (^)(NSDictionary*))success
            failure:(void (^)(NSError *))failure;

+(void)addCar:(NSString*)memberId vinNumber:(NSString*)vinNumber licensePlate:(NSString*)licensePlate andVehicleModel:(NSString*)vehicelModel withSuccess:(void (^)(NSDictionary*))success
                failure:(void (^)(NSError *))failure;

+(void)removeCar:(NSString*)carId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure;
+(void)updateStatusCar:(NSString*)carId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure;
+(void)removeEvent:(NSString*)bookingHistoryId withSuccess:(void (^)())success failure:(void(^)(NSError*))failure;

+(void)updateProfileWithMemberId:(NSString*)memberId name:(NSString*)name tel:(NSString*)tel address:(NSString*) address withSuccess:(void (^)())success failure:(void(^)(NSError*))failure;

+(void)deleteAllData;

#pragma mark  PARSER FUNCTIONS

+(NSMutableArray*)parserListNews:(NSArray*)arrDict;
+(NSMutableArray*)parserListDealer:(NSArray*)arrDict;
+(NSMutableArray*)parserListProduct:(NSArray*)arrDict;
+(NSMutableArray*)parserListService:(NSArray*)arrDict;
+(NSMutableArray*)parserListCollection:(NSArray*)arrDict;
+(NSMutableArray*)parserListVehicle:(NSArray*)arrDict;
+(NSMutableArray*)parserListSOSInfo:(NSArray*)arrDict;
+(NSMutableArray*)getRootCollection:(NSArray*)arrAllCollection;
+(NSMutableArray*)getSubCollection:(NSArray*)arrAllCollecion andId:(NSString*)collectionid;
+(NSMutableArray*)getRootService:(NSArray*)arrAllService;
+(NSMutableArray*)getSubService:(NSArray*)arrAllService andId:(NSString*)serviceId;
+(NSMutableArray*)parserListBookingHistory:(NSArray*)arrDict;

#pragma mark - Load From DB
-(NSArray*)loadNewsFromDB;
-(NSArray*)loadCollectionFromDB;
-(NSArray*)loadProductFromDB;

#pragma mark - saveDB
-(void)saveVehicleToDB:(NSArray*)vehicleArr;
-(NSArray*)loadBookingHistoryFromDB;
#pragma mark find FUNCTIONS

+(VehicleObj*)getVehicleById:(NSString*)car_id;
+(DealerObj*)getDealerById:(NSString*)dealer_id;
+(ServiceObj*)getServiceById:(NSString*)service_id;
+(NSString*)getModelDescriptionByVIN:(NSString*)vinNumber;


@end

