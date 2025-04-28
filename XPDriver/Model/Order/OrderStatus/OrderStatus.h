//
//  OrderStatus.h
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderStatus : NSObject
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSString *time;
- (instancetype)initWithStatus:(NSString *)status time:(NSString *)time;
@end

NS_ASSUME_NONNULL_END
