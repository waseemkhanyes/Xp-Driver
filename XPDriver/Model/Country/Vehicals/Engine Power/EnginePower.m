//
//  EnginePower.m
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "EnginePower.h"

@implementation EnginePower
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setPowerID:strFormat(@"%@",attribute[@"id"])];
    [self setPower:attribute[@"power"]];
    
    
    return self;
}
@end
