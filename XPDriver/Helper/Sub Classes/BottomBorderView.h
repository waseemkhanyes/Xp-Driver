//
//  BottomBorderView.h
//  XPDriver
//
//  Created by Syed zia on 02/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BORDER_COLOR  UIColorFromRGB(0xC7C7CC,1)
IB_DESIGNABLE
@interface BottomBorderView : UIView
@property (nonatomic,strong) IBInspectable UIColor *bottomBorderColor;
@property (nonatomic,assign) IBInspectable BOOL isBottomBorder;
@end
