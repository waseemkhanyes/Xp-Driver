//
//  CodManager.h
//  XPDriver
//
//  Created by Waseem  on 19/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CodManager : NSObject

+ (NSString *)getStripeKey;
+(UserCurrency *)selectedCurrency;
+(User *)currentUser;

typedef void (^HandlerDone)(void);
+ (void)fetchProfileDetailWithCompletionHandler:(HandlerDone)completionHandler;

@end

NS_ASSUME_NONNULL_END
