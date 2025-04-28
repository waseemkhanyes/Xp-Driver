//
//  Order.h
//  XPDriver
//
//  Created by Macbook on 30/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
#import "Customer.h"
#import "OrderItem.h"
#import "OrderRestaurant.h"
#import "OrderTracking.h"
#import <Foundation/Foundation.h>
#import "NSDictionary+NullReplacement.h"
#import "InvoiceItem.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    KOrderStatusUnknow = -1,
    KOrderStatusAssigned = 1,
    KOrderStatusAccepted = 2,
    KOrderStatusReached = 3,
    KOrderStatusPickedup = 4,
    KOrderStatusDelivered = 5,
    KOrderStatusRejected = 6,
    KOrderStatusSkiped  = 7,
}KOrderStatus;
@interface Order : NSObject
@property (nonatomic,assign) BOOL isEventOrder;
@property (nonatomic,assign) BOOL isRequested;
@property (nonatomic,assign) BOOL isAccepted;
@property (nonatomic,assign) BOOL isArrived;
@property (nonatomic,assign) BOOL isPickedUp;
@property (nonatomic,assign) BOOL isDelivered;
@property (nonatomic,assign) BOOL isMissed;
@property (nonatomic,assign) BOOL isPaid;
@property (nonatomic,assign) BOOL isRejected;
@property (nonatomic,assign) BOOL isCash;
@property (nonatomic,assign) BOOL isActive;
@property (nonatomic, assign) BOOL   isPickup;
@property (nonatomic, assign) BOOL   isDelivery;
@property (nonatomic, assign) float   tip;
@property (nonatomic, assign) float  totalprice;
@property (nonatomic, strong) NSString   *orderId;
@property (nonatomic, strong) NSString   *orderTime;
@property (nonatomic, strong) NSString   *preparingtime;
@property (nonatomic, assign) int deliveryMinutes;
@property (nonatomic, assign) int processingMinutes;
@property (nonatomic, strong) NSString   *price;
@property (nonatomic, strong) NSString   *distance;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *pickedUpTime;
@property (nonatomic, strong) NSString *deliveredTime;
@property (nonatomic, strong) NSString *currrencyCode;
@property (nonatomic, strong) NSString *currrencySymbol;
@property (nonatomic, assign) float serviceFee;
@property (nonatomic, assign) float deliveryFee;
@property (nonatomic, assign) float tax;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, strong) NSString *dateOrdered;
@property (nonatomic, strong) NSString *orderInfo;
@property (nonatomic, strong) NSString *parkingStopNumber;
@property (nonatomic, strong) NSString *vehicleInfo;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *priceInvoiceItems;
@property (nonatomic, strong) NSMutableArray *invoiceItems;
@property (nonatomic, strong) NSMutableArray *detailOptions;
@property (nonatomic, strong) NSURL *brandLogoUrl;
@property (nonatomic, strong) MyLocation *dropLocation;
@property (nonatomic, strong) OrderTracking *orderTracking;
@property (nonatomic, strong) OrderRestaurant *restaurant;
@property (nonatomic, strong) Customer *customer;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *addressNote;
@property (nonatomic, strong) NSString *aptNumber;
@property (nonatomic, strong) NSString *driverFee;
@property (nonatomic, strong) NSString *driverFeeWithoutCurrent;
@property (nonatomic, strong) NSString *buyerNote;
@property (nonatomic, strong) NSString *dropAddress;
@property (nonatomic, strong) NSString *fullPrice;
@property (nonatomic, strong) NSString *fullPriceWithoutCode;
@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, strong) NSString *subTotal;
@property (nonatomic, strong) NSString *deliveryDate;
@property (nonatomic, assign) BOOL isCouponApplied;
- (instancetype)initWithAtrribute:(NSDictionary *)attribute;
- (void)cancelOrder:(NSDictionary *)paramater Completion:(void (^)(NSString *error))block;

@end

NS_ASSUME_NONNULL_END
