//
//  RestaurentInfoReaderCell.h
//  XPEats
//
//  Created by Macbook on 14/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurentInfoReaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderFromLabel;
+(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
