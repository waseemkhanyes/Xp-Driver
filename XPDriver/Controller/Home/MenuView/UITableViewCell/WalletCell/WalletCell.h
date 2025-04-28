//
//  WalletCell.h
// A1Rides
//
//  Created by Syed zia on 21/03/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *cellImageView;
@property (nonatomic, strong) IBOutlet UILabel *balanceLable;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
