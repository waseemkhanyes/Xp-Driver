//
//  BottomBorderView.m
//  XPDriver
//
//  Created by Syed zia on 02/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "BottomBorderView.h"

@implementation BottomBorderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bottomBorderColor      = BORDER_COLOR;
        self.isBottomBorder         = NO;
        [self customInit];
    }
    return self;
}

-(void)setBottomBorderColor:(UIColor *)bottomBorderColor{
    _bottomBorderColor = bottomBorderColor;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.bottomBorderColor      = BORDER_COLOR;
        self.isBottomBorder         = NO;
        [self customInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit{
    CALayer *border = [CALayer layer];
    border.backgroundColor = self.bottomBorderColor.CGColor;
    border.frame = CGRectMake(0, self.bounds.size.height -1, self.bounds.size.width,1);
    [self.layer addSublayer:border];
}
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    
}
@end
