//
//  UIView+Helper.m
//  XPDriver
//
//  Created by Syed zia on 01/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)
- (void)popin{
    [self setAlpha:1];
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}
- (void)popOut{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
         [self setAlpha:0];
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)popUp{
    self.transform = CGAffineTransformMakeTranslation(0, ViewHeight(self));
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self setAlpha:1];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)popDown{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, ViewHeight(self));
    } completion:^(BOOL finished) {
        [self setAlpha:0];
        self.transform = CGAffineTransformIdentity;
    }];
}
-(void)addBorder{
    [self.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.layer setBorderWidth: 1.0];
    [self.layer setCornerRadius:4.0f];
    [self.layer setMasksToBounds:NO];
}
- (void)roundBottomRightConner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomRight) cornerRadii:CGSizeMake(20.0, 20.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)roundBottomLeftConner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(20.0, 20.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)roundTopLeftConner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(20.0, 20.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)addDwonShadow{
    self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 0.0f;
    self.layer.masksToBounds = NO;
}
- (void)addUpShadow{
    self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.0f;
    self.layer.masksToBounds = NO;
}
- (void)addUpAndDownShadow{
    self.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.layer.shadowOffset = CGSizeMake(-2.0f, 2.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.0f;
    self.layer.masksToBounds = NO;
}
- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}
@end
