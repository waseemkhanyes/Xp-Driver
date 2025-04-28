//
//  TripCell.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "TripCell.h"

@implementation TripCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = .25;
    CGRect shadowFrame = self.layer.bounds;
    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
    self.layer.shadowPath = shadowPath;
    // Initialization code
}
- (void)configer:(Trip *)trip{
    [self.dateLabel setText:trip.requestedTime];
    [self.fareLabel setText:trip.fare];
    [self.statusLabel setText:trip.status];
    [self.statusLabel setTextColor:trip.statusColor];
}
+(NSString *)identifier{
    return NSStringFromClass([self class]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
