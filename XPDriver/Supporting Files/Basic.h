//
//  Basic.h
//  XPDriver
//
//  Created by Syed zia on 26/02/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Basic_h
#define Basic_h




#define MAXLENGTH           6
#define DOCUMENT_REDIUS     8.0f
#define ORIGINAL_MAX_WIDTH  640.0f
#define Minimum_Distance    50.0f
#define kOFFSET_FOR_KEYBOARD 80.0
#define CNIC_NUMBER_LENGHT   14
#define ROUTING_NUMBER_LENGHT 9
#define MIX_PASSWORD_LENGHT  4

#define kPayPalEnvironment PayPalEnvironmentSandbox


static NSString *const TextCheckingResultAttributeName = @"TextCheckingResultAttributeName";
#pragma mark - DropDown

#define kLabelAllowanceSize 30.0f
#define kStarViewHeight 17.0f
#define kStarViewWidth  100.0f
#define kLeftPadding    10.0f
#define KNoteViewYPostion 334.0
#define KNoteViewHight    ScreenHeight

#define KReviewYPostion 260.0
#define KReviewHight    200
#pragma mark - CGColors

#define White_ColorCG    [[UIColor whiteColor] CGColor]
#define Gray_colorCG     [[UIColor grayColor]  CGColor]
#define Black_colorCG    [[UIColor blackColor]  CGColor]
#pragma mark - UIcolor

#define Black_Color       [UIColor blackColor]
#define WHITE_COLOR       [UIColor whiteColor]
#define Gray_color        [UIColor grayColor]
#define CLEAR_COLOR          [UIColor clearColor]
#define LOADING_SPINNER_COLOR    UIColorFromRGB(0xF46F26,1.0)
#define LABEL_TEXT_COLOR         UIColorFromRGB(0x2E2E2E,1.0)
#define BG_COLOR                 UIColorFromRGB(0xFFFFFF,1.0)
#define ALERT_TITEL_COLOR        UIColorFromRGB(0x0b2d5a,1.0)
#define ALERT_BG_COLOR           UIColorFromRGB(0xd7d7d7,1.0)//0b2d5a
#define ALERT_BTN_COLOR          UIColorFromRGB(0x2E2E2E,1.0)//E83225
#define ALERT_CACEL_BTN_COLOR    UIColorFromRGB(0x0E83225,1.0)//
#define TITEL_COLOR              UIColorFromRGB(0x6bc752,1.0)
#define CELL_BG_COLOR            UIColorFromRGB(0x5e5f5f,1.0)
#define HIGHTLIGHT_COLOR         UIColorFromRGB(0x191b1d,1.0)
#define KEYBOARD_BAR_COLOR       UIColorFromRGB(0xF46F26,1.0)
#define UNDERLINE_COLOR          UIColorFromRGB(0x26ACF3,1.0)
#define TOPBAR_COLOR             UIColorFromRGB(0x3EA668,1.0)
#define PICKER_TITEL_COLOR       UIColorFromRGB(0xB40004,1.0)
#define PICKER_ITEM_COLOR        UIColorFromRGB(0x2E2E2E,1.0)
#define TEXTFIELD_TEXT_COLOR     UIColorFromRGB(0x4D4D4D,1.0)
#define TEXTFIELD_TINT_COLOR     UIColorFromRGB(0x0facf3,1.0)
#define IMG_BORDER_COLOR         UIColorFromRGB(0xF15A26,1.0)
#define AR_MSG_TEXT_COLOR        UIColorFromRGB(0x0C2048,1.0)
#define SEGMENT_BG_COLOR         UIColorFromRGB(0xF15A26,1.0)
#define SEGMENT_SELECTED_COLOR   UIColorFromRGB(0x2E2E2E,1.0)//0E378C
#define LIGHT_COLOR_TEXT         UIColorFromRGB(0x0E378C,1.0)//00a651
#define GRAY_COLOR        [UIColor grayColor]

