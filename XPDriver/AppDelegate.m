//
//  AppDelegate.m
//  XPDriver
//
//  Created by Syed zia on 25/02/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import "AppDelegate.h"
#import "JDStatusBarNotification.h"
#import "EarningTitleController.h"
//#import "AFNetworkActivityLogger.h"
//#import "Firebase.h"
#import "XP_Driver-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CustomLocation retrieveSavedLocation];
#ifdef DEBUG
    //    [[AFNetworkActivityLogger sharedLogger] startLogging];
    //    [[AFNetworkActivityLogger sharedLogger] setLogLevel:AFLoggerLevelDebug];
#endif
    [self registerForRemoteNotifications];
    [self addNotificationBarStyles];
    [EarningTitleController fetchData];
    [GMSServices provideAPIKey:Google_Map_Key];
    [GMSPlacesClient provideAPIKey:GOOGLE_PLEACE_KEY];
    [self rootViewControllerSetup];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter  = 0;
    [self.locationManager requestAlwaysAuthorization];
    [self startLoaction];
    [self appreaneceSetUp];
//    [FIRApp configure];
    
    //    @import FirebaseCore;
    
    //ONE LINE OF CODE.
    //Enabling keyboard manager(Use this line to enable managing distance between keyboard & textField/textView).
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // [IQKeyboardManager sharedManager].enableDebugging   = YES;
    //(Optional)Set Distance between keyboard & textField, Default is 10.
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:35];
    //(Optional)Enable autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard. Default is NO.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //(Optional)Setting toolbar behaviour to IQAutoToolbarBySubviews to manage previous/next according to UITextField's hierarchy in it's SuperView. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order. Default is `IQAutoToolbarBySubviews`.
    [[IQKeyboardManager sharedManager] setToolbarManageBehavior:IQAutoToolbarBySubviews];
    
    //(Optional)Resign textField if touched outside of UITextField/UITextView. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setToolbarBarTintColor:[UIColor appBlackColor]];
    [[IQKeyboardManager sharedManager] setToolbarTintColor:[UIColor whiteColor]];
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
//    [self performSelector:@selector(handlePushNotification) withObject:nil afterDelay:10.0];
    return YES;
}
- (void)rootViewControllerSetup{
    
    if ([DictionryData isDataSaved]) {
        [self showRootviewController];
    }else{
        [self showLoadingView];
    }
}
- (void)appreaneceSetUp{
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appBlackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont heading1],
    }];
    [[UINavigationBar appearance] setTintColor:WHITE_COLOR];
    [[UITextView appearance]   setTintColor:[UIColor appBlueColor]];
    [[UITextView appearance]  setFont:[UIFont normal]];
    [[UIToolbar appearance] setBarTintColor:[UIColor appBlackColor]];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setTranslucent:YES];
    [[UITextField appearance]  setTintColor:[UIColor appBlackColor]];
    [[UITextField appearance]  setTextColor:[UIColor appBlackColor]];
    [[UITextField appearance] placeholderColor:[UIColor textFieldPlaceholderColor]];
    [[UITextField appearance]  setFont:[UIFont normal]];
    [[ACFloatingTextField appearance] setLineColor:[UIColor appGrayColor]];
    [[ACFloatingTextField appearance] setSelectedLineColor:[UIColor appGrayColor]];
    [[ACFloatingTextField appearance] setSelectedPlaceHolderColor:[UIColor appGrayColor]];
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont heading2]} forState:UIControlStateNormal];
    // [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITextField class]]].textColor = [UIColor lightGrayColor];
}
- (void)authorization{
    
}
-(void)startLoaction{
    [self.locationManager startUpdatingLocation];
}
-(void)showRootviewController{
    if([User isInfoSaved]){
        [self showViewControlller:CURRENTLOCATION];
    }else {
        [self showViewControlller:LOGIN];
    }
}
-(void)showViewControlller:(NSString *)identifier{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:instantiateVC(identifier)];//
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    
}
-(void)showLoadingView{
    _window.rootViewController = instantiateVC(LOADING);
    [_window makeKeyAndVisible];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self startLoaction];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
}
- (void)registerForRemoteNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
            
        }
    }];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"wk Noti willPresentNotification User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSLog(@"wk Noti didReceiveNotificationResponse User Info : %@",response.notification.request.content.userInfo);
    [self handlePushNotification:response.notification.request.content.userInfo shouldClick:true];
    completionHandler();
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //waseem click on notification
    if (application.applicationState == UIApplicationStateBackground) {
        NSString *playSoundOnAlert = [NSString stringWithFormat:@"%@", [[userInfo objectForKey:@"aps"] objectForKey:@"sound"]];
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],playSoundOnAlert]];
        
        NSError *error;
        
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    
}
- (void)applicationWillTerminate:(UIApplication *)application{
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSLog(@"deviceToken: %@", [NSString hexadecimalStringFromData:deviceToken]);
    NSString * token =  [NSString hexadecimalStringFromData:deviceToken];
    [SHAREMANAGER setDeviceToken:token];
}

