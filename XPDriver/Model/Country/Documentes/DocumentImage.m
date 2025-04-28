//
//  DocmentImage.m
//  XPDriver
//
//  Created by Syed zia on 02/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "DocumentImage.h"

@implementation DocumentImage
- (instancetype)initWithType:(NSString *)type image:(UIImage *)image{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setType:type];
    [self setImage:image];
    [self setImageDate:UIImageJPEGRepresentation(image,0.6)];
    return self;
}
- (void)setIsBackImage:(BOOL)isBackImage{
    _isBackImage = isBackImage;
    if (isBackImage) {
      self.side    = @"b";
    }
}
- (void)setIsFrontImage:(BOOL)isFrontImage{
    _isFrontImage = isFrontImage;
    if (isFrontImage) {
        self.side    = @"f";
    }
}
@end
