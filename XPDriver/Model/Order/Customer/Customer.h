//
//  Cutomer.h
//  XPDriver
//
//  Created by Macbook on 22/03/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Customer : NSObject
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString  *rating;
@property (nonatomic,strong) NSURL *imageURL;
- (instancetype)initWithAttrebute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
