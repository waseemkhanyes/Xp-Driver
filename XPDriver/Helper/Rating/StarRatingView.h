//
//  StarRatingView.h
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#define UIColorFromRGB(__HEX__, __A__) [UIColor \
colorWithRed:((float)((__HEX__ & 0xFF0000) >> 16))/255.0 \
green:((float)((__HEX__ & 0xFF00) >> 8))/255.0 \
blue:((float)(__HEX__ & 0xFF))/255.0 alpha:__HEX__]
#define RATING_COLOR   UIColorFromRGB(0x0facf3,1.0)
@interface StarRatingView : UIView

- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;
@end
