// AFAppDotNetAPIClient.h
//
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//Users/macbook/Developer/XPEates/Helper Classes/Networking Extensions/AFAppDotNetAPIClient.m/ THE SOFTWARE.
#import "JDStatusBarNotification.h"
#import "AFAppDotNetAPIClient.h"
#define INTERNET_CONNECTION_OFFLINE    @"The Internet connection appears to be offline."



@implementation AFAppDotNetAPIClient

//+ (instancetype)sharedClient {
//    static AFAppDotNetAPIClient *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString: AFAppDotNetAPIBaseURLString]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    });
//    
//    return _sharedClient;
//}
//- (BOOL)isInternetAvailable{
//    return (self.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi || self.networkStatus != AFNetworkReachabilityStatusReachableViaWWAN);
//}
//- (void)checkNewtworkConnection{
//    [[AFAppDotNetAPIClient sharedClient].reachabilityManager startMonitoring];
//    [[AFAppDotNetAPIClient sharedClient].reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        self.networkStatus = status;
//         [SHAREMANAGER setIsInternetAvailable:self.isInternetAvailable];
//        if (status != AFNetworkReachabilityStatusReachableViaWiFi && status != AFNetworkReachabilityStatusReachableViaWWAN) {
//            //DLog(@"Not reachable");
//            [JDStatusBarNotification showWithStatus:INTERNET_CONNECTION_OFFLINE styleName:JDStatusBarStyleError];
//            [[AFAppDotNetAPIClient sharedClient].reachabilityManager startMonitoring];
//           
//           //[SHAREMANAGER.rootViewController zingleWithMessage:(NSString * _Null_unspecified)INTERNET_CONNECTION_OFFLINE];
//        }else if (status == AFNetworkReachabilityStatusUnknown){
//            //DLog(@"unknow");
//        }else{
//            
//            [JDStatusBarNotification dismiss];
//            //DLog(@"reachable");
//        }
//        
//    }];
//    
//}
//- (void)postWithURLString:(NSString *)urlString :(NSDictionary *)parametrs block:(AFJSONCompletion)block{
//    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:parametrs  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//          NSDictionary *JSON = (NSDictionary *)responseObject;
//        if (JSON) {
//            block(JSON,nil);
//        }else{
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//}
//- (void)fetchRoutePathFromoOrigin:(NSString *_Nullable)origin destination:(NSString *_Nullable)destination completion:(AFRouteCompletion _Nonnull )completion{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    NSString *urlString =@"https://maps.googleapis.com/maps/api/directions/json";
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:origin forKey:@"origin"];
//    [parameters setObject:destination forKey:@"destination"];
//    [parameters setObject:@"driving" forKey:@"mode"];
//    [parameters setObject:@"AIzaSyCMNT51gPtbeVnUWr4j56UzuQqMioSuwAk" forKey:@"key"];
//    
//    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *JSON = (NSDictionary *)responseObject;
//        if ([JSON[@"routes"] count] > 0){
//            GMSMutablePath *path =[GMSMutablePath pathFromEncodedPath:JSON[@"routes"][0][@"overview_polyline"][@"points"]];
//            NSDictionary *resultArray  = JSON[@"routes"][0][@"legs"];
//            NSString *distance = [[resultArray valueForKey:@"distance"]valueForKey:@"text"];
//            NSString *duration =[[resultArray valueForKey:@"duration"]valueForKey:@"text"];
//            completion(path,distance,duration,nil);
//        }else{
//              completion(nil,nil,nil,nil);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         completion(nil,nil,nil,error.localizedDescription);
//    }];
//    
//    
//}
//- (void)uploadImage:(NSMutableDictionary *)parameters :(AFUploadingCompletion)block{
//    NSData *fileData = (NSData *)parameters[@"file"];
//    [parameters  removeObjectForKey:@"file"];
//    AFHTTPSessionManager  *manager = [[AFHTTPSessionManager  alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
//    
//    [manager POST:@"index.php" parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//         [formData appendPartWithFileData:fileData
//                     name:@"file"
//                 fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//          NSLog(@"Progress: %@", uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         if (block) {
//                     NSDictionary *JSON = (NSDictionary *)responseObject;
//                     block(JSON[@"data"][@"file_name"],nil);
//                 }
//                 NSLog(@"Response: %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//          
//                NSLog(@"error: %@", error.description);
//                if (error.code == NSURLErrorTimedOut) {
//                    [self uploadImage:parameters:nil];
//                }else{
//                    if (block) {
//                        block(nil,error.localizedDescription);
//                    }
//                }
//                
//                if (block) {
//                    block(nil,error.localizedDescription);
//                }
//                NSLog(@"error: %@", error.localizedDescription);
//    }];
//     
//    
//}

@end
