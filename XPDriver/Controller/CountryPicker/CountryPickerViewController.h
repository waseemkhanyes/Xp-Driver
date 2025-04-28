//
//  CountryPickerViewController.h
//  XPFood
//
//  Created by syed zia on 02/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//
#import "EMCCountryDelegate.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryPickerViewController : UIViewController
@property (assign, nonatomic) EMCCountry *selectedCountry;
@property (weak) IBOutlet id<EMCCountryDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
