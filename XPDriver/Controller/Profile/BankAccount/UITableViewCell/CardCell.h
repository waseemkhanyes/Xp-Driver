//
//  CardCell.h
// A1Rides
//
//  Created by Syed zia on 20/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet ShadowView *backView;
@property (strong, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;


@end

NS_ASSUME_NONNULL_END
