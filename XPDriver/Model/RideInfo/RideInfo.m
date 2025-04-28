//
//  Ride.m
//  fivestartdriver
//
//  Created by Syed zia ur Rehman on 20/07/2015.
//  Copyright (c) 2015 Syed zia ur Rehman. All rights reserved.
//
#import "NSDate+Helper.h"
#import "RideInfo.h"


@implementation RideInfo 
@synthesize rideId,rideTime,clientName,clientPhone,clientPic,pickupLocation,dropOffLocation,pickupCoordinate,dropOffCoordinate,fare;


+(RideInfo *)setRide : (NSDictionary *)res{
    
    RideInfo *ride =[[RideInfo alloc] init];
    NSString *clientName = [res objectForKey:@"name"];
    NSArray *nameArray  = [clientName componentsSeparatedByString:@" "];
    if (nameArray.count > 1) {
        NSString *lastName = nameArray[1];
        NSString *lastNameFirstCharacter;
        if (lastName.isEmpty) {
            lastNameFirstCharacter = @"";
        }else{
            lastNameFirstCharacter  = [lastName substringToIndex:1];
        }
        
        clientName = [NSString stringWithFormat:@"%@ %@",clientName,lastNameFirstCharacter];
    }
    NSString *rDate = [res objectForKey:@"ride_time"];
    [ride setRideId:[res objectForKey:@"id"]];
    [ride setRideTime:[res objectForKey:@"client_id"]];
    [ride setClientName:clientName];
    [ride setClientPhone:[res objectForKey:@"client_phone"]];
    [ride setClientPic:[res objectForKey:@"client_pic"]];
    [ride setPickupLocation:[res objectForKey:@"pickup_address"]];
    [ride setDropOffLocation:[res objectForKey:@"drop_address"]];
    [ride setPickupCoordinate:[res objectForKey:@"pickup_coordinate"]];
    [ride setDropOffCoordinate:[res objectForKey:@"drop_coordinate"]];
    [ride setRideTime:[NSDate dayMonthTimeString:rDate]];
    [ride setFare:[res objectForKey:@"fare"]];
        
    return ride;
    
}
+(NSMutableArray *)getRides:(NSArray *)results{
    
    NSMutableArray *rides =[NSMutableArray new];
    
    for (int i=0; i<[results count]; i++)
    {
        NSDictionary *res=[results objectAtIndex:i];
        [rides addObject:[RideInfo setRide:res]];
        
        
        
    }
    
    return rides;
}

@end

