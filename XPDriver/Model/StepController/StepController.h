//
//  stepController.h
//  XPDriver
//
//  Created by Syed zia on 26/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "RouteStep.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepController : NSObject
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSMutableArray *allSteps;
- (instancetype)initWithAttrebute:(NSDictionary *)attribute;
- (void)removeCoordinate:(CLLocationCoordinate2D )coordinate;
@end

NS_ASSUME_NONNULL_END
