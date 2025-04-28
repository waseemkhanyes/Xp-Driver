//
//  UserCurrency.m
//  XPFood
//
//  Created by syed zia on 08/01/2022.
//  Copyright © 2022 WelldoneApps. All rights reserved.
//

#import "UserCurrency.h"

@implementation UserCurrency
- (instancetype)initWithAtrribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setName:attribute[@"currency"]];
    [self setIsPreferred:[attribute[@"is_preferred"]  boolValue]];
    [self setIcon:[self flagIcon:self.name]];
    
    return self;
}
- (BOOL)isCanadian{
    return  [self.name isEqualToString:@"CAD"];
}
- (UIImage *)flagIcon:(NSString *)name{
    NSString *caImagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", [name deleteLastCharacter].uppercaseString];
    return  [UIImage imageNamed:caImagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}
- (NSComparisonResult)compare:(UserCurrency *)otherObject {
    return [self.name compare:otherObject.name];
}

@end
