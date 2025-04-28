//
//  TripEraningController.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
static NSString const *KRides = @"Rides";
static NSString const *KRide = @"Ride";
#import "TripEarningController.h"

@implementation TripEarningController
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSDictionary *revenueDictionary = [attribute[@"graph"] dictionaryByReplacingNullsWithBlanks];
    [self setChartData:revenueDictionary];
     [self setChartDataKeys:[NSMutableArray arrayWithArray:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"]]];
    [self setEarningChartDataValues:[self getChartDataValues:revenueDictionary]]; 
    [self setCurrenceySymbol:attribute[@"currencey_symbol"]];
    [self setTotal:strFormat(@"%@%@",self.currenceySymbol,attribute[@"total"])];
    [self setTotalOrders:strFormat(@"%@",attribute[@"total_orders"])];
    [self setAcceptanceRate:strFormat(@"Acceptance Rate %@",attribute[@"acceptance_rate"])];
    [self setOnlineTime:strFormat(@"%@",attribute[@"driver_online_time"])];
    [self setOrders:[self allOrders:attribute[@"orders"]]];
    
    return self;
}
- (NSMutableArray *)allOrders:(NSArray *)results{
    NSMutableArray *orders = [NSMutableArray new];
    for (NSDictionary *dic in results) {
        Order *order = [[Order alloc] initWithAtrribute:[dic dictionaryByReplacingNullsWithBlanks]];
        [orders addObject:order];
    }
    NSArray *sortedArray;
    sortedArray = [[orders mutableCopy] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Order*)a orderId];
        NSString *second = [(Order*)b orderId];
        return [first intValue] < [second intValue];
    }];
    return [NSMutableArray arrayWithArray:sortedArray];
}
- (NSMutableArray *)getChartDataValues:(NSDictionary *)dic{
    NSMutableArray *allVelues = [NSMutableArray new];
    for (NSString *key in self.chartDataKeys) {
        // NSString* keySubstring = [key substringToIndex:[key length] - 1];
        NSString *value = [NSString stringWithFormat:@"%.2f",[dic[key] doubleValue]];
        if (strEmpty(value)) {
            value = @"0";
        }
        [allVelues addObject:value];
    }
    return allVelues;
}
- (NSMutableArray *)allTripes:(NSArray *)titelsArray{
    NSMutableArray *allTripes = [NSMutableArray new];
    for (NSDictionary *dic in titelsArray) {
        [allTripes addObject:[[Trip alloc] initWithAttrebute:dic]];
    }
    
    return allTripes;
}
@end
