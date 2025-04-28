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
// THE SOFTWARE.

#import <Foundation/Foundation.h>
//@import AFNetworking;

typedef void(^AFJSONCompletion)(id  _Nullable JSON, NSString * _Nullable error);
typedef void(^AFSuccessCompletion)(BOOL success, NSString * _Nullable error);

typedef void(^LocationCompletionHandler)(NSString * _Nullable latitude, NSString * _Nullable longitude, NSString * _Nullable error);

typedef void(^AFRouteCompletion)(GMSMutablePath * _Nullable path,NSString * _Nullable distance,NSString * _Nullable duration,NSString * _Nullable error);
typedef void(^AFMessageCompletion)(NSString * _Nullable message);
//typedef void(^AFUploadingCompletion)(NSString * _Nullable imageName,NSString * _Nullable error);

typedef void(^AFVerificationCompletion)(NSDictionary * _Nullable JSON ,NSString * _Nullable error);
typedef void(^AFStripeCompletion)(NSString * _Nullable error,BOOL success);
typedef void(^AFVarificationCompletion)(NSString * _Nullable message,NSString * _Nullable error);
typedef void(^AFADdressesCompletion)(NSDictionary * _Nullable JSON ,NSString * _Nullable error);


@interface AFAppDotNetAPIClient : NSObject//AFHTTPSessionManager
@property (nonatomic,assign) BOOL isInternetAvailable;
@property (nonatomic,assign) BOOL isNetworkAlertShown;
//@property (nonatomic,assign) AFNetworkReachabilityStatus networkStatus;
+ (instancetype _Nonnull )sharedClient;
//- (void)checkNewtworkConnection;
- (void)fetchRoutePathFromoOrigin:(NSString *_Nullable)origin destination:(NSString *_Nullable)destination completion:(AFRouteCompletion _Nonnull )completion;
//- (void)uploadImage:(NSMutableDictionary *_Nonnull)parameters :(AFUploadingCompletion _Nullable )block;
@end
