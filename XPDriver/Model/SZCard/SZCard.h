//
//  SZCard.h
//  A1Rides
//
//  Created by Macbook on 08/12/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
//#import <CardConnectConsumerSDK/CardConnectConsumerSDK.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZCard : NSObject
@property (assign, nonatomic) BOOL isActive;
@property (strong, nonatomic) NSString *cardID;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *endingString;
@property (strong, nonatomic) NSString *last4;
@property (strong, nonatomic) UIImage *brandImage;
//+ (UIImage *)brandImageForCardBrand:(CCCCardIssuer)brand;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
