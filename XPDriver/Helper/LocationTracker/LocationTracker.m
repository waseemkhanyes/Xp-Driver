//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"


@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
          
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                _locationManager.distanceFilter = kCLDistanceFilterNone;
                _locationManager.pausesLocationUpdatesAutomatically = NO;
                [_locationManager setAllowsBackgroundLocationUpdates:YES];
           
			
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        _isInbackground = NO;
        self.baisShareModel = [ShareManager share];
        self.shareModel = [LocationShareModel backgroundTasksharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        [LocationTracker sharedLocationManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    _isInbackground = YES;
    if (self.baisShareModel.isOffline){
        [self stopLocationTracking];
        return;
    }
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}
-(void)applicationBecomeActive{
    self.isInbackground = NO;
}
- (void) restartLocationUpdates{
   DLog(@"restartLocationUpdates");
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
   
  
    
}


- (void)startLocationTracking {
    BOOL isOffline =  user_defaults_get_bool(ISOFFLINE);
    if (isOffline) {return;}
    
    DLog(@"startLocationTracking");
	if ([CLLocationManager locationServicesEnabled] == NO) {
        [CommonFunctions showSettingAlertWithTitel:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" inVC:SHAREMANAGER.rootViewController completion:^(BOOL success) {
            
        }];
       
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            [CommonFunctions showSettingAlertWithTitel:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" inVC:SHAREMANAGER.rootViewController completion:^(BOOL success) {
            }];

        } else {
            ////DLog(@"authorizationStatus authorized");
            
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            [locationManager requestAlwaysAuthorization];
            [locationManager startUpdatingLocation];
        }
	}
}


- (void)stopLocationTracking {
    DLog(@"stopLocationTracking");
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
	[[LocationTracker sharedLocationManager] stopUpdatingLocation];
}
- (void)stopLocationTrackingAndBackgroundTasks {
    DLog(@"stopLocationTrackingAndBackgroundTasks");
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }

    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    [[LocationTracker sharedLocationManager] stopUpdatingLocation];
    [self.shareModel.bgTask endAllBackgroundTasks];
}
#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *cLocation = [CLLocation new];
    cLocation = [locations lastObject];
   // CLLocationCoordinate2D canada = CLLocationCoordinate2DMake(43.787083, -79.497369);
    self.currentLocation = cLocation.coordinate;
  //  DLog(@"Current position %.6f,%.6f",cLocation.coordinate.latitude,cLocation.coordinate.longitude);
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 10.0){
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            
            [self.shareModel.myLocationArray addObject:dict];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    

}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [self setCurrentHeading:newHeading];
}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
    }


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
   // //DLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
        [CommonFunctions showAlertWithTitel:@"Network Error" message:@"Please check your network connection." inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
        
        }
            break;
        case kCLErrorDenied:{
              [CommonFunctions showAlertWithTitel:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
        }
            break;
        default:
        {
            
        }
            break;
    }
}



//Send the location to Server
- (CLLocationCoordinate2D)myLocationCoordinates {
    
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0)
    {
        //NSLog(@"Unable to get location, use the last known location");
        
        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
        
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    

    
    return self.myLocation;
}

-(void)removeAllSavedLocation{
    
    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    
    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
    
}





@end
