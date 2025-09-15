//
//  CancelOrderViewController.h
//  XPEats
//
//  Created by Macbook on 10/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CancelOrderViewControllerDelegate <NSObject>
- (void)orderCanceled:(Order *)order;;
@end
@interface CancelOrderViewController : UIViewController
@property (strong, nonatomic) id <CancelOrderViewControllerDelegate>delegate;
@property (strong, nonatomic) Order         *order;
@end

NS_ASSUME_NONNULL_END
