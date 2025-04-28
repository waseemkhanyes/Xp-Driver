//
//  UIFont+Helper.m
//  Alrimaya
//
//  Created by Syed zia on 07/06/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//

#import "UIFont+Helper.h"

@implementation UIFont (Helper)
+(UIFont *)heading{
    return [self HelveticaNeueBold:20];
}
+(UIFont *)heading1{
    return [self HelveticaNeueBold:20];
}
+(UIFont *)heading2{
    return [self HelveticaNeueBold:17];
}
+(UIFont *)heading3{
    return [self HelveticaNeueBold:14];
}
+(UIFont *)normal{
    return [self HelveticaNeueRegular:16];
}
+(UIFont *)boldNormal{
    return [self HelveticaNeueBold:16];
}
+(UIFont *)bottonBoldNormal{
    return [self HelveticaNeueBold:22];
}
+(UIFont *)small{
    return [self HelveticaNeueRegular:12];
}
+(UIFont *)extraSmall{
    return [self HelveticaNeueRegular:10];
}
+(UIFont *)OswaldBold:(CGFloat)size{
    return [UIFont fontWithName:@"Oswald-Bold" size:size];
}
+(UIFont *)OswaldRegular:(CGFloat)size{
    return [UIFont fontWithName:@"Oswald-Regular" size:size];
}
+(UIFont *)OswaldMedium:(CGFloat)size{
    return [UIFont fontWithName:@"Oswald-Medium" size:size];
}
+(UIFont *)HelveticaNeueBold:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}
+(UIFont *)HelveticaNeueRegular:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}
+(UIFont *)HelveticaNeueMedium:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}
@end
