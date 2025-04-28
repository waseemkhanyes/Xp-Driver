//
//  NSString+Utilities.m
//  MYXPTrip
//
//  Created by Syed zia on 19/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSString+Utilities.h"

@implementation NSString (Utilities)
-(BOOL)isEmpty{
    return (self.length == 0 || self == (id)[NSNull null] || self == nil || [self isEqualToString:@"<nil>"] || [self isEqualToString:@""]);
}
+ (NSString *)hexadecimalStringFromData:(NSData *)data
{
    NSUInteger dataLength = data.length;
    if (dataLength == 0) {
        return @"";
    }
    
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}
-(NSString *)dateString{
    NSDate *rideDate = [NSDate dateFromString:self];
    NSString *dbDateString = [NSDate stringFromDate:rideDate withFormat:DATE_TIME_DISPLAY]; // returns
    return dbDateString;
    
}
-(NSString *)dateStringWithFormate:(NSString *)formate{
    NSDate *rideDate = [NSDate dateFromString:self withFormat:formate];
    NSString *dbDateString = [NSDate stringFromDate:rideDate withFormat:DATE_ONLY]; // returns
    return dbDateString;
    
}
- (NSString *)deleteLastCharacter{
    if ([self length] > 2) {
        return [self substringToIndex:[self length] - 1];
    } else {
        return self;
    }
}
+ (NSString *)currencyString:(float)floatValue currency:(NSString *)currency{
    NSNumber *number = [NSNumber numberWithFloat:floatValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:currency];
    return   [formatter stringFromNumber:number];
}
@end
