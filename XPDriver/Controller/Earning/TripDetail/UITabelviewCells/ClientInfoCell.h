//
//  DriverInfoCell.h
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *clientImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *vehicleTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *vehicleInfoLabel;
- (void)configerName:(NSString *)name  picURL:(NSURL *)picURL carType:(NSString *)carType carinfo:(NSString *)carinfo;
@end

NS_ASSUME_NONNULL_END
