//
//  UIViewController+Helper.h
//  XPDriver
//
//  Created by Syed zia on 06/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    KAlertTypeNetwork = 0,
    KAlertTypeLocation,
    KAlertTypePhoto,
    KAlertTypeCamera,
    KAlertTypeNotification,
    KAlertTypeError,
    KAlertTypeInfo,
    KAlertTypeSuccess,
    KAlertTypeQestion,
    KAlertTypeContactUs,
    KAlertTypeMismatch,
    KAlertTypeNoDriverAvailable,
    KAlertTypePhoneNumberVerification,
} KAlertType;

@interface UIViewController (Helper)
- (BOOL)isVisible;
- (void)addRideNotification;
- (BOOL)isModal;
-(void)showHud;
- (void)hideHud;
- (CGFloat)navigationBarHeight;
- (void)addNavigatinBackgroundView;
- (void)showHudWithText:(NSString *)text;
- (void)showSuccessWithMessage:(NSString *)message;
- (void)showErrorWithMessage:(NSString *)message;
- (void)showWarningWithMessage:(NSString *)message;
- (void)showAlertWithMessage:(NSString *)message alertType:(KAlertType)type;
- (void)showAlertWithMessage:(NSString *)message  alertType:(KAlertType)type completion:(Completion)block;
@end

NS_ASSUME_NONNULL_END
