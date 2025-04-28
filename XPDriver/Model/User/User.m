//
//  User.m
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "Document.h"
//#import "NetworkController.h"
#import "User.h"
#import "XP_Driver-Swift.h"

@implementation User
- (id)initWithAttribute:(NSDictionary *)attribute{
    if (self != [super init]) {
        return nil;
    }
    
    NSDate *date =[NSDate dateFromString:[attribute objectForKey:@"dateAdded"] withFormat:DATE_AND_TIME_S];
    NSDate *DOBdate =[NSDate dateFromString:[attribute objectForKey:@"dob"] withFormat:DATE_ONLY];
    NSDate *expiryDate =[NSDate dateFromString:[attribute objectForKey:@"license_expiry"] withFormat:DATE_ONLY];
    NSString *phoneNumber = [attribute objectForKey:@"phone"];
    
    [self  setUserId:[attribute objectForKey:@"id"]];
    // [self  setFleetId:[attribute objectForKey:@"fleet_id"]];
    [self  setName   :[attribute objectForKey:@"name"]];
    [self  setFirstName:[attribute objectForKey:@"firstName"]];
    [self  setLastName :[attribute objectForKey:@"lastName"]];
    if (!phoneNumber.isEmpty) {
        if ([phoneNumber hasPrefix:@"+"]) {
            [self  setPhone:phoneNumber];
        }else{
            [self  setPhone  :strFormat(@"+%@",phoneNumber)];
        }
    }
    [self setCardRequired:[NSString stringWithFormat:@"%@", attribute[@"card_required"]]];
    [self setTelegramRegistered:[NSString stringWithFormat:@"%@", attribute[@"telegram_registered"]]];
    [self setTelegramRegistrationRequired:[NSString stringWithFormat:@"%@", attribute[@"telegram_registration_required"]]];
    [self setTotalReferral:[NSString stringWithFormat:@"%@",attribute[@"total_referral"]]];
    [self setTotalReferralString:[NSString stringWithFormat:@"Total Referrals: %@ ",self.totalReferral]];
    [self  setUsername:attribute[@"username"]];
    [self setCurrency:attribute[@"currency"]];
    [self  setEmail  :[attribute objectForKey:@"email"]];
    [self  setDob    :[NSDate stringFromDate:DOBdate withFormat:DATE_ONLY_DISPLAY]];
    [self  setPicNeme:[attribute objectForKey:@"photo"]];
    [self  setAddress :[attribute objectForKey:@"permanent_address"]];
    [self  setStatus :[attribute objectForKey:@"road_status"]];
    [self  setRating:[attribute objectForKey:@"reating"]];
    [self  setCustomerId:[attribute objectForKey:@"customerid"]];
    [self  setQRNumber:[attribute objectForKey:@"qr_no"]];
    [self  setStateName:[attribute objectForKey:@"state_name"]];
    [self  setStateID:[attribute objectForKey:@"state_id"]];
    [self  setReferralCode:[attribute objectForKey:@"reffarl_no"]];
    [self  setBsbNumber:[attribute objectForKey:@"bsb_no"]];
    [self  setFlageFare:[attribute objectForKey:@"base_fare"]];
    [self  setPerMileFare:[attribute objectForKey:@"per_mile_fare"]];
    [self  setPerMinFare:[attribute objectForKey:@"per_min_fare"]];
    [self setCnicNumber:[attribute objectForKey:@"NID"]];
    [self  setFareUpdatedAt:[attribute objectForKey:@"fare_updated_at"]];
    [self setDrivingLicenseNumber:[attribute objectForKey:@"license_number"]];
    [self  setDriver_licence_expiry:[NSDate stringFromDate:expiryDate withFormat:DATE_ONLY_DISPLAY]];
    [self  setTestUser:[attribute objectForKey:@"test_user"]];
    
    if ([attribute objectForKey:@"no_of_rides"]) {
        [self  setNumberOfRide:strFormat(@"%@ Rides",[attribute objectForKey:@"no_of_rides"])];
    }else{
        [self  setNumberOfRide:@"0 Ride"];
    }
    [self  setTotalEarned: strFormat(@"%@",[attribute objectForKey:@"total_earned"])];
    [self  setTotalPaid:   strFormat(@"%@",[attribute objectForKey:@"total_paid"])];
    
    [self  setJoinedAt:[NSDate stringFromDate:date withFormat:DATE_ONLY_DISPLAY]];
    [self setBankAddress:attribute[@"bank_address"]];
    [self setAccountType:attribute[@"account_type"]];
    [self setAccountNumber:attribute[@"account_number"]];
    [self setRoutingNumber:attribute[@"routing_number"]];
    [self  setAbnNumber:[attribute objectForKey:@"abn_number"]];
    [self setAccountTitle:[attribute objectForKey:@"account_title"]];
    NSDictionary *vehicleInfo = attribute[@"vehicle"];
    if (vehicleInfo.count != 0) {
        [self  setCarId:[vehicleInfo objectForKey:@"vehicle_id"]];
        [self  setCarNumber:[vehicleInfo objectForKey:@"vehicle_number"]];
        [self  setCarName:[vehicleInfo objectForKey:@"vehicle_name"]];
        [self  setCarManufactured:vehicleInfo[@"company"]];
        [self  setCarModel:vehicleInfo[@"model"]];
        [self setCarColor:vehicleInfo[@"color"]];
        [self setCarModelYear:vehicleInfo[@"year"]];
        [self  setVehicle_img_name:[vehicleInfo objectForKey:@"photo"]];
        self.isVehicelInfoUpdate = YES;
    }else{
        self.isVehicelInfoUpdate = NO;
    }
    if ([attribute[@"count_driver_uploaded_documents"] intValue] == 0) {
        self.isDocUploaded = NO;
    }else{
        self.isDocUploaded = YES;
    }
    
    [self setStripeCards:[attribute objectForKey:@"credit_cards"]];
    
    
    //    if (!self.isDocUploaded && !self.isVehicelInfoUpdate && self.picNeme.isEmpty) {
    //        [self setInfoMessage:@"Upload your profile picture, the required documents and update your vehicle information to start earning"];
    //    }else if (!self.isDocUploaded && !self.isVehicelInfoUpdate) {
    //        [self setInfoMessage:@"Upload the required Documents and update your vehicle information to start Earning"];
    //    }else if (!self.isDocUploaded && self.isVehicelInfoUpdate) {
    //        [self setInfoMessage:@"Upload your required Documents\n to start Earning"];
    //    }else if (self.isDocUploaded && !self.isVehicelInfoUpdate) {
    //        [self setInfoMessage:@"Update your vehicle information\n to start Earning"];
    //    }else if (self.isDocUploaded && self.isVehicelInfoUpdate && self.picNeme.isEmpty) {
    //        [self setInfoMessage:@"Upload your profile picture\n to start Earning"];
    //    }else{
    //        self.infoMessage = nil;
    //    }
    self.needToUpdateDocument = [self checkDocumentUploaded:[attribute objectForKey:@"documents"]];
    if (!self.isVehicelInfoUpdate && self.picNeme.isEmpty) {
        [self setInfoMessage:@"Upload your profile picture, the required documents and update your vehicle information to start earning"];
    } else if (self.picNeme.isEmpty) {
        [self setInfoMessage:@"Upload your profile picture\n to start Earning"];
    } else if (!self.isVehicelInfoUpdate) {
        [self setInfoMessage:@"Update your vehicle information\n to start Earning"];
    } else if (self.needToUpdateDocument.count > 0) {
        NSDictionary *dicDocument = self.needToUpdateDocument[0];
        [self setInfoMessage:[NSString stringWithFormat:@"Update your %@\n to start Earning", [dicDocument objectForKey:@"name"]]];
    } else if ([self.cardRequired isEqualToString:@"1"] && self.stripeCards.count == 0) {
        [self setInfoMessage:@"showCreditCardAlert"];
    }
//    else if ([self.telegramRegistrationRequired isEqualToString:@"1"]) {
//        [self setInfoMessage:@"showTelegramPopup"];
//    }
    else {
        self.infoMessage = nil;
    }
    
    //Credit card required
    
    [self setDebitCards:[self getSavedCards:attribute[@"debit_card_info"]]];
    [self setDefaultDebitCard:[self getDefaultDebitCard:self.debitCards]];
    [self setCarChassisNumber:attribute[@"car_chassis_no"]];
    [self setIsApproved:[attribute[@"status"] intValue] == 1];
    [self setAllAccounts:[self getAllBankAccounts:attribute[@"bank_info"]]];
    [self setBankAccounts:[self getBankAccounts:self.allAccounts]];
    [self setIbans:[self getAllIBANS:self.allAccounts]];
    [self setCards:[self getAllCards:self.allAccounts]];
    [self setDefaultbankAccount:[self getDefaultBankAccount:self.allAccounts]];
    [self setUserCurrencies:[self getUserCurrencies:attribute[@"user_currency"]]];
    [self setDefaultCurrency:[self getDefaultCurrency:self.userCurrencies]];
    
    //    DLog("** wk setStripeCards: %@", self.stripeCards);
    return self;
}
- (NSMutableArray *)getAllBankAccounts:(NSArray *)accounts{
    NSMutableArray *bankAccounts = [NSMutableArray new];
    for (NSDictionary *dic in accounts) {
        [bankAccounts addObject:[[Bank alloc] initWithAtrribute:dic]];
    }
    return bankAccounts;
}

