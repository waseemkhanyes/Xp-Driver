//
//  AvailableCountry.h
//  XPFood
//
//  Created by Macbook on 02/06/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvailableCountry : NSObject


@property (nonatomic, strong,nullable) NSString *countryID;
@property (nonatomic, strong,nullable) NSString *name;
@property (nonatomic, strong,nullable) NSString *currecy;
@property (nonatomic, strong,nullable) NSString *iso_code_2;
@property (nonatomic, strong,nullable) NSString *iso_code_3;
@property (nonatomic, assign) BOOL isCanada;
@property (nonatomic, assign) BOOL isUSA;
@property (nonatomic, assign) BOOL isUK;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
