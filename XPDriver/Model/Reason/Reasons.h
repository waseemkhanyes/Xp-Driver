//
//  Reasons.h
//  NexiDriver
//
//  Created by Syed zia ur Rehman on 16/05/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reasons : NSObject
{
    NSString *reasonId;
    NSString *reason;
}
@property (nonatomic,copy) NSString *reasonId;
@property (nonatomic,copy) NSString *reason;
+(id)setReasonId:(NSString *)reasId reason:(NSString *)reas;
@end
