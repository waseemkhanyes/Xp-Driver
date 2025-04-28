//
//  RouteStep.m
//  XPDriver
//
//  Created by Syed zia on 26/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "RouteStep.h"

@implementation RouteStep
- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setDistance:[attributes[@"distance"][@"value"] intValue]];
    [self setDuration:[attributes[@"duration"][@"value"] intValue]];
    [self setCoordinate:CLLocationCoordinate2DMake([attributes[@"end_location"][@"lat"] doubleValue], [attributes[@"end_location"][@"lng"] doubleValue])];
    DLog(@"Coordinates: %@,%@",attributes[@"end_location"][@"lat"],attributes[@"end_location"][@"lng"]);
    return self;
}
@end
