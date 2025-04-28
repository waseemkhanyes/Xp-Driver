//
//  RiderInfoView.h
//  XPDriver
//
//  Created by Macbook on 15/02/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "RoundedButton.h"
NS_ASSUME_NONNULL_BEGIN
@protocol RiderInfoViewDelegate <NSObject>
- (void)skipedSetup:(BOOL)isNewOrder;
- (void)backToMapScreen;
- (void)ShowOrderInfo:(Order *)order;
- (IBAction)viewBookingBtnPressed:(RoundedButton *)sender;
- (void)clickOnMessageButton:(Order *)order;
@end
@interface RiderInfoView : ShadowView
@property (nonatomic,strong) id <RiderInfoViewDelegate>delegate;
- (void)setup:(Order *)order totalEarning:(NSString *)totalEarning;

@end

NS_ASSUME_NONNULL_END
