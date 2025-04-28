//
//  MyLocation.m
//  Eze
//
//  Created by Syed zia on 25/03/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#import "MyLocation.h"

@implementation MyLocation
- (instancetype)initWithAddress:(NSString *)address coordinateString:(NSString  *)coordinateSting distance :(float)distance{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setAddress:address];
    [self setCoordinateString:coordinateSting];
    [self setDistance:[NSString stringWithFormat:@"%.1fkm",distance]];
    if (!coordinateSting.isEmpty) {
        [self setCoordinate:[SHAREMANAGER getCoodrinateFromSrting:self.coordinateString]];
        NSArray *latLng = [self.coordinateString componentsSeparatedByString:@","];
        [self setLat:latLng[0]];
        [self setLng:latLng[1]];
    }
    return self;
}
- (instancetype)initWithAddresses:(NSArray *)addresses coordinateString:(NSString  *)coordinateSting{
    self = [super init];
    if (!self) {
        return nil;
    }
    self = [[MyLocation alloc] initWithAddress:addresses[0] coordinateString:coordinateSting distance:0];
    [self setFormetedAddress:addresses[1]];
    
    return self;
}
- (instancetype)initWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D  )coordinate{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self setCoordinate:coordinate];
    [self setAddress:address];
    [self setCoordinateString:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]];
    NSArray *latLng = [self.coordinateString componentsSeparatedByString:@","];
       [self setLat:latLng[0]];
       [self setLng:latLng[1]];
    return self;
}
- (instancetype)initWithAddress:(NSString *)address coordinate:(CLLocationCoordinate2D  )coordinate state:(NSString *)state city:(NSString *)city{
    self = [super init];
       if (!self) {
           return nil;
       }
    self = [[MyLocation alloc] initWithAddress:address coordinate:coordinate];
    self.state = state;
    self.city = city;
       return self;
}
+ (void)addressFormCoordinate:(CLLocationCoordinate2D )coordinate completionHandler:(AFLocationCompletion)completionHandler{
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        GMSReverseGeocodeResult *addressObj = response.firstResult;
        if (addressObj.thoroughfare.isEmpty && addressObj.subLocality.isEmpty) {
            completionHandler(nil,NO);
            return ;
        }
       //NSString *localCity =  addressObj.locality.isEmpty  || addressObj.locality == nil? @"" : addressObj.locality;
        NSString *thoroughfare = addressObj.thoroughfare.isEmpty  || addressObj.thoroughfare == nil? @"" : addressObj.thoroughfare;
        NSString *subLocality = addressObj.subLocality.isEmpty || addressObj.subLocality == nil ?  @"" : addressObj.subLocality;
        NSString *currentaddress = @"";
        if (thoroughfare.isEmpty) {
            currentaddress =  [NSString stringWithFormat:@"%@",subLocality];
        }else if (subLocality.isEmpty) {
            currentaddress =  [NSString stringWithFormat:@"%@",thoroughfare];
        }else{
            currentaddress =  [NSString stringWithFormat:@"%@ %@",thoroughfare,subLocality];
        }
        if (currentaddress.isEmpty) {
            currentaddress = @"Current location";
        }
        MyLocation *location = [[MyLocation alloc] initWithAddress:currentaddress coordinate:addressObj.coordinate];
        completionHandler(location,YES);
        if (addressObj){
            // [DictionryData fetchDictionryData:addressObj.country];
        }
       
    }];
}
@end
