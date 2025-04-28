//
//  WithdrawController.h
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawController : NSObject
@property (nonatomic, assign) float availableBalanceValue;
@property (nonatomic,strong) NSString *pendingAmount;
@property (nonatomic,strong) NSString *availableBalance;
@property (nonatomic,strong) NSString *availableAmount;
@property (nonatomic,assign) float availableAmountValue;
@property (nonatomic,strong) NSString *balance;
@property (nonatomic,strong) NSString *pendingBalance;
@property (nonatomic,strong) NSString *totalBalance;
@property (nonatomic,strong) NSAttributedString *pendingAttributedString;
@property (nonatomic,strong) NSAttributedString *availableAttributedString;
@property (nonatomic,strong) NSMutableArray *payments;
@property (nonatomic,strong) NSMutableArray *transactions;
- (NSAttributedString *)pendingAttributedStringWithCurrency:(NSString *)currency;
- (NSAttributedString *)availableAttributedStringWithCurrency:(NSString *)currency;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
