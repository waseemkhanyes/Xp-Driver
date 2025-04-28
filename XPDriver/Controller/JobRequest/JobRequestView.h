//
//  JobRequestView.h
//  XPDriver
//
//  Created by Macbook on 07/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobRequestView : UIViewController
@property (nonatomic,strong) id <RiderInfoViewDelegate>delegate;
@property (nonatomic,strong, nullable)  Order *order;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