- (void)handlePushNotification:(NSDictionary *)userInfo shouldClick:(BOOL)shouldClick {
    NSLog(@"wk Noti handlePushNotification User Info: %@, %d", userInfo, shouldClick);
    
    NSDictionary *aps = userInfo[@"aps"];
    NSString *screen = aps[@"screen"];
    
    NSLog(@"wk Noti handlePushNotification screen: %@", screen);
    
    if ([screen isEqualToString:@"MapsActivity"]) {
        NSLog(@"wk Noti handlePushNotification screen: %@ 1", screen);
        NSLog(@"wk Noti Continue Action for %@", screen);
        
        UIViewController *mytopVC = [self myCurrenttopController];
        if (mytopVC != nil) {
            if ([mytopVC isKindOfClass:[CurrentLocatioView class]]) {
                NSLog(@"wk Noti call order api success");
                CurrentLocatioView *conCurrentLocation = (CurrentLocatioView *)mytopVC;
                [conCurrentLocation updateCoordinate];
                // Perform actions specific to YourViewController
            } else {
                if (shouldClick == YES) {
                    NSLog(@"wk Noti pop to root success");
                    [self popToRootCall];
                    
                    double delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                          
                    NSLog(@"wk Noti after 1 second delay");
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        UIViewController *mytopVCAgain = [self myCurrenttopController];
                        if (mytopVCAgain != nil) {
                            if ([mytopVCAgain isKindOfClass:[CurrentLocatioView class]]) {
                                NSLog(@"wk Noti after 1 second delay call order api done");
                                CurrentLocatioView *conCurrentLocationAgain = (CurrentLocatioView *)mytopVCAgain;
                                [conCurrentLocationAgain updateCoordinate];
                                // Perform actions specific to YourViewController
                            }
                        }
                    });
                }
            }
        } else {
            NSLog(@"wk Noti navigation top controller not found");
        }
    } else if ([screen isEqualToString:@"advanced_order_notification"]) {
        if (shouldClick == YES) {
            NSLog(@"wk Noti handlePushNotification screen: %@ 2", screen);
            UIViewController *rootVC = self.window.rootViewController;

            // Find the top-most presented view controller
            while (rootVC.presentedViewController) {
                rootVC = rootVC.presentedViewController;
            }
            
            NSLog(@"wk Noti handlePushNotification screen: %@ 3", screen);

            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            
            NSLog(@"wk Noti handlePushNotification screen: %@ 4", screen);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"wk Noti handlePushNotification screen: %@ 5", screen);
                NSString *fromDate = [[aps objectForKey:@"data"] valueForKey:@"date_from"];
                NSString *toDate = [[aps objectForKey:@"data"] valueForKey:@"date_to"];
                
                NSLog(@"wk Noti fromDate: %@, todate: %@", fromDate, toDate);
                
                if ((fromDate && toDate) && [fromDate isEqualToString:toDate]) {
                    UIDriverAvailabilityConfirmationPopupVC *swiftVC = [[UIDriverAvailabilityConfirmationPopupVC alloc] init];
                    swiftVC.data = aps;
                    swiftVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    swiftVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [rootVC presentViewController:swiftVC animated:YES completion:nil];
                } else {
                    UIViewController *mytopVC = [self myCurrenttopController];
                    if (mytopVC != nil) {
                        if ([mytopVC isKindOfClass:[CurrentLocatioView class]]) {
                            CurrentLocatioView *conCurrentLocation = (CurrentLocatioView *)mytopVC;
                            [conCurrentLocation pushToDriverAvailability];
                        } else {
                            [self popToRootCall];
                            
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));

                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                UIViewController *mytopVCAgain = [self myCurrenttopController];
                                if (mytopVCAgain != nil) {
                                    if ([mytopVCAgain isKindOfClass:[CurrentLocatioView class]]) {
                                        NSLog(@"wk Noti after 1 second delay call order api done");
                                        CurrentLocatioView *conCurrentLocationAgain = (CurrentLocatioView *)mytopVCAgain;
                                        [conCurrentLocationAgain pushToDriverAvailability];
                                    }
                                }
                            });
                        }
                    }
                }
            });
        }
    } else {
        // Handle other cases if needed
        NSLog(@"wk Noti Unhandled push notification for screen: %@", screen);
    }
}

