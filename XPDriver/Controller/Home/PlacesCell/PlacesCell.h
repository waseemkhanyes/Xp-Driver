//
//  PlacesCell.h
//  Nexi
//
//  Created by Syed zia on 11/10/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
+ (PlacesCell *)cellFromNibNamed:(NSString *)nibName;
@end