- (NSMutableArray *)checkDocumentUploaded:(NSArray *)documents{
    NSMutableArray *needToUpdate = [NSMutableArray new];
    for (NSDictionary *dic in documents) {
        DLog(@"** wk dic: %@", dic);
        NSArray *userRecord = [dic objectForKey:@"userRecord"];
        DLog(@"** wk userRecord: %@", userRecord);
        
        NSNumber *sidesNumber = dic[@"sides"];
        DLog(@"** wk sidesNumber: %@", sidesNumber);
        NSInteger numberOfSides = [sidesNumber integerValue];
        DLog(@"** wk numberOfSides: %ld", (long)numberOfSides);
        
        NSLog(@"Number of sides: %ld", (long)numberOfSides);
        if (numberOfSides == userRecord.count) {
            NSLog(@"document uploaded success");
        } else {
            [needToUpdate addObject:dic];
        }
    }
    return needToUpdate;
}

- (NSMutableArray *)getBankAccounts:(NSArray *)accounts{
    NSMutableArray *bankAccounts = [NSMutableArray new];
    for (Bank *bank in accounts) {
        if (bank.isBankAccount) {
            [bankAccounts addObject:bank];
        }
        
    }
    return bankAccounts;
}
- (NSMutableArray *)getAllCards:(NSArray *)accounts{
    NSMutableArray *bankAccounts = [NSMutableArray new];
    for (Bank *bank in accounts) {
        if (bank.isCARD) {
            [bankAccounts addObject:bank];
        }
        
    }
    return bankAccounts;
}
- (NSMutableArray *)getAllIBANS:(NSArray *)accounts{
    NSMutableArray *bankAccounts = [NSMutableArray new];
    for (Bank *bank in accounts) {
        if (bank.isIBAN) {
            [bankAccounts addObject:bank];
        }
        
    }
    return bankAccounts;
}
- (NSMutableArray *)getUserCurrencies:(NSArray *)currencyArray{
    NSMutableArray *currencies = [NSMutableArray new];
    for (NSDictionary *dic in currencyArray) {
        [currencies addObject:[[UserCurrency alloc] initWithAtrribute:dic]];
    }
    return currencies;
}
- (UserCurrency *)getDefaultCurrency:(NSMutableArray *)currencies{
    UserCurrency *defaulCurrency;
    for (UserCurrency *currency in currencies) {
        if (currency.isPreferred) {
            return currency;
        }
    }
    return defaulCurrency;
}
- (UserCurrency *)getCurrencyByCode:(NSString *)code{
    for (UserCurrency *currency in self.userCurrencies) {
        if ([currency.name isEqualToString:code]) {
            return  currency;
        }
    }
    return nil;
}
- (NSMutableArray *)getAllDocuments:(NSArray *)accounts{
    NSMutableArray *bankAccounts = [NSMutableArray new];
    for (NSDictionary *dic in accounts) {
        [bankAccounts addObject:[[Document alloc] initWithAttribute:dic]];
    }
    return bankAccounts;
}
- (NSMutableArray *)getSavedCards:(NSArray *)results{
    NSMutableArray *cards = [NSMutableArray new];
    for (NSDictionary *dic in results) {
        [cards addObject:[[SZCard alloc] initWithAttribute:dic]];
    }
    return cards;
}
- (void)updateBankAccount:(Bank *)selectedAccount{
    if (selectedAccount.isIBAN) {
        [self inactiveAllIBankAccounts];
    }else{
        [self inactiveAllIBNS];
    }
    [self inactiveAllIDebitCards];
    for (Bank *bank in self.bankAccounts) {
        if ([bank.bankId isEqualToString:selectedAccount.bankId]) {
            bank.isActive = YES;
        }else{
            bank.isActive = NO;
        }
    }
}
- (void)updateDebitCard:(SZCard *)selectedCard{
    [self inactiveAllIBankAccounts];
    [self inactiveAllIBNS];
    for (SZCard *card in self.debitCards) {
        if ([card.cardID isEqualToString:selectedCard.cardID]) {
            card.isActive = YES;
        }else{
            card.isActive = NO;
        }
    }
}
- (void)inactiveAllIBNS{
    for (Bank *bank in self.ibans) {
        bank.isActive = NO;
    }
}
- (void)inactiveAllIDebitCards{
    for (SZCard *card in self.debitCards) {
        card.isActive = NO;
    }
}
- (void)inactiveAllIBankAccounts{
    for (Bank *bank in self.bankAccounts) {
        bank.isActive = NO;
    }
}
- (Bank *)getDefaultBankAccount:(NSMutableArray *)accounts{
    Bank *defaulAccount;
    for (Bank *bank in accounts) {
        if (bank.isActive) {
            return bank;
        }
    }
    return defaulAccount;
}
- (SZCard *)getDefaultDebitCard:(NSMutableArray *)debitCards{
    SZCard *defaulCard;
    for (SZCard *card in debitCards) {
        if (card.isActive) {
            return card;
        }
    }
    return defaulCard;
}
+(void)save:(NSDictionary *)results{
    user_defaults_remove_object(PROFILE);
    user_defaults_set_object(PROFILE, results);
    [SHAREMANAGER setUser:[[User alloc] initWithAttribute:results]];
}
+ (BOOL)isInfoSaved{
    NSDictionary *infoDcition = user_defaults_get_object(PROFILE);
    return infoDcition != nil;
}
+ (User *)info{
    NSDictionary *infoDcition = user_defaults_get_object(PROFILE);
    if (infoDcition) {
        return [[User alloc] initWithAttribute:infoDcition];
    }
    return [User new];
}

