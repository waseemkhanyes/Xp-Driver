//
//  AccountsViewController.h
//  XPDriver
//
//  Created by Macbook on 01/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountsViewController : UIViewController
@property (nonatomic,assign)BOOL isAddAccount;
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@end

NS_ASSUME_NONNULL_END
