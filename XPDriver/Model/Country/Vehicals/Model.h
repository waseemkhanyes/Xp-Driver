//
//  Model.h
//  XPDriver
//
//  Created by Syed zia on 06/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (nonatomic,strong) NSString *modelID;
@property (nonatomic,strong) NSString *companylID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *colors;
@property (nonatomic,strong) NSMutableArray *enginePowers;

- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
