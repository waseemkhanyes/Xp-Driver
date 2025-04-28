//
//  OrderTracking.h
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderStatus.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderTracking : NSObject
@property (nonatomic, strong) OrderStatus *confirmed;
@property (nonatomic, strong) OrderStatus *prepare;
@property (nonatomic, strong) OrderStatus *assigned;
@property (nonatomic, strong) OrderStatus *onWay;
@property (nonatomic, strong) OrderStatus *completed;
@property (nonatomic, strong) OrderStatus *canceled;
@property (nonatomic, strong) OrderStatus *readyForPickup;
- (instancetype)initWithAtrribute:(NSDictionary *)attribute;

@end

NS_ASSUME_NONNULL_END
