//
//  AppDelegate.h
//  XPDriver
//
//  Created by Syed zia on 25/02/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
@import IQKeyboardManager;
@class LoadingView;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate>
@property (strong,nonatomic) AVAudioPlayer* theAudio;

@property (retain, nonatomic) LoadingView *splash;
-(void)stopLocationManager;
@property (retain,retain)     NSTimer *updLoctionTimer;
@property (retain,retain)     NSTimer *coordinatepdLoctionTimer;
@property (assign, nonatomic) BOOL isRequested;
@property (strong, nonatomic) NSString *countryName;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;

@end

