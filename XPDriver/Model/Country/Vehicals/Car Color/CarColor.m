//
//  CarColor.m
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "CarColor.h"

@implementation CarColor
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setColorID:strFormat(@"%@",attribute[@"id"])];
    [self setName:attribute[@"name"]];
    [self setColorString:attribute[@"color"]];
    [self setColor:[UIColor colorFromHexString:self.colorString]];
   
    return self;
}
@end
