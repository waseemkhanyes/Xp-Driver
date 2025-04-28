//
//  BankAccountViewController.h
//  XPDriver
//
//  Created by Syed zia on 08/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankAccountViewController : UIViewController
@property (strong, nonatomic) AvailableCountry *selectedCountry;
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@property (nonatomic, assign) BOOL isIBAN;
@end

NS_ASSUME_NONNULL_END