-(UIViewController *)myCurrenttopController {
    UIViewController *topViewController = [self topViewController];
    NSLog(@"wk Top View Controller Class: %@", NSStringFromClass([topViewController class]));
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)topViewController;
        UIViewController *visibleViewController = navigationController.topViewController;
        return visibleViewController;
    }
    
    return  nil;
}

-(void) popToRootCall {
    UIViewController *topViewController = [self topViewController];
    NSLog(@"wk Top View Controller Class: %@", NSStringFromClass([topViewController class]));
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)topViewController;
        [navigationController popToRootViewControllerAnimated:YES];
    }
}

- (UIViewController *)topViewController {
    UIViewController *topController = self.window.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

#pragma mark -
#pragma mark CLlocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentloaction = [locations lastObject];
    if ([SHAREMANAGER isVaildCoordinate:currentloaction.coordinate]) {
        [self setCurrentCoordinate:currentloaction.coordinate];
        if (!_countryName && !_isRequested ) {
            [SHAREMANAGER setStoredCoordinate:currentloaction.coordinate];
            [self getCountryNameFromCoordinates:currentloaction.coordinate];
        }else{
            
            
        }
        [self stopLocationManager];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // [self addRegion];
    }
    else if (status == kCLAuthorizationStatusDenied) {
        [self showLocationServicesError];
        NSLog(@"Location access denied");
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //DLog(@"error :%@",error.localizedDescription);
    NSString *errorString;
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            //    [self showLocationServicesError];
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    
}
- (void)showLocationServicesError{
    [CommonFunctions showSettingAlertWithTitel:@"Location service Access denied" message:@"Go Settings > Privacy > Location Services and turn on Location Service for this app." inVC:self.window.rootViewController completion:^(BOOL success) {
        if (!success){
            _countryName = USA;
            [self fetchDictionryData];
        }
        
    }];
}
-(void)getCountryNameFromCoordinates:(CLLocationCoordinate2D)coordinate{
    _isRequested = !_isRequested;//
    //  CLLocationCoordinate2D uk = CLLocationCoordinate2DMake(51.505983, -0.123635);
    //  CLLocationCoordinate2D canada = CLLocationCoordinate2DMake(43.787083, -79.497369);
    //  CLLocationCoordinate2D australia = CLLocationCoordinate2DMake(-33.800540, 151.179767);
    //  CLLocationCoordinate2D newZealand = CLLocationCoordinate2DMake(-45.020223, 168.740570);
    //  CLLocationCoordinate2D usa = CLLocationCoordinate2DMake(39.316889, -76.707658);
    DLog("** wk coordinates: lat: %f, long: %f", coordinate.latitude, coordinate.longitude);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *coor = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [geocoder reverseGeocodeLocation:coor completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error reverse geocoding location: %@", error);
                [self.locationManager startUpdatingLocation];
                _isRequested = !_isRequested;
                return;
            }
            
            if (placemarks.count > 0) {
                CLPlacemark *place = [placemarks firstObject];
                
                NSLog(@"Address string: %@", place);
                NSLog(@"Address country: %@", place.country);
                _countryName = strFormat(@"%@",place.country);
                [self fetchDictionryData];
            } else {
                NSLog(@"No placemarks found.");
            }
        }];
