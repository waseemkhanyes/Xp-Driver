//
//  Document.h
//  XPDriver
//
//  Created by Syed zia on 30/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.


#import <Foundation/Foundation.h>
#import "DocumentImage.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^DocCompletionHandler)(NSMutableArray *documents,NSString *error);
@interface Document : NSObject
@property (nonatomic,strong) NSString *docID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString  *status;
@property (nonatomic,strong) NSString *expiryDate;
@property (nonatomic,assign) NSInteger docSides;
@property (nonatomic,strong) UIColor   *statusColor;
@property (nonatomic,assign) BOOL isExpiryDate;
@property (nonatomic,assign) BOOL isONeSidedDocument;
@property (nonatomic,strong) UIImage  *placeholderImage;
+ (void)fetchUserDocments:(DocCompletionHandler)block;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end

NS_ASSUME_NONNULL_END
