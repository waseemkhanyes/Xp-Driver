//
//  ShdowView.m
//  XPDriver
//
//  Created by Syed zia on 31/07/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "ShadowView.h"
#define KCornnerRadius 0
#define KBorderColor   [UIColor clearColor]
#define KShadowColor  [UIColor clearColor]
@implementation ShadowView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderColor     = [UIColor clearColor];
        self.borderWidth     = 0;
        self.connerRaduis    = 0;
        self.shdowColor      = [UIColor clearColor];
        self.isShdow         = NO;
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self addBorder];
}
- (void)setborderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    [self addBorder];
}
- (void)setConnerRaduis:(CGFloat)connerRaduis{
    _connerRaduis = connerRaduis;
    [self addBorder];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self customInit];
    [self setNeedsDisplay];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)addBorder{
    [self.layer setBorderColor: self.borderColor.CGColor];
    [self.layer setBorderWidth: self.borderWidth];
    [self.layer setCornerRadius:self.connerRaduis];
    self.layer.masksToBounds = YES;
}
- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    if (self.isShdow) {
        
        self.layer.shadowRadius   = 12.0;
        self.layer.shadowColor    = self.shdowColor.CGColor;
        self.layer.shadowOffset   = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity  = 0.8f;
        UIEdgeInsets shadowInsets = UIEdgeInsetsMake(0, 1,0, 1);
        self.layer.masksToBounds  = NO;
        UIBezierPath *shadowPath   = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, shadowInsets)];
        self.layer.shadowPath      = shadowPath.CGPath;
    }
   // [self addBorder];
    
   
}

@end
