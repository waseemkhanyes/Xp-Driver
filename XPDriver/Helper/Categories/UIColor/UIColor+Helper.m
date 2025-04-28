//
//  UIColor+Helper.m
//  XPDriver
//
//  Created by Syed zia on 26/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+(UIColor *)appBlueColor{
    return UIColorFromRGB(0x157EFB,1);
}
+(UIColor *)appGrayColor{
    return UIColorFromRGB(0x707070,1);
}
+ (UIColor *)appCancelColor{
    return UIColorFromRGB(0x1B6FA7,1);
}
+(UIColor *)appRedColor{
    return UIColorFromRGB(0xEC0503,1);
}
+(UIColor *)appGreenColor{
    return UIColorFromRGB(0x24C24E,1);
}

+(UIColor *)textFieldPlaceholderColor{
    return UIColorFromRGB(0xCCCCCC,0.3);
}
+(UIColor *)appOrangeColor{
    return [self colorFromHexString:@"#F54A02"];
}
+(UIColor *)appBlackColor{
    return [self colorFromHexString:@"#394158"];
}
+(UIColor *)bankCellSelectedColor{
    return [self colorFromHexString:@"#F1F7FC"];
}
+(UIColor *)bankCellUnSelectedColor{
   return [self colorFromHexString:@"#FAFAFA"];
}
+(UIColor *)creditCardCellSelectedColor{
    return [self colorFromHexString:@"#F1F7FC"];
}
+(UIColor *)creditCardCellUnSelectedColor{
   return [self colorFromHexString:@"#FAFAFA"];
}
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString) {
        return nil;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
