//
//  Bank.h
//  XPDriver
//
//  Created by Macbook on 01/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bank : NSObject
@property (nonatomic, assign) BOOL   isVerified;
@property (nonatomic, assign) BOOL   isActive;
@property (nonatomic, assign) BOOL   isBankAccount;
@property (nonatomic, assign) BOOL   isIBAN;
@property (nonatomic, assign) BOOL   isCARD;
@property (nonatomic, strong) NSString   *bankId;
@property (nonatomic, strong) NSString   *accountNumber;
@property (nonatomic, strong) NSString   *accountType;
@property (nonatomic, strong) NSString   *name;
@property (nonatomic, strong) NSString   *profileName;
@property (nonatomic, strong) NSString   *price;
@property (nonatomic, strong) NSString   *payoutType;
- (instancetype)initWithAtrribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
