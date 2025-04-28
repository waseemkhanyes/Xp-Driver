//
//  CreditDebitViewController.h
//  XPFood
//
//  Created by syed zia on 25/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreditDebitViewController : UIViewController
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@property (strong, nonatomic) AvailableCountry *selectedCountry;
@end

NS_ASSUME_NONNULL_END
