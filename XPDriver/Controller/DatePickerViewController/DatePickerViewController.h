//
//  DatePickerViewController.h
//  XPDriver
//
//  Created by Syed zia on 15/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DatePickerViewControllerDelegate <NSObject>
- (void)dismissWithDateOrTime:(NSString *)dateTime;
@end
@interface DatePickerViewController : UIViewController
@property (nonatomic, assign) BOOL isDOB;
@property (nonatomic, assign) BOOL isExpiryDate;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, strong) NSDate *pickerDate;
@property (nonatomic, assign) id <DatePickerViewControllerDelegate> delegate;
@property (nonatomic, assign) UIDatePickerMode DatePickerMode;
@end

NS_ASSUME_NONNULL_END
