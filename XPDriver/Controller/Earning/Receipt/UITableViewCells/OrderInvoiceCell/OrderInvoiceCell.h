//
//  OrderInvoiceCell.h
//  XPDriver
//
//  Created by Macbook on 05/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderInvoiceCell : UITableViewCell
@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;
+(NSString *)identifier;
- (void)configer:(NSMutableArray *)invoiceItems;
@end

NS_ASSUME_NONNULL_END
