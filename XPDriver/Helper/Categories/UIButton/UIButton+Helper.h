//
//  UIButton+Helper.h
//  XPDriver
//
//  Created by Syed zia on 15/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Helper)
- (BOOL)isChecked;
- (BOOL)isOnLine;
- (void)updateStatusImage:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
