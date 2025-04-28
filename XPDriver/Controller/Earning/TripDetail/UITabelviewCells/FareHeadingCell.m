//
//  FareHeadingCell.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "FareHeadingCell.h"

@implementation FareHeadingCell

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
+(NSString *)identifier{
    return NSStringFromClass([self class]);
}
- (void)configerWithTitel:(NSString *)titel subTitel:(NSString *)subTitel{
    [self.titleLabel setText:titel];
    [self.subTitleLable setText:subTitel];
    [self.titleLabel setTextColor:[UIColor blackColor]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