//SWITCH

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define user_defaults_get_bool(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define user_defaults_get_int(key)    ((int) [[NSUserDefaults standardUserDefaults] integerForKey:key])
#define user_defaults_get_double(key) [[NSUserDefaults standardUserDefaults] doubleForKey:key]
#define user_defaults_get_string(key) fc_safeString([[NSUserDefaults standardUserDefaults] stringForKey:key])
#define user_defaults_get_array(key)  [[NSUserDefaults standardUserDefaults] arrayForKey:key]
#define user_defaults_get_object(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define user_defaults_set_bool(key, b)   { [[NSUserDefaults standardUserDefaults] setBool:b    forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_int(key, i)    { [[NSUserDefaults standardUserDefaults] setInteger:i forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_double(key, d) { [[NSUserDefaults standardUserDefaults] setDouble:d  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_string(key, s) { [[NSUserDefaults standardUserDefaults] setObject:s  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_array(key, a)  { [[NSUserDefaults standardUserDefaults] setObject:a  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_set_object(key, o) { [[NSUserDefaults standardUserDefaults] setObject:o  forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define user_defaults_remove_object(key) { [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }


#define SHOW_ALERT(title,msg,ButtonTitle)\
do { \
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *actionOk = [UIAlertAction actionWithTitle:ButtonTitle\
style:UIAlertActionStyleDefault\
handler:nil]; \
[alertController addAction:actionOk];\
[self presentViewController:alertController animated:YES completion:nil];\
}while(0);

#define showAlert(__TITLE__, __MSG__) [[[UIAlertView alloc] initWithTitle:__TITLE__ message:__MSG__ delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]




#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


#define strFormat(__FORMAT__,...) [NSString stringWithFormat:__FORMAT__,__VA_ARGS__]

#define strEquals(__STR__, __EQL1__) [__STR__ isEqualToString:__EQL1__]
#define strNotEquals(__STR__, __EQL1__) !strEquals(__STR__, __EQL1__)
#define strEqualsAny(__STR__, __EQL1__, __EQL2__,__EQL3__) [__STR__ isEqualToString:__EQL1__] || [__STR__ isEqualToString:__EQL2__] || [__STR__ isEqualToString:__EQL3__]

#define strEmpty(__STR__) (__STR__.length == 0)
#define strNotEmpty(__STR__) (__STR__.length != 0)
#define stringify(__DATA__) [[NSString alloc] initWithData:__DATA__ encoding:NSUTF8StringEncoding]

#define strAppend(__STR1__,__STR2__) [__STR1__ stringByAppendingString:__STR2__]

#define strAppendFormat(__STR__,__FORMAT__,...) [__STR__ stringByAppendingFormat:__FORMAT__,__VA_ARGS__]

#define fieldIsEmpty(__FIELD__) ([__FIELD__.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)

#define strUrl(__STR__) [NSURL URLWithString:__STR__]

#define imagify(__STR__) [UIImage imageNamed:__STR__]


#define colorify(__R__,__G__,__B__,__A__) [UIColor colorWithRed:__R__/255.0f green:__G__/255.0f blue:__B__/255.0f alpha:__A__]



#define MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
#define instantiateVC(__VC__) [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:__VC__]
#define JOB_STORYBOARD [UIStoryboard storyboardWithName:@"Job" bundle:[NSBundle mainBundle]]
#define Job_instantiateVC(__VC__) [JOB_STORYBOARD instantiateViewControllerWithIdentifier:__VC__]

#define INVITE_STORYBOARD [UIStoryboard storyboardWithName:@"InviteFriend" bundle:[NSBundle mainBundle]]
#define INVITE_instantiateVC(__VC__) [INVITE_STORYBOARD instantiateViewControllerWithIdentifier:__VC__]


#define pt(__X__,__Y__) CGPointMake(__X__,__Y__)
#define rect(__X__,__Y__,__W__,__H__) CGRectMake(__X__,__Y__,__W__,__H__)
#define size(__W__,__H__) CGSizeMake(__W__,__H__)

#define indexPathMake(__R__,__S__) [NSIndexPath indexPathForRow:__R__ inSection:__S__]

#define UA_invalidateTimer(t) [t invalidate]; t = nil;

#define UIColorFromRGB(__HEX__, __A__) [UIColor \
colorWithRed:((float)((__HEX__ & 0xFF0000) >> 16))/255.0 \
green:((float)((__HEX__ & 0xFF00) >> 8))/255.0 \
blue:((float)(__HEX__ & 0xFF))/255.0 alpha:__HEX__]

