//
//  UIColor+Helper.h
//  XPDriver
//
//  Created by Syed zia on 26/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)
+(UIColor *)appOrangeColor;
+(UIColor *)appBlueColor;
+(UIColor *)appGrayColor;
+(UIColor *)appRedColor;
+(UIColor *)appCancelColor;
+(UIColor *)appGreenColor;
+(UIColor *)appBlackColor;
+(UIColor *)bankCellSelectedColor;
+(UIColor *)bankCellUnSelectedColor;
+(UIColor *)textFieldPlaceholderColor;
+(UIColor *)creditCardCellSelectedColor;
+(UIColor *)creditCardCellUnSelectedColor;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end
