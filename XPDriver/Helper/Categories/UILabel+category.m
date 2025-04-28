//
//  UILabel+category.m
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 01/05/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "UILabel+category.h"

@implementation UILabel (category)


-(void)setTextWithAnimation:(NSString *)txt{
    
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.75;
    [self.layer addAnimation:animation forKey:@"kCATransitionFade"];
    // This will fade:
    self.text = txt;
}

@end