#define UIColorFromARGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0x00FF0000) >> 16)) / 255.0 green:((float)((argbValue & 0x0000FF00) >> 8)) / 255.0 blue:((float)(argbValue & 0x000000FF)) / 255.0 alpha:((float)((argbValue & 0xFF000000) >> 24)) / 255.0]

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SHAREMANAGER [ShareManager share]
#define LOCATION_SHAREMANAGER ([LocationTracker sharedLocationManager])
#define LOCATIONTRACKER  ([[LocationTracker alloc]init])
#define DELG       ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define isiPhone   (UI_USER_INTERFACE_IDIOM() == 0)?TRUE:FALSE
#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480)?TRUE:FALSE
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define isiPhone6  ([[UIScreen mainScreen] bounds].size.height == 667)?TRUE:FALSE
#define isiPhone6_plus  ([[UIScreen mainScreen] bounds].size.height == 736.0)?TRUE:FALSE

//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)





//#define Google_Map_Key  @"AIzaSyCGlEv3ubZWiYx2nzyKYhPjoE7R2V8rD1I"
//#define Google_Map_Key    @"AIzaSyB95HXl4-mxiH6kb8ex61WDc8E8Nbh2hRc"
//#define GOOGLE_PLEACE_KEY     @"AIzaSyB9mvZ901lJTPVhCjE2qx__jHIMSljVdKA"
//Form Niel
                            
#define Google_Map_Key         @"AIzaSyAc1S4BtUS6jbhmfYAnOgL1mgkvXTx1AUM"
//#define GOOGLE_PLEACE_KEY      @"AIzaSyAc1S4BtUS6jbhmfYAnOgL1mgkvXTx1AUM"
#define GOOGLE_PLEACE_KEY      @"AIzaSyBEJAb_ZUVwypgkpVH6WumOB4fwtx2478c"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_PuBXQ2DLcSzOluwbl4Yxf9k0"

//#define STRIPE_TEST_PUBLIC_KEY @"pk_live_pknwBp75l326B8fTRyeIeOZc"

#define STRIPE_TEST_POST_URL    @"https://trip.myxpapp.com/"
#define MAIN_URL                @"https://trip.myxpapp.com/"
#define baseUrl                 @"https://trip.myxpapp.com/"
#define KIMGBaseUrl             @"https://trip.myxpapp.com/upload/users"
#define KDOCBaseUrl             @"https://trip.myxpapp.com/upload/documents/"
#define kAPIHost                @"https://www.xpeats.com/api/"
#define KTERMSURL               @"https://www.xpeats.com/terms.blade.php"
#define KHelp_And_Support       @"https://trip.myxpapp.com/help.php"
#define KPrivacy_Policy         @"https://trip.myxpapp.com/policy.php"
#define KTerms_And_Condiotion   @"https://xpeats.com"
#define KRefund_Policy          @"https://trip.myxpapp.com/refundpolicy.php"
#define KContact_us             @"https://xpeats.com/#contact"
#define kAPIPath                @""

// Dev
 //static NSString * const AFAppDotNetAPIBaseURLString        = @"https://xpeats.mydoorbud.com/api/index.php";
// Live
static NSString * const AFAppDotNetAPIBaseURLString        = @"https://www.xpeats.com/api/";
static NSString * const KCountryPickerIdentifier       = @"PresentCountryPicker";
#define KSTRIPURL  @"https://trip.myxpapp.com/gateway/Stripe1.php?"
#define Kregister_stripe_url @"https://trip.myxpapp.com/gateway/register_stripe.php?"
#define KBase_MAP_URL @"http://maps.googleapis.com/maps/api/distancematrix/json?"
//#warning uncomment it for live app
#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#warning uncomment it for live app
#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
// Localized String
#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]

// TextField image
#define  DROPDOWN_ICON      imagify(@"dropdown_icon")
#define  RIGHT_IMAGE        imagify(@"right")
#define  WRONG_IMAGE        imagify(@"wrong")
#define  NO_IMAGE           imagify(@"no_image")
#define ALERT_BUTTON_IMAGE  imagify(@"btn_login")
#define NOTE_BG_IMAGE       imagify(@"note_bg")

#define ORANGE_BTN_IMAGE    imagify(@"b3")
#define RED_BTN_IMAGE       imagify(@"login_btn")

#define USER_PLACEHOLDER    imagify(@"user_placeholder")
#define DOCUMENT_PLACEHOLDER           imagify(@"document_placeholder")
#define PROFILE_BG_PLACEHOLDER imagify(@"user_profile_icon")
#define PROFILE_PLACEHOLDER    imagify(@"user_placeholder")//

#define V_PLACEHOLDER       imagify(@"v_placeholder")
#define PROFILE_BTN_IMAGE   imagify(@"profle-main")
#define CANCEL_BTN_IMAGE    imagify(@"cancel_ride")
#define CALL_BTN_IMAGE      imagify(@"call-main")

