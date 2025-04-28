//
//  SZImageView.m
//  AirAdsBeta
//
//  Created by Syed zia on 16/11/2018.
//  Copyright © 2018 welldoneApps. All rights reserved.
//

#import "SZImageView.h"

@implementation SZImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderColor  =  [UIColor clearColor];
        self.borderWidth  = 0.0;
        self.cornerRadius = 0.0;
        [self customInit]; // Run time, manual creation.
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

        [self customInit]; // Run time, manual creation.
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
     [self customInit];
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self customInit];
    
}
- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
     [self customInit];
  
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    
}
- (void)prepareForInterfaceBuilder{
    [super prepareForInterfaceBuilder];
    [self customInit];
}

- (void)customInit{
    self.layer.borderColor  = self.borderColor.CGColor;
    self.layer.borderWidth  = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
}
@end
