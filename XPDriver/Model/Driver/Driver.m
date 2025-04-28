//
//  Driver.m
//  ridegreendriver
//
//  Created by Syed zia ur Rehman on 08/09/2015.
//  Copyright (c) 2015 Syed zia ur Rehman. All rights reserved.
//

#import "Driver.h"

@implementation Driver
@synthesize driverId,driverName,driverPhone,driverPhoto,driverCarId,driverLocation,driverDistance;
@synthesize driverCarImage,driverCarImagPath,driverCarNumber,driverRating;
+(id)setDriverId :(NSString *)driverId driverName :(NSString *)driverName driverPhone:(NSString *)driverPhone driverPhoto:(NSString *)driverPhoto driverCarId:(NSString *)driverCarId driverCarNumber:(NSString *)driverCarNumber driverCarImage:(NSString *)driverCarImage driverCarImagPath:(NSString *)driverCarImagPath driverRating:(NSString *)driverRating driverLocation:(NSString *)driverLocation driverDistance:(NSString *)driverDistance;
{

    Driver *driver =[Driver new];
    [driver setDriverId:driverId];
    [driver setDriverName:driverName];
    [driver setDriverPhone:driverPhone];
    [driver setDriverPhoto:driverPhoto];
    [driver setDriverCarId:driverCarId];
    [driver setDriverLocation:driverLocation];
    [driver setDriverDistance:driverDistance];
    [driver setDriverCarNumber:driverCarNumber];
    [driver setDriverCarImage:driverCarImage];
    [driver setDriverCarImagPath:driverCarImagPath];
    [driver setDriverRating:driverRating];

    return driver;
}
@end
