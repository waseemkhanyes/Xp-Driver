//
//  PriceTotalHeaderCell.h
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceTotalHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
