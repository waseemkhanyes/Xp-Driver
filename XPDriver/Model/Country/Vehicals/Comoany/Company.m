//
//  Comoany.m
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "Company.h"

@implementation Company
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCompanyID:strFormat(@"%@",attribute[@"company_id"])];
    [self setName:attribute[@"company_name"]];
    [self setCarTypeID:strFormat(@"%@",attribute[@"car_type_id"])];
   
    return self;
}
@end
