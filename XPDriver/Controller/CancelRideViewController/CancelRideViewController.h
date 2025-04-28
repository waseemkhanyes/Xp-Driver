//
//  CancelRideViewController.h
//  XPDriver
//
//  Created by Syed zia on 05/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "Reasons.h"
@protocol CancelRideViewControllerDelegate <NSObject>
-(void)cancelRideWithReason:(Reasons *_Nonnull)reason;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CancelRideViewController : UIViewController
@property (nonatomic,strong) id <CancelRideViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
