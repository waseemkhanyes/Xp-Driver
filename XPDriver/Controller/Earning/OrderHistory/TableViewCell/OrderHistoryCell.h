//
//  MyOrdersTableViewCell.h
//  XPEats
//
//  Created by Muhammad Sajjad Zafar on 06/08/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *resturantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *resturantAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *parkingOrSeatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *vehicleInfoOrNotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *earningLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet RoundedButton *receiptButton;

@property (strong, nonatomic) IBOutlet UILabel *itemInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblCoupon;

- (void)configerCell:(Order *)order;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
