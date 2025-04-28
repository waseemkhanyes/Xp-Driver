//
//  Transaction.m
//  XPDriver
//
//  Created by Macbook on 20/01/2021.
//  Copyright © 2021 Syed zia. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *currancy = SHAREMANAGER.appData.country.currencey == nil ? @"" :SHAREMANAGER.appData.country.currencey;
    NSDate *date = [NSDate dateFromString:attribute[@"date"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self setTid:attribute[@"id"]];
    [self setUid:attribute[@"uid"]];
    [self setDirection:attribute[@"direction"]];
    if ([self.direction isEqualToString:@"debit"]) {
        [self setAmount:[NSString stringWithFormat:@"-%@%@",currancy,attribute[@"amount"]]];
    } else {
        [self setAmount:[NSString stringWithFormat:@"%@%@",currancy,attribute[@"amount"]]];
    }
    
    [self setPaymentMethod:attribute[@"payment_method"]];
    [self setPaymentStatus:attribute[@"payment_status"]];
    [self setTransactionAmount:attribute[@"transaction_amount"]];
    [self setDate:[date stringWithFormat:DATE_ONLY_DISPLAY]];
    [self setOrignalDate:attribute[@"date"]];
    return self;
}
@end
