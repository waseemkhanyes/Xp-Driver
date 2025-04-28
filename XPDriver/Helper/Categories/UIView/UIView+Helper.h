//
//  UIView+Helper.h
//  XPDriver
//
//  Created by Syed zia on 01/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)
- (void)popin;
- (void)popOut;
- (void)popUp;
- (void)popDown;
- (void)addBorder;
- (void)addUpShadow;
- (void)addDwonShadow;
- (void)addUpAndDownShadow;
- (void)roundBottomRightConner;
- (void)roundBottomLeftConner;
- (void)roundTopLeftConner;
- (UIViewController *)parentViewController;
@end
