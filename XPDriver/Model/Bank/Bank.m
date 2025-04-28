//
//  Bank.m
//  XPDriver
//
//  Created by Macbook on 01/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "Bank.h"

@implementation Bank
- (instancetype)initWithAtrribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *accountNumber = [NSString stringWithFormat:@"%@",attribute[@"account_number"]];
    [self setBankId:attribute[@"id"]];
    [self setAccountNumber:[accountNumber stringByReplacingCharactersInRange:NSMakeRange(0,accountNumber.length - 4) withString:@"*"]];
    [self setAccountType:attribute[@"account_type"]];
    [self setName:attribute[@"bank_name"]];
    [self setIsVerified:[attribute[@"is_verified"] boolValue]];
    [self setIsActive:[attribute[@"status"] boolValue]];
    [self setProfileName:attribute[@"p_name"]];
    [self setPayoutType:attribute[@"payout_type"]];
    self.isBankAccount = [self.payoutType isEqualToString:@"bank_account"];
    self.isIBAN = [self.payoutType isEqualToString:@"iban"];
    self.isCARD = [self.payoutType isEqualToString:@"card"];
    return self;
}
@end
