//
//  ReceiptViewController.m
//  XPEats
//
//  Created by Macbook on 13/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "Order.h"
#import "OrderItem.h"

#import "OrderInvoiceCell.h"
#import "PriceTotalHeaderCell.h"
#import "PickupDropAddressCell.h"
#import "ItemPriceCell.h"
#import "DriverInfoCell.h"
#import "ReceiptViewController.h"

@interface ReceiptViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titelLabel;

@property (strong, nonatomic)  NSMutableArray *itemAndSubItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
- (IBAction)closeButtonPressed:(UIButton *)sender;

@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemAndSubItems = self.order.items;
    [self.tableView reloadData];
    [self.titelLabel setText:[NSString stringWithFormat:@"Order Receipt\n#%@",self.order.orderId]];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)getAllItemsAndSubItems{
    NSMutableArray *alldata = [NSMutableArray new];
    for (OrderItem *item in self.order.items) {
        [alldata addObject:item];
        for (OrderSubItem *subItem in item.subItems) {
             [alldata addObject:subItem];
        }
    }
    return alldata;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PriceTotalHeaderCell *headerView = [self.tableView dequeueReusableCellWithIdentifier:PriceTotalHeaderCell.identifier];
    [headerView.totalLabel setText:self.order.totalAmount];
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(20, 0,0.5,ViewWidth(tableView)-40)];
    [view setBackgroundColor:self.tableView.separatorColor];
    return [UIView new];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self numberOfRows:section];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return   [self invoiceCell:indexPath];
//    switch (indexPath.section) {
//        case 0:
//           return [self itemPriceCell:indexPath];
//            break;
//        case 1:
//          return   [self invoiceCell:indexPath];
//            break;
//        default:
//            break;
//    }
//    return [UITableViewCell new];
}
- (OrderInvoiceCell *)invoiceCell:(NSIndexPath *)indexPath{
    OrderInvoiceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderInvoiceCell.identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[OrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderInvoiceCell.identifier];
    }
    [cell configer:self.order.priceInvoiceItems];
    return cell;
}
- (ItemPriceCell *)itemPriceCell:(NSIndexPath *)indexPath{
    ItemPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemPriceCell.identifier];
    if ([self.itemAndSubItems[indexPath.row] isKindOfClass:[OrderItem class]]) {
        OrderItem *item = self.itemAndSubItems[indexPath.row];
        [cell.nameLable setText:item.itemName];
         [cell.priceLabel setText:[NSString stringWithFormat:@"%@x %@",@(item.itemQuantity).stringValue,[NSString currencyString:item.itemPrice currency:self.order.currrencySymbol]]];
        [cell.subItemPriceLabel setHidden:item.subItemsString.isEmpty];
        [cell.subItemPriceLabel setText:[NSString stringWithFormat:@"%@ \n( %@)",item.subItemsString,[NSString currencyString:item.subItemPrice currency:self.order.currrencySymbol]]];
       
    }else{
        OrderSubItem *subItem = self.itemAndSubItems[indexPath.row];
        [cell.nameLable setText:subItem.name];
        [cell.priceLabel setText:[NSString stringWithFormat:@"(1x %@)",[NSString currencyString:subItem.price currency:self.order.currrencySymbol]]];
              [cell.subItemPriceLabel setHidden:YES];
    }
      return cell;
}
- (NSInteger)numberOfRows:(NSInteger)section{
    return 1;
//    switch (section) {
//        case 0:
//            return self.itemAndSubItems.count;
//            break;
//        case 1:
//            return 1;
//            break;
//        default:
//            return 0;
//            break;
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
