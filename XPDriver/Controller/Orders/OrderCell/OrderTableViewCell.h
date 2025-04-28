//
//  OrderCellTableViewCell.h
//  XPDriver
//
//  Created by Macbook on 27/10/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol OrderTableViewCellDelegate <NSObject>
- (void)infoButtonPressed:(Order *)order;
- (void)statusButtonPressed:(Order *)order;
@end

@interface OrderTableViewCell : UITableViewCell
@property (nonatomic, strong) id <OrderTableViewCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel1;
@property (strong, nonatomic) IBOutlet UILabel *vendorNameLabel;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintNoteHeight;
@property (strong, nonatomic) IBOutlet ShadowView *backgroundShadowView;
@property (strong, nonatomic) IBOutlet ShadowView *containerView;
@property (strong, nonatomic) IBOutlet RoundedButton *statusButton;
@property (strong, nonatomic) IBOutlet UIView *viewCOD;
@property (strong, nonatomic) IBOutlet UILabel *lblCodOrderPrice;

- (void)configer:(Order *)request;
- (IBAction)statusButtonPressed:(RoundedButton *)sender;
- (IBAction)infoButtonPressed:(RoundedButton *)sender;


+ (NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
