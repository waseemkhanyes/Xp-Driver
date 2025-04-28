//
//  FareInfo.h
//  XPDriver
//
//  Created by Syed zia on 27/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FareInfo : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subTitle;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
