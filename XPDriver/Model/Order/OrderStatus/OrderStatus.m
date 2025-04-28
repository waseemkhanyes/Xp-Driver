//
//  OrderStatus.m
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import "OrderStatus.h"

@implementation OrderStatus
- (instancetype)initWithStatus:(NSString *)status time:(NSString *)time{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setStatus:[status boolValue]];
    [self setTime:[NSDate timeString:time]];
    return  self;
}
@end
