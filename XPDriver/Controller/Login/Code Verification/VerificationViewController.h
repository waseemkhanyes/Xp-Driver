//
//  VerificationViewController.h
//  ZoomsRideClient
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerificationViewController : UIViewController
@property (nonatomic, strong) NSString *email;
@property (strong, nonatomic) NSString *verificatinCode;
@property (nonatomic, strong) NSString *userId;
@property (assign, nonatomic) BOOL isForgotPasword;
@end

NS_ASSUME_NONNULL_END
