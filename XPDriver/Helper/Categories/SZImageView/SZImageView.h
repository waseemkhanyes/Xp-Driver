//
//  SZImageView.h
//  AirAdsBeta
//
//  Created by Syed zia on 16/11/2018.
//  Copyright © 2018 welldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface SZImageView : UIImageView
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable UIColor *borderColor;
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;
@end

NS_ASSUME_NONNULL_END
