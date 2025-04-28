//
//  SZBorderLabel.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
typedef enum {
    Default = 0,
    Small,
    Large,
} FontType;
#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface SZBorderLabel : UIView
@property (nonatomic,strong)  UILabel *textLabel;
@property (nonatomic,strong)  UIFont   *font;
@property (nonatomic,assign) IBInspectable CGFloat connerRaduis;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor  *borderColor;
@property (nonatomic,strong) IBInspectable NSString *text;
@property (nonatomic,assign) IBInspectable int fontType;
@property (nonatomic,assign) IBInspectable int textAlignment;
@property (nonatomic,strong) IBInspectable UIColor  *textColor;

@end
