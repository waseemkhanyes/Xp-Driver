//
//  DocmentImage.h
//  XPDriver
//
//  Created by Syed zia on 02/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentImage : NSObject
@property (nonatomic, assign) BOOL isFrontImage;
@property (nonatomic, assign) BOOL isBackImage;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *side;
@property (nonatomic, retain) NSString *expiryDate;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSData *imageDate;
- (instancetype)initWithType:(NSString *)type image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
