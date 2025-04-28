//
//  State.h
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface State : NSObject
@property (nonatomic,strong) NSString *stateId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *cities;
@property (nonatomic,strong) NSMutableArray *documents;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
