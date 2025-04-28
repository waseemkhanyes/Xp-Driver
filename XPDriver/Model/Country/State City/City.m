//
//  City.m
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "City.h"

@implementation City
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil ;
    }
    [self setCityId:strFormat(@"%@",attribute[@"id"])];
    [self setStateId:strFormat(@"%@",attribute[@"state_id"])];
    [self setName:strFormat(@"%@",attribute[@"name"])];
    [self setZipcode:strFormat(@"%@",attribute[@"zip"])];
    return self;
}
@end
