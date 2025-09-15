//
//  OrdersViewController.h
//  XPDriver
//
//  Created by Macbook on 27/10/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "OrderTableViewCell.h"
#import <UIKit/UIKit.h>
#define KORDERS_NOTIFICATION_KEY @"OrdersNotificationKey"
NS_ASSUME_NONNULL_BEGIN
@protocol OrdersViewControllerDelegate <NSObject>
- (void)ordersViewControllerDismissed;
- (void)pushToFareAndRank: (Order *)order;
//- (void)changeActiveOrder: (NSDictionary *)data;
- (void)changeActiveOrder;
- (void)clickToNavigate;
-(void)clickScanButtonfromOrders;
//- (void)scanQrCode:(NSString *)orderId;
@end
@interface OrdersViewController : UIViewController

@property (nonatomic, strong) id <OrdersViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic,copy)    NSString *driverCoordinate;
@property (nonatomic,copy)    NSString *driverAddress;
@property (nonatomic,readwrite)   CLLocationCoordinate2D  driverLocation;
@end

NS_ASSUME_NONNULL_END
