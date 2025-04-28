//
//  NetworkController.m
//  Alrimaya
//
//  Created by Syed zia on 29/05/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//


#import "JDStatusBarNotification.h"
//#import "AFAppDotNetAPIClient.h"

//#import "NetworkController.h"
@implementation NetworkController

//+ (void)apiGetWithParameters:(NSDictionary *)parameters Completion:(NetworkControllerCompletion)block{
//    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
//     if (![AFAppDotNetAPIClient sharedClient].isInternetAvailable) {[[AFAppDotNetAPIClient sharedClient]  checkNewtworkConnection]; return;}
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//   // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager GET:@"index.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSString *jsonError = nil;
//        if ([JSON isKindOfClass:[NSDictionary class]]) {
//            if (JSON[@"error"]) {
//                jsonError = JSON[@"error"];
//            }
//        }if ([JSON isKindOfClass:[NSArray class]]) {
//            if (JSON[0][@"error"]) {
//                jsonError = JSON[0][@"error"];
//            }
//        }
//        if (block) {
//            block(JSON, jsonError);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error.code == NSURLErrorTimedOut) {
//            // Request time out
//        }else{
//            if (block) {
//                DLog(@"Error %@",error.localizedDescription);
//                block(nil, error.localizedDescription);
//                
//            }
//        }
//    }];
//    
//}
//+ (void)apiPostWithParameters:(NSDictionary *)parameters Completion:(NetworkControllerCompletion)block{
//      if (![AFAppDotNetAPIClient sharedClient].isInternetAvailable) {[[AFAppDotNetAPIClient sharedClient]  checkNewtworkConnection]; return;}
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    
//    [manager POST:@"index.php" parameters:parameters  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//               NSString *jsonError = nil;
//        NSDictionary *JSON = (NSDictionary *)responseObject;
//               if ([JSON isKindOfClass:[NSDictionary class]]) {
//                   if (JSON[@"error"]) {
//                       jsonError = JSON[@"error"];
//                   }
//               }if ([JSON isKindOfClass:[NSArray class]]) {
//                   if (JSON[@"error"]) {
//                       jsonError = JSON[@"error"];
//                   }
//               }
//               if (block) {
//                   block(JSON, jsonError);
//               }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        if (error.code == NSURLErrorTimedOut) {
//            // Request time out
//            block(nil, error.localizedDescription);
//        }else{
//            if (block) {
//                DLog(@"Error %@",error.localizedDescription);
//                block(nil, error.localizedDescription);
//                
//            }
//        }
//        
//    }];
//}

-(void) showInternetError: (NSString *)error {
    [JDStatusBarNotification showWithStatus:error styleName:JDStatusBarStyleError];
}

-(void) dismissInternetError {
    [JDStatusBarNotification dismiss];
}

@end
