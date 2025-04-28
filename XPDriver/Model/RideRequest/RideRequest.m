//
//  Ridem
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "RideRequest.h"

@implementation RideRequest


- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSArray *ordersArray       = attribute[@"orders"];
    
    self.orders              = [self getOrders:ordersArray];
    self.order               =  [self getActiveOrder];
    self.requestedOrder      = [self getNewOrder];
    self.isNewOrder          = self.requestedOrder != nil;
    self.deliverdOrder       = [self  getDeliveredOrder];
    return self;
    
}



- (NSMutableArray *)getOrders:(NSArray *)ordersArray{
    NSMutableArray *orders = [NSMutableArray new];
    NSMutableArray *allOrdersFormSameRestuarent = [NSMutableArray new];
    NSMutableArray *allOrdersFormOtherRestuarent = [NSMutableArray new];
    for (NSDictionary *dic in ordersArray) {
        Order *order = [[Order alloc] initWithAtrribute:[dic dictionaryByReplacingNullsWithBlanks]];
        [orders addObject:order];
    }
    for (Order *order in orders) {
        if ([order.restaurant.restaurentId isEqualToString:self.order.restaurant.restaurentId]) {
            [allOrdersFormSameRestuarent addObject:order];
        }else{
             [allOrdersFormOtherRestuarent addObject:order];
        }
    }
    
   // orders = [NSMutableArray arrayWithArray:[[self ordersSortedById:allOrdersFormSameRestuarent] arrayByAddingObjectsFromArray:[self ordersSortedById:allOrdersFormOtherRestuarent]]];
    NSSortDescriptor *sortDescriptor;
       sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isActive"
                                                    ascending:NO];
    return [NSMutableArray arrayWithArray:[orders sortedArrayUsingDescriptors:@[sortDescriptor]]];
}
- (NSArray *)ordersSortedById:(NSArray *)array{
    NSSortDescriptor *sortDescriptor;
       sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"status"
                                                    ascending:YES];
       return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}
- (Order *)getActiveOrder{
    for (Order *order in self.orders) {
        if (order.isActive) {
            return order;
        }
    }
    return  self.orders[0];
}
- (Order *)getDeliveredOrder{
    for (Order *order in self.orders) {
        if (order.isDelivered) {
            return order;
        }
    }
    return  nil;
}
- (Order *)getNewOrder{
    if (self.orders.count == 1) {
        return nil;
    }
    for (Order *order in self.orders) {
        if (order.isRequested) {
            return order;
        }
    }
    return  nil;
}



@end
