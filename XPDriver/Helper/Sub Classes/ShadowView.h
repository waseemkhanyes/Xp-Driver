//
//  ShdowView.h
//  XPDriver
//
//  Created by Syed zia on 31/07/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface ShadowView : UIView
@property (nonatomic,assign) IBInspectable CGFloat connerRaduis;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable BOOL isShdow;
@property (nonatomic,strong) IBInspectable UIColor *shdowColor;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@end
