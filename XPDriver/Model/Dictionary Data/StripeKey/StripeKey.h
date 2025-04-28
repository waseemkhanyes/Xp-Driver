//
//  StripeKey.h
//  XPFood
//
//  Created by syed zia on 16/10/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StripeKey : NSObject
@property (nonatomic,strong) NSString *canadainKey;
@property (nonatomic,strong) NSString *usaKey;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
