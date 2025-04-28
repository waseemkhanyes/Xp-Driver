//
//  Currency.m
//  XPFood
//
//  Created by syed zia on 09/10/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import "Currency.h"

@implementation Currency
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCurrencyId:attribute[@"id"]];
    [self setTitle:attribute[@"title"]];
    [self setName:attribute[@"name"]];
    return self;
}
- (BOOL)isCanadian{
    return  [self.name isEqualToString:@"CAD"];
}
@end
