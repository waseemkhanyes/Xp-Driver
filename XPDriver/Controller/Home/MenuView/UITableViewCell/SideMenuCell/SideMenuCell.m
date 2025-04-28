//
//  SideMenuCell.m
//  XPFood
//
//  Created by Macbook on 14/08/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "SideMenuCell.h"

@implementation SideMenuCell


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
