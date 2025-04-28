//
//  Cutomer.m
//  XPDriver
//
//  Created by Macbook on 22/03/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "Customer.h"

@implementation Customer
- (instancetype)initWithAttrebute:(NSDictionary *)attribute{
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *picName = attribute[@"photo"];
    DLog(@"** wkk customer picName: %@", picName);
    NSString *picNameURLString = ( strNotEmpty(picName) && strNotEquals(picName,NO_PICTURE)) ? strFormat(@"%@%@",SHAREMANAGER.appData.profilePicPath,picName) : @"";
    DLog(@"** wkk customer picNameURLString: %@", picNameURLString);
    if (attribute[@"rider_id"]) {
     [self setClientId:attribute[@"rider_id"]];
    }else{
        [self setClientId:attribute[@"id"]];
    }
    [self setFirstName:attribute[@"firstName"]];
  //  [NSString stringWithFormat:@"%@ %@",self.firstName,attribute[@"last_name"]//
    [self setName:attribute[@"name"]];
    [self setPhone:attribute[@"phone"]];
    DLog(@"** wkk customer picNameURLString: %@", picNameURLString);
    DLog(@"** wkk customer strNotEmpty(picNameURLString): %d", strNotEmpty(picNameURLString));
//    [self setImageURL:strNotEmpty(picNameURLString) ? [NSURL URLWithString:picNameURLString] : nil];
    [self setImageURL:[NSURL URLWithString:picNameURLString]];
//    [self setImageURL:strNotEmpty(picNameURLString) ? picNameURLString : @""];
    DLog(@"** wkk customer imageUrl: %@", self.imageURL);
    [self setRating:attribute[@"rating"]];
    return self;
}
@end