#define START_JOB_BTN_IMAGE imagify(@"start_job_btn")
#define END_JOB_BTN_IMAGE   imagify(@"end_job_btn")
#define NORMAL_BTN_IMAGE   imagify(@"b_main")
#define CHECKEDE_BTN_IMAGE   imagify(@"checked")
#define UNCHECKEDE_BTN_IMAGE   imagify(@"unchecked")
#define ONLINE_BTN_IMAGE   imagify(@"ic_go_online")
#define OFFLINE_BTN_IMAGE   imagify(@"ic_go_offline")
#pragma mark - maker images
//#define DRIVER_MARKER_IMAGE       [UIImage imageNamed:@"driver_marker"]
//#define PICKUP_MARKER_IMAGE       [UIImage imageNamed:@"pickup_marker"]
//#define DESTINATION_MARKER_IMAGE  [UIImage imageNamed:@"drop_marker"]
#define TF_PICKUP_MARKER        [UIImage imageNamed:@"pickup_marker"]
#define TF_DESTINATION_MARKER   [UIImage imageNamed:@"drop_marker"]

#define CURRENT_MARKER_IMAGE      [UIImage imageNamed:@"current_location_marker"]

#define PICKUP_MARKER_IMAGE        [UIImage imageNamed:@"pickup_point"]
#define DESTINATION_MARKER_IMAGE   [UIImage imageNamed:@"drop_point"]
// car Type
#define CAR_MAP         imagify(@"driver_marker_map")
#define BIKE_MAP        imagify(@"bike_marker_map")
//#define CAR_MAP         imagify(@"driver_marker")
#define VAN_MAP         imagify(@"car-wagon-map")
#define SUV_MAP         imagify(@"car-suv-map")
#define LEMO_MAP        imagify(@"car-black-map.png")


#define CAR         imagify(@"black_car_blue")
#define VAN         imagify(@"van_blue")
#define SUV         imagify(@"suv_blue")
#define LEMO        imagify(@"lemo_blue")

#define CAR_SELECTED         imagify(@"black_car_green")
#define VAN_SELECTED         imagify(@"van_green")
#define SUV_SELECTED         imagify(@"suv_green")
#define LEMO_SELECTED        imagify(@"lemo_green")


#define NOW              imagify(@"now_green")
#define TODAY            imagify(@"today_green")
#define TOMORROW         imagify(@"tomorrow_green")
#define LATER            imagify(@"later_green")

#define NOW_SELECTED     imagify(@"now_blue")
#define TODAY_SELECTED    imagify(@"today_blue")
#define TOMORROW_SELECTED imagify(@"tomorrow_blue")
#define LATER_SELECTED    imagify(@"later_blue")


#define A_PICKUP       imagify(@"a_pickup")
#define A_DROP         imagify(@"a_drop")
#define G_PICKUP       imagify(@"g_pickup")
#define G_DROP         imagify(@"g_drop")

#define GO_ONLINE_BTN_IMAGE     imagify(@"go_online_button")
#define GO_OFFLINE_BTN_IMAGE    imagify(@"go_offline_button")



#define ONLINE_IMAGE     imagify(@"online")
#define OFFLINE_IMAGE    imagify(@"offline")
#define OnDuty_IMAGE     imagify(@"onduty")

// Current loaction button images  direction
#define HOME_POINTER      imagify(@"ic_current")
#define DIRECTION         imagify(@"ic_navigate")



#define US_ADMIN_NUMBER  @"+14434608360"
#define PK_ADMIN_NUMBER  @"+92512222738"
#define CALL_ZOOM        @"Do you want to Call Support?"


#define ZERO                  @"0"
#define ONE                   @"1"
#define NOT_ADDED             @"0.00"
#define GENERAL               @"1"
#define AIRPORT               @"2"
#define IMG_P                 @"IMG_P"
#define RESULT                @"data"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define BOOKING_SOUND_FILE    @"rideRequest.mp3"
#define BOOKING_SOUND         @"rideRequest"
#define ASSIGNED_SOUND_FILE   @"assigned.mp3"
#define CANCEL_SOUND_FILE     @"Cancel.mp3"
#define PAID_SOUND_FILE       @"paid.mp3"
#define CANCEL_SOUND          @"Cancel"
#define ASSIGNED_SOUND        @"assigned"
#define PAID_SOUND            @"paid"
#define CUSTOMER_ID           @"customerid"
// Button Title
#define PASS                 @"Pass"
#define Missed               @"Missed"
#define VIEW_BOOKING         @"Accept"
#define ARRIVED              @"Arrived Now"
#define START_JOB            @"Start Job"
#define END_JOB              @"End Job"
#define SENDING_FARE         @"Sending Fare"
#define COMPLETED            @"Completed"
#define CANCELED             @"Canceled"


