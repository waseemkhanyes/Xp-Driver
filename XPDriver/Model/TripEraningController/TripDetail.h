//
//  TripDetail.h
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripDetail : NSObject

@property (nonatomic,strong) NSString *requestId;
@property (nonatomic,strong) NSString *currentActivity;
@property (nonatomic,strong) NSString *pickupAddress;
@property (nonatomic,strong) NSString *dropAddress;
@property (nonatomic,assign) CLLocationCoordinate2D pickupCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D dropCoordinate;
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) NSString *driverId;
@property (nonatomic,strong) NSString *driverFare;
@property (nonatomic,strong) NSString *clientFare;
@property (nonatomic,strong) NSString *paymetnMode;
@property (nonatomic,strong) NSString *driverFareConfirmed;
@property (nonatomic,strong) NSString *driverCoordinate;
@property (nonatomic,strong) NSString *driverAddress;
@property (nonatomic,strong) NSString *clientName;
@property (nonatomic,strong) NSString *clientPhone;
@property (nonatomic,strong) NSURL    *clientImageURL;
@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *totlaFare;
@property (nonatomic,strong) NSMutableArray *fare;
@property (nonatomic,strong) NSString *requestedTime;
@property (nonatomic,strong) NSString *connectedTime;
@property (nonatomic,strong) NSString *reachedTime;
@property (nonatomic,strong) NSString *stratTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *vehicleType;
@property (nonatomic,strong) NSString *vehicleInfo;
@property (nonatomic,strong) UIImage *vehicleTypeIcon;
@property (nonatomic,strong) GMSMutablePath* reoutePath;

@property (nonatomic,assign) BOOL isAppliedCancelFare;

- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
@end

NS_ASSUME_NONNULL_END
