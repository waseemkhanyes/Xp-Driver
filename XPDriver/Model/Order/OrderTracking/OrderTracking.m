//
//  OrderTracking.m
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import "OrderTracking.h"

@implementation OrderTracking
- (instancetype)initWithAtrribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    OrderStatus *confirmed = [[OrderStatus alloc] initWithStatus:attribute[@"confirmed"] time:attribute[@"confirm_time"]];
    OrderStatus *prepared  = [[OrderStatus alloc] initWithStatus:attribute[@"prepare"] time:attribute[@"prepare_time"]];
    OrderStatus *assigned  = [[OrderStatus alloc] initWithStatus:attribute[@"assign"] time:attribute[@"assign_time"]];
    OrderStatus *on_way    = [[OrderStatus alloc] initWithStatus:attribute[@"on_way"] time:attribute[@"onway_time"]];
    OrderStatus *completed = [[OrderStatus alloc] initWithStatus:attribute[@"completed"] time:attribute[@"completed_time"]];
    OrderStatus *canceled = [[OrderStatus alloc] initWithStatus:attribute[@"canceled"] time:attribute[@"cancel_time"]];
    OrderStatus *readyForPickup = [[OrderStatus alloc] initWithStatus:attribute[@"alert_customer"] time:attribute[@"alert_time"]];
    [self setConfirmed:confirmed];
    [self setPrepare:prepared];
    [self setAssigned:assigned];
    [self setOnWay:on_way];
    [self setCompleted:completed];
    [self setCanceled:canceled];
    [self setReadyForPickup:readyForPickup];
    
    return self;
}
@end

