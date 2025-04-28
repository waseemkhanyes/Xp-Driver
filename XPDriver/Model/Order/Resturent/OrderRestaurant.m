//
//  OrderRestaurant.m
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
NSString *const KParking_vehicle_info = @"parking_vehicle_info";
NSString *const KSeatings_and_notes = @"seatings_and_notes";
NSString *const kLocationDeliveryInfoNone = @"none";
NSString *const kLocationDeliveryInfo = @"location_delivery_info";
#import "OrderRestaurant.h"

@implementation OrderRestaurant
- (instancetype)initWithAtrribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *coordinateString = [NSString stringWithFormat:@"%@,%@",attribute[@"latitude"],attribute[@"longitude"]];
    [self setRestaurentId:attribute[@"id"]];
    [self setName:attribute[@"name"]];
    [self setAddress:attribute[@"address"]];
    [self setTitle:attribute[@"title"]];
    [self setPhone:attribute[@"mobile_number"]];
    [self setCurrrencyCode:attribute[@"currencey"]];
    [self setCurrrencySymbol:attribute[@"currencey_symbol"]];
    [self setBrandLogoUrl:[NSURL URLWithString:attribute[@"owner_detail"][@"profile"]]];
    [self setLocation:[[MyLocation alloc] initWithAddresses:@[attribute[@"address"],attribute[@"address_2"]] coordinateString:coordinateString]];
    if(![attribute[kLocationDeliveryInfo] isKindOfClass:[NSNull class]]){
        self.isForParking = [attribute[kLocationDeliveryInfo] isEqualToString:KParking_vehicle_info];
        self.isForSeats = [attribute[kLocationDeliveryInfo] isEqualToString:KSeatings_and_notes];
        self.isNone = [attribute[kLocationDeliveryInfo] isEqualToString:kLocationDeliveryInfoNone];
    }
   
    return self;
}
@end
