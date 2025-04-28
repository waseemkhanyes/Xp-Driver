//
//  Payments.h
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  strongright © 2020 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Payments : NSObject
@property (nonatomic, strong)   NSString *paymentID;
@property (nonatomic, strong)   NSString *userID;
@property (nonatomic, strong)   NSString *orderID;
@property (nonatomic, strong)   NSString *amount;
@property (nonatomic, strong)   NSString *availableAt;
@property (nonatomic, assign)   BOOL    available;
@property (nonatomic, strong)   NSString *createdAt;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
