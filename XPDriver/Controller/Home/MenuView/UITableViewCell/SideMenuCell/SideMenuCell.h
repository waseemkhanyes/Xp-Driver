//
//  SideMenuCell.h
//  XPFood
//
//  Created by Macbook on 14/08/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideMenuCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *cellImageView;
@property (nonatomic, strong) IBOutlet UILabel *lable;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
