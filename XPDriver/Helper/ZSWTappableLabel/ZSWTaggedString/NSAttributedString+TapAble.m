//
//  NSAttributedString+TapAble.m
//  AirAdsBeta
//
//  Created by Syed zia on 12/03/2018.
//  Copyright © 2018 welldoneApps. All rights reserved.
//
#import "NSAttributedString+TapAble.h"

@implementation NSAttributedString (TapAble)

+ (NSAttributedString *)attibutedSting:(id)string{
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllSystemTypes error:NULL];
    NSMutableAttributedString *attributedString;
    
    if ([string isKindOfClass:[NSString class]]) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:(NSString *)string attributes:nil];
    }else{
        attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:(NSAttributedString *)string];
    }
    [dataDetector enumerateMatchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[ZSWTappableLabelTappableRegionAttributeName] = @YES;
        attributes[ZSWTappableLabelHighlightedBackgroundAttributeName] = [UIColor lightGrayColor];
        attributes[ZSWTappableLabelHighlightedForegroundAttributeName] = [UIColor whiteColor];
        attributes[NSForegroundColorAttributeName]                     =  [UIColor blueColor];
        attributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        attributes[TextCheckingResultAttributeName] = result;
        [attributedString addAttributes:attributes range:result.range];
    }];
    return attributedString;
}
+ (NSMutableAttributedString *)lineSpacingMutableAttributedString:(NSAttributedString *)attributedString{
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing       = 1.5;
    style.minimumLineHeight = 15.f;
    style.maximumLineHeight = 20.f;
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [mutableString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [attributedString length])];
   return  mutableString;
}
+ (NSMutableAttributedString *)lineSpacingAttributtedStrting:(NSString *)string{
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing       = 1.5;
    style.minimumLineHeight = 15.f;
    style.maximumLineHeight = 20.f;
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [mutableString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [attributedString length])];
    return  mutableString;
}
@end
