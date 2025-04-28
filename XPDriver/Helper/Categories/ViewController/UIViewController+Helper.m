//
//  UIViewController+Helper.m
//  XPDriver
//
//  Created by Syed zia on 06/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "NYAlertViewController.h"
#import "JDStatusBarNotification.h"
#import "UIViewController+Helper.h"
#pragma mark - Constents -
static NSString * const KButtonTitelOK       = @"OK";
static NSString * const KButtonTitelCancel   = @"Cancel";
static NSString * const KButtonTitelYes      = @"Yes";
static NSString * const KButtonTitelNo       = @"No";
static NSString * const KButtonTitelBack     = @"Back";
static NSString * const KButtonTitelSettting = @"Setting";
static NSString * const KButtonTitelCallUs   = @"Call us";
static NSString * const KButtonTitelEmailUS  = @"Email us";
static NSString * const KButtonTitelContinue = @"Continue";
static NSString * const KButtonTitelCart     = @"Open Cart";

@implementation UIViewController (Helper)
-(void)showHud{
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomIn;
    [hud show:YES];
}
- (void)hideHud{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (CGFloat)navigationBarHeight{
    return   self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
}
- (void)addNavigatinBackgroundView{
    CGFloat height = self.navigationBarHeight;
    CGFloat width = self.navigationController.navigationBar.frame.size.width;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -height, width, height)];
    [backgroundView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:backgroundView];
}
- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}
-(void)showHudWithText:(NSString *)text
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(100, 50);
    hud.labelText = text;
    [hud hide:YES afterDelay:2];
    
}

- (void)addRideNotification{
    
}
- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}
#pragma mark - UIALERTVIEWCONTROLLER  -
#pragma mark AlertViewController
- (void)showAlertWithMessage:(NSString *)message alertType:(KAlertType)type{
    NSString *messageString = [NSString stringWithFormat:@"\n%@\n",message];
    NYAlertAction *okAction = [[NYAlertAction alloc] initWithTitle:KButtonTitelOK style:UIAlertActionStyleDefault handler:^(NYAlertAction * _Nonnull action) {
        
    }];
    NYAlertViewController * alertViewController = [[NYAlertViewController alloc] initWithOptions:nil title:@"Alert" message:messageString actions:@[okAction]];
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[self alertIcon:type]];
//    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [iconImageView.heightAnchor constraintEqualToConstant:60.0f].active = YES;
//    [iconImageView  setTintColor:[UIColor appBlackColor]];
//    alertViewController.alertViewContentView = iconImageView;
    [self presentViewController:alertViewController animated:YES completion:nil];
    
}
- (void)showAlertWithMessage:(NSString *)message  alertType:(KAlertType)type completion:(Completion)block{
     NSString *messageString = [NSString stringWithFormat:@"\n%@\n",message];
    NYAlertAction *okAction = [[NYAlertAction alloc] initWithTitle:KButtonTitelOK style:UIAlertActionStyleDefault handler:^(NYAlertAction * _Nonnull action) {
        if (block) {
            block(YES);
        }
    }];
    NYAlertViewController * alertViewController = [[NYAlertViewController alloc] initWithOptions:nil title:@"" message:messageString actions:@[okAction]];
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[self alertIcon:type]];
//    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [iconImageView.heightAnchor constraintEqualToConstant:60.0f].active = YES;
//    [iconImageView  setTintColor:[UIColor appBlackColor]];
//    alertViewController.alertViewContentView = iconImageView;
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - Banner Alerts
- (void)showSuccessWithMessage:(NSString *)message {
    [JDStatusBarNotification showWithStatus:message
                               dismissAfter:2.0
                                  styleName:@"Success"];
}

- (void)showErrorWithMessage:(NSString *)message {
    [JDStatusBarNotification showWithStatus:message dismissAfter:2.0 styleName:@"Error"];
}

- (void)showWarningWithMessage:(NSString *)message {
    [JDStatusBarNotification showWithStatus:message
                               dismissAfter:3.0
                                  styleName:@"Warning"];
}
@end
