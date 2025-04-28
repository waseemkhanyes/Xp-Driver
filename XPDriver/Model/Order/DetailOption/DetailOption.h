//
//  DetailOption.h
//  XPFood
//
//  Created by Macbook on 20/11/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailOption : NSObject
@property (nonatomic, strong) NSString   *title;
@property (nonatomic, strong) NSString   *subtitel;
- (instancetype)initWithTitel:(NSString *)titel subTitel:(NSString *)subTitel;
@end

NS_ASSUME_NONNULL_END
