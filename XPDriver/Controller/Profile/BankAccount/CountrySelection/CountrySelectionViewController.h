//
//  CountrySelectionViewController.h
//  XPFood
//
//  Created by Macbook on 02/06/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountrySelectionViewController : UIViewController
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@property (nonatomic, assign) BOOL isIBAN;
@property (nonatomic, assign) BOOL isCreditDebit;
@end

NS_ASSUME_NONNULL_END
