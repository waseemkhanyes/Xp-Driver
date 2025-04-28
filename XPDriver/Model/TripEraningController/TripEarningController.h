//
//  TripEraningController.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#import "Trip.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripEarningController : NSObject
@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) NSString *acceptanceRate;
@property (nonatomic, strong) NSString *onlineTime;
@property (nonatomic, strong) NSString *currenceySymbol;
@property (nonatomic, strong) NSString *totalOrders;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSDictionary   *chartData;
@property (nonatomic, strong) NSMutableArray *chartDataKeys;
@property (nonatomic, strong) NSMutableArray *earningChartDataValues;
- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
@end

NS_ASSUME_NONNULL_END
