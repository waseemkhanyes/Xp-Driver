//
//  CommonFunctions.h
//  Alrimaya
//
//  Created by Syed zia on 10/06/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject
typedef void(^Completion)(BOOL success);
//+(void)showPhotoBrowser:(NSMutableArray *)photos sender:(id)sender;
+(void)logAppFonts;
+ (NSAttributedString *)attributedString:(NSString *)string;
+ (void)showAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc;
+ (void)showAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block;
+ (void)showSettingAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block;
+ (void)showQuestionsAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block;
+ (void)showPhoneAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block;;
+ (void)showRequiredAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block;
+ (NSMutableArray *)roundedCoordinate:(CLLocationCoordinate2D) coordinate;
@end
