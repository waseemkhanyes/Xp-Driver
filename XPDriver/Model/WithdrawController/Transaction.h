//
//  Transaction.h
//  XPDriver
//
//  Created by Macbook on 20/01/2021.
//  Copyright © 2021 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transaction : NSObject
@property (nonatomic, strong)   NSString *tid;
@property (nonatomic, strong)   NSString *uid;
@property (nonatomic, strong)   NSString *amount;
@property (nonatomic, strong)   NSString *direction;
@property (nonatomic, strong)   NSString *date;
@property (nonatomic, strong)   NSString *orignalDate;
@property (nonatomic, strong)   NSString *tdescription;
@property (nonatomic, strong)   NSString *paymentMethod;
@property (nonatomic, strong)   NSString *paymentStatus;
@property (nonatomic, strong)   NSString *transactionAmount;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
