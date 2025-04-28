//
//  OrderInvoiceCell.m
//  XPDriver
//
//  Created by Macbook on 05/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "InvoiceView.h"
#import "OrderInvoiceCell.h"

@implementation OrderInvoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(NSString *)identifier {
    return NSStringFromClass([self class]);
}
- (void)configer:(NSMutableArray *)invoiceItems{
    BOOL isStackViewEmpty =  self.stackView.subviews.count == 0;
    if (!isStackViewEmpty) {
        [self removeAllSubViewsFormStuckView];
    }
   for (InvoiceItem *invoiceItem  in invoiceItems) {
       InvoiceView *view = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceView" owner:self options:nil] firstObject];
       view.translatesAutoresizingMaskIntoConstraints = NO;
       [view.heightAnchor constraintEqualToConstant:30].active = true;
      // [view.widthAnchor constraintEqualToConstant:self.bgView.frame.size.width].active = true;
       [view configer:invoiceItem];
       [self.stackView addArrangedSubview:view];
    }
}
- (void)removeAllSubViewsFormStuckView{
    for (SZBorderView *view in self.stackView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
