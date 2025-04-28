//
//  ItemPriceCell.h
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemPriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *subItemPriceLabel;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
