//
//  SHAREMANAGER.m
//  
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//
//

#import "ShareManager.h"

@implementation ShareManager
@synthesize fare,carImages,carSelectedImages,carNames,requiredDocuments;
+ (instancetype)share
{
    static id shareMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMyManager = [[self alloc] init];
    });
    return shareMyManager;
}
- (id)init {
    if (self = [super init]) {
        self.cities = [NSMutableArray new];
        self.vehicleModels = [NSMutableArray new];
        self.appData  = [DictionryData appData];
        self.user     = [User info];
        }
    return self;
}
- (void)setAppData:(DictionryData *)appData{
    _appData = appData;
}
-(Fare *)fare{
    NSDictionary * res = user_defaults_get_object(CALCULATED_FARE);
    fare = [Fare new];
    fare =  [[Fare alloc] initWithAttribute:res];
    return fare;
}
- (NSString *)requiredStripKey{
    User *user = self.user;
    Currency *currency = [self.appData getCurrencyByCode:user.currency];
    if (currency.isCanadian) {
        DLog("canadainKey %@",self.appData.stripeKeyes.canadainKey);
        return  self.appData.stripeKeyes.canadainKey;
    }else{
        DLog("usaKey %@",self.appData.stripeKeyes.usaKey);
        return  self.appData.stripeKeyes.usaKey;
    }
    
}

- (NSString *)getStripeKeyAsPerCountry: (NSString *)country {
    if ([country isEqualToString:@"Canada"]) {
        DLog("canadainKey %@",self.appData.stripeKeyes.canadainKey);
        return  self.appData.stripeKeyes.canadainKey;
    }else{
        DLog("usaKey %@",self.appData.stripeKeyes.usaKey);
        return  self.appData.stripeKeyes.usaKey;
    }
    
}
-(NSString *)userId{
    return self.user.userId;
}

-(BOOL)isOnline{
    return user_defaults_get_bool(ISONLINE);
}
-(BOOL)isOnduty{
    return user_defaults_get_bool(ISONDUTY);
}


-(BOOL)isOffline{
    return user_defaults_get_bool(ISOFFLINE);
}
-(BOOL)isCCInfoAdded{

    return !strEmpty(self.user.customerId);
}

-(NSString *)mainUrl{
    if (self.appData.mainUrl) {
        return self.appData.mainUrl;
    }
    return MAIN_URL;
    
}
-(NSString *)apiPath{
    if (self.appData.mainUrl && self.appData.apiPath){
     return strFormat(@"%@%@",self.appData.mainUrl,self.appData.apiPath);
    }
   
    return kAPIHost;
}
-(NSString *)profilePicPath{
    if (self.appData.profilePicPath){
        return strFormat(@"%@",self.appData.profilePicPath);
    }
    return KIMGBaseUrl;
    
}
-(NSString *)docPath{
    if (self.appData.mainUrl && self.appData.docPath){
        return strFormat(@"%@%@",self.appData.mainUrl,self.appData.docPath);
    }
    return KDOCBaseUrl;
    
}


-(NSString *)stripeRegisterPath{
    
    if (self.appData.mainUrl && self.appData.stripeRegisterPath){
        return strFormat(@"%@%@",self.appData.mainUrl,self.appData.stripeRegisterPath);
    }
    return Kregister_stripe_url;
    
}
-(NSString *)googleMapKey{
    
    if (self.appData.googleMapKey) {
        
        return self.appData.googleMapKey;
    }
  
    return Google_Map_Key;
    
}
-(BOOL)isPakistan {
    return strEquals(self.appData.country.name, PAKISTAN);
}

-(NSString *)adminNumber{
    
    if (self.isPakistan) {
        
        return PK_ADMIN_NUMBER;
        
    }else {
        
        return US_ADMIN_NUMBER;
    }
}


