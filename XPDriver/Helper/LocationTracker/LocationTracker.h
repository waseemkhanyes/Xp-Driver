//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic,retain) CLHeading *currentHeading;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;
@property (assign,nonatomic) BOOL isInbackground;
@property (strong,nonatomic) ShareManager *baisShareModel;
@property (strong,nonatomic) LocationShareModel *shareModel;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;
@property (nonatomic) CLLocationCoordinate2D myLocationCoordinates;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)stopLocationTrackingAndBackgroundTasks;
-(void)removeAllSavedLocation;

@end
