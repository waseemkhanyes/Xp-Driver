//
//  OrderCellTableViewCell.m
//  XPDriver
//
//  Created by Macbook on 27/10/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "XP_Driver-Swift.h"

@interface OrderTableViewCell()
@property (strong, nonatomic) Order *order;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)identifier{
    return NSStringFromClass([self class]);
}

- (void)configer:(Order *)order{
    
    self.order = order;
    [self.orderNumberLabel setText:[NSString stringWithFormat:@"Order No: %@",order.orderId]];
    [self.deliveryTimeLabel setText:[NSString stringWithFormat:@"%@",order.distance]];
    [self.imgView roundCorner:10 borderColor:[UIColor clearColor]];
    self.backgroundShadowView.isShdow = order.isActive;
    self.containerView.borderWidth = order.isActive ? 1 : 0;
    self.containerView.borderColor = [UIColor appGreenColor];
    if ([self.order.paymentMethod isEqualToString:@"cod"]) {
        [self.viewCOD setHidden:false];
    } else {
        [self.viewCOD setHidden:true];
    }
//    DLog(@"wk orderId: %@, status: %d, isPickedUp: %d", order.orderId, order.status, order.isPickedUp);
    if (order.isPickedUp || order.isDelivered) {
        [self.addressLabel setHidden:YES];
        [self.nameLabel setText:order.customer.name];
        [self.noteLabel setText:[NSString stringWithFormat:@"Note: %@", order.buyerNote]];
        [self.addressLabel1 setText:[NSString stringWithFormat:@"Address: %@", order.dropAddress]];
    } else {
        [self.addressLabel setHidden:NO];
        [self.nameLabel setText:order.restaurant.name];
        [self.addressLabel setText:order.restaurant.location.address];
        if (self.order.status == KOrderStatusReached) {
            [self.noteLabel setText:[NSString stringWithFormat:@"Note: %@", order.buyerNote]];
            [self.addressLabel1 setText:[NSString stringWithFormat:@"Address: %@", order.dropAddress]];
        } else {
            [self.noteLabel setText:[NSString stringWithFormat:@""]];
            if ([self.order.paymentMethod isEqualToString:@"cod"]) {
                [self.addressLabel1 setText:[NSString stringWithFormat:@"Address: %@", order.restaurant.address]];
            } else {
                [self.addressLabel1 setText:[NSString stringWithFormat:@"Vendor Address: %@", order.restaurant.address]];
            }
        }
    }
    
    if ([self.order.paymentMethod isEqualToString:@"cod"]) {
        [self.lblCodOrderPrice setText:order.fullPrice];
        [self.priceLabel setText:order.driverFee];
    } else {
        [self.lblCodOrderPrice setText:@""];
        [self.priceLabel setText:order.fullPrice];
    }
    
    
    [self setStatusButtonTitel];
    [self getClientImage:order];
    
}

-(void)getClientImage:(Order *)order{
    NSURL *imageUrl = (!order.isPickedUp && !order.isDelivered) ? order.brandLogoUrl : order.customer.imageURL;
    if (imageUrl) {
//        [self.imgView  setImageWithURL:imageUrl placeholderImage:USER_PLACEHOLDER];
        
        NSString *imageUrlString = [imageUrl absoluteString];
        
        [AlamofireWrapper downloadImageFrom:imageUrlString completion:^(UIImage *downloadedImage) {
            // Handle downloadedImage or nil as needed
            if (downloadedImage) {
                // Do something with the downloaded image
                self.imgView.image = downloadedImage;
                
            } else {
                // Handle the case when the image download fails
                [self.imgView setImage:USER_PLACEHOLDER];
            }
        }];
    }else{
        [self.imgView setImage:USER_PLACEHOLDER];
    }
}

- (void)setStatusButtonTitel{
    DLog(@"** wk oerderId: %@, orderStatus: %d", self.order.orderId, self.order.status);
    [self.statusButton setHidden:NO];
    if (self.order.status == KOrderStatusAccepted){
        [self setBtnTittel: @"ARRIVED"];
        [self.statusButton setType:Semple];
    } else if (self.order.status == KOrderStatusReached){
        [self setBtnTittel:@"PICKED UP"];
        [self.statusButton setType:Started];
    }else if (self.order.status == KOrderStatusPickedup){
        [self setBtnTittel:@"DELIVERED"];
        [self.statusButton setType:Ended];
    }else if (self.order.status == KOrderStatusDelivered){
        [self setBtnTittel:@"DELIVERED"];
        [self.statusButton setType:Ended];
    } else if (self.order.status == KOrderStatusAssigned) {
        [self.statusButton setHidden:YES];
    } else if (self.order.status == KOrderStatusUnknow) {
        [self setBtnTittel:@"Unknown"];
        [self.statusButton setType:Semple];
    } else {
        [self.statusButton setHidden:YES];
        [self.statusButton setType:Semple];
    }
    
    [self.statusButton.titleLabel setFont:[UIFont normal]];
}

- (void)setBtnTittel:(NSString *)titel{
    [self.statusButton setTitle:titel forState:UIControlStateNormal];
}

- (IBAction)infoButtonPressed:(RoundedButton *)sender {
    [self.delegate infoButtonPressed:self.order];
}

- (IBAction)statusButtonPressed:(RoundedButton *)sender {
    [self.delegate statusButtonPressed:self.order];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