#pragma  Car Type
-(NSArray *)carNames{
    carNames = [NSArray new];
    NSMutableArray *carTypies =[NSMutableArray new];
    NSArray *stored = self.appData.country.vehicles;
    for (int i = 0; i < stored.count; i++) {
        Vehicle *v =[stored  objectAtIndex:i];
        [carTypies addObject:v.name];
        
    }
    carNames = [carNames arrayByAddingObjectsFromArray:carTypies];
    return carNames;
}
-(NSArray *)carImages{
    carImages = [NSArray new];
    NSMutableArray *carTypies =[NSMutableArray new];
    NSArray *stored = self.appData.country.vehicles;
    for (int i = 0; i < stored.count; i++) {
        Vehicle *v =[stored  objectAtIndex:i];
        [carTypies addObject:v.image];
        
    }
    carImages = [carImages arrayByAddingObjectsFromArray:carTypies];
    return carImages;
}
-(NSArray *)carSelectedImages{
    carSelectedImages =[NSArray new];
    NSMutableArray *selectedCarTypies =[NSMutableArray new];
    NSArray *stored = self.appData.country.vehicles;
    for (int i = 0; i < stored.count; i++) {
        Vehicle *v =[stored objectAtIndex:i];
        [selectedCarTypies addObject:v.selectedImage];
        
    }
    carSelectedImages = [carSelectedImages arrayByAddingObjectsFromArray:selectedCarTypies];
    return carSelectedImages;
}
-(NSString *)getCaridByName:(NSString *)carType{
    NSString *carid ;
    NSArray *stored = self.appData.country.vehicles;
    for (int i = 0; i < stored.count; i++) {
        Vehicle *v =[stored objectAtIndex:i];
        if (strEquals(carType,v.name)) {
            carid = v.vId;
        }
        
    }
    return carid;
}
-(NSString *)getCarid:(NSInteger)index{
    Vehicle *v =[self.appData.country.vehicles  objectAtIndex:index];
    return v.vId;
}

-(NSString *)getCaridByIndex:(NSInteger)index{
    Vehicle *v =[self.appData.country.vehicles  objectAtIndex:index];
    return v.vId;
}


-(BOOL)isVaildCoordinate:(CLLocationCoordinate2D)coordi{
    if (coordi.latitude  == 0 && coordi.longitude == 0) {
        return NO;
    }else{
        return  YES;
    }
    
    
    
}

-(NSString *)coordinateInStringFormate:(CLLocationCoordinate2D)corid{

    return strFormat(@"%f,%f",corid.latitude,corid.longitude);
}
-(CLLocationCoordinate2D)storedCoordinate{
    
    NSString *coordinateStr = user_defaults_get_string(COORDINATE);
    CLLocationCoordinate2D coordinate =
[self getCoodrinateFromSrting:coordinateStr];
    
    return coordinate;
}
-(NSString *)storedCoordinateStr{
    
  
    
    return  user_defaults_get_string(COORDINATE);
}
-(void)setStoredCoordinate:(CLLocationCoordinate2D)storedCoordinate{
    NSString *coordinateStr = strFormat(@"%f,%f",storedCoordinate.latitude,storedCoordinate.longitude);
    user_defaults_set_string(COORDINATE, coordinateStr);
}


-(CLLocationCoordinate2D)getCoodrinateFromSrting:(NSString *)str{
    CLLocationCoordinate2D coord;
    NSArray  *ary  =[str componentsSeparatedByString:@","];
    if (ary.count == 2) {
        NSString *lati =[ary objectAtIndex:0];
        NSString *lngi =[ary objectAtIndex:1];
        coord = CLLocationCoordinate2DMake([lati doubleValue], [lngi doubleValue]);
        return coord;
    }
    return coord = CLLocationCoordinate2DMake(0.0, 0.0);

}

