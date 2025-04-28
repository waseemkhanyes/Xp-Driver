//
//  EarningTitle.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EarningTitle : NSObject
@property (nonatomic, strong) NSString *toDate;
@property (nonatomic, strong) NSString *fromDate;
@property (nonatomic, strong) NSString *title;
- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
@end

NS_ASSUME_NONNULL_END
