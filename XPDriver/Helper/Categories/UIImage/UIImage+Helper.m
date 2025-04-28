//
//  UIImage+Helper.m
//  XPDriver
//
//  Created by Syed zia on 02/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

- (UIImage *)initWithColor:(UIColor *)color{
  
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
 
}
@end
