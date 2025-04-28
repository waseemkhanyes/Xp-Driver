//
//  OrderSubItem.h
//  XPEats
//
//  Created by Macbook on 06/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderSubItem : NSObject
@property (nonatomic) float price;
@property (nullable,strong, nonatomic) NSString *subItemId;
@property (nullable,strong, nonatomic) NSString *name;
@property (nullable,strong, nonatomic) NSString *quantity;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