-(BOOL)isEqual:(CLLocationCoordinate2D )coordinate1 Coordinates:(CLLocationCoordinate2D)coordinate2 { return (coordinate1.latitude == coordinate2.latitude) && (coordinate1.longitude == coordinate2.longitude);
}
-(BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)removeObjectFromUD:(NSString *)key{
    
    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize ];
    
    
    
}
-(BOOL)isImageName:(NSString *)name{
    
    return (strNotEquals(name,ZERO) && strNotEquals(name,NO_PICTURE) && !strEmpty(name));
}
-(UIView *)countryCodeLabel{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30,25)];
    view.backgroundColor = CLEAR_COLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 7, 30,20)];
    label.font = [UIFont fontWithName:@"Montserrat" size:12];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:self.appData.country.countryCode];
    [view addSubview:label];
    
    
    return view;
}
#pragma mark Documents
-(NSString *)docImageNameByTag:(NSInteger)tag{
    
    NSString *docName;
    if (tag == 1)
    {
        docName = self.user.driver_licence_img_Front_name;
    }
    else if (tag == 2)
    {
        docName = self.user.taxi_licence_img_Front_name;
    }
    else if (tag == 3)
    {
        docName  = self.user.other_doc_img_name;
    }
    
    else if (tag == 4)
    {
        docName = self.user.vehicle_img_name;
    }
    return docName;

    
}
#pragma mark Documents
-(UIImage *)docPalceholderByTag:(NSInteger)tag{
    NSArray *results = self.appData.country.documents;
    UIImage  *palceholde = [UIImage new];
    Document *doc = [results objectAtIndex:tag-1];
    palceholde = doc.placeholderImage;
    return palceholde;
    
}
-(NSString *)docTypeByTag:(NSInteger)tag{
    
    NSArray *doctypes = DOC_TYPES_ARRAY;
    return [doctypes objectAtIndex:tag - 11];


}
-(NSURL *)docImageUrlByTag:(NSInteger)tag{

    return  strUrl(strFormat(@"%@%@",self.docPath,[self docImageNameByTag:tag]));
}
-(BOOL)isDocUploaded{
    BOOL isdoc;
    NSMutableDictionary *res = user_defaults_get_object(PROFILE);
    if (res == nil) {
      
        isdoc = [self isImageName:user_defaults_get_string(Driver_Licence_Img_Name)] && [self isImageName:user_defaults_get_string(Taxi_Licence_Img_Name)]? YES : NO;
        return isdoc;
    }
    user_defaults_set_string(Driver_Licence_Img_Name,[res objectForKey:Driver_Licence_Img_Name]);
    user_defaults_set_string(Taxi_Licence_Img_Name,[res objectForKey:Taxi_Licence_Img_Name]);
    
    isdoc = [self isImageName:user_defaults_get_string(Driver_Licence_Img_Name)] && [self isImageName:user_defaults_get_string(Taxi_Licence_Img_Name)]? YES : NO;
    return isdoc;
    
}

-(UIViewController *)rootViewController{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        if (navigationController.presentedViewController != nil) {
            return   navigationController.presentedViewController;
        }
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

-(void)makeCall:(NSString *)number{
    
    NSString *phoneNumber        = [@"telprompt://" stringByAppendingString:number];
    NSString *cleanedString      = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *phoneURLString     = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL              = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            
        }else{
#if TARGET_IPHONE_SIMULATOR
            [CommonFunctions showAlertWithTitel:escapedPhoneNumber message:@"" inVC:SHAREMANAGER.rootViewController];
#endif
        }
    }];
   
    
    
}

-(void)playSoundWithName:(NSString *) soundName
{
    NSError *err =  nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    self.theAudio = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.theAudio play];
    
}
-(NSMutableDictionary *)addobjectsWithKey:(NSArray *)keys withValues:(NSArray *)values {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    
    for ( int i = 0; i < keys.count ; i ++) {
        
        dic[[keys objectAtIndex:i]] = [values objectAtIndex:i];
        
    }
    
    return dic;
}
-(NSAttributedString *)attributedString:(NSString *)firststring secString: (NSString*)secString{
    UIFont *arialFont = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:firststring attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"Montserrat-BOLD" size:31.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: secString attributes:verdanaDict];
    
    
    [aAttrString appendAttributedString:vAttrString];
    
    
    return  aAttrString;
}
-(void)clearUserDefault{
    NSArray *keys = USERDEFAULT_KAYS_ARRAY;
    for ( int i = 0; i < keys.count ; i ++) {
        user_defaults_remove_object([keys objectAtIndex:i]);
    }
}
-(NSString *)dateString:(NSString *)date{
    NSDate *rideDate = [NSDate dateFromString:date];
    NSString *dbDateString = [NSDate stringFromDate:rideDate withFormat:@"d MMM h:mm a"]; // returns
    return dbDateString;
    
}

@end
