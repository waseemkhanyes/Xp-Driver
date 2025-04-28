//
//  CommonFunctions.m
//  Alrimaya
//
//  Created by Syed zia on 10/06/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions
//+ (void)showPhotoBrowser:(NSMutableArray *)photos sender:(id)sender{
//    NSArray *photoArray = [NSArray arrayWithArray:photos];
//    IDMPhotoBrowser *browser ;
//    if ([photos[0] isKindOfClass:[UIImage class]]) {
//        NSMutableArray *convertedPhotos = [IDMPhotoBrowser convertUImageArryaToIDMPhotoArray:photos];
//        browser = [[IDMPhotoBrowser alloc] initWithPhotos:convertedPhotos animatedFromView:sender];
//    }else if ([[photos objectAtIndex:0] isKindOfClass:[IDMPhoto class]]) {
//        browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sender];
//    }else{
//        if (sender != nil) {
//            browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:photoArray animatedFromView:sender];
//        }else{
//            browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:photoArray];
//        }
//    }
//    browser.usePopAnimation = YES;
//    browser.displayActionButton = NO;
//    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [controller presentViewController:browser animated:YES completion:nil];
//}
+ (NSAttributedString *)attributedString:(NSString *)string{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    return attributeString;
}
+ (void)showAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [vc presentViewController:alert animated:YES completion:^{
        
    }];
    
}
+ (void)showAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block) {
            block(YES);
        }
    }]];
    [vc presentViewController:alert animated:YES completion:^{
        
    }];
    
}
+ (void)showQuestionsAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (block) {
            block(NO);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block) {
            block(YES);
        }
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)showRequiredAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Skip" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (block) {
            block(NO);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         block(YES);
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)showSettingAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (block) {
            block(false);
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Setting Opened url");
            }
        }];
        if (block) {
            block(true);
        }
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
+ (void)showPhoneAlertWithTitel:(NSString *)titel message:(NSString *)message inVC:(UIViewController *)vc completion:(Completion)block{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titel message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (block) {
            block(NO);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (block) {
            block(YES);
        }
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
+(void)logAppFonts{
    for (NSString *familyName in [UIFont familyNames]){
        //  //DLog(@"Family name: %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"--Font name: %@", fontName);
        }
    }
}
+ (NSMutableArray *)roundedCoordinate:(CLLocationCoordinate2D) coordinate{
    NSMutableArray *rounded = [NSMutableArray new];
    NSNumber *number1 = [NSNumber numberWithDouble:[CommonFunctions round:coordinate.latitude palce:3]];
    NSNumber *number2 = [NSNumber numberWithDouble:[CommonFunctions round:coordinate.longitude palce:3]];
    [rounded addObject:[NSNumber numberWithDouble:number1.doubleValue]];
    [rounded addObject:[NSNumber numberWithDouble:number2.doubleValue]];
    return rounded;
}
+ (double)round:(double)value palce:(int)place{
    NSString *format = strFormat(@"%%.%if",place);
    NSString *string  = strFormat(format,value);
    return atof([string UTF8String]);
    
}

@end