- (void)removeBankAccount:(Bank *)selectedAccount{
    for (Bank *bank in self.bankAccounts) {
        if ([bank.bankId isEqualToString:selectedAccount.bankId]) {
            [self.bankAccounts removeObject:bank];
            break;
        }
    }
}
#pragma mark - WebServices -

//+ (void)verifiyEmailAddress:(NSMutableDictionary *)parameters  completion:(AFVerificationCompletion)completion{
//
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil) {
//            if ([json[@"success"] intValue] == 1) {
//                completion(json,@"");
//            }else{
//                completion(nil,[json objectForKey:@"msg"]);
//            }
//        }else{
//            completion(nil,[json objectForKey:@"error"]);
//        }
//    }];
//}

+ (void)verifiyEmailAddress:(NSMutableDictionary *)parameters  completion:(AFVerificationCompletion)completion{
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response verifiyEmailAddress JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            if ([json[@"success"] intValue] == 1) {
                completion(json,@"");
            }else{
                completion(nil,[json objectForKey:@"msg"]);
            }
        }else{
            completion(nil,[json objectForKey:@"error"]);
        }
        
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(nil,error.localizedDescription);
    }];
}

+ (void)getLocationsAsPerSelectedAddress:(NSMutableDictionary *)parameters  completion:(AFVerificationCompletion)completion{
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response verifiyEmailAddress JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            if ([json[@"success"] intValue] == 1) {
                completion(json,@"");
            }else{
                completion(nil,[json objectForKey:@"msg"]);
            }
        }else{
            completion(nil,[json objectForKey:@"error"]);
        }
        
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(nil,error.localizedDescription);
    }];
}

