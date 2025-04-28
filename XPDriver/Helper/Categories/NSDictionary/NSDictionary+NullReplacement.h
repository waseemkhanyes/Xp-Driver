//
//  NSDictionary+NullReplacement.h
//  GoInventory
//
//  Created by Bisma on 07/03/2017.
//  Copyright © 2017 Bisma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+NullReplacement.h"
@interface NSDictionary (NullReplacement)
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;
@end
