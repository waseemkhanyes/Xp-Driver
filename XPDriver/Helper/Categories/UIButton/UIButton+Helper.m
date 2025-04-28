//
//  UIButton+Helper.m
//  XPDriver
//
//  Created by Syed zia on 15/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UIButton+Helper.h"

@implementation UIButton (Helper)
- (BOOL)isChecked{
    return [SHAREMANAGER image:self.currentImage isEqualTo:CHECKEDE_BTN_IMAGE];
}
- (BOOL)isOnLine{
    return [SHAREMANAGER image:self.currentImage isEqualTo:ONLINE_BTN_IMAGE];
}
- (void)updateStatusImage:(NSString *)status{
    BOOL isOnline = strEquals(status, GO_ONLINE);
    UIImage *statusImage = isOnline ?  ONLINE_BTN_IMAGE : OFFLINE_BTN_IMAGE;
    UIViewAnimationOptions animationOption = isOnline ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    [UIView transitionWithView:self duration:0.9 options:animationOption animations:^{
         [self setImage:statusImage forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
   
}
@end
