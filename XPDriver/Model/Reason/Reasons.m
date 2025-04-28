//
//  Reasons.m
//  NexiDriver
//
//  Created by Syed zia ur Rehman on 16/05/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "Reasons.h"

@implementation Reasons
@synthesize reasonId,reason;
+(id)setReasonId:(NSString *)reasId reason:(NSString *)reas{

    Reasons *r = [Reasons new];
    [r setReasonId:reasId];
    [r setReason:reas];
    return r;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.reasonId forKey:@"reasonId"];
    [encoder encodeObject:self.reason forKey:@"reason"];
   
    
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        self.reasonId        = [decoder decodeObjectForKey:@"reasonId"];
        self.reason         = [decoder decodeObjectForKey:@"reason"];
        
    }
    return self;
}


@end