#define Accept_Order         @"Accept"
#define ARRIVED_At_Pickup    @"ARRIVED AT PICKUP"
#define Order_Picked_UP      @"PICKED UP"
#define Order_Delivered      @"DELIVERED"

// current activity



#define CANCEL_BEFORE_CONNECTIONG @"Client Cancel Before Connecting"
#define NOT_INTERESTED            @"Not Interested"
#define NOT_SELECTED              @"Not Selected"

// errors
#define  GOT_500              @"Expected status code in (200-299), got 500"
#define NETWORK_LOST          @"The network connection was lost."
#define STREAM_EXHAUSTED      @"request body stream exhausted"
#define TIME_OUT              @"The request timed out."
#define SERVER_NOT_CONNECT    @"Could not connect to the server."
#define Client_Not_Available  @"Client not available"


// String
#define IOS_DRIVER      @"IOS Driver"
#define SENSOR          @"false"
#define UPDTE_OBSERVER  @"updateLocationNotification"

#define GO_OFFLINE      @"Go Offline"
#define GO_ONLINE       @"Go Online"
#define ONLINE          @"online"
#define OFFLINE         @"offline"
#define ONDUTY          @"busy"

#define NO_PICTURE      @"no image"

// App Data keys
#define BASE_URL                @"Site url"
#define API_PATH                @"API host"
#define STRIPE_RIGESTER_PATH    @"Stripe register path"
#define PROFILE_PIC_PATH        @"photo_url"
#define GOOGLE_MAP_KEY          @"Google map key IOS"
#define COUNTRY                 @"default_countries"
#define STATES                  @"province"
#define CITYIES                 @"cities"
#define DOCUMENTS               @"documents"
#define PROMOTIONS              @"Promotion"
#define PROMOTIONS_DISCOUNT     @"Promotion Discount"
#define DOC_PATH                @"Documents path"

#define kRide_Request_Notification  @"RideRequestNotification"


// Activity String
#define RATING    @"rating"
#define PAYMENT   @"payment"
#define COMPLETE  @"complete"
#define Confirm_Fare   @"payment"
// No Rides Messages

#define NO_AVAILABLE_RIDES   @"No rides available"
#define NO_ASSIGNED_RIDES    @"No rides assigned to you"
#define NO_RIDES_HISTORY     @"No trip history"

// ViewController
#define WebView_Idintifire    @"ShowWebView"

#define SHOW_DATE_PICKER     @"ShowDatePicker"
#define REGESTERVIEW         @"RegisterView"
#define RESERVATION          @"Reservation"
#define LOGIN                @"MainView"
#define CURRENTLOCATION      @"CurrentLocation"
#define DOCUMENTS_VIEW       @"DocView"
#define MANAGEFARE           @"ManageFare"
#define AVAILABLERIDES       @"Available_My"
#define EARNING               @"Earning"

#define SHOWPROFILE          @"ShowProfile"
#define FAREANDRATING        @"FairAndRating"
#define REVIEW               @"Review"
#define REGISTERView         @"RegisterView"
#define LOADING              @"Loading"
#define FARE_Idintifire      @"ShowFareVC"

//date formate

// Error String
#define  NO_REQUEST      @"no ride request"


#define DATE_AND_TIME_S @"yyyy-MM-dd HH:mm:ss"
#define DATE_AND_TIME   @"yyyy-MM-dd hh:mm:ss a"
#define DATE_ONLY       @"yyyy-MM-dd"
#define TIME_ONLY       @"hh:mm a"
#define TIME_ONLY_S       @"HH:mm:ss"
#define DATE_ONLY_DISPLAY @"d MMM, yyyy"
#define DATE_TIME_DISPLAY @"d MMM, yyyy hh:mm a"

// current Country
#define  PAKISTAN  @"Pakistan"
#define  USA       @"United States"
#define  USD       @"$"
#define  RS       @"Rs."


#define ROLE_ID         @"16"


