//
//  VehicleController.h
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VehicleManager : NSObject
@property (nonatomic, strong) NSMutableArray *carTypres;
@property (nonatomic, strong) NSMutableArray *manufacturers;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableArray *enginePower;
@property (nonatomic, strong) NSMutableArray *modelYears;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic,assign) NSInteger  olderYear;
+ (instancetype)share;
@end

NS_ASSUME_NONNULL_END
