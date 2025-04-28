//
//  VehicleController.m
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "VehicleManager.h"

@implementation VehicleManager
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
        self.carTypres = SHAREMANAGER.appData.country.vehicles;
        self.manufacturers = [NSMutableArray new];
        self.models = [NSMutableArray new];
        self.enginePower = [NSMutableArray new];
        self.modelYears = [NSMutableArray new];
        self.colors = [NSMutableArray new];
        
    }
    return self;
}
- (void)setCarTypres:(NSMutableArray *)carTypres{
    _carTypres = carTypres;
    if (![_carTypres containsObject:PLEASE_SELECT]) {
       [_carTypres insertObject:PLEASE_SELECT atIndex:0];
    }
}
- (void)setManufacturers:(NSMutableArray *)manufacturers{
    _manufacturers = manufacturers;
    if (![_manufacturers containsObject:PLEASE_SELECT]) {
     [_manufacturers insertObject:PLEASE_SELECT atIndex:0];
    }
}
- (void)setModels:(NSMutableArray *)models{
    _models = models;
     if (![_models containsObject:PLEASE_SELECT]) {
     [_models insertObject:PLEASE_SELECT atIndex:0];
     }
}
- (void)setEnginePower:(NSMutableArray *)enginePower{
    _enginePower = enginePower;
     if (![_enginePower containsObject:PLEASE_SELECT]) {
     [_enginePower insertObject:PLEASE_SELECT atIndex:0];
     }
}
- (void)setColors:(NSMutableArray *)colors{
    _colors = colors;
      if (![colors containsObject:PLEASE_SELECT]) {
    [_colors insertObject:PLEASE_SELECT atIndex:0];
     }
}
- (NSMutableArray *)modelYears{
    //Expiration year
    NSMutableArray *requiredYears = [NSMutableArray new];
    for (int i = 0; i <self.olderYear; i++) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        NSString *yearString = [NSString stringWithFormat:@"%i",(int)currentYear - i];
        [requiredYears addObject:yearString];
        
    }
     [requiredYears insertObject:PLEASE_SELECT atIndex:0];
    return requiredYears;
}
@end
