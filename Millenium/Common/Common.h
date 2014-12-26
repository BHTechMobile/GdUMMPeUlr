//
//  Common.h
//  Millenium
//
//  Created by duc le on 2/20/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <Foundation/Foundation.h>

//SERVICE CONFIG

#define  USER_NAME                @"admin"
#define  PASSWORD                 @"zEV3n76HLPYworOFBXPy"


//#define BASE_URL                  @"http://115.146.126.146/car/en/api/"
//#define IMAGE_BASE_URL            @"http://115.146.126.146/car/"
//#define BASE_URL                  @"http://minii.asia/mlapp/en/api/"
//#define IMAGE_BASE_URL            @"http://minii.asia/mlapp/"
#define BASE_URL                  @"http://mgcmobileapp.mgc-asia.com/en/api/"
#define IMAGE_BASE_URL            @"http://mgcmobileapp.mgc-asia.com/"
#define URL_GET_INIT              @"getInit"
#define URL_LOGIN                 @"login"
#define URL_REGISTER              @"register"
#define URL_GET_SERVICE           @"getService"
#define URL_GET_DEALER            @"getDealer"
#define URL_GET_TIME_SLOT         @"getTimeSlot"
#define URL_GET_COLLECTION        @"getCollection"
#define URL_GET_PRODUCT           @"getProduct"
#define URL_GET_NEWS              @"getNew"
#define URL_ADD_EVENT             @"addEvent"
#define URL_UPDATE_EVENT          @"updateEvent"
#define URL_GET_PRODUCT           @"getProduct"
#define URL_GET_BOOKING_HISTORY   @"getBookingHistory"
#define URL_GET_LIST_SOS_INFO     @"getListSOSInfo"
#define URL_GET_LIST_ALL_DEALER   @"getAllDealer"
#define URL_GET_QUICK_DEALER      @"getQuickDealer"
#define URL_UPDATE_PROFILE        @"updateProfile"
#define URL_GET_CAR               @"getCar"
#define URL_ADD_CAR               @"addCar"
#define URL_REMOVE_CAR            @"removeCar"
#define URL_UPDATESTATUS_CAR      @"updateCar"
#define URL_REMOVE_EVENT          @"removeEvent"
#define URL_UPDATE_PROFILE        @"updateProfile"

#define DefaultLang               @"DefaultLanguage"
#define MyToken                   @"MyToken"
#define LastUpdate                @"Last Update"
//KEY CONFIG

#define KEY_MEMBER_ID             @"MEMBER_ID"
#define KEY_EMAIL                 @"EMAIL"
#define KEY_PHONE                 @"PHONE"
#define KEY_NAME                  @"NAME"
#define KEY_DEFAULT_BRANCH        @"DEFAULT_BRANCH"
#define KEY_FAVORITE_VEHICLE      @"FAVORITE_VEHICLE"
#define KEY_FAVORITE_VEHICLE_ID   @"FAVORITE_VEHICLE_ID"
#define KEY_DEFAULT_BRANCH_ID     @"DEFAULT_BRANCH_ID"
#define KEY_ACTIVE                @"1"
#define KEY_DEACTIVE                @"0"



//Multi lange guage

#define kNotifi_ChangeLange     @"Change language"
#define kNotifi_UpdateBookingHistory    @"Update booking history"
#define kNotifi_UpdateCalendarBooking   @"Update calendar booking"
#define KNotifi_reloadListVer            @"Reload list Ver"
#define kNotifi_UpdateDefaultCar        @"Update default car"
#define KNotifi_AddEventToCalendar      @"Add Event To Calendar"
#define kLang_Langugae          @"kLang_Langugae"

#define kLang_BMWCarService   @"kLang_BMWCarService"
#define kLang_News      @"kLang_News"
#define kLang_Services   @"kLang_Services"
#define kLang_Service    @"kLang_Service"
#define kLang_Booking    @"kLang_Booking"
#define kLang_Dealers   @"kLang_Dealers"
#define kLang_Collection  @"kLang_Collection"
#define kLang_SOS         @"kLang_SOS"

#define kLang_Emegency_Serivce  @"kLang_Emegency_Serivce"

#define kLang_NewsDetail    @"kLang_NewsDetail"
#define kLang_ProductDetail @"kLang_ProductDetail"
#define kLang_Back          @"kLang_Back"

#define kLang_EditProfile   @"kLang_EditProfile"
#define kLang_BookingHistory @"kLang_BookingHistory"
#define kLang_SelectVehicle  @"kLang_SelectVehicle"
#define kLang_SelectBranch   @"kLang_SelectBranch"
#define kLang_SelectDateTime  @"kLang_SelectDateTime"
#define kLang_SelectType    @"kLang_SelectType"
#define kLang_ServiceNote   @"kLang_ServiceNote"

#define kLang_RequestThisBooking  @"kLang_RequestThisBooking"
#define kLang_ConfirmThisBooking  @"kLang_ConfirmThisBooking"
#define kLang_YouhaveChoose_Vehicle @"kLang_YouhaveChoose_Vehicle"
#define kLang_YouhaveChoose_Service @"kLang_YouhaveChoose_Service"
#define kLang_YouhaveChoose_Branch  @"kLang_YouhaveChoose_Branch"
#define kLang_YouhaveChoose_Date  @"kLang_YouhaveChoose_Date"
#define kLang_YouhaveChoose_Date_Selected  @"kLang_YouhaveChoose_Date_Selected"
#define kLang_YouhaveChoose_Time  @"kLang_YouhaveChoose_Time"
#define kLang_YouhaveChoose_TimeServiceFrom8To17    @"kLang_YouhaveChoose_TimeServiceFrom8To17"
#define kLang_BookingService    @"kLang_BookingService"
#define kLang_BookService    @"kLang_BookService"
#define kLang_Vehicle       @"kLang_Vehicle"
#define kLang_MyVehicle     @"kLang_MyVehicle"
#define kLang_Branch        @"kLang_Branch"
#define kLang_Type      @"kLang_Type"
#define kLang_Date      @"kLang_Date"
#define kLang_Note      @"kLang_Note"
#define kLang_Status    @"kLang_Status"

