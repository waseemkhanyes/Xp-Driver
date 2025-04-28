//
//  Document.m
//  XPDriver
//
//  Created by Syed zia on 30/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "Document.h"
#import "XP_Driver-Swift.h"
@implementation Document

- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil ;
    }
    [self setDocID:[NSString stringWithFormat:@"%@",attribute[@"id"]]];
    [self setName:attribute[@"name"]];
    [self setType:attribute[@"type"]];
    UIImage *palceholder = [UIImage imageNamed:self.type];
    [self setPlaceholderImage:palceholder ? palceholder : [UIImage imageNamed:@"other_document"]];
    [self setDocSides:[attribute[@"sides"] integerValue]];
    [self setIsONeSidedDocument:self.docSides == 1];
    [self setIsExpiryDate:[attribute[@"expire_date"] integerValue] == 1];
    NSArray *documents = attribute[@"userRecord"];
    if (documents.count == 0) {
        [self setStatus:@"Missing"];
        [self setStatusColor:[UIColor appRedColor]];
        [self setExpiryDate:@""];
    }else{
        [self setStatus:@"Uploaded"];
        [self setStatusColor:[UIColor appGreenColor]];
        [self setExpiryDate:documents[0][@"expire_date"]];
        
    }
    return self;
}


//+ (void)fetchUserDocments:(DocCompletionHandler)block{
//    //command=&=793&state_id=62
//    User *user = SHAREMANAGER.user;
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getDocuments",@"command",user.userId,@"user_id",SHAREMANAGER.appData.country.countryId,@"country_id" , nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"]&& json!=nil){
//            NSArray *resultArray = [[json dictionaryByReplacingNullsWithBlanks] objectForKey:RESULT];
//           if (block) {
//               block([self getDocFormJSON:resultArray],@"");
//           }
//            
//        }else {
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self fetchUserDocments:block];
//            }else {
//                DLog(@"Error %@",errorMsg);
//            }
//            
//        }
//    }];
//}

+ (void)fetchUserDocments:(DocCompletionHandler)block{
    //command=&=793&state_id=62
    User *user = SHAREMANAGER.user;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getDocuments",@"command",user.userId,@"user_id",SHAREMANAGER.appData.country.countryId,@"country_id" , nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response fetchDictionryData JSON: %@", json);
        if (![json objectForKey:@"error"]&& json!=nil){
            NSArray *resultArray = [[json dictionaryByReplacingNullsWithBlanks] objectForKey:RESULT];
           if (block) {
               block([self getDocFormJSON:resultArray],@"");
           }
            
        }else {
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                [self fetchUserDocments:block];
            }else {
                DLog(@"Error %@",errorMsg);
            }
            
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        NSString *errorMsg = error.localizedDescription;
        if ([ErrorFunctions isError:errorMsg]){
            [self fetchUserDocments:block];
        }else {
            DLog(@"Error %@",errorMsg);
        }
    }];
}

+ (NSMutableArray *)getDocFormJSON:(NSArray *)jsonArray{
    NSMutableArray *allDocs = [NSMutableArray new];
    for (NSDictionary *dic in jsonArray) {
        Document *doc = [[Document alloc] initWithAttribute:dic];
        [allDocs addObject:doc];
    }
    return allDocs;
}
@end
