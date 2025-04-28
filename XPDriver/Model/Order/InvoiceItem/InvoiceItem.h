//
//  InvoiceItem.h
//  XPDriver
//
//  Created by Macbook on 01/02/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceItem : NSObject
@property (nonatomic, strong) NSString   *title;
@property (nonatomic, strong) NSString   *price;
@property (nonatomic, strong) NSString   *quantity;
@property (nonatomic, strong) NSString   *total;
@property (nonatomic, strong) NSString   *priceInfo;
@property (nonatomic, strong) UIColor    *color;
- (instancetype)initWithAttribute:(NSDictionary *)attribute currrencySymbol:(NSString *)currrencySymbol;
- (instancetype)initWithTitel:(NSString *)titel price:(NSString *)price currrencySymbol:(NSString *)currrencySymbol;
@end

NS_ASSUME_NONNULL_END
