//
//  CurrentLocatioView.h
//  fiveStarLuxuryCars
//
//  Created by Syed zia ur Rehman on 07/05/2014.
//  Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//
#import "RiderInfoView.h"
#import "AppDelegate.h"
#import "MapRequestModel.h"
#import "RoundedButton.h"
#import "MenuView.h"
@class CustomIOSAlertView;

@interface CurrentLocatioView : UIViewController<CLLocationManagerDelegate,AVAudioPlayerDelegate>
{
    
    GMSPolyline        *_polyline;
    CustomIOSAlertView *_alertView;
    CLHeading  *oldHeading;
    NSString       *selectedOption;
    NSString       *selectedOptionId;
    NSString       *oldCoordinate;
}
@property (assign ,nonatomic) BOOL isRideRequest;
@property (assign ,nonatomic) BOOL isLocationChanged;
@property (assign ,nonatomic) BOOL isNeedtoDrawRoute;
@property (assign ,nonatomic) BOOL isDirectionBtn;
@property (assign ,nonatomic) BOOL isPickupChenged;
@property (assign ,nonatomic) BOOL isDropChanged;
@property (nonatomic,retain)  RideRequest *request;
@property (nonatomic, strong) MapRequestModel *model;
@property (nonatomic,retain)  GMSMarker *driverMarker;
@property (nonatomic,retain)  LocationTracker * locationTracker;
@property (strong,nonatomic)  BackgroundTaskManager *backgroundTaskModel;
@property (strong,nonatomic)  AVAudioPlayer* theAudio;
@property (retain,retain)     NSTimer *countdownTimer;
@property (retain,retain)     NSTimer *markerTimer;
@property (strong,nonatomic)  NSString *currentLati;
@property (strong,nonatomic)  NSString *currentLngi;
@property (strong,nonatomic)  NSString *allSteps;
@property (nonatomic,copy)    NSString *driverCoordinate;
@property (nonatomic,copy)    NSString *driverAddress;
@property (nonatomic,copy)    NSString *endingString;
//@property (strong, nonatomic) IBOutlet MenuView *menuView;
@property (nonatomic,readwrite)   CLLocationCoordinate2D  driverLocation;
@property (nonatomic,readwrite)   CLLocationCoordinate2D  endingLocation;
@property (readwrite,nonatomic)   CLLocationCoordinate2D vaildCoordinate;
@property (retain, nonatomic) IBOutlet GMSMapView *mapView;
@property (retain,nonatomic)  IBOutlet ShadowView *bookingView;
@property (retain, nonatomic) IBOutlet UILabel *mainTitelLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *currentLocationBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomOptions;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintDriverProjectedEarningViewHeight;
@property (strong, nonatomic) IBOutlet UIView *viewProjectEarning;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalProjectedEarning;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalEarnings;
/// client View

@property (weak, nonatomic) IBOutlet RiderInfoView *clientView;


-(void)startTimer;
-(void)startTrackingLocation;
- (IBAction)viewBookingBtnPressed:(UIButton *)sender;
- (IBAction)currentLocationBtnPressed:(id)sender;
- (IBAction)onClickScan:(id)sender;
- (void)updateCoordinate;
-(void) pushToDriverAvailability;
//- (IBAction)onClickProjectedEarning:(id)sender;

@end
