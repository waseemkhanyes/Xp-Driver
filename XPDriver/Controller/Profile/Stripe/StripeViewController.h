//
//  StripeViewController.h
//  XPEats
//
//  Created by Macbook on 29/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import  Stripe;
NS_ASSUME_NONNULL_BEGIN
@protocol StripeViewControllerDelegate <NSObject>
//- (void)dismissedWithAccountInfo:(CCCAccount *)account isSaveCard:(BOOL)isSaveCard;
- (void)dismissedWithCardInfo:(STPToken *)token isSaveCard:(BOOL)isSaveCard;

@end
@interface StripeViewController : UIViewController
@property (nonatomic,assign) BOOL isFromProfile;
@property (nonatomic,assign) BOOL isFromDebitCard;
@property (nonatomic,strong) NSString *currency;
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@property (nonatomic,strong) id <StripeViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
