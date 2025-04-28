//
//  ProfileCell.m
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 21/04/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (NSString *)identifire{
    return NSStringFromClass([self class]);
}
@end
