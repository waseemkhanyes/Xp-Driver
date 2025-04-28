//
//  InvoiceView.m
//  XPEats
//
//  Created by Macbook on 24/03/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "InvoiceItem.h"
#import "InvoiceView.h"
@interface InvoiceView()
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;
@end
@implementation InvoiceView
- (void)configer:(InvoiceItem *)invoiceItem{
    BOOL isSubTotal  = [invoiceItem.title isEqualToString:@"Subtotal"];
    BOOL istotal  = [invoiceItem.title isEqualToString:@"Total"];
    if (isSubTotal || istotal) {
        self.isTop = YES;
        [self setTopLineColor:[UIColor lightTextColor]];
        [self setTopLineWidth:0.5];
    }
    [self.titleLabel setTextColor:invoiceItem.color];
    [self.subTitleLabel setTextColor:invoiceItem.color];
    [self.titleLabel setText:invoiceItem.title];
    [self.subTitleLabel setText:invoiceItem.priceInfo];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
