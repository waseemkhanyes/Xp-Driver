//
//  PaymentModeCell.h
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentModeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *paymentModeImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLable;
- (void)configerWithTitel:(NSString *)titel subTitel:(NSString *)subTitel;
@end

NS_ASSUME_NONNULL_END
