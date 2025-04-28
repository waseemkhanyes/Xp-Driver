//
//  OrederItem.m
//  XPEats
//
//  Created by Macbook on 04/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
       if (!self) {
           return nil;
       }
    NSArray *subitems = attribute[@"subitem"];
    [self setUnitPrice:[attribute[@"unit_price"] floatValue]];
    [self setMenuID:[attribute[@"menu_id"] intValue]];
    [self setItemID:[attribute[@"item_id"] intValue]];
    [self setItemName:attribute[@"name"]];
    [self setItemQuantity:[attribute[@"qty"] intValue]];
    [self setHasSubItems:[attribute[@"has_subitem"] boolValue]];
    [self setSubItemsString:self.hasSubItems ? [self subItemsString:subitems] : @""];
     float price = self.unitPrice + [self subItemsPrice:subitems];
    [self setItemPrice:(price *self.itemQuantity)];
    [self setSubItems:[self subItems:subitems]];
    [self setSubItemPrice:[self subItemsPriceStringString:self.subItems]];
    [self setSubItemsPriceString:@(self.subItemPrice).stringValue];
   return self;
}
- (float)subItemsPrice:(NSArray *)subitems{
     float price = 0.0;
    for (NSDictionary *dic in subitems) {
        price += [dic[@"price"] floatValue];
    }
    return price;
}
- (NSMutableArray *)subItems:(NSArray *)subitems{
    NSMutableArray *allSubItems = [NSMutableArray new];
    for (NSDictionary *dic in subitems) {
        OrderSubItem *subItem = [[OrderSubItem alloc] initWithAttribute:dic];
        [allSubItems addObject:subItem];
    }
    return allSubItems;
}
- (NSString *)subItemsString:(NSArray *)subitems{
    NSString *stringFromate = @"";
    for (NSDictionary *dic in subitems) {
        if (stringFromate.isEmpty) {
           stringFromate = [stringFromate stringByAppendingString:dic[@"name"]];
        }else{
             stringFromate = [NSString stringWithFormat:@"%@•%@",stringFromate,dic[@"name"]];
        }
    }
    return stringFromate;
}
- (float)subItemsPriceStringString:(NSMutableArray *)subitems{
    float subitemsTotalPrice = 0;
    for (OrderSubItem *subItem in subitems) {
        subitemsTotalPrice += subItem.price;
    }
    return subitemsTotalPrice;
}
@end
