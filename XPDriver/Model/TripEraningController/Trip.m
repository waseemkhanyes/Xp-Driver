//
//  Trip.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "Trip.h"

@implementation Trip
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSDate *date =[NSDate dateFromString:attribute[@"request_at"] withFormat:DATE_AND_TIME_S];
    NSString *colorStaing = [NSString stringWithFormat:@"%@",attribute[@"status_color"]];
    [self setTripId:strFormat(@"%@",attribute[@"d_id"])];
    [self setStatus:attribute[@"status_name"]];
    [self setStatusColor:[UIColor colorFromHexString:colorStaing]];
    [self setRequestedTime:[NSDate stringFromDate:date withFormat:DATE_ONLY_DISPLAY]];
    [self setFare:strFormat(@"%@ %@",SHAREMANAGER.appData.country.currencey,attribute[@"calculated_fare"])];
    
    return self;
}
@end
