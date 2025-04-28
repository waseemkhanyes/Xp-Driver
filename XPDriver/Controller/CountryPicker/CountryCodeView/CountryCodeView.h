//
//  CountryCodeView.h
//  XPFood
//
//  Created by syed zia on 02/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//
#import "EMCCountry.h"
#import <UIKit/UIKit.h>

@protocol CountryCodeViewDelegate <NSObject>
- (void)showCountryPicker;
@end
NS_ASSUME_NONNULL_BEGIN

@interface CountryCodeView : UIView

@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id <CountryCodeViewDelegate>delegate;
- (void)configerWithCountry:(EMCCountry *)country delegate:(id <CountryCodeViewDelegate>)delegate;
- (void)updateUI:(EMCCountry *)country;
@end

NS_ASSUME_NONNULL_END
