//
//  Invitation.m
//  A1Rides
//
//  Created by Macbook on 31/01/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "Invitation.h"

@implementation Invitation
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
       if (!self) {
           return nil;
       }
    // NSString *urlString = [NSString stringWithFormat:@"%@%@",SHAREMANAGER.appData.notificationPath,attribute[@"img"]];
    [self setTitel:attribute[@"id"]];
    [self setInviteDescription:attribute[@"description"]];
    [self setMessage:attribute[@"message"]];
     //[self setImageURL:[NSURL URLWithString:urlString]];
    return self;
}
//+ (void)fetchMessageCompletion:(AFInvitationCompletion)completion{
//   NSMutableDictionary * params = [NSMutableDictionary new];
//    State *state = SHAREMANAGER.appData.country.currentState;
//    NSString *cityId = state.currentCity.cityId;
//    [params setObject :ROLE forKey:@"role"];
//    [params setObject:SHAREMANAGER.appData.country.countryId forKey:@"country_id"];
//    [params setObject:state.stateId forKey:@"state_id"];
//    [params setObject:cityId forKey:@"city_id"];
//    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [[AFAppDotNetAPIClient sharedClient] POST:@"get_invite_friends_notifications" parameters:params completion:^(NSString *error, NSDictionary *JSON) {
//        if (!error) {
//            NSArray *responseData = JSON[RESULT];
//            if (responseData.count == 0) {
//              completion(nil);
//                return;
//            }
//            completion([[Invitation alloc] initWithAttribute:responseData[0]]);
//        }else{
//            completion(nil);
//        }
//    }];
//
//}
@end
