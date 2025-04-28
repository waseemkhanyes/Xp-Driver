//
//  DetailOption.m
//  XPFood
//
//  Created by Macbook on 20/11/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import "DetailOption.h"

@implementation DetailOption
- (instancetype)initWithTitel:(NSString *)titel subTitel:(NSString *)subTitel{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setTitle:titel];
    [self setSubtitel:subTitel];
    return self;
    
}
@end
