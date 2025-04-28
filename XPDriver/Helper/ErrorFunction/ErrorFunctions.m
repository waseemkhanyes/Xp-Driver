//
//  ErrorFunctions.m
//  ridegreen
//
//  Created by Syed zia ur Rehman on 24/11/2015.
//  Copyright © 2015 Syed zia ur Rehman. All rights reserved.
//

#import "ErrorFunctions.h"
        
    

       
@implementation ErrorFunctions
+(BOOL)isError:(NSString *)errorString


{
    if (!errorString || [errorString isEqual:[NSNull null]]){
        return NO;
    }
    else if([errorString  isEqualToString:SERVER_NOT_CONNECT])
    {
        return YES;
    }
    else if([errorString  isEqualToString:GOT_500])
    {
        return YES;
    }
    else if([errorString  isEqualToString:NETWORK_LOST])
    {
        return YES;
    }
    else if([errorString  isEqualToString:STREAM_EXHAUSTED])
    {
        return YES;
    }
    else if([errorString  isEqualToString:TIME_OUT])
    {
        return YES;
    }else
    {
        return NO;
    }


}
@end
