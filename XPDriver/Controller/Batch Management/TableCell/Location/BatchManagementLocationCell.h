//
//  BatchManagementLocationCell.h
//  XPDriver
//
//  Created by Moghees on 10/10/2022.
//  Copyright © 2022 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * identifierBML = @"BatchManagementLocationCell";
@interface BatchManagementLocationCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

- (void)configerBatchManagementLocationCell;
@end

NS_ASSUME_NONNULL_END
