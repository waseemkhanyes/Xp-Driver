//
//  CarColor.h
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarColor : NSObject
@property (nonatomic,strong) NSString *colorID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *colorString;
@property (nonatomic,strong) UIColor *color;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
