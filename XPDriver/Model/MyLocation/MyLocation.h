//
//  MyLocation.h
//  Eze
//
//  Created by Syed zia on 25/03/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonFunctions.h"
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+Helper.h"
#import <GoogleMaps/GoogleMaps.h>
#import "NSString+Utilities.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyLocation : NSObject
typedef void(^AFLocationCompletion)(MyLocation * _Nullable location,BOOL success);
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *formetedAddress;
@property (nonatomic,strong) NSString *coordinateString;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *postalCode;
- (instancetype)initWithAddresses:(NSArray *)addresses coordinateString:(NSString  *)coordinateSting;
- (instancetype)initWithAddress:(NSString *)address coordinateString:(NSString  *)coordinateSting distance :(float)distance;
- (instancetype)initWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D  )coordinate;
- (instancetype)initWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D  )coordinate  state:(NSString *)state city:(NSString *)city;
//+ (void)addressFormCoordinate:(CLLocationCoordinate2D )coordinate completionHandler:(AFLocationCompletion)completionHandler;
@end

NS_ASSUME_NONNULL_END
