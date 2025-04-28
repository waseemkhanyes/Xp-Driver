//
//  Currency.h
//  XPFood
//
//  Created by syed zia on 09/10/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Currency : NSObject
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *currencyId;
@property (nonatomic,strong) NSString   *name;
- (BOOL)isCanadian;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
