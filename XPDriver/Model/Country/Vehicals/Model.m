//
//  Model.m
//  XPDriver
//
//  Created by Syed zia on 06/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "Model.h"

@implementation Model
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setModelID:strFormat(@"%@",attribute[@"id"])];
    [self setName:attribute[@"model_name"]];
    [self setCompanylID:strFormat(@"%@",attribute[@"car_company_id"])];
    return self;
}
@end
