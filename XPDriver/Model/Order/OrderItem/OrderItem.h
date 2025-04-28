//
//  OrederItem.h
//  XPEats
//
//  Created by Macbook on 04/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "OrderSubItem.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderItem : NSObject
@property (nonatomic) BOOL forPickup;
@property (nonatomic) BOOL forDelivery;
@property (nonatomic) BOOL hasSubItems;
@property (nonatomic) int categoryID;
@property (nonatomic) int itemID;
@property (nonatomic) int subItemID;
@property (nonatomic) int restaurantID;
@property (nonatomic) int menuID;
@property (nonatomic) int itemQuantity;
@property (nonatomic) float itemPrice;
@property (nonatomic) float unitPrice;
@property (nonatomic) float subItemPrice;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *itemNote;
@property (strong, nonatomic) NSString *subItemsString;
@property (strong, nonatomic) NSString *subItemsPriceString;
@property (strong, nonatomic) NSMutableArray <OrderSubItem *> *subItems;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
