//
//  RideRequest.h
//  relaxidriver
//
//  Created by Syed zia ur Rehman on 16/04/2016.
//  strongright © 2016 Syed zia ur Rehman. All rights reserved.
//
#import "Order.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ShareManager.h"
#import "FareInfo.h"
typedef enum {
    KRequested= 8,
    KConnected,
    KDriverArrived,
    KStarted,
    KEneded,
    KCalculatingFare,
    KClientFare,
    KPaid,
    KCanceled,
    KDriverCanceld,
    KCompleted,
}RideStatus;
@interface RideRequest : NSObject
@property (nonatomic,assign) BOOL isNewOrder;
@property (nonatomic,assign) BOOL isXPEatsOrder;
@property (nonatomic,strong) NSString *XPEatsOrderId;
@property (nonatomic,strong) NSMutableArray <Order *>  *orders;
@property (nonatomic,strong) Order  *order;
@property (nonatomic,strong) Order  *requestedOrder;
@property (nonatomic,strong) Order  *deliverdOrder;
@property (nonatomic,assign) RideStatus status;

- (instancetype)initWithAttribute:(NSDictionary *)attribute;



@end
