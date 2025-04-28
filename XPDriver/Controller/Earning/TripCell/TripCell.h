//
//  TripCell.h
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#import "Trip.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *fareLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
+(NSString *)identifier;
- (void)configer:(Trip *)trip;
@end

NS_ASSUME_NONNULL_END
