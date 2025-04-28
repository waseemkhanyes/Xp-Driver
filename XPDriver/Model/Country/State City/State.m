//
//  State.m
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "State.h"

@implementation State
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setStateId:attribute[@"zone_id"]];
    [self setName:attribute[@"name"]];
    return self;
}
@end
