//
//  City.h
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *stateId;
@property (nonatomic,strong) NSString *zipcode;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
