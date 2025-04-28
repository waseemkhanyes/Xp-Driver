//
//  DictionryData.m
//  Nexi
//
//  Created by Syed zia on 20/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "DictionryData.h"

@implementation DictionryData
- (instancetype)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.availableCountries   = [self getAvailableCountries:attribute[@"available_countries"]];
    self.ibanCountries        = [self getIBANCountries:attribute[@"iban_countries"]];
    self.currencies        = [self getAllCurrencies:attribute[@"currencies"]];
    self.stripeKeyes          = [[StripeKey alloc] initWithAttribute:attribute[@"stripe_keys"]];
    NSArray  *result = [attribute objectForKey:COMMON];
    for (int i = 0; i < result.count; i++) {
        NSDictionary *dic = [result objectAtIndex:i];
        
        NSString *dataType = [dic objectForKey:@"data_type"];
        NSString *value    = [dic objectForKey:VALUES];
        
        if (strEquals(dataType, BASE_URL)) {
            self.mainUrl = value;
        }
        else if (strEquals(dataType, API_PATH)) {
            self.apiPath = strFormat(@"%@%@",self.mainUrl,value);
        }
        else if (strEquals(dataType, DOC_PATH)) {
            self.docPath = value;
        }
        else if (strEquals(dataType, GOOGLE_MAP_KEY)) {
            self.googleMapKey = value;
        }
        else if (strEquals(dataType, PROFILE_PIC_PATH)) {
            self.profilePicPath =  [value stringByReplacingOccurrencesOfString:@"dap/dap_new/" withString:@""];;
        }
        else if (strEquals(dataType, PROMOTIONS)) {
            self.promotion = value;
        }
        else  if (strEquals(dataType, PROMOTIONS_DISCOUNT)) {
            self.promotionDiscount = value;
        }
        
        else if (strEquals(dataType, STRIPE_RIGESTER_PATH)) {
            self.stripeRegisterPath = value;
        }else if ([dataType isEqualToString: @"terms_url"]){
            self.tremsURL = [NSURL URLWithString:value];
        }else if ([dataType isEqualToString: @"privacy_url"]){
             self.privacyURL = [NSURL URLWithString:value];
        }else if ([dataType isEqualToString: @"contacts_url"]){
            self.contactUsURL = [NSURL URLWithString:value];
       }
    }
    NSDictionary *countryDic   = [attribute objectForKey:COUNTRY];
    NSArray      *vehicleArray = attribute[VEHICLES];
    NSArray      *colorArray   = attribute[COLOR];
    NSDictionary *vehicales    = @{VEHICLES:vehicleArray};
    // //DLog(@"Companies dic%@",vehicales[COMPANIES]);
    NSDictionary *dataDic      = @{COUNTRY : countryDic,@"CarTypes":vehicales,COLOR:colorArray};
    self.country                    =  [[Country alloc] initWithAttribute:dataDic];
    self.reasons                    = [self getReasons:[attribute objectForKey:REASONS]];
    return self;
}

+ (void)save:(NSDictionary *)result{
    user_defaults_remove_object(APP_DATA);
    user_defaults_set_object(APP_DATA, [result dictionaryByReplacingNullsWithBlanks]);
    [SHAREMANAGER setAppData:[DictionryData appData]];
}

+(DictionryData *)appData{
    NSDictionary *savedData = user_defaults_get_object(APP_DATA);
    if (savedData) {
      return [[DictionryData alloc] initWithAttribute:savedData];
    }
    return [DictionryData new];
}
+ (BOOL)isDataSaved{
     NSDictionary *savedData = user_defaults_get_object(APP_DATA);
    return savedData != nil;
}
-(NSMutableArray *)getReasons:(NSArray *)results{
    NSMutableArray *cancelReason =[NSMutableArray new];
    for (int i = 0; i < results.count; i++) {
        NSMutableDictionary *res =[results objectAtIndex:i];
        [cancelReason addObject:[Reasons setReasonId:[res objectForKey:@"id"] reason:[res objectForKey:@"reason"]]];
    }
    return cancelReason;
    
    
}
- (NSMutableArray *)getAvailableCountries:(NSArray *)result{
    NSMutableArray *allCategroies = [NSMutableArray new];
    for (NSDictionary *dic in result) {
        [allCategroies addObject:[[AvailableCountry alloc] initWithAttribute:dic]];
    }
    return allCategroies;
}
- (NSMutableArray *)getIBANCountries:(NSArray *)result{
    NSMutableArray *allCategroies = [NSMutableArray new];
    for (NSDictionary *dic in result) {
        [allCategroies addObject:[[AvailableCountry alloc] initWithAttribute:dic]];
    }
    return allCategroies;
}
- (NSMutableArray *)getAllCurrencies:(NSArray *)result{
    NSMutableArray *allCurrencies = [NSMutableArray new];
    for (NSDictionary *dic in result) {
        [allCurrencies addObject:[[Currency alloc] initWithAttribute:dic]];
    }
    return allCurrencies;
}
- (int)indexOfCurrency:(NSString *)currency{
    for (Currency *curren in self.currencies) {
        if ([curren isKindOfClass:[NSString class]] ) {
            continue;
        }
        if ([curren.name isEqualToString:currency] ) {
            return (int)[self.currencies indexOfObject:curren];
        }
    }
    return 0;
}
- (Currency *)getCurrencyByCode:(NSString *)code{
    for (Currency *currency in self.currencies) {
        if ([currency.name isEqualToString:code]) {
            return  currency;
        }
    }
    return nil;
}
- (NSString *)getStripeKeyByCurrency:(Currency *)currency{
    if (currency.isCanadian) {
        return  self.stripeKeyes.canadainKey;
    }else{
        return  self.stripeKeyes.usaKey;
    }
    return nil;
}
@end
