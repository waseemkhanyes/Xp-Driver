//
//  SZBorderLabel.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "SZBorderLabel.h"
@implementation SZBorderLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFontType:Default];
        self.textAlignment  = 1;
        self.textColor      = [UIColor appGrayColor];
        self.text           = @"";
        self.borderColor     = [UIColor clearColor];
        self.borderWidth     = 0;
        self.connerRaduis    = 0;

        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ViewWidth(self),ViewHeight(self))];
        [label setNumberOfLines:0];
        
        [self addSubview:label];
        self.textLabel = label;
        [self customInit];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self customInit];
    [self setNeedsDisplay];
}
- (void)layoutSubviews{
    self.textLabel.frame = CGRectMake(0, 0,ViewWidth(self),ViewHeight(self));
    [super layoutSubviews];
}
- (void)prepareForInterfaceBuilder {
    [self customInit];
}
#pragma mark- Properties
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
- (void)setText:(NSString *)text{
    _text = text;
    [self customInit];
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor  = textColor;
    [self customInit];
}
- (void)setTextAlignment:(int)textAlignment{
    _textAlignment = textAlignment;
    [self customInit];
}
- (void)setFontType:(int)fontType{
    _fontType = fontType;
    switch (fontType) {
        case Default:
            self.font = [UIFont small];
            break;
        case Small:
            self.font = [UIFont heading2];
            break;
        case Large:
            self.font = [UIFont heading1];
            break;
        default:
            break;
    }
    [self customInit];
}
-(void)addBorder{
    [self.layer setBorderColor: self.borderColor.CGColor];
    [self.layer setBorderWidth: self.borderWidth];
    [self.layer setCornerRadius:self.connerRaduis];
    self.layer.masksToBounds = YES;
}


- (void)customInit {
    [self addBorder];
    if (!self.textLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ViewWidth(self),ViewHeight(self))];
        [label setNumberOfLines:0];
        [self addSubview:label];
        self.textLabel = label;
    }
    self.textLabel.textColor     = self.textColor;
    self.textLabel.textAlignment = self.textAlignment;
    self.textLabel.font          = self.font;
    self.textLabel.text          = self.text;
}


@end