//+ (void)updatePassword:(NSMutableDictionary *)parameters  completion:(AFVarificationCompletion)completion{
//    [parameters setObject:@"resetPassword" forKey:@"command"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil) {
//            // NSDictionary *res  = json[@"data"][@"userdetail"];
//            DLog(@"User %@",json);
//            if ([json[@"success"] intValue] == 1) {
//                completion(json[@"msg"],@"");
//            }else{
//                completion(@"",json[@"msg"]);
//            }
//        }else{
//            completion(@"",json[@"error"]);
//        }
//    }];
//
//}

+ (void)updatePassword:(NSMutableDictionary *)parameters  completion:(AFVarificationCompletion)completion{
    [parameters setObject:@"resetPassword" forKey:@"command"];
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updatePassword JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            // NSDictionary *res  = json[@"data"][@"userdetail"];
            DLog(@"User %@",json);
            if ([json[@"success"] intValue] == 1) {
                completion(json[@"msg"],@"");
            }else{
                completion(@"",json[@"msg"]);
            }
        }else{
            completion(@"",json[@"error"]);
        }
        
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(@"",error.localizedDescription);
    }];
}

//+ (void)updateUserBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion{
//    User *user = [User info];
//    [parameters setObject:@"changeStatusBankAccount" forKey:@"command"];
//    [parameters setObject:user.userId forKey:@"user_id"];
//    [parameters setObject:@"1" forKey:@"status"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil) {
//            NSDictionary *res  = [json[@"data"]dictionaryByReplacingNullsWithBlanks];
//            //DLog(@"User %@",JSON);
//            [User save:res];
//            completion(YES,nil);
//
//        }else{
//            completion(NO,json[@"error"]);
//        }
//
//    }];
//
//}

