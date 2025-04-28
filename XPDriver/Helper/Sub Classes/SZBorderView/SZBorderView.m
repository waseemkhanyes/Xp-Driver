//
//  SZBorderView.m
//  A1Driver
//
//  Created by Syed zia on 08/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <objc/runtime.h>
#import "SZBorderView.h"

static void *topBorderContext = &topBorderContext;
static void *bottomBorderContext = &bottomBorderContext;
static void *leftBorderContext = &leftBorderContext;
static void *rightBorderContext = &rightBorderContext;
static char bottomLineColorKey,topLineColorKey,rightLineColorKey,leftLineColorKey;
static NSString* const KTopBorderLayer = @"topBorderLayer";
static NSString* const KBottomBorderLayer = @"bottomBorderLayer";
static NSString* const KLeftBorderLayer = @"leftBorderLayer";
static NSString* const KRightBorderLayer = @"rightBorderLayer";

@implementation SZBorderView
@dynamic borderColor,borderWidth,bottomLineWidth,topLineWidth,rightLineWidth,leftLineWidth;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
   [self.layer setBorderWidth:borderWidth];
}
- (void)setIsShdow:(BOOL)isShdow{
   self.layer.shadowColor = isShdow ?[UIColor grayColor].CGColor : [UIColor clearColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(0.2f,0.5f);
   
}
// for Bottom Line
- (UIColor *)bottomLineColor {
    return objc_getAssociatedObject(self, &bottomLineColorKey);
}
- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    objc_setAssociatedObject(self, &bottomLineColorKey,
                             bottomLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setBottomLineWidth:(CGFloat)bottomLineWidth {
    [self addBottomBorder:[self bottomLineColor] andWidth:bottomLineWidth];
}
// for top Line
- (UIColor *)topLineColor {
    return objc_getAssociatedObject(self, &topLineColorKey);
}
- (void)setTopLineColor:(UIColor *)topLineColor {
    objc_setAssociatedObject(self, &topLineColorKey,
                             topLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setTopLineWidth:(CGFloat)topLineWidth{
    [self addTopBorder:[self topLineColor] andWidth:topLineWidth];
}
// for right Line
- (UIColor *)rightLineColor {
    return objc_getAssociatedObject(self, &rightLineColorKey);
}
-(void)setRightLineColor:(UIColor *)rightLineColor {
    objc_setAssociatedObject(self, &rightLineColorKey,
                             rightLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setRightLineWidth:(CGFloat)rightLineWidth{
    [self addRightBorder:[self rightLineColor] andWidth:rightLineWidth];
}
// for left Line
-(UIColor *)leftLineColor {
    return objc_getAssociatedObject(self, &leftLineColorKey);
}
-(void)setLeftLineColor:(UIColor *)leftLineColor{
    objc_setAssociatedObject(self, &leftLineColorKey,
                             leftLineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setLeftLineWidth:(CGFloat)leftLineWidth{
    [self addLeftBorder:[self leftLineColor] andWidth:leftLineWidth];
}
- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    [self addTopBorder:[UIColor lightGrayColor] andWidth:0.5];
}
- (void)setIsBottom:(BOOL)isBottom{
    _isBottom = isBottom;
    [self addBottomBorder:[UIColor lightGrayColor] andWidth:0.5];
}
- (void)setIsLeft:(BOOL)isLeft{
    _isLeft = isLeft;
    if (!isLeft) {
        [self removeLeftBorder];
    }else{
     [self addLeftBorder:[UIColor lightGrayColor] andWidth:0.5];
    }
}
- (void)setIsRight:(BOOL)isRight{
    _isRight = isRight;
    [self addRightBorder:[UIColor lightGrayColor] andWidth:0.5];
}
- (void)setIsTopBottom:(BOOL)isTopBottom{
    _isTopBottom = isTopBottom;
    [self addTopBorder:[UIColor lightGrayColor] andWidth:0.5];
     [self addBottomBorder:[UIColor lightGrayColor] andWidth:0.5];
}
- (void)addTopBorder:(UIColor *)color andWidth:(CGFloat) borderWidth {
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *border = [CALayer layer];
        border.name = KTopBorderLayer;
        [self removePreviouslyAddedLayer:border.name];
        border.backgroundColor = color.CGColor;
        border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
        [self.layer addSublayer:border];
        [self addObserver:self forKeyPath: @"bounds" options:NSKeyValueObservingOptionNew context:topBorderContext];
    });
}

- (void)addBottomBorder:(UIColor *)color andWidth:(CGFloat) borderWidth {
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *border = [CALayer layer];
        border.name = @"bottomBorderLayer";
        [self removePreviouslyAddedLayer:border.name];
        border.backgroundColor = color.CGColor;
        border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
        [self.layer addSublayer:border];
        [self addObserver:self forKeyPath: @"bounds" options:NSKeyValueObservingOptionNew context:bottomBorderContext];
    });
}

- (void)addLeftBorder:(UIColor *)color andWidth:(CGFloat) borderWidth {
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *border = [CALayer layer];
        border.name = @"leftBorderLayer";
        [self removePreviouslyAddedLayer:border.name];
        border.backgroundColor = color.CGColor;
        border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
        [self.layer addSublayer:border];
        [self addObserver:self forKeyPath: @"bounds" options:NSKeyValueObservingOptionNew context:leftBorderContext];
    });
}

- (void)addRightBorder:(UIColor *)color andWidth:(CGFloat) borderWidth {
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *border = [CALayer layer];
        border.name = @"rightBorderLayer";
        [self removePreviouslyAddedLayer:border.name];
        border.backgroundColor = color.CGColor;
        border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
        [self.layer addSublayer:border];
        [self addObserver:self forKeyPath: @"bounds" options:NSKeyValueObservingOptionNew context:rightBorderContext];
    });
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == topBorderContext) {
        for (CALayer *border in self.layer.sublayers) {
            if ([border.name isEqualToString:@"topBorderLayer"]) {
                [border setFrame:CGRectMake(0, 0, self.frame.size.width, border.frame.size.height)];
            }
        }
    } else if (context == bottomBorderContext) {
        for (CALayer *border in self.layer.sublayers) {
            if ([border.name isEqualToString:@"bottomBorderLayer"]) {
                [border setFrame:CGRectMake(0, self.frame.size.height - border.frame.size.height, self.frame.size.width, border.frame.size.height)];
            }
        }
    } else if (context == leftBorderContext) {
        for (CALayer *border in self.layer.sublayers) {
            if ([border.name isEqualToString:@"leftBorderLayer"]) {
                [border setFrame:CGRectMake(0, 0, border.frame.size.width, self.frame.size.height)];
            }
        }
    } else if (context == rightBorderContext) {
        for (CALayer *border in self.layer.sublayers) {
            if ([border.name isEqualToString:@"rightBorderLayer"]) {
                [border setFrame:CGRectMake(self.frame.size.width - border.frame.size.width, 0, border.frame.size.width, self.frame.size.height)];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)removePreviouslyAddedLayer:(NSString *)name {
    if (self.layer.sublayers.count > 0) {
        for (CALayer *layer in self.layer.sublayers) {
            if ([layer.name isEqualToString:name]) {
                [layer removeFromSuperlayer];
                break;
            }
        }
    }
}

- (void)removeTopBorder{
    [self removePreviouslyAddedLayer:KTopBorderLayer];
}
- (void)removeLeftBorder{
    [self removePreviouslyAddedLayer:KLeftBorderLayer];
}
- (void)removeRightBorder{
    [self removePreviouslyAddedLayer:KRightBorderLayer];
}
- (void)removeBottomBorder{
    [self removePreviouslyAddedLayer:KBottomBorderLayer];
}
@end
