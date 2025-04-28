//
//  CodManager.m
//  XPDriver
//
//  Created by Waseem  on 19/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

#import "CodManager.h"
#import "UserCurrency.h"
#import "XP_Driver-Swift.h"

//@property (strong, nonatomic) UserCurrency *selectedCurrency;

@implementation CodManager

+ (NSString *)getStripeKey {
    return SHAREMANAGER.requiredStripKey;;
}

+(UserCurrency *)selectedCurrency {
    return SHAREMANAGER.user.defaultCurrency;
}
+(User *)currentUser {
    return [User info];;
}

+ (void)fetchProfileDetailWithCompletionHandler:(HandlerDone)completionHandler {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"getProfile",@"command", SHAREMANAGER.userId, @"user_id", nil];

    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        DLog(@"json result is %@", json);
        NSArray *results = [json objectForKey:RESULT];
        if (![json objectForKey:@"error"] && json != nil && results.count != 0) {
            NSDictionary *profileDetails = [[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:profileDetails];
        }
        if (completionHandler) {
            completionHandler();
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        if (completionHandler) {
            completionHandler();
        }
    }];
}


@end
