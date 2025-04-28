//
//  InvoiceCell.h
//  XPDriver
//
//  Created by Macbook on 01/02/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "InvoiceItem.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceCell : UITableViewCell
@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
+(NSString *)identifier;
- (void)configer:(InvoiceItem *)invoiceItem;
@end

NS_ASSUME_NONNULL_END
