//
//  DriverInfoCell.m
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
//#import "UIImageView+WebCache.h"
#import "DriverInfoCell.h"

@implementation DriverInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(NSString *)identifier {
    return NSStringFromClass([self class]);
}
- (void)configer:(Driver *)driver{
//    [self.nameLable setText:[NSString stringWithFormat:@"delivered by %@",driver.name]];
//    if (driver.PicURL.isVailed) {
//        [self.driverImageView  sd_setShowActivityIndicatorView:YES];
//        [self.driverImageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [self.driverImageView sd_setImageWithURL:driver.PicURL placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            [self.driverImageView setImage:image];
//        }];
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
