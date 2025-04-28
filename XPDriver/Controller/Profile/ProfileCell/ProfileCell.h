//
//  ProfileCell.h
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 21/04/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titelLab;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
+(NSString *)identifire;
@end
