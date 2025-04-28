//
//  BatchManagementLocationCell.m
//  XPDriver
//
//  Created by Moghees on 10/10/2022.
//  Copyright © 2022 Syed zia. All rights reserved.
//

#import "BatchManagementLocationCell.h"
#import "BatchManagmentLocationCollectionCell.h"
@interface BatchManagementLocationCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionViewFlowLayout *layout;
    
}

@end
@implementation BatchManagementLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configerBatchManagementLocationCell{
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0,8,0,8);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewLoadingCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewLoadingCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BatchManagmentLocationCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"BatchManagmentLocationCollectionCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  //  float width = indexPath.row == 2 ? 175 : 110;
    return CGSizeMake(300, 69);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat totalCellWidth = 350;
    CGFloat totalSpacingWidth = 0;
    CGFloat leftInset = (self.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2;
    CGFloat rightInset = leftInset;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    return sectionInset;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BatchManagmentLocationCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BatchManagmentLocationCollectionCell" forIndexPath:indexPath];
    return cell;
        
    
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger totalProducts = 10;
    return  totalProducts;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    [collectionView scrollToItemAtIndexPath:indexPath
      atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
              animated:true];


}

@end
