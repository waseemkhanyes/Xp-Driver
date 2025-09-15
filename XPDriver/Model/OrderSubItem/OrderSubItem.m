//
//  OrderSubItem.m
//  XPEats
//
//  Created by Macbook on 06/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "OrderSubItem.h"

@implementation OrderSubItem
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
  self = [super init];
       if (!self) {
           return nil;
       }
//    [self setSubItemId:[NSString stringWithFormat:@"%@",attribute[@"id"]]];
    [self setName:attribute[@"name"]];
    [self setPrice:[attribute[@"price"] floatValue]];
    [self setQuantity:[NSString stringWithFormat:@"%@",attribute[@"qty"]]];
    return self;
}
    
    
@end
