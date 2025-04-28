//
//  RegisterController.m
//  XPDriver
//
//  Created by Syed zia on 01/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
//#import "AFAppDotNetAPIClient.h"
#import "RegisterController.h"

@implementation RegisterController
+ (instancetype)share
{
    static id RegisterController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RegisterController = [[self alloc] init];
    });
    return RegisterController;
}
- (id)init {
    if (self = [super init]) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        Vehicle *car = SHAREMANAGER.appData.country.vehicles[0];
        Vehicle *car = SHAREMANAGER.appData.country.vehicles.firstObject; // Use `firstObject` to safely access the first element
        NSString *countryId  = SHAREMANAGER.appData.country.countryId;
        NSString *carId = car ? car.vId : @""; // Safely unwrap `car` and handle nil case
        self.registerParametrs = [NSMutableDictionary new];
        [self.registerParametrs setObject:COMMAND_NEW_ACCOUNT forKey:@"command"];
        [self.registerParametrs setObject:carId forKey:@"car_id"];
        [self.registerParametrs setObject:@"" forKey:@"car_number"];
        [self.registerParametrs setObject:ROLE_ID forKey:@"role_id"];
        [self.registerParametrs setObject:countryId forKey:@"country_id"];
        [self.registerParametrs setObject:@"IOS" forKey:@"device_name"];
        [self.registerParametrs setObject:appVersion forKey:@"app_version"];
        
    }
    return self;
}
- (void)userRegisterWithBlock:(AFSuccessCompletion)block{
    [User userRegister:self.registerParametrs completion:block];
}
@end
