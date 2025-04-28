//
//  InvoiceCell.m
//  XPDriver
//
//  Created by Macbook on 01/02/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "InvoiceCell.h"
@interface InvoiceCell()
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@end
@implementation InvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(NSString *)identifier{
    return NSStringFromClass([self class]);
}
- (void)configer:(InvoiceItem *)invoiceItem{
   //[self.titleLabel setTextColor:invoiceItem.color];
    //[self.subTitleLabel setTextColor:invoiceItem.color];
    [self.titleLabel setText:invoiceItem.title];
    [self.subTitleLabel setText:invoiceItem.priceInfo];
}
- (void)layoutSubviews {
    [super layoutSubviews];
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
