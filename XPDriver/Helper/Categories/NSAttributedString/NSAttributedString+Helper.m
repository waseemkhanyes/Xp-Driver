//
//  NSAttributedString+Helper.m
//  XPDriver
//
//  Created by Syed zia on 24/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "NSAttributedString+Helper.h"

@implementation NSAttributedString (Helper)
+ (NSAttributedString *)attributedString:(NSString *)title withFont:(UIFont *)titleFont subTitle:(NSString *)subtitel withfont:(UIFont *)subtitleFont nextLine:(BOOL)nextLine{
    subtitel = nextLine ? strFormat(@"\n%@",subtitel) : subtitel;
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: titleFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:title attributes: arialDict];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:subtitleFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: subtitel attributes:verdanaDict];
    [aAttrString appendAttributedString:vAttrString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:aAttrString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    paragraphStyle.alignment    = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, aAttrString.length)];
    return attributedString;
}
+ (NSAttributedString *)attributedStringWithTitel:(NSString *)title withFont:(UIFont *)titleFont  titleColor:(UIColor *)titleColor subTitle:(NSString *)subtitel withfont:(UIFont *)subtitleFont subtitleColor:(UIColor *)subtitleColor   nextLine:(BOOL)nextLine{
    subtitel = nextLine ? [NSString stringWithFormat:@"\n%@",subtitel] : subtitel;
    NSDictionary *arialDict = @{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:titleColor};
   
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:title attributes: arialDict];
    NSDictionary *verdanaDict =@{NSFontAttributeName:subtitleFont,NSForegroundColorAttributeName:subtitleColor};
    
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: subtitel attributes:verdanaDict];
    [aAttrString appendAttributedString:vAttrString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:aAttrString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    paragraphStyle.alignment    = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, aAttrString.length)];
    return attributedString;
    
}
- (NSAttributedString *)withLineSpacing:(float)space{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space;
    paragraphStyle.alignment    = NSTextAlignmentLeft;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    return attributedString;
    
}
@end
