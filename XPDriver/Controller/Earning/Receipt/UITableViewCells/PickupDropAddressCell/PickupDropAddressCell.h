//
//  PickupDropAddressCell.h
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickupDropAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLable;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
