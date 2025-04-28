//
//  EarningTitleController.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "EarningTitleController.h"
#import "XP_Driver-Swift.h"

@implementation EarningTitleController
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    Page *previous = [[Page alloc] initWithAttrebute:attribute[@"previous"]];
    Page *next = [Page new];
    self.isNext = (attribute[@"next"] != nil);
    if (attribute[@"next"]) {
        next = [[Page alloc] initWithAttrebute:attribute[@"next"]];
    }
   
    [self setNext:next];
    [self setPervious:previous];
    [self setEarningTitles:[self allEarningTitles:attribute[@"tabs"]]];
    [self setTitles:[self allTitles:attribute[@"tabs"]]];
    return self;
}
- (NSMutableArray *)allEarningTitles:(NSArray *)titelsArray{
    NSMutableArray *allTitles = [NSMutableArray new];
    // [allTitles addObject:@"Previous"];
    for (NSDictionary *dic in titelsArray) {
        [allTitles addObject:[[EarningTitle alloc] initWithAttrebute:dic]];
    }
//    if (self.isNext) {
//        [allTitles addObject:@"Next"];
//    }
    return allTitles;
}
- (NSMutableArray *)allTitles:(NSArray *)titelsArray{
    NSMutableArray *allTitles = [NSMutableArray new];
  //   [allTitles addObject:@"Previous"];
    for (NSDictionary *dic in titelsArray) {
        EarningTitle *eTitles = [[EarningTitle alloc] initWithAttrebute:dic];
        [allTitles addObject:eTitles.title];
    }
   
//    if (self.isNext) {
//        [allTitles addObject:@"Next"];
//    }
    return allTitles;
}
+ (void)save:(NSDictionary *)data{
    user_defaults_remove_object(Earning_Titles);
    NSDictionary *previousData = user_defaults_get_object(Earning_Titles);
    user_defaults_set_object(Earning_Titles,data);
}
+ (EarningTitleController *)info{
     NSDictionary *data = user_defaults_get_object(Earning_Titles);
    EarningTitleController *etCotroller = [[EarningTitleController alloc] initWithAttrebute:data];
    return etCotroller;
}
+ (void)fetchData{
    //https://trip.myxpapp.com/services/index.php?command=get_weekly_tabs&weeks=-4&dec=n
    dispatch_async(dispatch_get_main_queue(), ^{
         NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"0" forKey:@"weeks"];
        [params setObject:@"p" forKey: @"dec"];
        [self fetchDataFormServer:params WithCompletion:^(BOOL success) {
        }];
    });
}
//+ (void)fetchDataFormServer:(NSMutableDictionary *)parameters WithCompletion:( void ( ^)(BOOL success))block{
//    [parameters setObject:@"getWeeklyTabs" forKey:@"command"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        //NSLog(@"the json return is %@",json);
//        if (![json objectForKey:@"error"]&& json!=nil){
//            [self save:[json[RESULT] dictionaryByReplacingNullsWithBlanks]];
//            if (block) {
//                block(YES);
//            }
//        }else {
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self fetchData];
//            }else {
//                if (block) {
//                    block(NO);
//                }
//                DLog(@"Error %@",errorMsg);
//            }
//            
//        }
//    }];
//    
//}

+ (void)fetchDataFormServer:(NSMutableDictionary *)parameters WithCompletion:( void ( ^)(BOOL success))block{
    [parameters setObject:@"getWeeklyTabs" forKey:@"command"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response fetchDictionryData JSON: %@", json);
        if (![json objectForKey:@"error"]&& json!=nil){
            [self save:[json[RESULT] dictionaryByReplacingNullsWithBlanks]];
            if (block) {
                block(YES);
            }
        }else {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                [self fetchData];
            }else {
                if (block) {
                    block(NO);
                }
                DLog(@"Error %@",errorMsg);
            }
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        NSString *errorMsg = error.localizedDescription;
        if ([ErrorFunctions isError:errorMsg]){
            [self fetchData];
        }else {
            if (block) {
                block(NO);
            }
            DLog(@"Error %@",errorMsg);
        }
    }];
}

@end
