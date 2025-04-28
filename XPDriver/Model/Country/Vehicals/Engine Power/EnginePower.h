//
//  EnginePower.h
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnginePower : NSObject
@property (nonatomic,strong) NSString *powerID;
@property (nonatomic,strong) NSString *power;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;

@end

NS_ASSUME_NONNULL_END
