//
//  Payments.m
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "Payments.h"

@implementation Payments
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *currancy = SHAREMANAGER.appData.country.currencey == nil ? @"" :SHAREMANAGER.appData.country.currencey;
    NSDate *date = [NSDate dateFromString:attribute[@"available_at"] withFormat:@"yyyy-MM-dd"];
    [self setPaymentID:attribute[@"id"]];
    [self setOrderID:attribute[@"order_id"]];
    [self setAvailable:[attribute[@"available"] intValue] == 1];
    [self setAmount:[NSString stringWithFormat:@"%@%@",currancy,attribute[@"amount"]]];
    [self setCreatedAt:attribute[@"created_at"]];
    [self setAvailableAt:[date stringWithFormat:DATE_ONLY_DISPLAY]];
    return self;
}
@end
