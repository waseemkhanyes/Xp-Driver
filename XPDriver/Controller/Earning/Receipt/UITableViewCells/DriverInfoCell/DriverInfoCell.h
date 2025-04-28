//
//  DriverInfoCell.h
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "Driver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriverInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UIImageView *driverImageView;
+(NSString *)identifier;
- (void)configer:(Driver *)driver;
@end

NS_ASSUME_NONNULL_END
