//
//  Driver.h
//  ridegreendriver
//
//  Created by Syed zia ur Rehman on 08/09/2015.
//  Copyright (c) 2015 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Driver : NSObject

{
    NSString *driverId;
    NSString *driverName;
    NSString *driverPhone;
    NSString *driverPhoto;
    NSString *driverCarId;
    NSString *driverCarNumber;
    NSString *driverCarImage;
    NSString *driverCarImagPath;
    NSString *driverRating;
    NSString *driverLocation;
    NSString *driverDistance;

}

@property (nonatomic,copy) NSString *driverId;
@property (nonatomic,copy) NSString *driverName;
@property (nonatomic,copy) NSString *driverPhone;
@property (nonatomic,copy) NSString *driverPhoto;
@property (nonatomic,copy) NSString *driverCarId;
@property (nonatomic,copy) NSString *driverCarNumber;
@property (nonatomic,copy) NSString *driverCarImage;
@property (nonatomic,copy) NSString *driverCarImagPath;
@property (nonatomic,copy) NSString *driverRating;

@property (nonatomic,copy) NSString *driverLocation;
@property (nonatomic,copy) NSString *driverDistance;

+(id)setDriverId :(NSString *)driverId driverName :(NSString *)driverName driverPhone:(NSString *)driverPhone driverPhoto:(NSString *)driverPhoto driverCarId:(NSString *)driverCarId driverCarNumber:(NSString *)driverCarNumber driverCarImage:(NSString *)driverCarImage driverCarImagPath:(NSString *)driverCarImagPath driverRating:(NSString *)driverRating driverLocation:(NSString *)driverLocation driverDistance:(NSString *)driverDistance;
@end
