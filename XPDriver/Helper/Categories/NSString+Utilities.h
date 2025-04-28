//
//  NSString+Utilities.h
//  MYXPTrip
//
//  Created by Syed zia on 19/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utilities)
-(BOOL)isEmpty;
- (NSString *)deleteLastCharacter;
+ (NSString *)hexadecimalStringFromData:(NSData *)data;
+ (NSString *)currencyString:(float)floatValue currency:(NSString *)currency;
-(NSString *)dateString;
-(NSString *)dateStringWithFormate:(NSString *)formate;
@end

NS_ASSUME_NONNULL_END
