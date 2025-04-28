//
//  OrderInfoViewController.m
//  XPDriver
//
//  Created by Macbook on 03/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "OrderItemCell.h"
#import "OrderSubItemCell.h"
#import "OrderInfoViewController.h"

@interface OrderInfoViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;

- (IBAction)closeButtonPressed:(UIButton *)sender;
@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titelLabel setText:[NSString stringWithFormat:@"Order# %@",self.order.orderId]];
    // Do any additional setup after loading the view.
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ((section == 0) ? 0 : 30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        OrderItemCell *headerView = [self.tableView dequeueReusableCellWithIdentifier:OrderItemCell.identifier];
        OrderItem *item = self.order.items[section - 1];
        [headerView.nameLabel setText:item.itemName];
        return headerView;
    }
    
    return [[UIView init] alloc];
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
    return self.order.items.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    OrderItem *item = self.order.items[section - 1];
    return item.subItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return   [self subItemCell:indexPath];

}
- (OrderSubItemCell *)subItemCell:(NSIndexPath *)indexPath{
    OrderSubItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderSubItemCell.identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[OrderSubItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderSubItemCell.identifier];
    }
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            NSString *name = [NSString stringWithFormat:@"Vendor Name: %@",self.order.restaurant.title];
            [cell.nameLabel setText:name];
            [cell.nameLabel setFont:[UIFont small]];
            [cell.nameLabel setTextAlignment:NSTextAlignmentLeft];
        } else if (indexPath.row == 1) {
            NSString *name = [NSString stringWithFormat:@"Customer Note: %@",self.order.buyerNote];
            [cell.nameLabel setText:name];
            [cell.nameLabel setFont:[UIFont small]];
            [cell.nameLabel setTextAlignment:NSTextAlignmentLeft];
        } else if (indexPath.row == 2) {
            NSString *name = [NSString stringWithFormat:@"Address Note: %@",self.order.addressNote];
            [cell.nameLabel setText:name];
            [cell.nameLabel setFont:[UIFont small]];
            [cell.nameLabel setTextAlignment:NSTextAlignmentLeft];
        }
        
    } else {
        OrderItem *item = self.order.items[indexPath.section - 1];
        OrderSubItem *subItem = item.subItems[indexPath.row];
        NSString *name = [NSString stringWithFormat:@"%@",subItem.name];
        NSString *quantityString = [NSString stringWithFormat:@"(%@) ",subItem.quantity];
        
        NSAttributedString *atributedString = [NSAttributedString attributedString:quantityString withFont:[UIFont heading1] subTitle:name withfont:[UIFont normal] nextLine:NO];
        [cell.nameLabel setAttributedText:atributedString];
        [cell.nameLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return cell;
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
    
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
