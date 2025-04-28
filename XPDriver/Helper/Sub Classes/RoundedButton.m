//
//  RoundedButton.m
//  XPDriver
//
//  Created by Syed zia on 30/07/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//



#import "RoundedButton.h"
@interface RoundedButton()
@property (strong,nonatomic) UIActivityIndicatorView *activity;
@property CGRect currentBounds;
@property CGFloat currentCornerRadius;
@end
@implementation RoundedButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
- (void)setCornerRadius:(int)cornerRadius{
    _cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.layer.cornerRadius  = self.cornerRadius;
    
    
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderWidth   = 1;
    self.layer.borderColor    = self.borderColor.CGColor;
}
- (void)setType:(int)type{
    _type = type;
    [self setButtonBackgroundColor:type];
}
- (void)setButtonBackgroundColor:(buttonType)type{
    // self.enabled = type != Disable;
    switch (type) {
        case Semple:
            self.backgroundColor = [UIColor appBlackColor];
            break;
        case Started:
            self.backgroundColor = [UIColor appGreenColor];
            break;
        case Ended:
            self.backgroundColor =  [UIColor appRedColor];
            break;
        case Disable:
            self.backgroundColor =  [UIColor appGrayColor];
            break;
        case -1:
            self.backgroundColor = CLEAR_COLOR;
            break;
        default:
            break;
    }
    self.layer.borderColor   = (self.backgroundColor).CGColor;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self.titleLabel setFont:[UIFont bottonBoldNormal]];
}
//- (void)setEnabled:(BOOL)enabled{
//    [super setEnabled:enabled];
//    if (self.currentImage != nil) {
//        return;
//    }
//     if (self.type == Unknown) {
//           UIColor *color = enabled ? [UIColor appBlackColor] : [UIColor lightGrayColor];
//          [self setTitleColor:color forState:UIControlStateNormal];
//           [self setTitleColor:color forState:UIControlStateDisabled];
//     }else{
//          [self setButtonBackgroundColor:enabled ? Semple : Disable];
//     }
//   
//    
//}
//Code Copied form...SLButton https://github.com/PersianDevelopers/SLButton
- (void)awakeFromNib {
    self.animationDuration = 0.3;
    self.disableWhileLoading = YES;
    [super awakeFromNib];
}

- (void)showLoading {
    _isLoading = YES;
    [self addActivityIndicator];
    [self setCurrentData];
    [self clearText];
    [self disableButton];
   // [self deShapeAnimation];
    [self setNeedsDisplay];
}

- (void)addActivityIndicator {
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [self setFrameForActivity];
    [self.activity setHidden:NO];
    [self.activity startAnimating];
    [self.activity setCenter:self.center];
    [self.superview addSubview:self.activity];
}

- (void)setCurrentData {
    [self setCurrentText:self.currentTitle];
    [self setCurrentBounds:self.bounds];
    [self setCurrentCornerRadius:self.layer.cornerRadius];
}

- (void)clearText {
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)disableButton {
    if (self.disableWhileLoading)
        [self setEnabled:NO];
}

- (void)deShapeAnimation {
    if (self.isSkipDeShape) {
        return;
    }
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizing.duration= (self.animationDuration * 2) / 5.0;
    if (self.bounds.size.width > self.bounds.size.height)
        sizing.toValue= [NSValue valueWithCGRect:CGRectMake(self.layer.bounds.origin.x, self.layer.bounds.origin.y, self.layer.bounds.size.height, self.layer.bounds.size.height)];
    else
        sizing.toValue= [NSValue valueWithCGRect:CGRectMake(self.layer.bounds.origin.x, self.layer.bounds.origin.y, self.layer.bounds.size.width, self.layer.bounds.size.width)];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"de-scale"];
    
    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.beginTime = CACurrentMediaTime() + (self.animationDuration * 2) / 5.0;
    shape.duration = (self.animationDuration * 3) / 5.0;
    shape.toValue= @(self.layer.bounds.size.height / 2.0);
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"de-shape"];
}

- (void)reShapeAnimation {
    if (self.isSkipDeShape) {
        return;
    }
    CABasicAnimation *shape = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    shape.duration = (self.animationDuration * 3) / 5.0;
    shape.toValue= @(self.currentCornerRadius);
    shape.removedOnCompletion = FALSE;
    shape.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:shape forKey:@"re-shape"];
    
    CABasicAnimation *sizing = [CABasicAnimation animationWithKeyPath:@"bounds"];
    sizing.beginTime = CACurrentMediaTime() + (self.animationDuration * 3) / 5.0;
    sizing.duration= (self.animationDuration * 2) / 5.0;
    sizing.toValue= [NSValue valueWithCGRect:self.currentBounds];
    sizing.removedOnCompletion = FALSE;
    sizing.fillMode = kCAFillModeForwards;;
    [self.layer addAnimation:sizing forKey:@"re-scale"];
}

- (void)hideLoading {
    _isLoading = NO;
    [self.activity removeFromSuperview];
    //[self reShapeAnimation];
    [self reEnable];
    [self performSelector:@selector(resetText) withObject:nil afterDelay:self.animationDuration];
}
- (void)hideLoadingWithTitel:(NSString *)titel{
    _isLoading = NO;
    [self.activity removeFromSuperview];
   // [self reShapeAnimation];
    if (strEquals(titel, GO_ONLINE) || strEquals(titel, GO_OFFLINE)) {
        self.currentText = @"";
        [self updateStatusImage:titel];
    }else{
        if (strEquals(titel, Order_Picked_UP)) {
            [self setType:Started];
        }else if (strEquals(titel, Order_Delivered)){
            [self setType:Ended];
        }
        self.currentText = titel;
    }
    
    
    [self performSelector:@selector(resetText) withObject:nil afterDelay:self.animationDuration];
    [self reEnable];
}

- (void)reEnable {
    [self setEnabled:YES];
}

- (void)resetText {
    [self setTitle:self.currentText forState:UIControlStateNormal];
}

- (void)setFrameForActivity {
    [self.activity setCenter:self.center];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setFrameForActivity];
}

@end