//        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
//            if (!error) {
//                GMSAddress* addressObj = [[response results] firstObject];
//                DLog("** wk adress: %@", addressObj.description);
//                _countryName = strFormat(@"%@",addressObj.country);
//                [self fetchDictionryData];
//            }else{
//                DLog("** wk error: %@", error.localizedDescription);
//                [self.locationManager startUpdatingLocation];
//                _isRequested = !_isRequested;
//            }
//            
//            
//            
//        }];
}
//-(void)fetchDictionryData{
//    NSString *appID = @"9";
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"dictionry",@"command",ROLE_ID,@"role_id",_countryName,@"country_name",appID, @"app_id" , nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"]&&json!=nil){
//            NSDictionary *res = [json objectForKey:RESULT];
//            [DictionryData save:res];
//            if ([self.window.rootViewController isKindOfClass:[LoadingView class]]) {
//                [self showRootviewController];
//            }
//        }
//        else{
//            NSString *errorMsg =[[json objectForKey:@"error"] capitalizedString];
//            if ([ErrorFunctions isError:errorMsg]){
//
//            }else{
//                NSString * errorMessge = [json objectForKey:@"error"];
//                if (!errorMessge.isEmpty) {
//                    [CommonFunctions showAlertWithTitel:@"Oops!" message:errorMessge inVC:self.window.rootViewController];
//                }
//
//            }
//
//        }
//
//    }];
//
//}

-(void)fetchDictionryData{
    NSString *appID = @"9";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"dictionry",@"command",ROLE_ID,@"role_id",_countryName,@"country_name",appID, @"app_id" , nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response fetchDictionryData JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil){
            NSDictionary *res = [json objectForKey:RESULT];
            [DictionryData save:res];
            if ([self.window.rootViewController isKindOfClass:[LoadingView class]]) {
                [self showRootviewController];
            }
        }
        else{
            NSString *errorMsg =[[json objectForKey:@"error"] capitalizedString];
            [self handleError:errorMsg];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
}

- (void) handleError: (NSString *)errorDescription {
    NSLog(@"Error: %@", errorDescription);
    
    NSString *errorMsg =[errorDescription capitalizedString];
    if ([ErrorFunctions isError:errorMsg]){
        
    }else{
        NSString * errorMessge = errorDescription;
        if (!errorMessge.isEmpty) {
            [CommonFunctions showAlertWithTitel:@"Oops!" message:errorMessge inVC:self.window.rootViewController];
        }
    }
}

-(void)stopLocationManager{
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
}
-(void)playSoundWithName:(NSString *) soundName{
    NSError *err =  nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    self.theAudio = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.theAudio play];
    
}

- (void)addNotificationBarStyles {
    [JDStatusBarNotification addStyleNamed:@"Success"
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
        style.textColor = [UIColor whiteColor];
        style.progressBarColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
        style.progressBarHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
        style.animationType = JDStatusBarAnimationTypeMove;
        style.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:20];;
        return style;
    }];
    [JDStatusBarNotification addStyleNamed:@"Error"
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
        style.textColor = [UIColor whiteColor];
        style.progressBarColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
        style.progressBarHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
        style.animationType = JDStatusBarAnimationTypeMove;
        style.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:20];;
        return style;
    }];
    [JDStatusBarNotification addStyleNamed:@"Warning"
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.barColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
        style.textColor = [UIColor darkGrayColor];
        style.progressBarColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
        style.progressBarHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
        style.animationType = JDStatusBarAnimationTypeMove;
        style.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:20];;
        return style;
    }];
    
    
}
@end
