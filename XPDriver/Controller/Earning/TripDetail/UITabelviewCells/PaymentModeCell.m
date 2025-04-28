//
//  PaymentModeCell.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "PaymentModeCell.h"

@implementation PaymentModeCell

- (void)awakeFromNib {
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = .25;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
    [super awakeFromNib];
    // Initialization code
}
- (void)configerWithTitel:(NSString *)titel subTitel:(NSString *)subTitel{
    [self.titleLabel setText:strFormat(@"%@ Piad",titel)];
    [self.subTitleLable setText:subTitel];
    [self.paymentModeImageView setImage:[UIImage imageNamed:[titel lowercaseString]]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}

@end
