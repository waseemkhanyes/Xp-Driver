//
//  AddressSelectionViewController.h
//  XPDriver
//
//  Created by Macbook on 18/03/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "AvailableCountry.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AddressViewControllerDelegate <NSObject>
- (void)setSelectedAddress:(MyLocation *)address;
@end
@interface AddressSelectionViewController : UIViewController
@property (strong, nonatomic) AvailableCountry *selectedCountry;
@property (strong, nonatomic) MyLocation *selectedAddress;
@property (nonatomic,strong) id <AddressViewControllerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
