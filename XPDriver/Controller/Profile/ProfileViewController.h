//
//  ProfileViewController.h
//  FiveStarLuxuryCar_Driver
//
//  Created by Syed zia ur Rehman on 01/07/2014.
//  Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//
#import <CoreImage/CoreImage.h>
#import "AppDelegate.h"
#import "RoundedButton.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@class CurrentLocatioView;
@interface ProfileViewController : UIViewController<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,VPImageCropperDelegate>


{

    
    UIImagePickerController *imagePickerController;

    CurrentLocatioView *_currentLocation;
}
@property  (assign,nonatomic,setter=isPicSelestion:) BOOL isPicSelestion;

@property (nonatomic,retain) NSString *currentAddress;
@property (nonatomic,retain) LocationTracker * locationTracker;
@property (strong,nonatomic) User        *user;

@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalEarenedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPaidLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalRidesLabel;

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *ratingView;

@property (retain, nonatomic) IBOutlet UIImageView *statusImage;

@property (retain, nonatomic) IBOutlet RoundedButton *onlineOfflineBtn;

-(IBAction)statusBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;





@end
