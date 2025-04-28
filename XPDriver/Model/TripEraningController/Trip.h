//
//  Trip.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
/*
 
 
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Trip : NSObject
@property (nonatomic, strong) NSString *tripId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UIColor *statusColor;
@property (nonatomic, strong) NSString *requestedTime;
@property (nonatomic, strong) NSString *fare;
@property (nonatomic, strong) NSString *paymentMode;

- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
@end

NS_ASSUME_NONNULL_END
