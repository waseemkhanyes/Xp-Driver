//
//  AvailableCountry.m
//  XPFood
//
//  Created by Macbook on 02/06/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import "AvailableCountry.h"


@implementation AvailableCountry

- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCountryID:attribute[@"id"]];
    [self setName:attribute[@"name"]];
    [self setCurrecy:attribute[@"currency"]];
    [self setIso_code_2:attribute[@"iso_code_2"]];
    [self setIso_code_3:attribute[@"iso_code_3"]];
    BOOL isUK = [self.name isEqualToString:@"United Kingdom"];
    BOOL isUSA = [self.name isEqualToString:@"United States"];
    BOOL isCAD = [self.name isEqualToString:@"Canada"];
    [self setIsUK: isUK];
    [self setIsUSA: isUSA];
    [self setIsCanada:isCAD];
    return  self;
}

@end