+ (void)updateUserBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion{
    User *user = [User info];
    [parameters setObject:@"changeStatusBankAccount" forKey:@"command"];
    [parameters setObject:user.userId forKey:@"user_id"];
    [parameters setObject:@"1" forKey:@"status"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateUserBankAccount JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            NSDictionary *res  = [json[@"data"]dictionaryByReplacingNullsWithBlanks];
            //DLog(@"User %@",JSON);
            [User save:res];
            completion(YES,nil);
        }else{
            completion(NO,json[@"error"]);
        }
        
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(NO,error.localizedDescription);
    }];
    
}

//+ (void)updateUserStripeCustomerID:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion{
//    User *user = [User info];
//    [parameters setObject:@"register_stripe" forKey:@"command"];
//    [parameters setObject:user.userId forKey:@"user_id"];
//    [NetworkController apiGetWithParameters:parameters Completion:^(id JSON, NSString *error) {
//        if (!error) {
//            NSDictionary *res  = [JSON[@"data"][@"userdetail"] dictionaryByReplacingNullsWithBlanks];
//            //DLog(@"User %@",JSON);
//            [User save:res];
//            completion(nil,YES);
//        }else{
//            completion(error,NO);
//        }
//    }];
//}

+ (void)updateUserStripeCustomerID:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion{
    User *user = [User info];
    [parameters setObject:@"register_stripe" forKey:@"command"];
    [parameters setObject:user.userId forKey:@"user_id"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodGet
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateUserStripeCustomerID JSON: %@", json);
        NSDictionary *res  = [json[@"data"][@"userdetail"] dictionaryByReplacingNullsWithBlanks];
        //DLog(@"User %@",JSON);
        [User save:res];
        completion(nil,YES);
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(error.localizedDescription,NO);
    }];
    
}

//+ (void)addDebitCardBankAccount:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion{
//    User *user = [User info];
//    [parameters setObject:@"addDebitCardBankAccount" forKey:@"command"];
//    [parameters setObject:user.userId forKey:@"user_id"];
//    [NetworkController apiGetWithParameters:parameters Completion:^(id JSON, NSString *error) {
//        if (!error) {
//            NSDictionary *res  = [JSON[@"data"][@"userdetail"] dictionaryByReplacingNullsWithBlanks];
//            //DLog(@"User %@",JSON);
//            [User save:res];
//            completion(nil,YES);
//        }else{
//            completion(error,NO);
//        }
//    }];
//}

+ (void)addDebitCardBankAccount:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion{
    User *user = [User info];
    [parameters setObject:@"addDebitCardBankAccount" forKey:@"command"];
    [parameters setObject:user.userId forKey:@"user_id"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response addDebitCardBankAccount JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            NSDictionary *res  = [json[@"data"]dictionaryByReplacingNullsWithBlanks];
            //DLog(@"User %@",JSON);
            [User save:res];
            completion(nil,YES);
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(error,NO);
    }];
}

//+ (void)removeBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion{
//    User *user = [User info];
//    [parameters setObject:@"creditcard_delete" forKey:@"command"];
//    [parameters setObject:user.userId forKey:@"user_id"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil) {
//            NSDictionary *res  = [json[@"data"] dictionaryByReplacingNullsWithBlanks];
//            //DLog(@"User %@",JSON);
//            [User save:res];
//            completion(YES,nil);
//
//        }else{
//            completion(NO,json[@"error"]);
//        }
//
//    }];
//}

