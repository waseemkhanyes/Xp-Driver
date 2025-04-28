//
//  WithdrawController.m
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "Payments.h"
#import "Transaction.h"
#import "WithdrawController.h"

@implementation WithdrawController
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *available = attribute[@"active_balance"];
    NSString *currency = @"";
    if (SHAREMANAGER.user.defaultCurrency.name){
        currency = SHAREMANAGER.user.defaultCurrency.name;
    }else{
        currency =  SHAREMANAGER.user.currency;
    }
    DLog(@"wk currency: %@", currency);
    DLog(@"wk active_balance: %@", available);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
//    float value = [numberFormatter numberFromString:[available stringByReplacingOccurrencesOfString:currency withString:@""]].floatValue;
    
    float value = [numberFormatter numberFromString:attribute[@"active_amount"]].floatValue;
    
    DLog(@"wk value: %f", value);
    NSString *availableBlance = [NSString currencyString:value currency:currency];
    DLog(@"wk availableBlance1: %@", availableBlance);
    
    [self setAvailableAmount:attribute[@"available_balance"]];
    [self setAvailableBalanceValue:[attribute[@"active_amount"] floatValue]];
    [self setAvailableAmountValue:[attribute[@"available_amount"] floatValue]];
    
//    [self setBalance:[NSString stringWithFormat:@"%@",availableBlance]];
    [self setBalance:attribute[@"active_balance"]];
//    [self setAvailableBalance:[NSString stringWithFormat:@"Available %@", attribute[@"available_balance"]]];
    [self setAvailableBalance:[NSString stringWithFormat:@"%@ %@", (self.availableAmountValue < 0 ? @"Owing" : @"Available"), attribute[@"available_balance"]]];
    
//    [self setAvailableAmount:attribute[@"active_balance"]];
////    [self setAvailableBalanceValue:value];
//    [self setAvailableBalanceValue:[attribute[@"active_amount"] floatValue]];
////    [self setBalance:[NSString stringWithFormat:@"%@",availableBlance]];
//    [self setBalance:[NSString stringWithFormat:@"%@",available]];
//    [self setAvailableBalance:[NSString stringWithFormat:@"Available %@",availableBlance]];
    
    
//    [self setAvailableAmount:attribute[@"active_balance"]];
//    [self setAvailableBalanceValue:value];
//    [self setBalance:[NSString stringWithFormat:@"%@",availableBlance]];
//    [self setAvailableBalance:[NSString stringWithFormat:@"Available %@",availableBlance]];
    
    
    NSString *pending = attribute[@"pending_balance"];
    BOOL isEmptyAmount = [pending isEqualToString:@"$ "] || [pending isEqualToString:@"$"];
    NSString *displayPendingAmount = isEmptyAmount ? [NSString currencyString:0.0 currency:currency] : pending;
    [self setPendingAmount:[NSString stringWithFormat:@"Pending %@",displayPendingAmount]];

    [self setPendingBalance:[NSString stringWithFormat:@"%@",attribute[@"pending_balance"]]];
    [self setAvailableAttributedString:[NSAttributedString attributedString:@"Available " withFont:[UIFont normal] subTitle:availableBlance withfont:[UIFont heading1] nextLine:NO]];
    [self setPendingAttributedString:[NSAttributedString attributedString:@"Pending " withFont:[UIFont normal] subTitle:displayPendingAmount withfont:[UIFont heading1] nextLine:NO]];
    [self setPayments:[self allPayments:attribute[@"payments"]]];
    [self setTransactions:[self alltransactions:attribute[@"transactions"]]];
    float total = [self.balance floatValue] + [self.pendingBalance floatValue];
    [self setTotalBalance: [NSString currencyString:total currency:SHAREMANAGER.user.currency]];
    return self;

}

- (NSAttributedString *)pendingAttributedStringWithCurrency:(NSString *)currency{
    NSString *pending = [self.pendingBalance stringByReplacingOccurrencesOfString:@"$" withString:@""];
    BOOL isEmptyAmount = [pending isEqualToString:@"$ "] || [pending isEqualToString:@"$"];
    NSString *displayPendingAmount = isEmptyAmount ? [NSString currencyString:0.0 currency:currency] : pending;
    return  [NSAttributedString attributedString:@"Pending " withFont:[UIFont normal] subTitle:displayPendingAmount withfont:[UIFont normal] nextLine:NO];
}
- (NSAttributedString *)availableAttributedStringWithCurrency:(NSString *)currency{
//    NSString *available = [self.availableAmount stringByReplacingOccurrencesOfString:@"$" withString:@""];
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
//    float value = [numberFormatter numberFromString:available].floatValue;
//    NSString *availableBlance = [NSString currencyString:value currency:currency];
//    DLog(@"wk check %@", availableBlance);
//    return  [NSAttributedString attributedString:@"Available " withFont:[UIFont normal] subTitle:availableBlance withfont:[UIFont heading1] nextLine:NO];
    NSDictionary *availableAttributes = @{
        NSFontAttributeName: [UIFont normal],
    };
    NSDictionary *restAttributes = @{
        NSFontAttributeName: [UIFont normal],
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.availableBalance];
    [attributedString setAttributes:availableAttributes range:[self.availableBalance rangeOfString:@"Available"]];
    [attributedString setAttributes:restAttributes range:NSMakeRange(10, self.availableBalance.length - 10)];
    return attributedString;
}
- (NSMutableArray *)allPayments:(NSArray *)paymentsArray{
    NSMutableArray *payments = [NSMutableArray new];
    for (NSDictionary *dic in paymentsArray) {
        [payments addObject:[[Payments alloc] initWithAttribute:dic]];
    }
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"availableAt" ascending:YES];
//    [payments sortUsingDescriptors:@[sortDescriptor]];
    return payments;
}
- (NSMutableArray *)alltransactions:(NSArray *)transactionsArray{
    NSMutableArray *transactions = [NSMutableArray new];
    for (NSDictionary *dic in transactionsArray) {
        [transactions addObject:[[Transaction alloc] initWithAttribute:dic]];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orignalDate" ascending:NO];
    [transactions sortUsingDescriptors:@[sortDescriptor]];
    return transactions;
}
@end
