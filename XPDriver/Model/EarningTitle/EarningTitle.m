//
//  EarningTitle.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "EarningTitle.h"

@implementation EarningTitle
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setFromDate:attribute[@"from"]];
    [self setToDate:attribute[@"to"]];
    [self setTitle:attribute[@"lable"]];
    return self;
}
@end
