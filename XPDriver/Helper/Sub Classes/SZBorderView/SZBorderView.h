//
//  SZBorderView.h
//  A1Driver
//
//  Created by Syed zia on 08/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE


@interface SZBorderView : UIView
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,strong) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable BOOL isShdow;
@property (nonatomic,assign) IBInspectable BOOL isTop;
@property (nonatomic,assign) IBInspectable BOOL isBottom;
@property (nonatomic,assign) IBInspectable BOOL isLeft;
@property (nonatomic,assign) IBInspectable BOOL isRight;
@property (nonatomic,assign) IBInspectable BOOL isTopBottom;

@property (nonatomic, strong) IBInspectable UIColor *topLineColor;
@property (nonatomic, assign) IBInspectable CGFloat topLineWidth;
@property (nonatomic, strong) IBInspectable UIColor *bottomLineColor;
@property (nonatomic, assign) IBInspectable CGFloat bottomLineWidth;
@property (nonatomic, strong) IBInspectable UIColor *rightLineColor;
@property (nonatomic, assign) IBInspectable CGFloat rightLineWidth;
@property (nonatomic, strong) IBInspectable UIColor *leftLineColor;
@property (nonatomic, assign) IBInspectable CGFloat leftLineWidth;
- (void)removeTopBorder;
- (void)removeLeftBorder;
- (void)removeRightBorder;
- (void)removeBottomBorder;
@end


