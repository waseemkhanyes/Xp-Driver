//
//  User.h
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//
#import "AFAppDotNetAPIClient.h"
#import "Bank.h"
#import "SZCard.h"
#import "UserCurrency.h"

@interface User : NSObject
@property (nonatomic,assign) BOOL isApproved;
@property (nonatomic,assign) BOOL isVehicelInfoUpdate;
@property (nonatomic,assign) BOOL isDocUploaded;
@property (nonatomic,assign) BOOL isFareAdded;
@property (nonatomic,assign) BOOL isOnline;

@property (strong,nonatomic) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *totalReferralString;
@property (nonatomic, strong) NSString *totalReferral;
@property (strong,nonatomic) NSString *infoMessage;
@property (strong,nonatomic) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *picNeme;
@property (strong,nonatomic) NSString *dob;
@property (strong,nonatomic) NSString *cnicNumber;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *rating;
@property (strong,nonatomic) NSString *customerId;
@property (strong,nonatomic) NSString *QRNumber;
@property (strong,nonatomic) NSString *referralCode;
@property (strong,nonatomic) NSString *stateName;
@property (strong,nonatomic) NSString *stateID;
@property (strong,nonatomic) NSString *abnNumber;
@property (strong,nonatomic) NSString *flageFare;
@property (strong,nonatomic) NSString *perMileFare;
@property (strong,nonatomic) NSString *perMinFare;
@property (strong,nonatomic) NSString *drivingLicenseNumber;
@property (strong,nonatomic) NSString *fareUpdatedAt;
@property (strong,nonatomic) NSString *driver_licence_img_Back_name;
@property (strong,nonatomic) NSString *driver_licence_img_Front_name;
@property (strong,nonatomic) NSString *driver_licence_expiry;
@property (strong,nonatomic) NSString *taxi_licence_img_Back_name;
@property (strong,nonatomic) NSString *taxi_licence_img_Front_name;
@property (strong,nonatomic) NSString *taxi_licence_expiry;
@property (strong,nonatomic) NSString *other_doc_img_name;
@property (strong,nonatomic) NSString *other_doc_expiry;
@property (strong,nonatomic) NSString *vehicle_img_name;
@property (strong,nonatomic) NSString *doc_updated_at;
@property (strong,nonatomic) NSString *numberOfRide;
@property (strong,nonatomic) NSString *totalEarned;
@property (strong,nonatomic) NSString *totalPaid;
// car info
@property (strong,nonatomic) NSString *carId;
@property (strong,nonatomic) NSString *carName;
@property (strong,nonatomic) NSString *carManufactured;
@property (strong,nonatomic) NSString *carModel;
@property (strong,nonatomic) NSString *carEnginePower;
@property (strong,nonatomic) NSString *carModelYear;
@property (strong,nonatomic) NSString *carColor;
@property (strong,nonatomic) NSString *carNumber;
@property (strong,nonatomic) NSString *carChassisNumber;
// bank Account
@property (strong,nonatomic) NSString *accountTitle;
@property (strong,nonatomic) NSString *bankAddress;
@property (strong,nonatomic) NSString *accountType;
@property (strong,nonatomic) NSString *routingNumber;
@property (strong,nonatomic) NSString *bsbNumber;
@property (strong,nonatomic) NSString *accountNumber;
@property (strong,nonatomic) NSString *cardRequired;
@property (strong,nonatomic) NSString *telegramRegistered;
@property (strong,nonatomic) NSString *telegramRegistrationRequired;
@property (strong,nonatomic) Bank *DefaultbankAccount;
@property (nonatomic, strong) SZCard *defaultDebitCard;
@property (strong,nonatomic) NSMutableArray *allAccounts;
@property (strong,nonatomic) NSMutableArray *bankAccounts;
@property (strong,nonatomic) NSMutableArray *ibans;
@property (strong,nonatomic) NSMutableArray *cards;
@property (strong,nonatomic) NSMutableArray *debitCards;
@property (strong,nonatomic) NSString *joinedAt;
@property (strong,nonatomic) NSString *testUser;
@property (nonatomic,assign) NSDictionary *profileData;
@property (nonatomic, strong) UserCurrency *defaultCurrency;
@property (nonatomic,strong) NSMutableArray    *userCurrencies;
@property (strong,nonatomic) NSMutableArray *stripeCards;
@property (strong,nonatomic) NSMutableArray *needToUpdateDocument;
+ (BOOL)isInfoSaved;
+ (User *)info;
+ (int)appId;
- (void)updateDebitCard:(SZCard *)selectedCard;
- (void)updateBankAccount:(Bank *)selectedAccount;
- (void)removeBankAccount:(Bank *)selectedAccount;
- (UserCurrency *)getCurrencyByCode:(NSString *)code;
+(void)save:(NSDictionary *)results;
+ (void)userRegister:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion;
+ (void)verifiyEmailAddress:(NSMutableDictionary *)parameters  completion:(AFVerificationCompletion)completion;
+ (void)updatePassword:(NSMutableDictionary *)parameters  completion:(AFVarificationCompletion)completion;
+ (void)updateUserBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion;
+ (void)removeBankAccount:(NSMutableDictionary *)parameters  completion:(AFSuccessCompletion)completion;
+ (void)updateUsername:(NSMutableDictionary *)parameters  completion:(AFMessageCompletion)completion;

+ (void)updateUserStripeCustomerID:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion;
+ (void)addDebitCardBankAccount:(NSMutableDictionary *)parameters  completion:(AFStripeCompletion)completion;
+ (void)getLocationsAsPerSelectedAddress:(NSMutableDictionary *)parameters  completion:(AFADdressesCompletion)completion;


@end