#define COMMAND_NEW_ACCOUNT      @"driverRegister"
#define COMMAND_RIDE           @"ride"
#define COMMAND_PROFILE        @"profile"
#define COMMAND_RESERVATION    @"reservation"
#define REGISTER               @"create_user"
#define SIGN_IN                @"login"
#define RIDE_HISTORY           @"ride_history"
#define ESTIMATED_FARE         @"estimate_fare"



#define Created                @"1"
#define Dispatched          @"2"
#define Assigned            @"3"
#define Accepted            @"4"
#define Edited                @"5"
#define Ride                @"6"
#define Deleted             @"7"
#define Waiting_for_driver    @"8"
#define Driver_connected    @"9"
#define Driver_reached         @"10"
#define Start_journey        @"11"
#define End_journey            @"12"
#define Waiting_for_payment    @"13"
#define Client_added_fare   @"14"
#define Paid                @"15"
#define Cleint_Canceled        @"16"
#define Driver_Canceled        @"17"
#define RIDE_COMPLETED      @"18"

#define PLEASE_SELECT     @"----- Please select -----"
// Keys for dic


#define FARE_KAYS     @[@"command",@"car_id",@"pickup_coordinate", @"drop_coordinate"]
#define LOGIN_KEYS     @[@"command",@"mobile",@"role_id",@"country_id"]
#define REGISTER_KEYS     @[@"command", @"password",@"name",@"mobile", @"email",@"photo",@"role_id",@"car_id",@"car_number",@"coordinate",@"address",@"country_id",@"device_id", @"device_name",@"app_version"];

#define KEYS_RIDE_REQUEST @[@"command",@"pickup_coordinate", @"pickup_address",@"drop_coordinate", @"drop_address",@"client_id",@"driver_id",@"reservation_id",@"current_activity",@"request_at"]
#define KEYS_ADD_RESERVATION @[@"command",@"name",@"mobile", @"add_by",@"client_id", @"status",@"reserve_type",@"no_of_passanger",@"car_type_id",@"pickup_date_time",@"pickup_address",@"drop_address",@"pickup_coordinate",@"drop_coodinate",@"flight_number",@"reservation_from",@"note"]x

#define KEYS_RESERVARION_RIDE @[@"command",@"status",@"request_at",@"pickup_coordinate", @"pickup_address",@"drop_coordinate",@"drop_address",@"client_id",@"driver_id",@"reservation_id",@"current_activity"]


#define MONTH_ARRAY  @[@"01 - January", @"02 - February", @"03 - March",@"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",@"10 - October", @"11 - November", @"12 - December"];
#define Days_ARRAY   @[@"Now", @"Today", @"Tomorrow",@"Later"]
#define DOC_TYPES_ARRAY  @[@"IMG_DL",@"IMG_TL",@"IMG_O",@"IMG_V"];

#define USERDEFAULT_KAYS_ARRAY  @[USERID,ISONLINE,ISOFFLINE,ISONDUTY,ISONDUTY,CALCULATED_FARE,PROFILE,ISRIDEREQUEST,ALL_RESERVATIONS,Taxi_Licence_Img_Name,Driver_Licence_Img_Name]
// userdefault keys
#define COMMON          @"common"
#define REASONS         @"reasons"
#define VEHICLES        @"vehicles"
#define COMPANIES       @"car_companies"
#define MODELS          @"car_model"
#define COLOR           @"color"
#define ENGINE_POWER    @"vehicle_power"
#define DOCs            @"documents"
#define APP_DATA        @"app_Data"
#define  VALUES         @"values"


#define USERID                @"userId"
#define ISONLINE              @"isOnline"
#define ISOFFLINE             @"isOffLinle"
#define COORDINATE            @"coordinate"
#define ISONDUTY              @"isDuty"
#define UD_REQUEST          @"request"
#define MARKER_POSTION        @"MarkerPostion"
#define D_ADDRESS             @"Driver Address"
#define D_COORDINATE          @"Driver Coordinate"
#define CALCULATED_FARE       @"Calculated_fare"
#define PROFILE               @"profile"
#define Earning_Titles        @"EarningTitles"
#define ISRIDEREQUEST         @"isRideRequest"
#define ALL_RESERVATIONS      @"all_reservation"
#define Taxi_Licence_Img_Name @"taxi_licence_img_name"
#define Driver_Licence_Img_Name @"driver_licence_img_name"


inline __attribute__((always_inline)) NSString *fc_safeString(NSString *str) { return str ? str : @""; }

#endif /* Basic_h */