+ (void)removeBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion{
    User *user = [User info];
    [parameters setObject:@"creditcard_delete" forKey:@"command"];
    [parameters setObject:user.userId forKey:@"user_id"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response removeBankAccount JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            NSDictionary *res  = [json[@"data"] dictionaryByReplacingNullsWithBlanks];
            //DLog(@"User %@",JSON);
            [User save:res];
            completion(YES,nil);
            
        }else{
            completion(NO,json[@"error"]);
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(NO,error.localizedDescription);
    }];
}

//+ (void)registerextracted:(AFSuccessCompletion _Nonnull)completion parameters:(NSMutableDictionary * _Nonnull)parameters {
//    [NetworkController apiPostWithParameters:parameters Completion:^(id JSON, NSString *error) {
//        if (!error) {
//            // NSDictionary *results=[JSON objectForKey:@"userdetail"];
//            // [User save:[results dictionaryByReplacingNullsWithBlanks]];
//            completion(YES,nil);
//        }else{
//            completion(NO,error);
//        }
//    }];
//    //    [NetworkController apiXPRegisterWithParameters:parameters Completion:^(id JSON, NSString *error) {
//    //
//    //    }];
//}

+ (void)registerextracted:(AFSuccessCompletion _Nonnull)completion parameters:(NSMutableDictionary * _Nonnull)parameters {
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response registerextracted JSON: %@", json);
        completion(YES,nil);
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(NO,error.localizedDescription);
    }];
    //    [NetworkController apiXPRegisterWithParameters:parameters Completion:^(id JSON, NSString *error) {
    //
    //    }];
}
//+ (void)updateUsername:( NSMutableDictionary *)parameters  completion:(AFMessageCompletion)completion{
//    User *user = [User info];
//    [parameters setObject:user.userId forKey:@"user_id"];
//    [parameters setObject:@"updateUserProfile" forKey:@"command"];
//    [NetworkController apiGetWithParameters:parameters Completion:^(id JSON, NSString *error) {
//        if (!error) {
//            if ([JSON[@"success"] intValue] == 1){
//                NSMutableDictionary *res = JSON[@"data"];
//                [User save:[res dictionaryByReplacingNullsWithBlanks]];
//                completion(JSON[@"msg"]);
//            }else{
//                completion(nil);
//                [CommonFunctions showAlertWithTitel:@"" message:JSON[@"msg"] inVC:SHAREMANAGER.rootViewController];
//            }
//        }else{
//            completion(nil);
//            [CommonFunctions showAlertWithTitel:@"" message:error inVC:SHAREMANAGER.rootViewController];
//        }
//    }];
//}

+ (void)updateUsername:( NSMutableDictionary *)parameters  completion:(AFMessageCompletion)completion{
    User *user = [User info];
    [parameters setObject:user.userId forKey:@"user_id"];
    [parameters setObject:@"updateUserProfile" forKey:@"command"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodGet
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateUsername JSON: %@", json);
        if ([json[@"success"] intValue] == 1){
            NSMutableDictionary *res = json[@"data"];
            [User save:[res dictionaryByReplacingNullsWithBlanks]];
            completion(json[@"msg"]);
        }else{
            completion(nil);
            [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:SHAREMANAGER.rootViewController];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        completion(nil);
        [CommonFunctions showAlertWithTitel:@"" message:error.localizedDescription inVC:SHAREMANAGER.rootViewController];
    }];
}

+ (void)userRegister:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion{
#if TARGET_IPHONE_SIMULATOR
    SHAREMANAGER.deviceToken = @"444bb5d17c084f6fd1690fb94dd8faeede83b03415a4abf12a4dd38290b9911f";
#endif
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [parameters setObject:@"userRegister" forKey:@"command"];
    [parameters setObject:@"IOS" forKey:@"device_name"];
    [parameters setObject:SHAREMANAGER.deviceToken forKey:@"device_id"];
    [parameters setObject:appVersion forKey:@"app_version"];
    [parameters setObject:[NSNumber numberWithInt:[self appId]] forKey:@"app_id"];
    [self registerextracted:completion parameters:parameters];
    
}

+ (int)appId{
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    if ([appName isEqualToString:@"DoorBud"]) {
        return 11;
    }else if ([appName isEqualToString:@"XP Driver"]) {
        return 9;
    }else if ([appName isEqualToString:@"MYXP"]) {
        return 6;
    }else{
        return 0;
    }
}
@end
