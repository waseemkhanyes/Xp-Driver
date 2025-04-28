//
//  DictionryData.h
//  Nexi
//
//  Created by Syed zia on 20/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//
#import "Currency.h"
#import <Foundation/Foundation.h>
#import "Country.h"
#import "StripeKey.h"
#import "AvailableCountry.h"
@interface DictionryData : NSObject
@property (nonatomic,assign) BOOL         isPomotion;
@property (nonatomic,retain) NSString     *promotion;
@property (nonatomic,retain) NSString     *promotionDiscount;
@property (nonatomic,strong) StripeKey    *stripeKeyes;
@property (nonatomic,retain) NSString     *mainUrl;
@property (nonatomic,retain) NSString     *apiPath;
@property (nonatomic,strong) NSURL       *tremsURL;
@property (nonatomic,strong) NSURL       *privacyURL;
@property (nonatomic,strong) NSURL       *contactUsURL;
@property (nonatomic,retain) NSString     *stripeRegisterPath;
@property (nonatomic,retain) NSString     *profilePicPath;
@property (nonatomic,retain) NSString     *googleMapKey;
@property (nonatomic,retain) Country     *country;
@property (nonatomic,retain) NSString     *docPath;
@property (nonatomic,retain) NSMutableArray *reasons;
@property (nonatomic,strong) NSMutableArray *availableCountries;
@property (nonatomic,strong) NSMutableArray *ibanCountries;
@property (nonatomic,strong) NSMutableArray *currencies;
+ (BOOL)isDataSaved;
+ (void)save:(NSDictionary *)result;
+ (DictionryData *)appData;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
- (int)indexOfCurrency:(NSString *)currency;
- (Currency *)getCurrencyByCode:(NSString *)code;
- (NSString *)getStripeKeyByCurrency:(Currency *)currency;
@end
