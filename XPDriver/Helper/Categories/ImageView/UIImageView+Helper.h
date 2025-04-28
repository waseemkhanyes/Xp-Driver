//
//  UIImageView+Helper.h
//  XPDriver
//
//  Created by Syed zia on 02/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Helper)
- (void)round;
- (void)roundWithoutBorder;
- (void)roundWithBoarderColor:(UIColor *)color;
- (void)roundCorner:(float)radius borderColor:(UIColor *)color;
- (void)roundBottomLeftConner;
- (BOOL)isPlaceHolder:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