#define kLang_OpenInAppleMap     @"kLang_OpenInAppleMap"
#define kLang_OpenInGoogleMap    @"kLang_OpenInGoogleMap"
#define kLang_DirectFromCur @"kLang_DirectFromCur"

#define kLang_CallSOS   @"kLang_CallSOS"
#define kLang_AreYouSure    @"kLang_AreYouSure"

#define kLang_YES       @"kLang_YES"
#define kLang_NO        @"kLang_NO"
#define kLang_OK        @"kLang_OK"
#define kLang_Cancel    @"kLang_Cancel"
#define kLang_Done      @"kLang_Done"
#define KLang_Error     @"KLang_Error"
#define kLang_BookingSent   @"kLang_BookingSent"
#define kLang_addEventSuccess   @"kLang_addEventSuccess"
#define kLang_PleaseWaitConfirm   @"kLang_PleaseWaitConfirm"
#define kLang_YouHavetoRegister   @"kLang_YouHavetoRegister"
#define kLang_YouHaveNoVehicle    @"kLang_YouHaveNoVehicle"

#define kLang_EditProfile   @"kLang_EditProfile"
#define kLang_Name      @"kLang_Name"
#define kLang_Email     @"kLang_Email"
#define kLang_SaveSuccessfully  @"kLang_SaveSuccessfully"
#define kLang_PleaseInputVIN    @"kLang_PleaseInputVIN"

#define kLang_DefaultVehicle    @"kLang_DefaultVehicle"
#define kLang_FavoriteBranch    @"kLang_FavoriteBranch"
#define kLang_Save  @"kLang_Save"
#define kLang_AddVehicle    @"kLang_AddVehicle"
#define kLang_ConnectToFacebook     @"kLang_ConnectToFacebook"
#define kLang_ConnectToTwitter      @"kLang_ConnectToTwitter"
#define kLang_ConnectedFB           @"kLang_ConnectedFB"
#define kLang_ConnectedTW           @"kLang_ConnectedTW"

#define kLang_PleaseInputYourVIN    @"kLang_PleaseInputYourVIN"
#define kLang_ScanQRCode    @"kLang_ScanQRCode"
#define kLang_CheckVIN      @"kLang_CheckVIN"
#define kLang_VehicleModel  @"kLang_VehicleModel"
#define kLang_Name          @"kLang_Name"
#define kLang_LicensePlate  @"kLang_LicensePlate"
#define kLang_RegisterVehicle   @"kLang_RegisterVehicle"

#define kLang_Plate         @"kLang_Plate"
#define kLang_Model         @"kLang_Model"
#define KLangChangeEvent    @"KLang_ChangeEvent"
#define KLangLocation       @ "KLang_location"
#define KLangbookingHasUpdated       @"KLang_bookingHasUpdated"
#define KLangConnectServer           @"KLang_ConnectServer"
#define KLangDoYouWantAddCalendar    @"KLang_DoYouWantAddCalendar"
#define kLang_DealerDetail  @"kLang_DealerDetail"
#define kLang_Address   @"kLang_Address"
#define kLang_OpeningHours @"kLang_OpeningHours"
#define kLang_Tel       @"kLang_Tel"

#define kLang_Call    @"kLang_Call"
#define kLang_Next    @"kLang_Next"
#define kLang_Previous  @"kLang_Previous"
#define kLang_Edit      @"kLang_Edit"
#define KLang_BookOnline @"KLang_BookOnline"
#define KLang_CallService @"KLang_CallService"
#define KLang_ChangeEvent @"kLang_ChangeEvent"
#define KLang_location @"kLang_location"
#define KLang_bookingHasUpdated @"kLang_bookingHasUpdated"
#define KLang_ConnectServer @"kLang_ConnectServer"
#define KLang_DoYouWantAddCalendar @"kLang_DoYouWantAddCalendar"

#define KLang_EditBookingFailure @"kLang_EditBookingFailure"
#define KLang_CanNotRemoveBooking @"kLang_CanNotRemoveBooking"
#define KLang_BookingFailure @"kLang_BookingFailure"

#define KLang_EmailAccountSettings @"kLang_EmailAccountSettings"
#define KLang_NoEmailAccount @"kLang_NoEmailAccount"
#define KLang_SureToCall @"kLang_SureToCall"
#define KLang_CanNotUpdateProfile @"kLang_CanNotUpdateProfile"
#define KLang_Savedlocalsuccessfully @"kLang_Savedlocalsuccessfully"
#define KLang_ServerSuccessfully @"KLang_ServerSuccessfully"
#define KLang_UseNewEmail @"KLang_UseNewEmail"

#define KLang_CanNotMakeCall @"kLang_CanNotMakeCall"
#define KLang_CallEmergencyService @"kLang_CallEmergencyService"
#define KLang_VINNumberInvalid @"kLang_VINNumberInvalid"
#define KLang_AddVehicleError @"kLang_AddVehicleError"
#define KLang_InputAllField @"kLang_InputAllField"

#define kLang_NoProductFound    @"kLang_NoProductFound"

// LAYOUT CONFIG

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

#define keyboard_h_iphone_portrait 216.
#define keyboard_h_iphone_landscape 162.
#define keyboard_h_ipad_portrait 264.
#define keyboard_h_ipad_landscape 352.



// COLOR UTIL

#define FS_UICOLOR_RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
