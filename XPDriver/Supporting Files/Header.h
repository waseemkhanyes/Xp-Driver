//
//  Header.h
//  XPDriver
//
//  Created by Syed zia on 26/02/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//

#ifndef Header_h
#define Header_h

@class ShareManager;
@class LocationTracker;
@class RideRequest;


// frameWorks

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CFNetwork/CFNetwork.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "ShareManager.h"
// new Model

#import "User.h"
#import "Country.h"
#import "Vehicle.h"
#import "DictionryData.h"
#import "VehicleManager.h"
#import "RideRequest.h"
#import "LoadingView.h"
#import "RegisterController.h"

#import "Driver.h"
#import "ShadowView.h"
#import "ErrorFunctions.h"
#import "StarRatingView.h"
//#import "NetworkController.h"
//#import "AFNetworking.h"

//#import "NetworkController.h"
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"
#import "LRouteController.h"
#import "ACFloatingTextField.h"
#import "TQStarRatingView.h"
#import "HMSegmentedControl.h"
#import "LocationTracker.h"
#import "MDDirectionService.h"

#import "UIPlaceHolderTextView.h"
#import "NYAlertViewController.h"

#import "NSDictionary_JSONExtensions.h"
#import "VPImageCropperViewController.h"
#import "LocationShareModel.h"
#import "BackgroundTaskManager.h"
#import "NSDate+Helper.h"
#import "UIFont+Helper.h"
#import "UIButton+Helper.h"
#import "UIImageView+Helper.h"
#import "UITextField+Utilties.h"
#import "UIViewController+Helper.h"
#import "UILabel+category.h"
#import "UIColor+Helper.h"
#import "UIView+Helper.h"
#import "SZImageView.h"
#import "SZBorderLabel.h"
#import "SZBorderView.h"
#import "ZSWTappableLabel.h"
#import "NSAttributedString+TapAble.h"
#import "NSAttributedString+Helper.h"
#import "NSDictionary+NullReplacement.h"
#import "OpenInGoogleMapsController.h" // open  Directions
#import "Document.h"
#import "State.h"
#import "NSString+Utilities.h"
#import "NSDictionary_JSONExtensions.h"
#import "UIImage+Helper.h"
#import "UIImageView+Helper.h"
#import "CommonFunctions.h"

#import "EMCCountry.h"
#import "CountryCodeView.h"
#import "EMCCountryManager.h"
#import "CountryPickerViewController.h"
#import "UIImage+UIImage_EMCImageResize.h"
// calsses
#import "RideInfo.h"
#import "User.h"
#import "Reasons.h"
#import "CurrentLocatioView.h"
#import "ProfileViewController.h"

#import "ProfileCell.h"
#import "FareAndRatingView.h"
#endif /* Header_h */
