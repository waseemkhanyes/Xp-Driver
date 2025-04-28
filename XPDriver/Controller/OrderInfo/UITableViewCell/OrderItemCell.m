//
//  OrderItemCell.m
//  XPDriver
//
//  Created by Macbook on 03/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "OrderItemCell.h"

@implementation OrderItemCell


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
