//
//  PayoutCell.m
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "Transaction.h"
#import "PayoutCell.h"
@interface PayoutCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;

@end
@implementation PayoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configer:(Payments *)payment{
    UIColor *statusColor = payment.available ?  [UIColor appGreenColor] : [UIColor appRedColor];
    NSString *statusText = payment.available ? @"Available" : @"Pending";
    [self.dayLabel setText:[NSString stringWithFormat:@"%@\nOrder# %@",payment.availableAt,payment.orderID]];
    [self.totalAmountLabel setText:payment.amount];
    [self.payoutLabel setText:statusText];
    [self.payoutLabel setTextColor:statusColor];
}
- (void)configerWithTranction:(Transaction *)transaction{
    UIColor *statusColor = [UIColor appBlackColor];
    NSString *statusText = transaction.paymentStatus;
    [self.dayLabel setText:[NSString stringWithFormat:@"%@",transaction.date]];
    [self.totalAmountLabel setText:transaction.amount];
    [self.payoutLabel setText:statusText];
    [self.payoutLabel setTextColor:statusColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
