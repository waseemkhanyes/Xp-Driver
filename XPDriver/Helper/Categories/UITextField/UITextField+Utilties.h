//
//  UITextField+Utilties.h
//  XPDriver
//
//  Created by Syed zia on 24/02/2017.
//  Copyright © 2017 Syed zia ur Rehman. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UITextField (Utilties)
- (BOOL)isEmpty;
- (void)showLoading;
- (void)addEyeButton;
- (void)addBottomBoarder;

- (void)addBackgroundShadow;
- (void)placeholderColor:(UIColor *)clolor;
- (void)addimageToTextfield:(UIImage *)img;
- (void)removeImageForTextfieldRightView;
- (void)addLeftPading;
- (void)addCountryCodeLabel;
- (void)addCountryFalg;
- (void)addBorder;
-(void)setBottomBorder;
@end
