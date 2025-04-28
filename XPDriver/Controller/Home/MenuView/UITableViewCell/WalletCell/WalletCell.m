//
//  WalletCell.m
// A1Rides
//
//  Created by Syed zia on 21/03/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import "WalletCell.h"

@implementation WalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(NSString *)identifier{
    return NSStringFromClass([self class]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
