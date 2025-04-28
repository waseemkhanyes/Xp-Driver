//
//  PayoutCell.h
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "Payments.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayoutCell : UITableViewCell
- (void)configer:(Payments *)payment;
- (void)configerWithTranction:(Transaction *)transaction;
@end

NS_ASSUME_NONNULL_END
