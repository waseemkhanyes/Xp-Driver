//
//  Page.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Page : NSObject
@property (nonatomic, strong) NSString *weeks;
@property (nonatomic, strong) NSString *descending;

- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
@end

NS_ASSUME_NONNULL_END
