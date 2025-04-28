//
//  InvoiceView.h
//  XPEats
//
//  Created by Macbook on 24/03/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "InvoiceItem.h"
#import "SZBorderView.h"


NS_ASSUME_NONNULL_BEGIN

@interface InvoiceView : SZBorderView
- (void)configer:(InvoiceItem *)invoiceItem;
@end

NS_ASSUME_NONNULL_END
