//
//  OrderRestaurant.h
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderRestaurant : NSObject
@property (nonatomic, assign) BOOL isForParking;
//@property (nonatomic, assign) BOOL isForSeats;
@property (nonatomic, assign) BOOL isNone;
@property (nonatomic, strong) NSString *restaurentId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
//@property (nonatomic, strong) NSString *currrencyCode;
//@property (nonatomic, strong) NSString *currrencySymbol;
@property (nonatomic, strong) NSURL *brandLogoUrl;
@property (nonatomic, strong) MyLocation *location;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
- (instancetype)initWithAtrribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
