//
//  MyOrdersTableViewCell.m
//  XPEats
//
//  Created by Muhammad Sajjad Zafar on 06/08/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
#import "Order.h"
#import "OrderHistoryCell.h"

@implementation OrderHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+(NSString *)identifier {
    return NSStringFromClass([self class]);
}
- (void)configerCell:(Order *)order {
    BOOL isPakringSeatingInfo = order.detailOptions.count != 0;
    [self.parkingOrSeatingLabel setHidden:!isPakringSeatingInfo];
    [self.vehicleInfoOrNotesLabel setHidden:!isPakringSeatingInfo];
    [self.orderIdLabel setText:[NSString stringWithFormat:@"#%@",order.orderId]];
    [self.resturantNameLabel setText:order.restaurant.name];
    [self.resturantAddressLabel setText:order.restaurant.location.formetedAddress];
    [self.orderDateLabel setText:order.dateOrdered];
    [self.customerNameLabel setText:order.customer.firstName];
    [self.customerAddressLabel setText:order.dropLocation.address];
    [self.orderStatusLabel setText:order.statusName];
    [self.orderDateLabel setText:order.dateOrdered];
    //    InvoiceItem *invoice = order.priceInvoiceItems.lastObject;
    //    [self.earningLabel setText:invoice.priceInfo];
    [self.earningLabel setText:order.totalAmount];
    if (isPakringSeatingInfo) {
        
        NSString *vehicleTitle = order.restaurant.isForParking ? @"Vehicle " : @"Notes ";
        NSString *parkingTitle = order.restaurant.isForParking ?  @"Parking spot " : @"Seat ";
        NSAttributedString *vehicelOrNotesAttributedText = [NSAttributedString attributedStringWithTitel:vehicleTitle withFont:[UIFont boldNormal] titleColor:[UIColor appBlackColor] subTitle:order.vehicleInfo withfont:[UIFont normal] subtitleColor:[UIColor lightGrayColor] nextLine:NO];
        NSAttributedString *parkingOrSeatingAttributedText = [NSAttributedString attributedStringWithTitel:parkingTitle withFont:[UIFont boldNormal] titleColor:[UIColor appBlackColor] subTitle:order.parkingStopNumber withfont:[UIFont normal] subtitleColor:[UIColor lightGrayColor] nextLine:NO];
        [self.parkingOrSeatingLabel setHidden:order.parkingStopNumber.isEmpty];
        [self.vehicleInfoOrNotesLabel setHidden:order.vehicleInfo.isEmpty];
        [self.parkingOrSeatingLabel setAttributedText:parkingOrSeatingAttributedText];
        [self.vehicleInfoOrNotesLabel setAttributedText:vehicelOrNotesAttributedText];
        [self.parkingOrSeatingLabel setTextAlignment:NSTextAlignmentLeft];
        [self.vehicleInfoOrNotesLabel setTextAlignment:NSTextAlignmentLeft];
    }
    
    [self.lblCoupon setHidden:!order.isCouponApplied];
}

@end
