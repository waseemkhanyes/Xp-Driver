//
//  FareInfo.m
//  XPDriver
//
//  Created by Syed zia on 27/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "FareInfo.h"

@implementation FareInfo
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setTitle:attribute[@"meta_key"]];
    [self setSubTitle:strFormat(@"%@ %@",SHAREMANAGER.appData.country.currencey,attribute[@"meta_value"])];
    return self;
}
@end
