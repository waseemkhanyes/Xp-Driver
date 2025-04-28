//
//  UITextField+Utilties.m
//  XPDriver
//
//  Created by Syed zia on 24/02/2017.
//  Copyright © 2017 Syed zia ur Rehman. All rights reserved.
//

#import "UITextField+Utilties.h"
@implementation UITextField (Utilties)

- (BOOL)isEmpty{
    return fieldIsEmpty(self);
}
- (void)placeholderColor:(UIColor *)color{
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        if (self.placeholder) {
         self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        }
        
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}
-(void)addBottomBoarder{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor appGrayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;

}
-(void)addBackgroundShadow{
    [self.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.layer setBorderWidth: 0.0];
    [self.layer setCornerRadius:8.0f];
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowRadius:2.0f];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;

}
- (void)addEyeButton{
    CGFloat height = self.frame.size.height;
    UIView *contantView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, height)];
    [contantView setBackgroundColor:[UIColor clearColor]];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0,0, 30,height);
    [addButton setImage:[UIImage imageNamed:@"ic_hide_password"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"ic_show_password"] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(eyeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    addButton.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    addButton.center = contantView.center;
    [contantView addSubview:addButton];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = contantView;
}
- (void)eyeButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.secureTextEntry = !sender.selected;
}
- (void)addLeftPading{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, ViewHeight(self))];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
-(void)addBorder{
    [self.layer setBorderColor: [[UIColor appBlackColor] CGColor]];
    [self.layer setBorderWidth: 1.0];
    [self.layer setCornerRadius:4.0f];
    [self.layer setMasksToBounds:NO];
}
- (void)showLoading{
    if ([self.rightView isKindOfClass:[UIActivityIndicatorView class]] ) {
        return;
    }
    UIActivityIndicatorView * indy = (UIActivityIndicatorView *)self.rightView;
    CGFloat tfHeight = ViewHeight(self);
    if(!indy || ![indy isKindOfClass:[UIActivityIndicatorView class]]) {
        indy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indy.transform = CGAffineTransformMakeScale(0.75, 0.75);
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tfHeight,tfHeight)];
        indy.center = newView.center;
        [newView addSubview:indy];
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = newView;
    }
    [indy startAnimating];
}
- (void)addCountryFalg
{
    CGFloat tfHeight = ViewHeight(self);
    UIImage *flag    = imagify(SHAREMANAGER.appData.country.shortName);
    UIView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tfHeight+25, tfHeight)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    
    UIView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,flag.size.width, tfHeight)];
    [flagView setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,flag.size.width,flag.size.height)];
    imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    imageView.image = flag;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = flagView.center;
    [flagView addSubview:imageView];
    UIView *countyCodeView = [[UIView alloc] initWithFrame:CGRectMake(ViewWidth(flagView),0, tfHeight,tfHeight)];
    [countyCodeView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ViewWidth(countyCodeView) ,ViewHeight(countyCodeView))];
    label.tag = 121;
    label.font = self.font;
    label.textAlignment = NSTextAlignmentLeft;
    [label setTextColor:WHITE_COLOR];
    [label setText:strFormat(@"%@",SHAREMANAGER.appData.country.countryCode)];
    [countyCodeView addSubview:label];
    [leftView addSubview:flagView];
    [leftView addSubview:countyCodeView];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)addimageToTextfield:(UIImage *)img
{
    CGFloat tfHeight = ViewHeight(self);
    UIView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tfHeight, tfHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,20,20)];
    imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = rightView.center;
    [rightView addSubview:imageView];
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

-(void)removeImageForTextfieldRightView{
    self.rightView = nil;
}

-(void)setBottomBorder{

    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor appGrayColor].CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    border.borderWidth = borderWidth;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;

}
@end
