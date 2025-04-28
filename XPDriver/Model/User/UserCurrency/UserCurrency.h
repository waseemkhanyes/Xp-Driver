//
//  UserCurrency.h
//  XPFood
//
//  Created by syed zia on 08/01/2022.
//  Copyright © 2022 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCurrency : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) BOOL isPreferred;
@property (nonatomic, assign) BOOL isCanadian;
- (instancetype)initWithAtrribute:(NSDictionary *)attribute;

@end

NS_ASSUME_NONNULL_END
