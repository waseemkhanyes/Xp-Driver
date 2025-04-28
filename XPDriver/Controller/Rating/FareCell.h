//
//  FareCell.h
//  XPDriver
//
//  Created by Syed zia on 24/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FareCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLable;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
