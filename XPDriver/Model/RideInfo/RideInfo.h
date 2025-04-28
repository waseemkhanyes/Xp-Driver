//
//  Ride.h
//  fivestartdriver
//
//  Created by Syed zia ur Rehman on 20/07/2015.
//  Copyright (c) 2015 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideInfo : NSObject 
{
    NSString *rideId;
    NSString *rideTime;
    NSString *clientName;
    NSString *clientPhone;
    NSString *clientPic;
    NSString *pickupLocation;
    NSString *dropOffLocation;
    NSString *pickupCoordinate;
    NSString *dropOffCoordinate;
    NSString *fare;
    
    
    
}
@property (nonatomic ,copy)  NSString *rideId;
@property (nonatomic ,copy)  NSString *rideTime;
@property (nonatomic ,copy)  NSString *clientName;
@property (nonatomic ,copy)  NSString *clientPhone;
@property (nonatomic ,copy)  NSString *clientPic;
@property (nonatomic ,copy)  NSString *pickupLocation;
@property (nonatomic ,copy)  NSString *dropOffLocation;
@property (nonatomic ,copy)  NSString *pickupCoordinate;
@property (nonatomic ,copy)  NSString *dropOffCoordinate;
@property (nonatomic ,copy)  NSString *fare;





+(RideInfo *)setRide : (NSDictionary *)res;
+(NSMutableArray *)getRides:(NSArray *)results;
@end
