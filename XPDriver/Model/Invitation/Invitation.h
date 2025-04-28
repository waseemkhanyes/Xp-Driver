//
//  Invitation.h
//  A1Rides
//
//  Created by Macbook on 31/01/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Invitation : NSObject
@property (strong, nonatomic) NSString *titel;
@property (strong, nonatomic) NSString *inviteDescription;
@property (strong, nonatomic) NSString *message;
@property (nonatomic,strong) NSURL    *imageURL;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
//+ (void)fetchMessageCompletion:(AFInvitationCompletion)completion;
@end

NS_ASSUME_NONNULL_END
