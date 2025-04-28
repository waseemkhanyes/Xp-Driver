//
//  InvoiceItem.m
//  XPDriver
//
//  Created by Macbook on 01/02/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "InvoiceItem.h"

@implementation InvoiceItem
- (instancetype)initWithAttribute:(NSDictionary *)attribute currrencySymbol:(NSString *)currrencySymbol{
    self = [super init];
       if (!self) {
           return nil;
       }
    
    if (attribute[@"quantity"]) {
        [self setColor:[UIColor blackColor]];
        [self setTitle:attribute[@"item_name"]];
        [self setQuantity:[NSString stringWithFormat:@"%@",attribute[@"quantity"]]];
    }else{
        [self setColor:[UIColor lightGrayColor]];
        [self setTitle:attribute[@"name"]];
        [self setQuantity:[NSString stringWithFormat:@"%@",attribute[@"qty"]]];
    }
    if (attribute[@"unit_price"]) {
        [self setColor:[UIColor blackColor]];
        [self setPrice:[NSString stringWithFormat:@"%@",attribute[@"unit_price"]]];
    }else{
        [self setColor:[UIColor lightGrayColor]];
        [self setPrice:[NSString stringWithFormat:@"%@",attribute[@"price"]]];
    }
    [self setTotal:[NSString stringWithFormat:@"%@",attribute[@"total"]]];
    [self setPriceInfo:[NSString stringWithFormat:@"%@ X %@%@",self.quantity,currrencySymbol,self.price]];
    return self;
}
- (instancetype)initWithTitel:(NSString *)titel price:(NSString *)price currrencySymbol:(NSString *)currrencySymbol{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setTitle:titel];
    [self setPriceInfo:[NSString stringWithFormat:@"%@",price]];
    return self;
    
}
@end
