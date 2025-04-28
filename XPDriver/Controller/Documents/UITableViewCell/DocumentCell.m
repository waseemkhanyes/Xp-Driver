//
//  DocumentCell.m
//  XPDriver
//
//  Created by Syed zia on 01/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//


#import "DocumentCell.h"

@implementation DocumentCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configer:(Document *)document indexPath:(NSIndexPath *)indexPath{
    UIImage *paceholderImage = document.placeholderImage;
    [self.docImageView setTag:indexPath.row];
    [self.docImageView setImage:paceholderImage];
    [self.docTitleLabel setText:document.name];
    [self.statusLabel setText:document.status];
    [self.statusLabel setTextColor:document.statusColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
