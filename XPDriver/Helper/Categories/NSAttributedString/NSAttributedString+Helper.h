//
//  NSAttributedString+Helper.h
//  XPDriver
//
//  Created by Syed zia on 24/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Helper)
+ (NSAttributedString *)attributedString:(NSString *)title withFont:(UIFont *)titleFont subTitle:(NSString *)subtitel withfont:(UIFont *)subtitleFont nextLine:(BOOL)nextLine;
+ (NSAttributedString *)attributedStringWithTitel:(NSString *)title withFont:(UIFont *)titleFont  titleColor:(UIColor *)titleColor subTitle:(NSString *)subtitel withfont:(UIFont *)subtitleFont subtitleColor:(UIColor *)subtitleColor   nextLine:(BOOL)nextLine;
- (NSAttributedString *)withLineSpacing:(float)space;
@end

NS_ASSUME_NONNULL_END
