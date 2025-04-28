//
//  Page.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "Page.h"

@implementation Page
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setWeeks:attribute[@"weeks"]];
    [self  setDescending:attribute[@"dec"]];
    return self;
}
@end
