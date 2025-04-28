//
//  Fare.m
//  Nexi
//
//  Created by Syed zia on 25/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "Fare.h"

@implementation Fare

- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setBaseFare:attribute[@"base_fare"]];
    [self setGst:attribute[@"GST"]];
    [self setBookingFee:attribute[@"booking_fee"]];
    [self setTotalFare:attribute[@"fare"]];
    [self setDistance:attribute[@"distance"]];
    [self setDuration:attribute[@"duration"]];
    return self;
}
@end
