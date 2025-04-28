//
//  SHAREMANAGER.h
//  
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Fare.h"
#import "DictionryData.h"
#import "User.h"
@interface ShareManager : NSObject<AVAudioPlayerDelegate>{
    Fare *fare;
    NSArray *carNames;
    NSArray *carImages;
    NSArray *carSelectedImages;
    NSArray *requiredDocuments;
}
@property (nonatomic,assign) BOOL isOffline;
@property (nonatomic,assign) BOOL isOnline;
@property (nonatomic,assign) BOOL isOnduty;
@property (nonatomic,assign) BOOL isCCInfoAdded;
@property (nonatomic,assign) BOOL isPakistan;
@property (nonatomic,assign) BOOL isRide;
@property (nonatomic,assign) BOOL isInternetAvailable;
@property (nonatomic,retain) NSString *adminNumber;
@property (nonatomic,strong) NSString *requiredStripKey;
@property (nonatomic,strong) GMSCoordinateBounds *coordinateBounds;
@property (nonatomic,retain) DictionryData *appData;
@property (nonatomic,retain) User *user;
@property (nonatomic,retain) Fare *fare;
@property (readwrite,nonatomic,retain) NSString *deviceToken;
@property (nonatomic,assign) CLLocationCoordinate2D storedCoordinate;
@property (strong,nonatomic) AVAudioPlayer* theAudio;
@property (nonatomic,retain) NSString *estimatedFareString;
@property (nonatomic,retain) NSString *storedCoordinateStr;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSArray *carNames;
@property (nonatomic,retain) NSArray *carImages;
@property (nonatomic,retain) NSArray *carSelectedImages;
@property (nonatomic,retain) NSArray *requiredDocuments;
@property (nonatomic,retain) NSString     *mainUrl;
@property (nonatomic,retain) NSString     *apiPath;
@property (nonatomic,retain) NSString     *stripeRegisterPath;
@property (nonatomic,retain) NSString     *profilePicPath;
@property (nonatomic,retain) NSString     *googleMapKey;
@property (nonatomic,retain) NSString     *docPath;
@property (nonatomic,retain) NSMutableArray     *cities;
@property (nonatomic,retain) NSMutableArray     *vehicleModels;

@property (nonatomic,strong) UIViewController *rootViewController;
+ (instancetype)share;
-(void)clearUserDefault;
-(NSString *)dateString:(NSString *)date;
-(void)makeCall:(NSString *)number;
-(void)removeObjectFromUD:(NSString *)key;
-(void)playSoundWithName:(NSString *) soundName;

-(NSString *)docTypeByTag:(NSInteger)tag;
-(NSString *)docImageNameByTag:(NSInteger)tag;
-(UIImage *)docPalceholderByTag:(NSInteger)tag;
-(NSURL *)docImageUrlByTag:(NSInteger)tag;

- (NSString *)getStripeKeyAsPerCountry: (NSString *)country;


-(BOOL)isImageName:(NSString *)name;
-(BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2;
-(BOOL)isVaildCoordinate:(CLLocationCoordinate2D)coordi;

-(NSString *)getCaridByName:(NSString *)carType;
-(NSString *)getCaridByIndex:(NSInteger)index;
-(NSString *)getCarid:(NSInteger)index;
-(NSString *)coordinateInStringFormate:(CLLocationCoordinate2D)corid;
-(CLLocationCoordinate2D)getCoodrinateFromSrting:(NSString *)str;
-(NSAttributedString *)attributedString:(NSString *)firststring secString: (NSString*)secString;
-(NSMutableDictionary *)addobjectsWithKey:(NSArray *)keys withValues:(NSArray *)values;

@end
