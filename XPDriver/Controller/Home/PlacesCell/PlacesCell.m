//
//  PlacesCell.m
//  Nexi
//
//  Created by Syed zia on 11/10/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "PlacesCell.h"

@implementation PlacesCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (PlacesCell *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PlacesCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PlacesCell class]]) {
            customCell = (PlacesCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

@end
