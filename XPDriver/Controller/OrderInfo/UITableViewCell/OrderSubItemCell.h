//
//  OrderSubItemCell.h
//  XPDriver
//
//  Created by Macbook on 03/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderSubItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
