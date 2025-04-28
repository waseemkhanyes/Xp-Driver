//
//  DocumentCell.h
//  XPDriver
//
//  Created by Syed zia on 01/08/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "Document.h"
#import <UIKit/UIKit.h>
@interface DocumentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *docImageView;
@property (strong, nonatomic) IBOutlet UILabel *docTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
- (void)configer:(Document *)document indexPath:(NSIndexPath *)indexPath;
@end
