//
//  Comoany.h
//  XPDriver
//
//  Created by Syed zia on 07/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Company : NSObject
@property (nonatomic,strong) NSString *companyID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *carTypeID;
@property (nonatomic,strong) NSMutableArray *modeles;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
