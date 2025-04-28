//
//  Fare.h
//  Nexi
//
//  Created by Syed zia on 25/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Fare : NSObject
@property (nonatomic,strong) NSString *gst;
@property (nonatomic,strong) NSString *baseFare;
@property (nonatomic,strong) NSString *bookingFee;
@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *totalFare;
- (instancetype)initWithAttribute:(NSDictionary *)attribute;
@end
