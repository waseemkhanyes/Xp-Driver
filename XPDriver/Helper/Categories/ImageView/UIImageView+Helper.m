//
//  UIImageView+Helper.m
//  XPDriver
//
//  Created by Syed zia on 02/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)
- (BOOL)isPlaceHolder:(UIImage *)image{
   return [SHAREMANAGER image:self.image isEqualTo:image];
}
#pragma mark -
-(void)round{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor =[[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    
}
-(void)roundWithoutBorder{
    self.layer.borderWidth = 0.0f;
    self.layer.borderColor =[[UIColor whiteColor] CGColor];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    
}
-(void)roundWithBoarderColor:(UIColor *)color{
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;


}
- (void)roundCorner:(float)radius borderColor:(UIColor *)color{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.shadowRadius  = radius;
    self.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = 0.5f;
//    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
//    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, shadowInsets)];
//     self.layer.shadowPath        = shadowPath.CGPath;
    
    
}
-(void)roundBottomLeftConner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:( UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
}
@end
