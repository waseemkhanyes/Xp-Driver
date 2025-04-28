//
//  EarningTitleController.h
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#import "Page.h"
#import "EarningTitle.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EarningTitleController : NSObject
@property (nonatomic, assign) BOOL isNext;
@property (nonatomic, strong) Page *next;
@property (nonatomic, strong) Page *pervious;
@property (nonatomic, strong) NSMutableArray *earningTitles;
@property (nonatomic, strong) NSMutableArray *titles;
- (instancetype)initWithAttrebute:(NSDictionary *)attribut;
+ (void)save:(NSDictionary *)data;
+ (EarningTitleController *)info;
+ (void)fetchData;
+ (void)fetchDataFormServer:(NSMutableDictionary *)parameters WithCompletion:(void (^)(BOOL success))block;
@end

NS_ASSUME_NONNULL_END
