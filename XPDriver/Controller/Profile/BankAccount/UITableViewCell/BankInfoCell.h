//
//  BankInfoCell.h
//  XPDriver
//
//  Created by Macbook on 01/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet ShadowView *backView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@end

NS_ASSUME_NONNULL_END
