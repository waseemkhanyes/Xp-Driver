//
//  SZCard.m
//  A1Rides
//
//  Created by Macbook on 08/12/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
@import Stripe;
#import "SZCard.h"

@implementation SZCard
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
       if (!self) {
           return nil;
       }
    int status = [attribute[@"status"] intValue];
    [self setCardID:[NSString stringWithFormat:@"%@",attribute[@"id"]]];
    if (attribute[@"creditcardtype"] != nil) {
        [self setBrand:attribute[@"creditcardtype"]];
    }else if (attribute[@"brand"] != nil) {
        [self setBrand:attribute[@"brand"]];
    }
    if (attribute[@"last4"] != nil) {
        [self setLast4:attribute[@"last4"]];
    }else if (attribute[@"account_number"] != nil) {
        [self setLast4:attribute[@"account_number"]];
    }
    [self setEndingString:[NSString stringWithFormat:@"••••%@",self.last4]];
    STPCardBrand  brand = [STPCard brandFromString:self.brand];
    [self setBrandImage:[STPImageLibrary brandImageForCardBrand:brand]];
    [self setIsActive:status != 0];
    return self;
}

@end
