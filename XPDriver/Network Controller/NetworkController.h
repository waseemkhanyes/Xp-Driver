//
//  NetworkController.h
//  Alrimaya
//
//  Created by Syed zia on 29/05/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>


//typedef void(^NetworkControllerCompletion)(NSDictionary *json, NSString *error);
//typedef void(^NetworkControllerSuccessCompletion)(BOOL success, NSString *error);
//typedef void(^NetworkControllerAddressCompletion) (NSMutableArray *addresses,NSString *error);
//typedef void(^LocationCompletionHandler)(NSString *latitude, NSString *longitude, NSString *error);
//typedef void(^AFRouteCompletion)(GMSMutablePath * path,NSString * distance,NSString * duration,NSString * error);

@interface NetworkController : NSObject

// Get
//+ (void)apiGetWithParameters:(NSDictionary *)parameters Completion:(NetworkControllerCompletion)block;
//// Post
//+ (void)apiPostWithParameters:(NSDictionary *)parameters Completion:(NetworkControllerCompletion)block;

-(void) showInternetError: (NSString *)error;
-(void) dismissInternetError;

@end
