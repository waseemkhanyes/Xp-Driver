//
//  TripDetail.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights attributerved.
//

#import "TripDetail.h"

@implementation TripDetail
- (instancetype)initWithAttrebute:(NSDictionary *)attribut{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSArray      *fareAray     = attribut[@"fare_breakdown"];
    NSDictionary *vehicleInof  = attribut[@"driver_profile"];
    NSString  *routeString     = attribut[@"route"];
    NSString  *picName = strFormat(@"%@",[attribut objectForKey:@"photo"]);
    NSString  *picUrlString = strNotEmpty(picName) ? strFormat(@"%@%@",SHAREMANAGER.profilePicPath,picName) : @"";
    self.requestId           = [attribut objectForKey:@"d_id"];
    self.currentActivity     = [attribut objectForKey:@"current_activity"];
    self.pickupCoordinate    = [SHAREMANAGER getCoodrinateFromSrting:attribut[@"pickup_coordinate"]];
    self.pickupAddress       = [attribut objectForKey:@"pickup_address"];
    self.dropCoordinate      = [SHAREMANAGER getCoodrinateFromSrting:attribut[@"drop_coordinate"]];
    self.dropAddress         = [attribut objectForKey:@"drop_address"];
    self.driverId            = [attribut objectForKey:@"driver_id"];
    self.driverFare          = [attribut objectForKey:@"driver_fare"];
    self.clientFare          = [attribut objectForKey:@"client_fare"];
    self.driverFareConfirmed = [attribut objectForKey:@"payment_confirmed"];
    self.paymetnMode         = [attribut[@"payment_mode"] intValue]  == 0 ? @"Cash" : @"Credit Card" ;
    self.distance            = [attribut objectForKey:@"distance"];
    self.duration            = [attribut objectForKey:@"duration"];
    self.totlaFare           = strFormat(@"%@ %@",SHAREMANAGER.appData.country.currencey,attribut[@"calculated_fare"]);
    self.requestedTime       = [self dateString:attribut[@"request_at"]];
    self.connectedTime       = [self dateString:attribut[@"connected_at"]];
    self.reachedTime         = [self dateString:attribut[@"driver_reached_at"]];
    self.stratTime           = [self dateString:attribut[@"journye_started_at"]];
    self.endTime             = [self dateString:attribut[@"journey_ended_at"]];
    self.fare                = [self fareInfo:fareAray];
    self.reoutePath          = strNotEmpty(routeString) ? [self routPath:routeString] : [GMSMutablePath new];
    self.clientId            = [attribut objectForKey:@"client_id"];
    self.clientImageURL      = strNotEmpty(picUrlString) ? strUrl(picUrlString) : nil;
    self.clientName          = [attribut objectForKey:@"name"];
    self.clientPhone         = strFormat(@"+%@",[attribut objectForKey:@"mobile"]);
    self.vehicleType         = [attribut objectForKey:@"car_id"];
    self.isAppliedCancelFare = [[attribut objectForKey:@"is_applied_cancel_fare"] boolValue];
    self.vehicleInfo         = vehicleInof[@"car_model"];
    self.vehicleType         = vehicleInof[@"car_name"];
    self.vehicleTypeIcon     = imagify(vehicleInof[@"car_img"]);
    
    return self;
}
- (GMSMutablePath *)routPath:(NSString *)route{
    NSArray *allRoutePoints = [route componentsSeparatedByString:@"!"];
    NSMutableArray *tempArray = [NSMutableArray new];
    GMSMutablePath *path = [GMSMutablePath new];
    for (NSString *coordinateStrig in allRoutePoints) {
        CLLocationCoordinate2D coordinate = [SHAREMANAGER getCoodrinateFromSrting:coordinateStrig];
        if (![tempArray  containsObject:coordinateStrig]) {
            [path addCoordinate:coordinate];
            [tempArray addObject:coordinateStrig];
        }
        
    }
    [path insertCoordinate:self.pickupCoordinate atIndex:0];
    [path insertCoordinate:self.dropCoordinate atIndex:path.count-1];
    return path;
}
- (NSMutableArray *)fareInfo:(NSArray *)fareArray{
    NSMutableArray *allInfo = [NSMutableArray new];
    for (NSDictionary *dic in fareArray) {
        FareInfo *info = [[FareInfo alloc] initWithAttribute:dic];
        [allInfo addObject:info];
    }
    return allInfo;
}
-(NSString *)dateString:(NSString *)date{
    NSDate *rideDate = [NSDate dateFromString:date];
    NSString *dbDateString = [NSDate stringFromDate:rideDate withFormat:DATE_TIME_DISPLAY]; // returns
    return dbDateString;
    
}
@end
