//
//  StripeKey.m
//  XPFood
//
//  Created by syed zia on 16/10/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import "StripeKey.h"

@implementation StripeKey
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCanadainKey:attribute[@"ca"]];
    [self setUsaKey:attribute[@"usa"]];
    return  self;
}
@end
