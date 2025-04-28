//
//  RouteStep.h
//  XPDriver
//
//  Created by Syed zia on 26/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteStep : NSObject
@property (nonatomic,assign) int distance;
@property (nonatomic,assign) int duration;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END
