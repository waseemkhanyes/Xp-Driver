//
//  CurrentLocatioView.m
// Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//
#import "MenuView.h"
#import "FTPopOverMenu.h"
#import "JobRequestView.h"
#import "StepController.h"
#import "UIView+Helper.h"
#import "OrdersViewController.h"
#import "WebViewController.h"
#import "OrderInfoViewController.h"
#import "EarningTitleController.h"
#import "XP_Driver-Swift.h"

#import "CancelOrderViewController.h"
#define SHOW_CHANGE_LOCATION  @"ShowLocationVC"
#define CancelOrder_Idintifire    @"ShowCancelOrder"
#define CONTACT_SUPPORT    @"https://xpeats.com/#contact"
#import "CurrentLocatioView.h"
#import <MapKit/MapKit.h>
#import "XP_Driver-Swift.h"
#import "WithdrawViewController.h"
#import "CountrySelectionViewController.h"

@interface CurrentLocatioView ()<GMSMapViewDelegate,CancelOrderViewControllerDelegate,MenuViewDeleagte,ARCarMovementDelegate,RiderInfoViewDelegate,OrdersViewControllerDelegate, WebSocketManagerDelegate>{
    CLLocation *prevCurrLocation;
    StarRatingView *starviewAnimated;
    MBProgressHUD *hude;
    NSMutableArray *_coordinates;
    GMSMarker *pickupMarker;
    GMSMarker *dropMarker;
    NSMutableArray *markers;
    JobRequestView *jobVC;
}
@property (nonatomic,retain)   NSURL *selectedURL;
@property BOOL isOrderVCShown;
@property BOOL markerTapped;
@property BOOL cameraMoving;
@property BOOL idleAfterMovement;
@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;
//«««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»//
@property (strong, nonatomic) ARCarMovement *moveMent;
@property (assign) int counter;
@property (assign) int timeInterval;
@property (nonatomic,strong)  CLLocation *currLocation;
@property (nonatomic,strong)  Order *selectedOrder;
@property (nonatomic,strong)  GMSMutablePath *path;
@property (strong, nonatomic) StepController *stepsController;
@property (strong, nonatomic)  NSMutableArray *orders;
@property (nonatomic,strong)  IBOutlet RoundedButton *cancelRideBarButton;
@property (nonatomic,strong)  IBOutlet RoundedButton *batchManagmentButton;
@property (strong, nonatomic) IBOutlet MenuView *menuView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (retain, nonatomic) IBOutlet UILabel *countdownLable;
@property (strong, nonatomic) IBOutlet RoundedButton *passButton;
@property (strong, nonatomic) IBOutlet RoundedButton *viewBookingBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *clientViewTop;
//@property (strong, nonatomic) IBOutlet UIButton *orderListButton;
@property (strong, nonatomic) IBOutlet UIView *viewOrderListButton;
@property (strong, nonatomic) IBOutlet UIView *viewOrdersMap;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderCount;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet OrdersViewController *ordersVC;
- (IBAction)orderListButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottom;
@property (nonatomic,strong)  NSDictionary *dicWallet;
@property (nonatomic,strong)  NSString *strLatDummy;
@property (nonatomic,strong)  NSString *strLongDummy;
@property BOOL showLowBalance;
@property BOOL isShowTelegramPopupFirstTime;

@property (nonatomic, strong) WebSocketManager *webSocketManager;
@property BOOL isWebSocketConnected;
@property BOOL shouldShowOrders;

@property (nonatomic, strong) NSMutableArray<GMSMarker *> *mapMarkers;

@end

static NSString * const kOpenInMapsSampleURLScheme = @"XP_Driver://";
@implementation CurrentLocatioView

-(void)loadView
{
    [super loadView];
    self.mapMarkers = [NSMutableArray array];

    [self startTrackingLocation];
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    self.shouldShowOrders = true;
    self.isShowTelegramPopupFirstTime = false;
    self.showLowBalance = false;
    [super viewDidLoad];
    
    self.strLatDummy = @"43.108133076719085";
    self.strLongDummy = @"-80.31102590687195";
    
    [self.navigationItem setHidesBackButton:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.leading.constant = -(ViewWidth(self.view) + 10);
    self.moveMent = [[ARCarMovement alloc]init];
    self.moveMent.delegate = self;
    [self hideOrdersScreen];
    [OpenInGoogleMapsController sharedInstance].callbackURL =
    [NSURL URLWithString:kOpenInMapsSampleURLScheme];
    [OpenInGoogleMapsController sharedInstance].fallbackStrategy =
    kGoogleMapsFallbackChromeThenAppleMaps;
    _timeInterval = 0;
    [self removeCancelRideButtonFromNavigationBar];
    //    [self hideStatusButton];
    [self screenSetup];
    [self checkIsAppNeedToUpdate];
    
    
    //    UICodCashDetailPopupViewController *codPN = [[UICodCashDetailPopupViewController alloc] init];
    //
    //    [codPN setHandler:^{
    //        DLog(@"wk click");
    //        UICodChargeToCustomerViewController *codCheck = [[UICodChargeToCustomerViewController alloc] init];
    //        [self.navigationController pushViewController:codCheck animated:true];
    //    }];
    //    codPN.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    codPN.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self presentViewController:codPN animated:YES completion:nil];
    
    //    UICodReasonPopupViewController *codreason = [[UICodReasonPopupViewController alloc] init];
    //    codreason.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    codreason.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self presentViewController:codreason animated:YES completion:nil];
    
    //    UISubmitedSuccessfullyPopupViewController *success = [[UISubmitedSuccessfullyPopupViewController alloc] init];
    //    success.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    success.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self presentViewController:success animated:YES completion:nil];
    
    //    UICodChargeToCustomerViewController *codCheck = [[UICodChargeToCustomerViewController alloc] init];
    //    [self.navigationController pushViewController:codCheck animated:true];
    
    //    UICodChargeToCustomerViewController *codCheck = [[UICodChargeToCustomerViewController alloc] init];
    //    [self.navigationController pushViewController:codCheck animated:true];
    
    [self startToConnectWebSocket];
    [self getProjectedEarningApi];
    
//    self.viewOrderListButton.layer.cornerRadius = self.viewOrderListButton.frame.size.height / 2.0; // Make it circular
//    self.viewOrderListButton.layer.masksToBounds = NO;                           // Allow shadow outside bounds
//    self.viewOrderListButton.clipsToBounds = YES;                                // Ensure content respects bounds

    // Add shadow
    
    self.viewOrderListButton.layer.shadowColor = [UIColor blackColor].CGColor;   // Set shadow color to black
    self.viewOrderListButton.layer.shadowOpacity = 1.0;                          // Maximum shadow opacity
    self.viewOrderListButton.layer.shadowOffset = CGSizeMake(0, 3);              // Slightly adjust offset for a sharper effect
    self.viewOrderListButton.layer.shadowRadius = 5.0;
    
    self.viewOrdersMap.layer.shadowColor = [UIColor blackColor].CGColor;   // Set shadow color to black
    self.viewOrdersMap.layer.shadowOpacity = 1.0;                          // Maximum shadow opacity
    self.viewOrdersMap.layer.shadowOffset = CGSizeMake(0, 3);              // Slightly adjust offset for a sharper effect
    self.viewOrdersMap.layer.shadowRadius = 5.0;
    
//    self.viewProjectEarning.layer.shadowColor = [UIColor blackColor].CGColor;   // Shadow color
//    self.viewProjectEarning.layer.shadowOpacity = 0.5;                         // Shadow opacity (0.0 to 1.0)
//    self.viewProjectEarning.layer.shadowOffset = CGSizeMake(0, 5);             // Shadow offset
    
}


- (void)screenSetup{
    dropMarker        = [[GMSMarker alloc] init];
    pickupMarker      = [[GMSMarker alloc] init];
    _request          = [RideRequest new];
    _coordinates      = [NSMutableArray new];
    markers          = [NSMutableArray new];
    self.viewOrderListButton.hidden = YES;
    [self showGoogelMaps];
    [self setHomeLocationBtn];
    [self mainSetup];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchProfileDetail];
        
    });
    [self updateDriverLocationAndGetOrdersApi:true];
    [self startCoordinateUpdateTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self invalidateDriverCoordinateLocationTimer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC); // 2 second delay
//        dispatch_after(delay, dispatch_get_main_queue(), ^{
//        [self hideOrdersScreen];
//    });
}

//MARK: - WebSocketManager -

-(void) startToConnectWebSocket {
    self.isWebSocketConnected = false;
    self.webSocketManager = [WebSocketManager shared];
    self.webSocketManager.delegate = self;
    
    [self.webSocketManager connect];
}

//MARK: - WebSocketManagerDelegate -

- (void)webSocketDidConnect {
    self.isWebSocketConnected = true;
    NSLog(@"** wk WebSocket did connect");
}

- (void)webSocketDidDisconnect {
    NSLog(@"** wk WebSocket did disconnect");
    self.isWebSocketConnected = false;
}

- (void)webSocketDidReceiveMessageWithText:(NSString *)text data:(NSDictionary *)data {
    if (text) {
        NSLog(@"** wk WebSocket received text: %@", text);
    }
    if (data) {
        if (![self checkUserSessionActive:data]) {
            return;
        }
        
        NSLog(@"** wk WebSocket received data: %@", data);
        NSString *type = [data[@"type"] stringValue];
        
        if ([type isEqualToString:@"update_user_coordinates"]) {
            [self updateDriverCoordinatesResponse:data];
        } else if ([type isEqualToString:@"update_driver_location"]) {
            [self updateDriverLocationGetOrdersResponse:data];
        }
    }
}

-(BOOL) checkUserSessionActive:(NSDictionary *)data {
    BOOL value = true;
    
    id sessionIdValue = data[@"session_id"];
    
    NSString *sessionId;
    if (![sessionIdValue isKindOfClass:[NSNull class]] && sessionIdValue != nil) {
        sessionId = [sessionIdValue stringValue]; // Use stringValue if it exists
    } else {
        sessionId = @""; // Or handle the null case appropriately
    }
    
    //    NSLog(@"** wk remote id: %@", sessionId);
    NSString *idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (sessionId.length > 0 && ![sessionId isEqualToString:idString]) {
        value = false;
        [self clearUserCacheData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [DELG.updLoctionTimer invalidate];
//            DELG.updLoctionTimer = nil;
//            [SHAREMANAGER clearUserDefault];
//            
//            [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
//        });
    }
    return value;
}

- (void)webSocketDidReceiveErrorWithError:(NSError *)error {
    NSLog(@"WebSocket encountered an error: %@", error.localizedDescription);
    
    NSString *errorDescription = error.localizedDescription;
    // Check if the error is related to the socket not being connected
    if ([error.domain isEqualToString:NSPOSIXErrorDomain] && error.code == 57) {
        NSLog(@"Socket is not connected. Attempting to reconnect...");
        
        [self startToConnectWebSocket];
    } else if ([errorDescription containsString:@"Connection reset by peer"] || [errorDescription containsString:@"Socket is not connected"]) {
        [self startToConnectWebSocket];
    } else {
        //        [self startToConnectWebSocket];
        //        [CommonFunctions showQuestionsAlertWithTitel:@"Web Socket Error" message:error.localizedDescription inVC:self completion:^(BOOL success) {
        //        }];
    }
}

-(void) webSocketDidSendErrorWithError:(NSError *)error {
    NSLog(@"WebSocket encountered an error: %@", error.localizedDescription);
    if ([error.domain isEqualToString:NSPOSIXErrorDomain] && error.code == -1001) {
        NSLog(@"Socket is not connected. Attempting to reconnect...");
        
        [self startToConnectWebSocket];
    } else {
        [self startToConnectWebSocket];
        //        [CommonFunctions showQuestionsAlertWithTitel:@"Web Socket Error" message:error.localizedDescription inVC:self completion:^(BOOL success) {
        //        }];
    }
}

-(void) sendDataThroughtWebSocket: (NSDictionary *)data {
    //    NSLog(@"** wk webSocket params: %@", data);
    
    if (self.webSocketManager) {
        [self.webSocketManager sendMessage:data];
    } else {
        [self startToConnectWebSocket];
    }
}

-(void)mainSetup{
    
    self.markerTapped = NO;
    self.cameraMoving = NO;
    self.idleAfterMovement = NO;
    _counter    = 20;
    [self.mainTitelLabel setHidden:YES];
    [self.viewBookingBtn setEnabled:YES];
    [self removeCancelRideButtonFromNavigationBar];
    [self.bookingView setAlpha:0.0];
    [self.constraintBottomOptions setConstant:0.0];
    [self hideClientView];
    [self setHomeLocationBtn];
    [self.viewBookingBtn hideLoading];
    [self.bookingView popDown];
    
    
}

- (void)addCancelRideButtonToNavigationBar{
    
    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
    self.cancelRideBarButton.frame = CGRectMake(0, 0, 50, 30);
    [self.cancelRideBarButton addTarget:self action:@selector(cancelOrderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButton=[[UIBarButtonItem alloc] init];
    UIImage *cancelBarButtonimage = [UIImage imageNamed:@"ic_more"];
    [cancelBarButton setCustomView:self.cancelRideBarButton];
    [cancelBarButton setTintColor:[UIColor whiteColor]];
    //self.navigationItem.rightBarButtonItems = @[barButton , cancelBarButton];
    [self.cancelRideBarButton setEnabled:YES];
    [self.cancelRideBarButton setImage:cancelBarButtonimage forState:UIControlStateNormal];
    // [self.cancelRideBarButton setTitle:@"Cancel" forState:UIControlStateNormal];
}
- (void)removeCancelRideButtonFromNavigationBar{
    [self.cancelRideBarButton setEnabled:NO];
    [self.cancelRideBarButton setTitle:@""  forState:UIControlStateNormal];
    
}
- (IBAction)gotoBatchManangmentVCPressed:(UIBarButtonItem *)sender{
    [self performSegueWithIdentifier:@"ShowBatchManagementVC" sender:self];
}
//- (void)showStatusButton:(NSString *)status{
//
//
////    UILabel *badgeLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, -7, 20, 20)];
////    badgeLbl.backgroundColor = [UIColor appRedColor];
////    [badgeLbl setFont:[UIFont systemFontOfSize:12]];
////    badgeLbl.textColor = [UIColor whiteColor];
////    badgeLbl.textAlignment = NSTextAlignmentCenter;
////    badgeLbl.layer.cornerRadius = 10.0;
////    badgeLbl.layer.masksToBounds = true;
////    badgeLbl.text = @"10";
//
//    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
//    self.cancelRideBarButton.frame = CGRectMake(0, 0, 50, 30);
//    [self.cancelRideBarButton addTarget:self action:@selector(cancelOrderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *cancelBarButton=[[UIBarButtonItem alloc] init];
//    UIImage *cancelBarButtonimage = [UIImage imageNamed:@"ic_more"];
//    [cancelBarButton setCustomView:self.cancelRideBarButton];
//    [cancelBarButton setTintColor:[UIColor whiteColor]];
//    //self.navigationItem.rightBarButtonItems = @[barButton , cancelBarButton];
//    [self.cancelRideBarButton setEnabled:YES];
//    [self.cancelRideBarButton setImage:cancelBarButtonimage forState:UIControlStateNormal];
//
//   UIBarButtonItem *batchManagmentbarBtn = [[UIBarButtonItem alloc]initWithCustomView:self.cancelRideBarButton];
//    [batchManagmentbarBtn setTintColor:[UIColor whiteColor]];
//
//
//
////    self.batchManagmentButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
////    self.batchManagmentButton.frame = CGRectMake(10, 0, 50, 50);
////    [self.batchManagmentButton addTarget:self action:@selector(cancelOrderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
////    UIBarButtonItem *batchManagmentbarButton=[[UIBarButtonItem alloc] init];
////    UIImage *image = [UIImage imageNamed:@"ic_batch_management"];
////    [batchManagmentbarButton setCustomView:self.batchManagmentButton];
////
////    [batchManagmentbarButton setTintColor:[UIColor whiteColor]];
//
////    [self.batchManagmentButton setEnabled:YES];
////    [self.batchManagmentButton setImage:image forState:UIControlStateNormal];
//
//    self.cancelRideBarButton = [[RoundedButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
//    [self.cancelRideBarButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.cancelRideBarButton addTarget:self action:@selector(statusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.cancelRideBarButton.isSkipDeShape = YES;
//    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//    [barButton setCustomView:self.cancelRideBarButton];
//    barButton.customView.transform = CGAffineTransformMakeScale(0.75, 0.75);
//
////    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithCustomView:spaceView];
//
//    self.navigationItem.rightBarButtonItems = @[batchManagmentbarBtn,space, barButton];
//    [self.cancelRideBarButton setEnabled:YES];
//    [self.cancelRideBarButton hideLoadingWithTitel:status];
//
//}

//- (void)showStatusButton:(NSString *)status {
//    
//    // Create and configure the first button
//    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
//    self.cancelRideBarButton.frame = CGRectMake(0, 0, 20, 30);
//    [self.cancelRideBarButton addTarget:self action:@selector(cancelOrderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancelRideBarButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
//    [self.cancelRideBarButton setEnabled:YES];
//    
//    // Create UIBarButtonItem for the first button (moreBtn)
//    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithCustomView:self.cancelRideBarButton];
//    [moreBtn setTintColor:[UIColor whiteColor]];
//    
//    
//    RoundedButton *btnEarning = [RoundedButton buttonWithType:UIButtonTypeCustom];
//    btnEarning.frame = CGRectMake(0, 0, 30, 30);
//    [btnEarning addTarget:self action:@selector(onClickExpandEarningView:event:) forControlEvents:UIControlEventTouchUpInside];
////    [self.cancelRideBarButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
//    [btnEarning setEnabled:YES];
//    [btnEarning setTitle:@"⬇" forState:UIControlStateNormal];
//    
//    UIBarButtonItem *projectEarningBtn = [[UIBarButtonItem alloc] initWithCustomView:btnEarning];
//    [projectEarningBtn setTintColor:[UIColor whiteColor]];
//    
////    // Create UIBarButtonItem for the first button (moreBtn)
////    UIBarButtonItem *projectEarningBtn = [[UIBarButtonItem alloc] initWithCustomView:self.cancelRideBarButton];
////    [projectEarningBtn setTitle:@"⬇"];
////    [projectEarningBtn setTintColor:[UIColor whiteColor]];
//    
//    // Create and configure the label
//    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 25)];
//    statusLabel.text = (self.orders.count < 2 ? @"": [NSString stringWithFormat:@"%lu Orders", (unsigned long)self.orders.count]);
//    statusLabel.textColor = [UIColor yellowColor];
//    statusLabel.font = [UIFont systemFontOfSize:14];
//    
//    // Create and configure the second button
//    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
//    self.cancelRideBarButton.frame = CGRectMake(65, 0, 70, 25); // Adjusted frame to fit the label
//    [self.cancelRideBarButton addTarget:self action:@selector(statusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.cancelRideBarButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
//    [self.cancelRideBarButton setEnabled:YES];
//    
//    // Create a container view that holds both the label and the second button
//    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 135, 25)];
//    [containerView addSubview:btnEarning];
//    [containerView addSubview:statusLabel];
//    [containerView addSubview:self.cancelRideBarButton];
//    
//    // Create UIBarButtonItem for the container view
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:containerView];
//    
//    // Add both UIBarButtonItems to the right side of the navigation bar
//    if (self.orders.count == 0) {
//        self.navigationItem.rightBarButtonItems = @[barButton];
//    } else {
//        self.navigationItem.rightBarButtonItems = @[moreBtn, barButton];
//    }
//    
//    [self.cancelRideBarButton hideLoadingWithTitel:status];
//}

- (void)showStatusButton:(NSString *)status {
    // Create and configure the first button
    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
    self.cancelRideBarButton.frame = CGRectMake(0, 0, 20, 30);
    [self.cancelRideBarButton addTarget:self action:@selector(cancelOrderButtonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelRideBarButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.cancelRideBarButton setEnabled:YES];
    
    // Create UIBarButtonItem for the first button (moreBtn)
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithCustomView:self.cancelRideBarButton];
    [moreBtn setTintColor:[UIColor whiteColor]];
    
    // Create the earning button
    RoundedButton *btnEarning = [RoundedButton buttonWithType:UIButtonTypeCustom];
    btnEarning.frame = CGRectMake(0, 0, 30, 30);
    [btnEarning setImage:[UIImage imageNamed:@"imgProjectedEarning"] forState:UIControlStateNormal];
    [btnEarning addTarget:self action:@selector(onClickExpandEarningView:event:)
         forControlEvents:UIControlEventTouchUpInside];
    [btnEarning.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btnEarning setEnabled:YES];
    [btnEarning setClipsToBounds:YES];
    
    // Set explicit width and height constraints for btnEarning
    [btnEarning.widthAnchor constraintEqualToConstant:30].active = YES;
    [btnEarning.heightAnchor constraintEqualToConstant:30].active = YES;

    self.lblOrderCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.orders.count];
    // Create and configure the label
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = (self.orders.count < 2 ? @"" : [NSString stringWithFormat:@"%lu Orders", (unsigned long)self.orders.count]);
    statusLabel.textColor = [UIColor yellowColor];
    statusLabel.font = [UIFont systemFontOfSize:14];
    statusLabel.textAlignment = NSTextAlignmentCenter;

    // Create and configure the second button
    self.cancelRideBarButton = [RoundedButton buttonWithType:UIButtonTypeCustom];
    [self.cancelRideBarButton addTarget:self action:@selector(statusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelRideBarButton setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [self.cancelRideBarButton setEnabled:YES];
    
    [self.cancelRideBarButton.widthAnchor constraintEqualToConstant:70].active = YES;
    [self.cancelRideBarButton.heightAnchor constraintEqualToConstant:25].active = YES;

    // Create a horizontal stack view
    UIStackView *hStackView = [[UIStackView alloc] initWithArrangedSubviews:@[btnEarning, statusLabel, self.cancelRideBarButton]];
    hStackView.axis = UILayoutConstraintAxisHorizontal;
    hStackView.distribution = UIStackViewDistributionFillProportionally;
    hStackView.alignment = UIStackViewAlignmentCenter;
    hStackView.spacing = 8; // Adjust spacing between elements
    
    // Set intrinsic content size for the stack view
    hStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [hStackView.widthAnchor constraintGreaterThanOrEqualToConstant: self.orders.count < 2 ? 130 : 200].active = YES;
    [hStackView.heightAnchor constraintEqualToConstant:30].active = YES;
    
    // Create UIBarButtonItem for the stack view
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:hStackView];
    
    // Add both UIBarButtonItems to the right side of the navigation bar
    if (self.orders.count == 0) {
        self.navigationItem.rightBarButtonItems = @[barButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[moreBtn, barButton];
    }
    
    [self.cancelRideBarButton hideLoadingWithTitel:status];
}




- (void)hideStatusButton{
    [self.cancelRideBarButton setEnabled:NO];
    [self.cancelRideBarButton setImage:nil forState:UIControlStateNormal];
    
}
- (void)showGoogelMaps{
    NSLog(@"** wk map showGoogelMaps");
    GMSCameraPosition *camera   = [GMSCameraPosition cameraWithLatitude:self.vaildCoordinate.latitude longitude:self.vaildCoordinate.longitude zoom:18.0f];
    [self.mapView setMinZoom:5 maxZoom:20];
    [self.mapView setDelegate:self];
    [self.mapView animateToCameraPosition:camera];
}

-(void)showDocmentsView{
    [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW) animated:NO];
}
- (void)driverLocationWithAddress{
    if (self.driverMarker.map == nil) {
        self.driverMarker = [[GMSMarker alloc] init];
        self.driverMarker.title = @"Current Location";
        self.driverMarker.snippet = SHAREMANAGER.user.carNumber;
        if ([SHAREMANAGER.user.carId intValue] == 5) {
            self.driverMarker.icon = BIKE_MAP;
        }else{
            self.driverMarker.icon = CAR_MAP;
        }
        self.driverMarker.draggable = NO;
        self.driverMarker.position = self.vaildCoordinate;
        self.driverMarker.map       = self.mapView;
    }else{
        self.driverMarker.position = self.vaildCoordinate;
    }
}
-(void)updateMarker{
    if (!self.isLocationChanged) {
        return;
    }
    CLLocationCoordinate2D oldCooridenate ;
    NSString *oldCoordinateString = user_defaults_get_string(MARKER_POSTION);
    if (strNotEmpty(oldCoordinateString)) {
        oldCooridenate = [SHAREMANAGER getCoodrinateFromSrting: user_defaults_get_string(MARKER_POSTION)];
        if (![SHAREMANAGER isVaildCoordinate:oldCooridenate]) {
            oldCooridenate = DELG.currentCoordinate;
        }
    }else{
        oldCooridenate = self.vaildCoordinate;
    }
    if (self.isLocationChanged) {
        [self.moveMent ARCarMovementWithMarker:self.driverMarker oldCoordinate:oldCooridenate newCoordinate:self.vaildCoordinate mapView:self.mapView bearing:0];
        user_defaults_set_string(MARKER_POSTION,strFormat(@"%f,%f",self.vaildCoordinate.latitude,self.vaildCoordinate.longitude) );
    }
}
#pragma mark - ARCarMovementDelegate
- (void)ARCarMovementMoved:(GMSMarker * _Nonnull)Marker {
    if (self.driverMarker.map) {
        self.driverMarker = Marker;
        //        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:self.driverMarker.position zoom:self.mapView.camera.zoom];
        //        [self.mapView animateWithCameraUpdate:updatedCamera];
    }
    Marker.map = self.mapView;
    
    //    //animation to make car icon in center of the mapview
    //    //
    
}
- (BOOL)isLocationChanged{
    NSString *newCoordinateStr = strFormat(@"%f,%f",self.currLocation.coordinate.latitude,self.currLocation.coordinate.longitude);
    NSString *oldCoordinateStr  = user_defaults_get_string(MARKER_POSTION);
    return  strNotEquals(newCoordinateStr,oldCoordinateStr);
}
- (CLLocation *)currLocation{
    CLLocationCoordinate2D coordinats = self.locationTracker.currentLocation;
    return  [[CLLocation alloc] initWithLatitude:coordinats.latitude longitude:coordinats.longitude];;
}
- (void)somthlyMoveMarker:(GMSMarker *)marker to :(CLLocationCoordinate2D )coordinate
{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    marker.position = coordinate;
    [CATransaction commit];
    marker.position = coordinate;
    
    GMSVisibleRegion region = _mapView.projection.visibleRegion;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:region];
    if (![bounds containsCoordinate:marker.position]){
        NSLog(@"** wk map somthlyMoveMarker");
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:_mapView.camera.zoom bearing:self.mapView.camera.bearing viewingAngle:0];
        [self.mapView animateToCameraPosition:camera];
    }
}
- (CLLocationCoordinate2D)vaildCoordinate{
    CLLocationCoordinate2D coordinate = self.locationTracker.currentLocation;
    NSString *oldCoordinateStr  = user_defaults_get_string(MARKER_POSTION);
    if ([SHAREMANAGER isVaildCoordinate:coordinate]){
        [SHAREMANAGER setStoredCoordinate:coordinate];
        return coordinate;
    }else if (strNotEmpty(oldCoordinateStr)){
        CLLocationCoordinate2D oldCoordinate = [SHAREMANAGER getCoodrinateFromSrting:oldCoordinateStr];
        if ([SHAREMANAGER isVaildCoordinate:oldCoordinate]){
            return oldCoordinate;
        }
        return DELG.currentCoordinate;
        
    }else  if (strNotEmpty(SHAREMANAGER.storedCoordinateStr)){
        
        return SHAREMANAGER.storedCoordinate;
    }
    return DELG.currentCoordinate;
    
}
- (IBAction)cancelOrderButtonPressed:(UIBarButtonItem *)sender event:(UIEvent *)event{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.textColor = [UIColor appBlackColor];
    configuration.backgroundColor = [UIColor whiteColor];
    configuration.textAlignment = NSTextAlignmentCenter;
    [FTPopOverMenu showFromEvent:event withMenuArray:@[@"Cancel order", @"Contact support"] imageArray:@[] configuration:configuration doneBlock:^(NSInteger selectedIndex) {
        if (selectedIndex == 0) {
            [self cancelOrder];
        }else if (selectedIndex == 1) {
            self.selectedURL = [NSURL URLWithString:CONTACT_SUPPORT];
            [self performSegueWithIdentifier:WebView_Idintifire sender:self];
        }
    } dismissBlock:^{
        DLog(@"dismissed");
    }];
    
    
}

- (IBAction)onClickExpandEarningView:(UIBarButtonItem *)sender event:(UIEvent *)event{
    if (self.constraintDriverProjectedEarningViewHeight.constant == 0.0) {
        [self updateProjectedEarningViewHeight:self.mapView.frame.size.height / 2.0];
    } else {
        [self updateProjectedEarningViewHeight:0.0];
    }
}

- (void)cancelOrder{
    //    if (!self.request.order.isPickedUp && !self.request.order.isDelivered) {
    [self performSegueWithIdentifier:CancelOrder_Idintifire sender:self];
    //    }else{
    //        [CommonFunctions showAlertWithTitel:@"Can't Cancel" message:@"You can't cancel order at this stage. Please contact support" inVC:self];
    //    }
}
- (IBAction)statusButtonPressed:(RoundedButton *)sender{
    User *user = [User info];
    if (user.infoMessage) {
        NSString *strTitle = @"Required Information";
        NSString *strMessage = user.infoMessage;
        
        if ([user.infoMessage isEqualToString:@"showCreditCardAlert"]) {
            strTitle = @"Add debit/credit card";
            strMessage = @"Will be charged for cash you collect that is owed to XP Driver";
        }
        
        [CommonFunctions showRequiredAlertWithTitel:strTitle message:strMessage inVC:self completion:^(BOOL success) {
            if (success) {
                if ([user.infoMessage isEqualToString:@"showCreditCardAlert"]) {
                    UIAddPaymentMethodViewController *walletVC = [[UIAddPaymentMethodViewController alloc] init];
                    [self.navigationController pushViewController:walletVC animated:true];
                } else {
                    NSString *identifier = @"";
                    if (!user.isVehicelInfoUpdate) {
                        identifier = @"ShowVehicleVC";
                    } else if (!user.isDocUploaded || user.needToUpdateDocument.count > 0) {
                        identifier = @"ShowDocumentsVC";
                    } else if (user.picNeme.isEmpty) {
                        identifier = SHOWPROFILE;
                    }
//                    else if ([user.infoMessage isEqualToString:@"CreditCardRequired"]) {
//                        identifier = @"ShowCountrySelectionVC";
//                    }
                    if (!identifier.isEmpty) {
                        [self performSegueWithIdentifier:identifier sender:self];
                    }
                }
            }
        }];
        return;
    }
    // hide functionality of Telegram
//    else if ([user.telegramRegistered isEqualToString:@"0"] && [user.telegramRegistrationRequired isEqualToString:@"1"]) {
//        [self showTelegramPopup:user];
//        return;
//    }
    
    NSString *status = sender.isOnLine ? OFFLINE : ONLINE;
    [self.cancelRideBarButton showLoading];
    [self updateStatus:status];
}
- (IBAction)menuBtnPressed:(id)sender{
    [self toggleShowMenuView];
}
- (void)toggleShowMenuView{
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        if (self.menuView.isShown) {
            self.leading.constant = - (ViewWidth(self.view) + 20);
        }else{
            [self.menuView dataSetupWithDeleagte:self];
            
            self.leading.constant = 0;
        }
        self.menuView.isShown = !self.menuView.isShown;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
-(void)showView:(NSString *)identifier url:(nullable NSURL *)url{
    //    DLog(@"** wk identifier: %@", identifier);
    [self toggleShowMenuView];
    if (url) {
        self.selectedURL = url;
        [self performSegueWithIdentifier:WebView_Idintifire sender:self];
        return;
    }else if (url == nil && identifier.isEmpty){
        [self signout];
    } else if ([identifier isEqualToString:@"ShowBatchManagementVC"]) {
        [self performSegueWithIdentifier:@"ShowBatchManagementVC" sender:self];
    }else{
        [self performSegueWithIdentifier:identifier sender:self];
    }
    //[self pushwithIdentifier:identifier];
}
-(void)walletsClick {
    //    DLog("** wk click wallet success");
    [self toggleShowMenuView];
    [self pushToWalletListScreen];
}

-(void)clickDriverAvailability {
    //    DLog("** wk click wallet success");
    [self toggleShowMenuView];
    [self pushToDriverAvailability];
}

-(void)CustomLocationClick {
    //    DLog("** wk click wallet success");
    [self toggleShowMenuView];
    UIDebugLocationViewController *debugLocation = [[UIDebugLocationViewController alloc] init];
    [self.navigationController pushViewController:debugLocation animated:true];
}

-(void) pushToWalletListScreen {
    UIListWalletsViewController *walletVC = [[UIListWalletsViewController alloc] init];
    [walletVC setHandler:^(NSDictionary *data) {
        //        DLog("** wk data: %@", data);
        self.dicWallet = data;
        //        DLog("** wk data1: %@", self.dicWallet);
        [self performSegueWithIdentifier:@"ShowWithdrawVC" sender:self];
    }];
    [self.navigationController pushViewController:walletVC animated:true];
}
-(void) pushToDriverAvailability
{
    UIDriverAvailabilityViewController *driverVC = [[UIDriverAvailabilityViewController alloc] init];
    //    [walletVC setHandler:^(NSDictionary *data) {
    //        DLog("** wk data: %@", data);
    //        self.dicWallet = data;
    //        DLog("** wk data1: %@", self.dicWallet);
    //        [self performSegueWithIdentifier:@"ShowWithdrawVC" sender:self];
    //    }];
    [self.navigationController pushViewController:driverVC animated:true];
}
-(void)pushwithIdentifier:(NSString *)identifier{
    UIViewController *controller = instantiateVC(identifier);
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Profil Detail

-(void)fetchProfileDetail
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.userId,@"user_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        //        NSLog(@"wk Response withdraw JSON: %@", json);
        NSArray *results  =[json objectForKey:RESULT];
        if (![json objectForKey:@"error"] && json!=nil && results.count != 0) {
            
            NSDictionary *data = json[@"data"];
            NSString *balanceString = data[@"default_wallet_alance"];
            double balance = [balanceString doubleValue];
            NSLog(@"default_wallet_balance as double: %.2f", balance);
            if (balance <= 50.0) {
                //                [self showAlertForLowBalance];
            }
            
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            NSString *status = [results objectForKey:@"road_status"];
            [User save:results];
            User *user = [User info];
            if (user.infoMessage) {
                NSString *strTitle = @"Required Information";
                NSString *strMessage = user.infoMessage;
                if ([user.infoMessage isEqualToString:@"showCreditCardAlert"]) {
                    strTitle = @"Add debit/credit card";
                    strMessage = @"Will be charged for cash you collect that is owed to XP Driver";
                }
                
                [CommonFunctions showRequiredAlertWithTitel:strTitle message:strMessage inVC:self completion:^(BOOL success) {
                    if (success) {
                        if ([user.infoMessage isEqualToString:@"showCreditCardAlert"]) {
                            UIAddPaymentMethodViewController *walletVC = [[UIAddPaymentMethodViewController alloc] init];
                            [self.navigationController pushViewController:walletVC animated:true];
                        } else {
                            NSString *identifier = @"";
                            if (!user.isVehicelInfoUpdate) {
                                identifier = @"ShowVehicleVC";
                            }else if (!user.isDocUploaded || user.needToUpdateDocument.count > 0) {
                                identifier = @"ShowDocumentsVC";
                            }else if (user.picNeme.isEmpty) {
                                identifier = SHOWPROFILE;
                            } 
//                            else if ([user.infoMessage isEqualToString:@"CreditCardRequired"]) {
//                                identifier = @"ShowCountrySelectionVC";
//                            }
                            
                            if (!identifier.isEmpty) {
                                [self performSegueWithIdentifier:identifier sender:self];
                            }
                        }
                    }
                }];
            } else {
                // hide functionality of Telegram
//                if ([user.telegramRegistered isEqualToString:@"0"] && !self.isShowTelegramPopupFirstTime) {
//                    [self showTelegramPopup:user];
//                }
            }
            if (strEquals(status, ONLINE)) {
                [self showStatusButton:GO_ONLINE];
                [self driverLocationWithAddress];
                [self invalidateLocationTimer];
                [self startTimer];
                user_defaults_set_bool(ISONLINE, YES);
                user_defaults_set_bool(ISOFFLINE, NO);
                user_defaults_set_bool(ISONDUTY,  NO);
            }else if (strEquals(status, OFFLINE)){
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE,YES);
                user_defaults_set_bool(ISONDUTY, NO);
                [self showStatusButton:GO_OFFLINE];
            }
            else if (strEquals(status, ONDUTY)){
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE,NO);
                user_defaults_set_bool(ISONDUTY, YES);
                //                [self hideStatusButton];
                [self invalidateLocationTimer];
                [self startTimer];
            }
            
            
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                [self fetchProfileDetail];
            }else{
                
                
            }
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        if ([ErrorFunctions isError:error.localizedDescription]){
            [self fetchProfileDetail];
        }else{
            
        }
        DLog(@"Error: %@", error.localizedDescription);
    }];
}

-(void) showAlertForLowBalance {
    if (self.showLowBalance == false) {
        self.showLowBalance = true;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:@"This is your alert message."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        // Create an OK action
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            // Handle OK button tap action here
            NSLog(@"OK button tapped");
            [self pushToWalletListScreen];
        }];
        
        // Add the OK action to the alert controller
        [alertController addAction:okAction];
        
        // Present the alert controller
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark FareView

-(void)showFareAndRatingView{
    if ([self.navigationController.visibleViewController isKindOfClass:[FareAndRatingView class]]) {
        return;
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[FareAndRatingView class]]) {
            // FareAndRatingView is already in the navigation stack, no need to perform the segue
            return;
        }
    }
    
    [self hideClientView];
    [self mainSetup];
    [self driverLocationWithAddress];
    [self performSegueWithIdentifier:FARE_Idintifire sender:self];
    
    
}

-(void)invalidateLocationTimer{
    UA_invalidateTimer(DELG.updLoctionTimer);
    [DELG.updLoctionTimer invalidate];
    //    [DELG.coordinatepdLoctionTimer invalidate];
    DELG.updLoctionTimer = nil;
    //    DELG.coordinatepdLoctionTimer = nil;
    
}

-(void)invalidateDriverCoordinateLocationTimer{
    UA_invalidateTimer(DELG.coordinatepdLoctionTimer);
    [DELG.coordinatepdLoctionTimer invalidate];
    DELG.coordinatepdLoctionTimer = nil;
    
}
#pragma mark -
#pragma mark - update driver location

-(void)startTimer{
    if (DELG.updLoctionTimer.isValid) {
        return;
    }
    self.backgroundTaskModel = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.backgroundTaskModel beginNewBackgroundTask];
    [self driverCurrentLocation];
    // wk waseem changes
    DELG.updLoctionTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                            target:self
                                                          selector:@selector(driverCurrentLocation)
                                                          userInfo:nil
                                                           repeats:YES];
    
}

-(void)startCoordinateUpdateTimer{
    if (DELG.coordinatepdLoctionTimer.isValid) {
        return;
    }
    
    [self driverCurrentLocation];
    
    DELG.coordinatepdLoctionTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                                     target:self
                                                                   selector:@selector(driverCoordinatesUpdate)
                                                                   userInfo:nil
                                                                    repeats:YES];
    [self driverCoordinatesUpdate];
}
-(void)startMarkerTimer{
    
    BOOL isOffline =  user_defaults_get_bool(ISOFFLINE);
    if (self.locationTracker.isInbackground || isOffline) {
        UA_invalidateTimer(self.markerTimer);
        return;
    }
    if (self.markerTimer.isValid){return;}
    self.markerTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(updateMarker)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.markerTimer forMode:NSRunLoopCommonModes];
    
    DLog(@"startMarkerTimer  Called");
    
}
-(void)driverCurrentLocation
{
    DLog(@"wk call driverCurrentLocation");
    [self startMarkerTimer];
    if (!self.isLocationChanged) {
        if (self.driverAddress && self.driverCoordinate) {
            [self updateDriverLocationAndGetOrdersApi:true];
            return;
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:self.vaildCoordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
            if (error == nil) {
                GMSAddress *addressObj   = [[response results] firstObject];
                DLog(@"Line 1%@",addressObj.lines[0]);
                // DLog(@"Line 2%@",addressObj.lines[1]);
                //  NSString *locatedaddress = strFormat(@"%@,%@,%@",addressObj.thoroughfare,addressObj.subLocality,addressObj.locality);
                
                if ([SHAREMANAGER.user.testUser isEqualToString:@"1"] && CustomLocation.isActive) {
                    NSString *testcoordinateStr = [NSString stringWithFormat:@"%@,%@", CustomLocation.lati, CustomLocation.longi];
                    
                    double latitude = [CustomLocation.lati doubleValue];
                    double longitude = [CustomLocation.longi doubleValue];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    NSString *locatedaddress = [addressObj.lines firstObject];
                    
                    self.driverAddress    = locatedaddress;
                    self.driverCoordinate = testcoordinateStr;
                    self.driverLocation   = coordinate;
                    
                    user_defaults_set_string(D_ADDRESS,locatedaddress);
                    user_defaults_set_string(D_COORDINATE,testcoordinateStr);
                    [self updateDriverLocationAndGetOrdersApi:true];
                } else {
                    NSString *locatedaddress = [addressObj.lines firstObject];
                    NSString *coordinateStr = strFormat(@"%f,%f",addressObj.coordinate.latitude,addressObj.coordinate.longitude);
                    self.driverAddress    = locatedaddress;
                    self.driverCoordinate = coordinateStr;
                    self.driverLocation   = addressObj.coordinate;
                    //                    DLog(@"** wk driverLocation: %f, %f", self.driverLocation.latitude, self.driverLocation.longitude);
                    user_defaults_set_string(D_ADDRESS,locatedaddress);
                    user_defaults_set_string(D_COORDINATE,coordinateStr);
                    [self updateDriverLocationAndGetOrdersApi:true];
                }
                
            }else{
                //DLog(@"No Address Found");
            }
        }];
    });
}

-(void)driverCoordinatesUpdate
{
    DLog(@"wk call driverCurrentLocationCoordinateswk");
    
    if (!self.isLocationChanged) {
        if (self.driverAddress && self.driverCoordinate) {
            [self driverCoordinateUpdateApi];
            return;
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:self.vaildCoordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
            if (error == nil) {
                GMSAddress *addressObj   = [[response results] firstObject];
                DLog(@"Line 1%@",addressObj.lines[0]);
                // DLog(@"Line 2%@",addressObj.lines[1]);
                //  NSString *locatedaddress = strFormat(@"%@,%@,%@",addressObj.thoroughfare,addressObj.subLocality,addressObj.locality);
                
                if ([SHAREMANAGER.user.testUser isEqualToString:@"1"] && CustomLocation.isActive) {
                    NSString *testcoordinateStr = [NSString stringWithFormat:@"%@,%@", CustomLocation.lati, CustomLocation.longi];
                    
                    double latitude = [CustomLocation.lati doubleValue];
                    double longitude = [CustomLocation.longi doubleValue];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    NSString *locatedaddress = [addressObj.lines firstObject];
                    
                    self.driverAddress    = locatedaddress;
                    self.driverCoordinate = testcoordinateStr;
                    self.driverLocation   = coordinate;
                    
                    user_defaults_set_string(D_ADDRESS,locatedaddress);
                    user_defaults_set_string(D_COORDINATE,testcoordinateStr);
                    [self driverCoordinateUpdateApi];
                } else {
                    NSString *locatedaddress = [addressObj.lines firstObject];
                    
                    NSString *coordinateStr = strFormat(@"%f,%f",addressObj.coordinate.latitude,addressObj.coordinate.longitude);
                    self.driverAddress    = locatedaddress;
                    self.driverCoordinate = coordinateStr;
                    self.driverLocation   = addressObj.coordinate;
                    //                    DLog(@"** wk driverLocation: %f, %f", self.driverLocation.latitude, self.driverLocation.longitude);
                    user_defaults_set_string(D_ADDRESS,locatedaddress);
                    user_defaults_set_string(D_COORDINATE,coordinateStr);
                    [self driverCoordinateUpdateApi];
                }
            }else{
                //DLog(@"No Address Found");
            }
        }];
    });
}

- (void)updateDriverLocationAndGetOrdersApi: (BOOL) shouldCheckOffline {
    NSString *isOffline = user_defaults_get_string(ISOFFLINE);
    if ([isOffline isEqualToString:@"1"] && shouldCheckOffline == true) {
        return;
    }
    NSString  *dAddress = user_defaults_get_string(D_ADDRESS);
    NSString  *dcoordi  = user_defaults_get_string(D_COORDINATE);
    NSString *saveLocation  = @"0";
    if (self.request.order.status == KOrderStatusPickedup) {
        saveLocation = @"1";
    }
    if (strEmpty(self.driverAddress) && strEmpty(self.driverCoordinate)) {
        if (strEmpty(dAddress) && strEmpty(dcoordi)) {
            return;
        }else {
            self.driverAddress    = dAddress;
            self.driverCoordinate = dcoordi;
        }
    }
    NSArray *latlong= [self.driverCoordinate componentsSeparatedByString:@","];
    
    BOOL testUser = [SHAREMANAGER.user.testUser isEqualToString:@"1"] && CustomLocation.isActive;
    
    NSString *commandKey = (self.isWebSocketConnected ? @"type" : @"command");
    NSDictionary *params = @{
        commandKey  : @"update_driver_location",
        @"user_id"  :   SHAREMANAGER.userId,
        @"lat"      :  (testUser ? CustomLocation.lati : latlong[0]),
        @"long"     :  (testUser ? CustomLocation.longi : latlong[1]),
        @"address"  :   self.driverAddress,
        @"update_location"   :   saveLocation
    };
    
    DLog(@"wk PARAMS %@",params);
    
    if (self.isWebSocketConnected == true) {
        [self sendDataThroughtWebSocket:params];
    } else {
        [self updateDriverLocationAndGetOrdersByAlamofire:params];
    }
    
}

-(void) updateDriverLocationAndGetOrdersByAlamofire: (NSDictionary *)params {
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        [self updateDriverLocationGetOrdersResponse: json];
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self handleUpdateLocationError:error.localizedDescription];
    }];
}

-(void) updateDriverLocationGetOrdersResponse: (NSDictionary *)json {
    if (![self checkUserSessionActive:json]) {
        return;
    }
    
    if ([json[@"success"] intValue] == 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *resultArray = json[RESULT];
            if (resultArray.count != 0) {
                
                [SHAREMANAGER setIsRide:YES];
                NSDictionary *res = @{@"orders":resultArray};
                user_defaults_set_object(UD_REQUEST,[res dictionaryByReplacingNullsWithBlanks]);
                self.request = [[RideRequest alloc] initWithAttribute:res];
                
                self.orders = self.request.orders;
                NSLog(@"** wk map drawPinsOnMap from updateDriverLocationGetOrdersResponse");
                [self drawPinsOnMap];
                [self postNotificationToOrdersViewController:self.orders];
                self.viewOrderListButton.hidden = self.orders.count <= 1;
                
                NSString *isOnline = user_defaults_get_string(ISONLINE);
                NSString *isOffline = user_defaults_get_string(ISOFFLINE);
                
                [self showStatusButton:isOnline ? GO_ONLINE : GO_OFFLINE];
                if (self.orders.count <= 1) {
                    [self hideOrdersScreen];
                }
                else if (self.orders.count > 1){
                    if (self.shouldShowOrders == true) {
                        self.shouldShowOrders = false;
                        [self showOrdersScreen];
                    }
                    
//                    [self.constraintBottomOptions setConstant:0.0];
//                    [self.bookingView popDown];
                }
                int acceptedOrderCount = [self checkAcceptedOrderCount];
                if (acceptedOrderCount == 0 && self.clientViewTop.constant == 0) {
                    [self hideClientView];
                }
                
                [self checkDriverIsOnMapScreen];
                [self setRequestData];
                [self.locationTracker removeAllSavedLocation];
                
            } else {
                NSString *isOnline = user_defaults_get_string(ISONLINE);
                NSString *isOffline = user_defaults_get_string(ISOFFLINE);
                
                [self hideClientView];
                
                [self showStatusButton:isOnline ? GO_ONLINE : GO_OFFLINE];
                self.orders = [[NSMutableArray alloc] init];
                [self postNotificationToOrdersViewController:self.orders];
                
                if (user_defaults_get_object(UD_REQUEST)){
                    [self stopCountdownTimerAndPlayer];
                    [SHAREMANAGER removeObjectFromUD:UD_REQUEST];
                    [self mainSetup];
                    [self removeCancelRideButtonFromNavigationBar];
                    [self clearMapView];
                    [self fetchProfileDetail];
                }
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleUpdateLocationError:json[@"error"]];
        });
    }
}

- (void)acceptOrderByQrCode:(NSString *) orderId{
    [self showHud];
    NSString  *dcoordi  = user_defaults_get_string(D_COORDINATE);
    
    if (strEmpty(self.driverCoordinate)) {
        if (strEmpty(dcoordi)) {
            [self hideHud];
            return;
        }else {
            self.driverCoordinate = dcoordi;
        }
    }
    
    BOOL testUser = [SHAREMANAGER.user.testUser isEqualToString:@"1"] && CustomLocation.isActive;
    
    NSArray *latlong= [self.driverCoordinate componentsSeparatedByString:@","];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                 @"acceptOrderByQrCode",@"command",
                                 SHAREMANAGER.userId,@"driver_id",
                                 (testUser ? CustomLocation.lati : latlong[0]),@"lat",
                                 (testUser ? CustomLocation.longi : latlong[1]),@"long",
                                 orderId,@"order_id", nil
    ];
    
    //    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"acceptOrderByQrCode",@"command",SHAREMANAGER.userId,@"driver_id",self.strLatDummy,@"lat",self.strLongDummy,@"long",orderId,@"order_id", nil];
    
    DLog(@"wk PARAMS %@",params);
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        DLog(@"Message %@",json);
        [self hideHud];
        if ([json[@"success"] intValue] == 1){
            NSString *message = [NSString stringWithFormat:@"#%@ order added", orderId];
            [BannerUtil.shared showBannerAlerrtWithType:BannerStyleSuccess message:message onTap:nil];
            [self updateDriverLocationAndGetOrdersApi:true];
        }else{
            NSString *message = [NSString stringWithFormat:@"%@ %@", orderId, [json objectForKey:@"msg"]];
            [BannerUtil.shared showBannerAlerrtWithType:BannerStyleWarning message:message onTap:nil];
            
//            NSString *msg = [NSString stringWithFormat:@"[%@] %@", orderId, [json objectForKey:@"msg"]];
//            [CommonFunctions showAlertWithTitel:@"Order Error" message:msg inVC:SHAREMANAGER.rootViewController];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self hideHud];
        DLog(@"Error: %@", error.localizedDescription);
        [CommonFunctions showAlertWithTitel:@"" message:error.localizedDescription inVC:SHAREMANAGER.rootViewController];
    }];
}

-(void) handleScanQrCodeError: (NSString *) errorDescription {
    [SHAREMANAGER setIsRide:NO];
    NSString *errorMsg = errorDescription;
    if ([errorMsg isEqualToString:@"You are disabled"]){
        [self clearUserCacheData];
//        [self invalidateLocationTimer];
//        UA_invalidateTimer(self.markerTimer);
//        [SHAREMANAGER clearUserDefault];
//        [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
    }
    else if ([errorMsg isEqualToString:@"you are offline"] || [errorMsg isEqualToString:@"user not exist"]){
        user_defaults_set_bool(ISONLINE, NO);
        user_defaults_set_bool(ISOFFLINE, YES);
        [self invalidateLocationTimer];
        UA_invalidateTimer(self.markerTimer);
        self.markerTimer = nil;
        [self.locationTracker stopLocationTracking];
        
        [self showStatusButton:GO_OFFLINE];
    }
    else if (strEquals(errorMsg, NO_REQUEST)){
        if (user_defaults_get_object(UD_REQUEST)){
            [self stopCountdownTimerAndPlayer];
            [SHAREMANAGER removeObjectFromUD:UD_REQUEST];
            [self mainSetup];
            [self removeCancelRideButtonFromNavigationBar];
            [self clearMapView];
            [self showStatusButton:GO_ONLINE];
        }
    }
    DLog(@"errorMsg :%@",errorMsg);
}

- (int)checkAcceptedOrderCount {
    if (!self.orders || self.orders.count == 0) {
        NSLog(@"No orders available.");
        return 0;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == 2 || status == 3 || status == 4 || status == 5"];
    
    // Filter the orders array using the predicate
    NSArray *filteredOrders = [self.orders filteredArrayUsingPredicate:predicate];
    
    return (int)filteredOrders.count;
}

-(void) handleUpdateLocationError: (NSString *) errorDescription {
    [SHAREMANAGER setIsRide:NO];
    NSString *errorMsg = errorDescription;
    if ([errorMsg isEqualToString:@"You are disabled"]){
        [self clearUserCacheData];
//        [self invalidateLocationTimer];
//        UA_invalidateTimer(self.markerTimer);
//        [SHAREMANAGER clearUserDefault];
//        [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
    }
    else if ([errorMsg isEqualToString:@"you are offline"] || [errorMsg isEqualToString:@"user not exist"]){
        user_defaults_set_bool(ISONLINE, NO);
        user_defaults_set_bool(ISOFFLINE, YES);
        [self invalidateLocationTimer];
        UA_invalidateTimer(self.markerTimer);
        self.markerTimer = nil;
        [self.locationTracker stopLocationTracking];
        
        [self showStatusButton:GO_OFFLINE];
    }
    else if (strEquals(errorMsg, NO_REQUEST)){
        if (user_defaults_get_object(UD_REQUEST)){
            [self stopCountdownTimerAndPlayer];
            [SHAREMANAGER removeObjectFromUD:UD_REQUEST];
            [self mainSetup];
            [self removeCancelRideButtonFromNavigationBar];
            [self clearMapView];
            [self showStatusButton:GO_ONLINE];
        }
    }
    DLog(@"errorMsg :%@",errorMsg);
}

- (void) driverCoordinateUpdateApi{
    NSString  *dAddress = user_defaults_get_string(D_ADDRESS);
    NSString  *dcoordi  = user_defaults_get_string(D_COORDINATE);
    
    if (strEmpty(self.driverAddress) && strEmpty(self.driverCoordinate)) {
        if (strEmpty(dAddress) && strEmpty(dcoordi)) {
            return;
        }else {
            self.driverAddress    = dAddress;
            self.driverCoordinate = dcoordi;
        }
    }
    
    BOOL testUser = [SHAREMANAGER.user.testUser isEqualToString:@"1"] && CustomLocation.isActive;
    
    NSArray *latlong= [self.driverCoordinate componentsSeparatedByString:@","];
    
    NSString *commandKey = (self.isWebSocketConnected == true ? @"type" : @"command");
    NSDictionary *params = @{
        commandKey  : @"update_user_coordinates",
        @"user_id"  : SHAREMANAGER.userId,
        @"lat"      :  (testUser ? CustomLocation.lati : latlong[0]),
        @"long"     :  (testUser ? CustomLocation.longi : latlong[1]),
        @"address"  : self.driverAddress
        
    };
    
    if (self.isWebSocketConnected == true) {
        [self sendDataThroughtWebSocket:params];
    } else {
        [self updateCoordinatesByAlamofire:params];
    }
}

-(void) updateCoordinatesByAlamofire: (NSDictionary *) params {
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        [self updateDriverCoordinatesResponse:json];
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        DLog(@"Error: %@", error.localizedDescription);
    }];
}

-(void) updateDriverCoordinatesResponse: (NSDictionary *)json {
    
    if (![self checkUserSessionActive:json]) {
        return;
    }
    
    if ([json[@"success"] intValue] == 1){
        
        NSNumber *dataValue = json[@"data"];
        if ([dataValue isKindOfClass:[NSNumber class]]) {
            NSString *isOnline = user_defaults_get_string(ISONLINE);
            if (![isOnline isEqualToString:@"0"]) {
                if (self.orders.count != [dataValue unsignedIntegerValue]) {
                    NSLog(@"Value: done");
                    [self updateDriverLocationAndGetOrdersApi:true];
                }
                //                else {
                //                    NSLog(@"Value: fail");
                //                }
            }
        } else {
            NSLog(@"No data found or data is not in the expected format.");
        }
    }
}

- (void)checkIsAppNeedToUpdate {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    DLog(@"** wk version: %@", version);
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"checkAppVersion",@"command",version,@"app_version",@"XPDriver",@"app_identifier", @"iOS", @"platform", nil];
    
    
    DLog(@"wk PARAMS %@",params);
    
//    [self fetchAppStoreVersionWithCompletion:^(NSString * _Nullable appStoreVersion) {
//        if (appStoreVersion) {
//            NSLog(@"App Store Version: %@", appStoreVersion);
//            
//            NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//            if (![localVersion isEqualToString:appStoreVersion]) {
//                NSLog(@"A new version is available: %@", appStoreVersion);
//            } else {
//                NSLog(@"Your app is up to date.");
//            }
//        } else {
//            NSLog(@"Failed to fetch App Store version.");
//        }
//    }];
    
    
    [AlamofireWrapper checkAppVersionApiWithCompletion:^(NSString *isNewVersion){
        if (isNewVersion) {
            if ([isNewVersion isEqualToString:@"true"]) {
                [self openAppUpdatePopup];
            }
        }
    }];
    
//    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
//                                         urlString:@"https://www.xpeats.com/api/index.php"
//                                        parameters:params
//                                          encoding:RequestParameterEncodingJson
//                                           headers:nil
//                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
//        // Handle success
//        if ([json[@"success"] intValue] == 1){
//            //            DLog(@"** wk json: %@", json);
//            NSNumber *value = json[@"data"];
//            //            DLog(@"** wk value: %@", value);
//            if ([value isEqualToNumber:@1]) {
//                [self openAppUpdatePopup];
//            }
//        }
//    }
//                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        // Handle failure
//        DLog(@"Error: %@", error.localizedDescription);
//    }];
}

- (void)postNotificationToOrdersViewController:(NSMutableArray *)orders{
    NSDictionary* userInfo = @{@"orders": orders,@"driverAddress": self.driverAddress,@"driverCoordinate":self.driverCoordinate};
    NSNotificationCenter* notificationCeneter = [NSNotificationCenter defaultCenter];
    [notificationCeneter postNotificationName:KORDERS_NOTIFICATION_KEY object:self userInfo:userInfo];
}
- (void)makeHomeViewcontrollerVisible{
    if (![self.navigationController.visibleViewController isKindOfClass:[self class]] && ![self.navigationController.visibleViewController isKindOfClass:[FareAndRatingView class]]) {
        [self.navigationController setViewControllers:@[instantiateVC(CURRENTLOCATION)] animated:NO];
    }
}
#pragma mark -
-(void)setRequestData{
    [self rideRequestSetup];
}
- (void)checkDriverIsOnMapScreen{
    if (self.request.isNewOrder) {
        [self showNewOrderVC];
        return;
    }
    if (!self.isVisible) {
        if (self.request.order.status != KOrderStatusAssigned) {
            return;
        }
        [self showNewOrderVC];
        
    }
}
- (void)showNewOrderVC{
    if ([SHAREMANAGER.rootViewController isKindOfClass:[JobRequestView class]]) {
        return;
    }
    jobVC = Job_instantiateVC(@"JobRequestVC");
    jobVC.order = self.request.isNewOrder ? self.request.requestedOrder : self.request.order;
    jobVC.delegate = self;
    //  SHAREMANAGER.rootViewController.definesPresentationContext = YES; //self is presenting view controller
    jobVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    jobVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:jobVC animated:YES completion:nil];
}
- (void)dismissJobRequestVC{
    if ([SHAREMANAGER.rootViewController isKindOfClass:[JobRequestView class]]) {
        [jobVC dismiss];
    }
}
-(void)rideRequestSetup{
    [self clientSetup];
    if (self.request.deliverdOrder != nil) {
        self.selectedOrder = self.request.deliverdOrder;
        [self showFareAndRatingView];
    }
    if (self.bookingView.alpha == 0 ) {
        if (self.request.order.status != KOrderStatusDelivered) {
            [self.constraintBottomOptions setConstant:60.0];
            [self.bookingView popUp];
        }
        if (self.clientViewTop.constant != 0) {
            [self showClientView];
        }
    }
    [self.countdownLable setText:@""];
    //    [self.mainTitelLabel setHidden:false];
    [self drawRoute];
    if (self.request.order.status == KOrderStatusAssigned){
        [self setBtnTittel:Accept_Order];
        [self.mainTitelLabel setTextWithAnimation:@"Order Request"];
        [self invalidateLocationTimer];
        if (self.countdownTimer.isValid) {
            return;
        }
        [self setDirectionBtn];
        [self startCountdown];
    } else if (self.request.order.status == KOrderStatusAccepted){
        
        [self setBtnTittel:ARRIVED_At_Pickup];
        [self.mainTitelLabel setTextWithAnimation:@"Connected"];
        [self.infoLabel setText:@"Reached at pickup,Tap"];
        [self setDirectionBtn];
        [self showCancelBtn];
    }
    else if (self.request.order.status == KOrderStatusReached){
        [self hideDirectionBtn];
        [self showCancelBtn];
        [self setBtnTittel:Order_Picked_UP];
        [self.infoLabel setText:@"Ride just entred Vehicle,Tap"];
        [self.mainTitelLabel setTextWithAnimation:@"Reached"];
    }else if (self.request.order.status == KOrderStatusPickedup){
        [self setDirectionBtn];
        [self showCancelBtn];
        [self setBtnTittel:Order_Delivered];
        [self.infoLabel setText:@"Once Destination is Reached,Tap"];
        [self.mainTitelLabel setTextWithAnimation:@"Job Started"];
    }else if (self.request.order.status == KOrderStatusDelivered){
        [self hideDirectionBtn];
        [self showCancelBtn];
        [self removeCancelRideButtonFromNavigationBar];
        [self setBtnTittel:Order_Delivered];
        [self.viewBookingBtn setEnabled:NO];
        //[self.mainTitelLabel setTextWithAnimation:@"Job Ended"];
        [self.infoLabel setText:@"Calculating fare"];
        [markers removeAllObjects];
        [self hideClientView];
        [self invalidateLocationTimer];
        
        
    }
    
    
}
-(void)clearPolyLine{
    if (pickupMarker.map) {
        pickupMarker.map = nil;
        
    }
    if (_polyline.map) {
        _polyline.map = nil;
    }
    
}
-(void)clientSetup{
    self.clientView.delegate = self;
    [self.clientView setup:self.request.order totalEarning:[self calculateDriverEarning]];
}

-(NSString *) calculateDriverEarning {
    float total = 0.0;
    for (int i = 0; i < self.orders.count; i++) {
        Order *data = self.orders[i];
        //        NSLog(@"** wk driver single earning: %@, float: %.2f", data.driverFeeWithoutCurrent, [data.driverFeeWithoutCurrent floatValue]);
        if (data.driverFeeWithoutCurrent) {
            total += [data.driverFeeWithoutCurrent floatValue];
        }
    }
    NSString *strTotalEarnings = [NSString stringWithFormat:@"Total Earnings: %@%.2f", self.request.order.currrencySymbol, total];
    [self.lblTotalEarnings setText:[NSString stringWithFormat:@"%@%.2f", self.request.order.currrencySymbol, total]];
    return strTotalEarnings;
}
- (void)hideClientView{
    [self.mainTitelLabel setTextWithAnimation:@""];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3
                     animations:^{
        self.clientViewTop.constant = -(self.navigationBarHeight  + ViewHeight(self.clientView));
        [self.view layoutIfNeeded]; // Called on parent view
    }];
    
}
- (void)showClientView{
    [self.mainTitelLabel setTextWithAnimation:@""];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3
                     animations:^{
        self.clientViewTop.constant = 0;
        [self.view layoutIfNeeded]; // Called on parent view
    }];
    
}
#pragma mark - draw Route
#pragma mark -
- (BOOL)isNeedtoDrawRoute{
    if (self.isPickupChenged || self.isDropChanged) {
        return YES;
    }
    if (self.isLocationChanged || _polyline.map == nil) {
        return YES;
    }else{
        return NO;
    }
    
}
- (void)drawRoute{
    CLLocationCoordinate2D coordinate1  = [SHAREMANAGER getCoodrinateFromSrting:self.driverCoordinate];
    CLLocationCoordinate2D coordinate2  = CLLocationCoordinate2DMake(0.0,0.0);
    if (self.driverMarker.map == nil) {
        [self driverLocationWithAddress];
    }else{
        self.driverMarker.position  = coordinate1;
        //  self.driverMarker.snippet   = _request.driverAddress;
        self.driverMarker.map       = self.mapView;
    }
    if (self.request.order.status == KOrderStatusAssigned  || self.request.order.status == KOrderStatusAccepted ) {
        coordinate2 = self.request.order.restaurant.location.coordinate;
    }else if (self.request.order.status == KOrderStatusPickedup){
        coordinate2 =_request.order.dropLocation.coordinate;
    }
    
    if (self.request.order.status == KOrderStatusReached){
        return;
    }
    
    if (self.request.order.status == KOrderStatusAssigned  || self.request.order.status == KOrderStatusAccepted || self.request.order.status == KOrderStatusPickedup) {
        if (pickupMarker.map == nil) {
            pickupMarker = [GMSMarker new];
        }
        if (self.request.order.status == KOrderStatusAssigned  || self.request.order.status == KOrderStatusAccepted) {
            pickupMarker.snippet   = _request.order.restaurant.location.address;
            pickupMarker.title     = @"Pickup Location";
            pickupMarker.icon      = PICKUP_MARKER_IMAGE;
        }else if (self.request.order.status == KOrderStatusPickedup){
            pickupMarker.title    = @"Drop Location";
            pickupMarker.icon     = DESTINATION_MARKER_IMAGE;
            pickupMarker.snippet = _request.order.dropLocation.address;
            
        }
        pickupMarker.position         = coordinate2;
        pickupMarker.appearAnimation  = kGMSMarkerAnimationNone;
        pickupMarker.infoWindowAnchor = CGPointMake(0.0f, 0.0f);
        pickupMarker.map              = self.mapView;
        pickupMarker.draggable = NO;
        // self.mapView.selectedMarker = pickupMarker;
        
        
    }
    //    if (!isDropSelected || isReached) {
    //        return;
    //    }
    
    [_coordinates removeAllObjects];
    [_coordinates addObject:strFormat(@"%f,%f", coordinate1.latitude, coordinate1.longitude)];
    [_coordinates addObject:strFormat(@"%f,%f", coordinate2.latitude, coordinate2.longitude)];
    [markers addObject:self.driverMarker];
    [markers addObject:pickupMarker];
    //  [self focusMapToShowAllMarkers];
}

-(void)drawRouteOnMap{
    NSArray *parameters = [NSArray arrayWithObjects:SENSOR, _coordinates,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    MDDirectionService *mds=[[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
    
}
- (void)addDirections:(NSDictionary *)json {
    
    NSArray *route = [json objectForKey:@"routes"];
    if (json != nil &&  route.count != 0) {
        if (_polyline.map) {
            _polyline.map  = nil;
            _polyline      = nil;
        }
        NSArray * legs = json[@"routes"][0][@"legs"];
        NSString *distance = legs[0][@"distance"][@"text"];
        NSString *duration = legs[0][@"duration"][@"text"];
        NSInteger distanceValue = [legs[0][@"distance"][@"value"] integerValue];
        DLog(@"Distance %@ Duration %@ distanceValue %@",distance,duration,@(distanceValue));
        [self.infoLabel setTextWithAnimation:strFormat(@"%@   %@",distance,duration)];
        NSDictionary *routes  = [json objectForKey:@"routes"][0];
        self.stepsController  = [[StepController alloc] initWithAttrebute:legs[0]];
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        self.path = [GMSMutablePath pathFromEncodedPath:overview_route];
        [self drawPolyLineOnPath:self.path];
        
    }
}
- (void)focusMapToShowAllMarkers{
    if (markers.count == 0) {return;}
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in markers){
        bounds = [bounds includingCoordinate:marker.position];
    }
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsZero]];
}
- (void)drawPolyLineOnPath:(GMSMutablePath *)path{
    _polyline = [GMSPolyline new];
    _polyline.path         = path;
    _polyline.strokeWidth  = 4;
    _polyline.strokeColor  = [UIColor appGrayColor];
    _polyline.geodesic     = YES;
    _polyline.map          = _mapView;
    [self focusMapToShowAllMarkers];
    _coordinates      = [NSMutableArray new];
    markers           = [NSMutableArray new];
    // self.polylineTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:true block:^(NSTimer * _Nonnull timer) {    [self animate:path]; }];
}
- (void)removeTraviledPath{
    DLog(@"before self.path.count %@",@(self.path.count));
    for (int i = 0; i <= self.path.count; i++) {
        CLLocationCoordinate2D pathCoordinate = [self.path coordinateAtIndex:i];
        CLLocationCoordinate2D driverCoordinate = [SHAREMANAGER getCoodrinateFromSrting:self.driverCoordinate];
        NSMutableArray *pathRoundedCoordinateArray = [CommonFunctions roundedCoordinate:pathCoordinate];
        NSMutableArray *driverRoundedCoordinateArray = [CommonFunctions roundedCoordinate:driverCoordinate];
        if ([pathRoundedCoordinateArray isEqualToArray:driverRoundedCoordinateArray]) {
            [self.path removeCoordinateAtIndex:i];
            [self.stepsController removeCoordinate:driverCoordinate];
            [self.infoLabel setTextWithAnimation:strFormat(@"%@   %@",self.stepsController.distance,self.stepsController.duration)];
            [self drawPolyLineOnPath:self.path];
            DLog(@"After-> self.path.count %@",@(self.path.count));
            break;
        }
    }
    
}
-(void)stopCountdownTimerAndPlayer
{
    if(self.theAudio.playing){
        [self.theAudio stop];
    }
    UA_invalidateTimer(self.countdownTimer)
}


#pragma mark - Countdown timer
- (void)startCountdown{
    if (self.countdownTimer.isValid) {
        return;
    }
    UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(counterstart)
                                                         userInfo:nil
                                                          repeats:YES];
    
    
}

-(void)counterstart
{
    [self.countdownLable setAlpha:1.0];
    [self setCounter:(_counter -1)];
    [self playSoundWithName:BOOKING_SOUND];
    [self.countdownLable setText:[NSString stringWithFormat:@"%d",_counter]];
    if (_counter == 0){
        [self skipedSetup:NO];
    }
}
#pragma mark- ClintViewDelegate
- (void)backToMapScreen{
    NSMutableArray *viewCntrollers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers.mutableCopy];
    [self.navigationController popToViewController:viewCntrollers[0] animated:NO];
}
- (void)skipedSetup:(BOOL)isNewOrder{
    if (!isNewOrder) {
        [self mainSetup];
        [self stopCountdownTimerAndPlayer];
        [self.mapView clear];
        [self.countdownLable setText:@""];
        //  [self startTimer];
        [self driverLocationWithAddress];
    }
    NSTimeInterval delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Do some work");
        [self updateActivityStatus:KOrderStatusSkiped sender:[RoundedButton new]];
    });
    
}
#pragma mark- Driver Activity
- (IBAction)viewBookingBtnPressed:(RoundedButton *)sender
{
    NSString *titel = sender.currentTitle;
    DLog(@"wk order detail status: %@, tag: %ld", titel, (long)sender.tag);
    if (strEquals(titel, VIEW_BOOKING) || strEquals(titel, Accept_Order)){
        [self.passButton setHidden:YES];
    }
    if (strNotEquals(titel, END_JOB) && strNotEquals(titel, Order_Delivered) ) {
        [sender showLoading];
    }
    if (strEquals(titel, @"Skip") || strEquals(titel, @"REJECT")) {
        if (sender.tag != 999) {
            [self invalidateLocationTimer];
            [self stopCountdownTimerAndPlayer];
            [self invalidateLocationTimer];
            [self mainSetup];
            [self removeCancelRideButtonFromNavigationBar];
            [self setHomeLocationBtn];
            [self clearMapView];
            [self.countdownLable setText:@""];
        }
        [self updateActivityStatus:KOrderStatusRejected sender:sender];
    } else if (strEquals(titel, VIEW_BOOKING) || strEquals(titel, Accept_Order)) {
        DLog(@"wk params viewBookingBtnPressed : %@", titel);
        if (sender.tag != 1000) {
            [self stopCountdownTimerAndPlayer];
            [self invalidateLocationTimer];
            [self.countdownLable setText:@""];
            _counter    = 20;
            self.viewBookingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [self updateActivityStatus:KOrderStatusAccepted sender:sender];
    }
    else if (strEquals(titel, ARRIVED) || strEquals(titel, ARRIVED_At_Pickup)){
        [self updateActivityStatus:KOrderStatusReached sender:sender];
        [self clearMapView];
    }
    else if (strEquals(titel, START_JOB) || strEquals(titel, Order_Picked_UP)){
        NSInteger moreORdersForPickdup = [self isMoreOrderFormSameRestuarentSameStatus] - 1;
        if (moreORdersForPickdup > 0) {
            [sender hideLoading];
            NSString * orderString = moreORdersForPickdup  == 1 ? @"Additional order requires pick up" : [NSString stringWithFormat:@"%@ Additional order requires pick up",@(moreORdersForPickdup).stringValue];
            NSString *message = [NSString stringWithFormat:@"%@\n%@  ",orderString,self.request.order.restaurant.name];
            [CommonFunctions showAlertWithTitel:@"Alert" message:message inVC:self completion:^(BOOL success) {
                [self showOrdersScreen];
            }];
            return;
        }
        [self updateActivityStatus:KOrderStatusPickedup sender:sender];
        
    } else if (strEquals(titel, END_JOB) || strEquals(titel, Order_Delivered)){
        if ([self.request.order.paymentMethod isEqualToString:@"cod"] && strEquals(titel, Order_Delivered)) {
            DLog("** wk latlng: %@", self.driverCoordinate);
            UICodChargeToCustomerViewController *codCheck = [[UICodChargeToCustomerViewController alloc] init];
            codCheck.order = self.request.order;
            codCheck.latLong = self.driverCoordinate;
            codCheck.address = self.driverAddress;
            [codCheck setHandlerSuccess:^(NSDictionary * _Nonnull data) {
                NSLog(@"Handler success data: %@", data);
                [self updateDriverLocationAndGetOrdersApi:false];
//                Order *order = [[Order alloc] initWithAtrribute:data];
//                [self pushToFareAndRank:order];
                //                UISubmitedSuccessfullyPopupViewController *success = [[UISubmitedSuccessfullyPopupViewController alloc] init];
                //                success.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                //                success.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                //                [self presentViewController:success animated:YES completion:nil];
            }];
            [self.navigationController pushViewController:codCheck animated:true];
        } else {
            [CommonFunctions showQuestionsAlertWithTitel:@"Are you sure?" message:@"You've completed the delivery" inVC:self completion:^(BOOL success) {
                if (success) {
                    [sender showLoading];
                    [self updateActivityStatus:KOrderStatusDelivered sender:sender];
                    _timeInterval = 10;
                    [self clearMapView];
                    if ([self isMoreDeliveriesForSameUser]) {
                        [self showOrdersScreen];
                        
                    }
                    
                }
            }];
        }
    }
    
    
}
- (void)setBtnTittel:(NSString *)titel{
    [self.passButton setHidden:strNotEquals(titel, Accept_Order)];
    DLog(@"wk title: %@", titel);
    if (self.viewBookingBtn.isLoading) {
        //[self.viewBookingBtn hideLoadingWithTitel:titel];
    }else{
        [self.viewBookingBtn setTitle:titel forState:UIControlStateNormal];
    }
    if (strEquals(titel, START_JOB) || strEquals(titel, Order_Picked_UP)) {
        [self.viewBookingBtn setType:Started];
    }else if (strEquals(titel, END_JOB) || strEquals(titel, Order_Delivered)) {
        [self.viewBookingBtn setType:Ended];
    }
    else{
        [self.viewBookingBtn setType:Semple];
    }
    [self.viewBookingBtn setEnabled:YES];
}
- (BOOL)isMoreOrderFormSameRestuarent{
    if (self.orders.count == 1) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurant.restaurentId == %@", self.request.order.restaurant.restaurentId];
    NSArray *filteredArray = [self.orders filteredArrayUsingPredicate:predicate];
    return filteredArray.count != 0;
}
- (NSInteger)isMoreOrderFormSameRestuarentSameStatus{
    if (self.orders.count == 1) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurant.restaurentId == %@", self.request.order.restaurant.restaurentId];
    NSArray *filteredArray = [self.orders filteredArrayUsingPredicate:predicate];
    
    NSPredicate *statuspredicate = [NSPredicate predicateWithFormat:@"statusName == %@", self.request.order.statusName];
    NSArray *statusFilteredArray = [filteredArray filteredArrayUsingPredicate:statuspredicate];
    return statusFilteredArray.count ;
}
- (BOOL)isMoreDeliveriesForSameUser{
    if (self.orders.count == 1) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customer.clientId == %@", self.request.order.restaurant.restaurentId];
    NSArray *filteredArray = [self.orders filteredArrayUsingPredicate:predicate];
    return filteredArray.count != 0;
}
- (IBAction)currentLocationBtnPressed:(id)sender{
    if (self.isDirectionBtn) {
        [self openDirectionsInGoogleMaps];
    }else{
        [self.mapView animateToLocation:self.locationTracker.currentLocation];
    }
    
}

- (IBAction)onClickProjectedEarningViewExpand:(id)sender{
    [self updateProjectedEarningViewHeight: self.mapView.frame.size.height / 2];
    
}

- (IBAction)onClickProjectedEarningViewClose:(id)sender{
    [self updateProjectedEarningViewHeight: 0];
}

- (void)updateProjectedEarningViewHeight:(CGFloat)newHeight {
    // Update the constraint's constant value
    self.constraintDriverProjectedEarningViewHeight.constant = newHeight;
    
    // Animate the change
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded]; // Applies the layout changes
    }];
}

-(void) clickScanButtonfromOrders {
    [self showAlertForScanAndInputOrder];
}

- (IBAction)onClickScan:(id)sender{
    //    DLog(@"** wk scan click done");
    [self showAlertForScanAndInputOrder];
}

-(void) showAlertForScanAndInputOrder {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Scan Order" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UICustomScannerViewController *scanner = [[UICustomScannerViewController alloc] init];
        [scanner setHandlerSuccess:^(NSString *orderId) {
            //            DLog(@"** wk scan result: %@", orderId);
            [self acceptOrderByQrCode:orderId];
        }];
        [self.navigationController pushViewController:scanner animated:true];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enter Order Id" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIAcceptOrderByIdPopupViewController *con = [[UIAcceptOrderByIdPopupViewController alloc] init];
        [con setHandlerSuccess:^(NSString *orderId) {
            //            DLog(@"** wk scan result: %@", orderId);
            [self acceptOrderByQrCode:orderId];
        }];
        
        con.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        con.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:con animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)clearMapView{
    if (markers.count == 0  && _polyline.map == nil) {
        return;
    }
    _coordinates    = [NSMutableArray new];
    markers       = [NSMutableArray new];
    _polyline.map   = nil;
    [self.mapView clear];
    [self driverLocationWithAddress];
    
}

-(void)updateActivityStatus:(KOrderStatus)currentAction sender:(RoundedButton *)sender{
    BOOL isFormNewJob = (sender.tag == 1000 || sender.tag == 999);
    NSArray *latlong = [self.driverCoordinate componentsSeparatedByString:@","];
    Order *order = self.request.isNewOrder ? self.request.requestedOrder : self.request.order;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"parcelDelivery",@"command",order.orderId,@"order_id",[NSNumber numberWithInt:currentAction],@"current_activity",SHAREMANAGER.userId,@"driver_id"
                                 ,latlong[0],@"lat",latlong[1],@"long",self.driverAddress,@"address", nil];
    
    DLog(@"wk params updateActivityStatus: %@", params);
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        if (!isFormNewJob) {
            [self invalidateLocationTimer];
            [self startTimer];
        }
        DLog(@"wk updateActivityStatus result json: %@", json);
        if (json != nil && ![json objectForKey:@"error"]){
            if (currentAction == KOrderStatusSkiped || currentAction == KOrderStatusRejected) {
                if (!isFormNewJob) {
                    if (self.passButton.isLoading) {
                        [self.passButton hideLoading];
                    }
                    [SHAREMANAGER setIsRide:NO];
                    [self fetchProfileDetail];
                    //                    [self showNewOrderVC];
                }else{
                    [sender hideLoading];
                    [self dismissJobRequestVC];
                }
                
            }
            else if (currentAction == KOrderStatusAccepted) {
                if (!isFormNewJob) {
                    [self stopCountdownTimerAndPlayer];
                    [self.viewBookingBtn hideLoadingWithTitel: ARRIVED_At_Pickup];
                    [self invalidateLocationTimer];
                    [self startTimer];
                    [self performSelector:@selector(showCancelBtn) withObject:nil afterDelay:0];
                }else{
                    [sender hideLoading];
                    [self dismissJobRequestVC];
                    
                    NSArray *resultArray = [json objectForKey:RESULT];
                    if (resultArray.count != 0) {
                        NSDictionary *res = @{@"orders":resultArray};
                        //                        DLog(@"wk orders resultArray: %@", resultArray);
                        //                        DLog(@"wk orders res: %@", res);
                        user_defaults_set_object(UD_REQUEST,[res dictionaryByReplacingNullsWithBlanks]);
                        self.request = [[RideRequest alloc] initWithAttribute:res];
                        
                        self.orders = self.request.orders;
                        NSLog(@"** wk map drawPinsOnMap from updateActivityStaus");
                        [self drawPinsOnMap];
                        [self postNotificationToOrdersViewController:self.orders];
                        
                        int acceptedOrderCount = [self checkAcceptedOrderCount];
                        //                        DLog(@"** wk count: %d", acceptedOrderCount);
                        if (acceptedOrderCount == 0 && self.clientViewTop.constant == 0) {
                            [self hideClientView];
                        } else if (acceptedOrderCount != 0 && self.clientViewTop.constant != 0) {
                            [self showClientView];
                        }
                    }
                }
                
                if (self.request.orders.count > 1) {
                    [self showOrdersScreen];
                }
            }else if (currentAction == KOrderStatusReached){
                [self.viewBookingBtn hideLoadingWithTitel:Order_Picked_UP ];
                
            }else if (currentAction == KOrderStatusPickedup){
                [self.viewBookingBtn hideLoadingWithTitel:Order_Delivered];
                
                
            }else if (currentAction == KOrderStatusPickedup){
                [self.viewBookingBtn hideLoadingWithTitel:Order_Delivered];
                
                
            }
        }else{
            NSString *errorMsg = [json objectForKey:@"error"] ;
            [self handleUpdateActivityStatusError:errorMsg currentAction:currentAction sender:sender];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        if (!isFormNewJob) {
            [self invalidateLocationTimer];
            [self startTimer];
        }
        [self handleUpdateActivityStatusError:error.localizedDescription currentAction:currentAction sender:sender];
        DLog(@"Error: %@", error.localizedDescription);
    }];
    
}

-(void) handleUpdateActivityStatusError: (NSString *)errorDescription currentAction: (KOrderStatus) currentAction sender: (RoundedButton *)sender {
    NSString *errorMsg = errorDescription;
    DLog(@"wk error: %@", errorMsg);
    if (currentAction == KOrderStatusAccepted) {
        if (strEquals(errorMsg, @"Order canceled") || strEquals(errorMsg, @"You missed")) {
            [self mainSetup];
            [self.mapView clear];
            [self driverLocationWithAddress];
            [self invalidateLocationTimer];
            [self startTimer];
            if (!errorMsg.isEmpty) {
                [CommonFunctions showAlertWithTitel:@"Oops!" message:errorMsg inVC:self];
            }
        }
    }
    if ([ErrorFunctions isError:errorMsg]){
        [self updateActivityStatus:currentAction sender:sender];
    }else{
        DLog(@"\n%@\n",errorMsg);
        [self rideRequestSetup];
    }
}

#pragma mark - StatusViewDelegate

-(void)updateStatus:(NSString *)status{
    if (self.menuView.isShown) {[self toggleShowMenuView];}
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"updateStatus",@"command",SHAREMANAGER.userId,@"user_id",status,@"road_status", nil];
    DLog(@"wk params updateStatus: %@", params);
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        if (![json objectForKey:@"error"]&&json!=nil && [json[@"success"] intValue] != 0){
            NSDictionary *results = [[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            NSString *UpdatedStatus = [results objectForKey:@"road_status"];
            [User save:results];
            BOOL isOnline = strEquals(status,ONLINE);
            //            if (self.cancelRideBarButton.isLoading) {
            [self showStatusButton:isOnline ? GO_ONLINE : GO_OFFLINE];
            
            //            }
            
            if (strEquals(UpdatedStatus, ONLINE)){
                if (self.shouldShowOrders == false) {
                    self.shouldShowOrders = true;
                }
                user_defaults_set_bool(ISONLINE, YES);
                user_defaults_set_bool(ISOFFLINE, NO);
                [self driverLocationWithAddress];
                [self startTrackingLocation];
                [self invalidateLocationTimer];
                [self startTimer];
            }else if (strEquals(UpdatedStatus, OFFLINE)) {
                [self offlineSetup];
                
            }
        }else{
            [self.cancelRideBarButton hideLoading];
            if ([json[@"success"] intValue] == 0) {
                [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:self];
                return ;
            }
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                [self updateStatus:status];
            } else{
                [CommonFunctions showAlertWithTitel:@"" message:errorMsg inVC:self];
            }
            
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSString *errorMsg = error.localizedDescription;
        if ([ErrorFunctions isError:errorMsg]){
            [self updateStatus:status];
        } else{
            [CommonFunctions showAlertWithTitel:@"" message:errorMsg inVC:self];
        }
        DLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)offlineSetup{
    user_defaults_set_bool(ISONLINE, NO);
    user_defaults_set_bool(ISOFFLINE, YES);
    user_defaults_remove_object(D_ADDRESS);
    user_defaults_remove_object(D_COORDINATE);
    self.driverAddress     = nil;
    self.driverCoordinate  = nil;
    self.driverLocation   = kCLLocationCoordinate2DInvalid;
    //    DLog(@"** wk driverLocation: %f, %f", self.driverLocation.latitude, self.driverLocation.longitude);
    [self invalidateLocationTimer];
    UA_invalidateTimer(self.markerTimer);
    self.markerTimer = nil;
    [self.locationTracker stopLocationTracking];
    self.driverMarker.map = nil;
}
#pragma mark - Fetch Drivers

-(void)cancelJourneyWithReason:(NSString *)reason
{
    [self showHud];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"cancel_ride" ,@"command",SHAREMANAGER.userId,@"user_id",reason,@"activity",@"driver",@"user_is", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        if (json != nil && ![json objectForKey:@"error"]){
            [self hideHud];
            [self invalidateLocationTimer];
            [self mainSetup];
            [self.mapView clear];
            [self driverLocationWithAddress];
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            [self handleCancelJourneyError:errorMsg reason:reason];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self handleCancelJourneyError:error.localizedDescription reason:reason];
    }];
    
}

-(void) handleCancelJourneyError: (NSString *)errorDescription reason: (NSString *)reason {
    NSString *errorMsg = errorDescription;
    if ([ErrorFunctions isError:errorMsg]){
        [self cancelJourneyWithReason:reason];
    }
    else
    {
        [self hideHud];
    }
    DLog(@"Error: %@", errorMsg);
}


#pragma mark -
#pragma mark -GMSMarker InfoWindow
#pragma mark -

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    // Create a custom view for the marker info window
    UIView *infoWindow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 70)];
    infoWindow.backgroundColor = [UIColor whiteColor];
    infoWindow.layer.cornerRadius = 8;
    infoWindow.layer.masksToBounds = YES;
    
    // Add a label for the title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, infoWindow.frame.size.width - 16, 20)];
    titleLabel.text = marker.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [infoWindow addSubview:titleLabel];
    
    // Add a label for the snippet
    UILabel *snippetLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 36, infoWindow.frame.size.width - 16, 20)];
    snippetLabel.text = marker.snippet;
    snippetLabel.font = [UIFont systemFontOfSize:14];
    snippetLabel.textColor = [UIColor grayColor];
    [infoWindow addSubview:snippetLabel];
    
    return infoWindow;
    
    return nil;
}



// Since we want to display our custom info window when a marker is tapped, use this delegate method
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    // A marker has been tapped, so set that state flag
    self.markerTapped = YES;
    
    // If a marker has previously been tapped and stored in currentlyTappedMarker, then nil it out
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    // make this marker our currently tapped marker
    self.currentlyTappedMarker = marker;
    /* animate the camera to center on the currently tapped marker, which causes
     mapView:didChangeCameraPosition: to be called */
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker.position];
    [self.mapView animateWithCameraUpdate:cameraUpdate];
    return NO;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    /* if we got here after we've previously been idle and displayed our custom info window,
     then remove that custom info window and nil out the object */
    if(self.idleAfterMovement) {
    }
    
    // if we got here after a marker was tapped, then set the cameraMoving state flag to YES
    if(self.markerTapped) {
        self.cameraMoving = YES;
    }
}

// This method gets called whenever the map was moving but has now stopped
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
    /* if we got here and a marker was tapped and our animate method was called, then it means we're ready
     to show our custom info window */
    if(self.markerTapped && self.cameraMoving){
        // reset our state first
        self.cameraMoving = NO;
        self.markerTapped = NO;
        self.idleAfterMovement = YES;
        
    }
}

/* If the map is tapped on any non-marker coordinate, reset the currentlyTappedMarker and remove our
 custom info window from self.view */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self.menuView.isShown) {
        [self toggleShowMenuView];
    }
    
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
}
-(void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{
    GMSVisibleRegion visibleRegion = self.mapView.projection.visibleRegion;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:visibleRegion.nearLeft
                                                                       coordinate:visibleRegion.nearRight];
    SHAREMANAGER.coordinateBounds = bounds;
}

/* When the button is clicked, verify that we've got access to the correct marker.
 You might use this button to push a new VC with detail about that marker onto the navigation stack. */
- (void)buttonClicked:(id)sender{
    ////DLog(@"button clicked for this marker: %@",self.currentlyTappedMarker);
}
#pragma mark IBActions
- (void)signout{
    
    [CommonFunctions showQuestionsAlertWithTitel:@"Are you sure?" message:@"Do you really want to log out?" inVC:self completion:^(BOOL success) {
        if (success) {
            [self logout];
        }
    }];
    
}

-(void)logout
{
    
    [self invalidateLocationTimer];
    [self showHud];
    NSString *idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"logout",@"command",SHAREMANAGER.userId,@"user_id", idString, @"session_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        [self hideHud];
        //////DLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&&json!=nil){
            [self clearUserCacheData];
//            [self offlineSetup];
//            [self invalidateLocationTimer];
//            user_defaults_set_bool(ISONLINE, NO);
//            user_defaults_set_bool(ISOFFLINE, YES);
//            [self.navigationController setViewControllers:@[instantiateVC(@"MainView")] animated:NO];
//            [SHAREMANAGER clearUserDefault];
            [self hideHud];
        }else  {
            [CommonFunctions showAlertWithTitel:@"Info" message:[json objectForKey:@"error"] inVC:self];
            
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self hideHud];
        [CommonFunctions showAlertWithTitel:@"Info" message:error.localizedDescription inVC:self];
    }];
}
//https:xpeats.com/api/index.php?command=getProjectedEarningForDriver&driver_id=4547&date=2024-11-20
-(void)getProjectedEarningApi {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:today];

    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProjectedEarningForDriver",@"command",SHAREMANAGER.userId,@"driver_id", formattedDate, @"date", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        //////DLog(@"the json return is %@",json);
        if (![json objectForKey:@"error"]&&json!=nil){
            DLog(@"** wk response: %@", json);
            NSDictionary *data = json[@"data"];
            NSString *strAmount = [NSString stringWithFormat:@"%@", data[@"projected_earning"]];
            if (strAmount) {
                [self.lblTotalProjectedEarning setText:strAmount];
            } else {
                [self.lblTotalProjectedEarning setText:@"-"];
            }
//            [self onClickProjectedEarningViewExpand:[[UIButton alloc] init]];
        }else  {
            [CommonFunctions showAlertWithTitel:@"Info" message:[json objectForKey:@"error"] inVC:self];
            
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self hideHud];
        [CommonFunctions showAlertWithTitel:@"Info" message:error.localizedDescription inVC:self];
    }];
}


#pragma Cancel Reason View
-(void)showslectionView{
    [self performSegueWithIdentifier:@"ShowCancelRideVC" sender:self];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _polyline.map = nil;
    UA_invalidateTimer(self.markerTimer);
    
}
-(void)showCancelBtn{
    [self addCancelRideButtonToNavigationBar];
}

#pragma Play Sound
-(void)playSoundWithName:(NSString *) soundName
{
    if (self.theAudio.isPlaying) {
        return;
    }
    NSError *err =  nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    self.theAudio = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self.theAudio play];
    
}
#pragma Start Tracking Location
-(void)startTrackingLocation{
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        [CommonFunctions showAlertWithTitel:@"" message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh" inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        [CommonFunctions showAlertWithTitel:@"" message: @"The functions of this app are limited because the Background App Refresh is disable." inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
        
    } else{
        if (!self.locationTracker) {
            self.locationTracker = [[LocationTracker alloc] init];
        }
        [self.locationTracker startLocationTracking];
        
    }
}
-(void)setHomeLocationBtn{
    [self.currentLocationBtn setHidden:NO];
    [self.currentLocationBtn setImage:HOME_POINTER forState:UIControlStateNormal];
    
}
-(void)setDirectionBtn{
    [self.currentLocationBtn setHidden:NO];
    [self.currentLocationBtn setImage:HOME_POINTER forState:UIControlStateNormal];
    //* uncomment to use DIRECTION feature
    [self.currentLocationBtn setImage:DIRECTION forState:UIControlStateNormal];
    
}
-(void)hideDirectionBtn{
    
    [self.currentLocationBtn setHidden:YES];
}
-(BOOL)isDirectionBtn{
    UIImage *btnImg =[self.currentLocationBtn imageForState:UIControlStateNormal];
    return [SHAREMANAGER image:btnImg isEqualTo:DIRECTION];
}

#pragma mark- Open Google Directions

- (void)openDirectionsInGoogleMaps {
    GoogleDirectionsDefinition *directionsDefinition = [[GoogleDirectionsDefinition alloc] init];
    NSString *endingString = self.request.order.status != KOrderStatusPickedup ? self.request.order.restaurant.location.address : self.request.order.dropLocation.address;
    CLLocationCoordinate2D endingLocation = self.request.order.status != KOrderStatusPickedup ? self.request.order.restaurant.location.coordinate : self.request.order.dropLocation.coordinate;
    GoogleDirectionsWaypoint *startingPoint = [[GoogleDirectionsWaypoint alloc] init];
    startingPoint.queryString = self.driverAddress;
    startingPoint.location = self.driverLocation;
    directionsDefinition.startingPoint = startingPoint;
    //    DLog(@"** wk startingPoint queryString: %@, location: %f,%f", startingPoint.queryString, startingPoint.location.latitude, startingPoint.location.longitude);
    GoogleDirectionsWaypoint *destination = [[GoogleDirectionsWaypoint alloc] init];
    destination.queryString = endingString;
    destination.location = endingLocation;
    directionsDefinition.destinationPoint = destination;
    //    DLog(@"** wk destination queryString: %@, location: %f,%f", destination.queryString, destination.location.latitude, destination.location.longitude);
    directionsDefinition.travelMode = self.request.order.isEventOrder? kTravelModeWalking: kTravelModeDriving;
    [[OpenInGoogleMapsController sharedInstance] openDirections:directionsDefinition];
}
#pragma  mark - CancelOrderViewControllerDelegate -
- (void)orderCanceled{
    [self updateDriverLocationAndGetOrdersApi:true];
    // [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - OrdersViewControllerDelegate -
- (void)ordersViewControllerDismissed{
    [self hideOrdersScreen];
}
- (void) pushToFareAndRank:(Order *)order {
    self.selectedOrder = order;
    
    [self showFareAndRatingView];
}
-(void) changeActiveOrder:(NSDictionary *)data {
    DLog(@"wk changeActiveOrder");
    [self updateDriverLocationGetOrdersResponse: data];
}
//- (void)changeActiveOrder {
//    DLog(@"wk changeActiveOrder");
//    [self updateDriverLocationAndGetOrdersApi];
//}
- (void)clickToNavigate {
    [self openDirectionsInGoogleMaps];
}
- (void)ShowOrderInfo:(Order *)order{
    self.selectedOrder = order;
    [self performSegueWithIdentifier:@"ShowOrderInfo" sender:self];
}

-(void) openAppUpdatePopup {
    UIUpdateAppPopupViewController *updateVC = [[UIUpdateAppPopupViewController alloc] init];
    
    updateVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    updateVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:updateVC animated:YES completion:nil];
}
-(void)clickOnMessageButton:(Order *)order {
    DLog(@"** wk clickOnMessageButton");
    UIMessageToCustomerViewController *messageVC = [[UIMessageToCustomerViewController alloc] init];
    messageVC.orderId = order.orderId;
    
    [self.navigationController presentViewController:messageVC animated:true completion:nil];
    
    
    //    [self.navigationController pushViewController:messageVC animated:true];
    
    //    UIMessageToCustomerViewController *messageVC = [[UIMessageToCustomerViewController alloc] init];
    //    messageVC.orderId = order.orderId;
    //
    //    // Assuming 'self.mainViewController' is the parent view controller where you want to add the subview
    //    [self.navigationController.view addSubview:messageVC.view];
    //
    //    // If needed, adjust the frame of the messageVC view to fit within the parent view bounds
    //    messageVC.view.frame = self.navigationController.view.bounds;
    //
    //    // Perform any additional configuration or customization of the messageVC view or its subviews as needed
    //
    //    // Optionally, you can animate the addition of the subview
    //    [UIView animateWithDuration:0.3 animations:^{
    //        // Perform any animations or layout adjustments here if needed
    //    }];
    //
    //    // Notify the view controller that it has been added as a child view controller
    //    [self.navigationController addChildViewController:messageVC];
    
    // Notify the view controller that its view has been added to the view hierarchy
    //    [messageVC didMoveToParentViewController:self.mainViewController];
    
}
//-(void)scanQrCode:(NSString *)orderId {
//    [self acceptOrderByQrCode:orderId];
//}
- (IBAction)orderListButtonPressed:(UIButton *)sender {
    [self showOrdersScreen];
}

- (IBAction)onClickMapOrders:(UIButton *)sender {
    UIMapForLocatonAndOrderPinsViewController *vc = [[UIMapForLocatonAndOrderPinsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - CancelRideViewControllerDeleagte
- (void)cancelRideWithReason:(Reasons *)reason{
    selectedOption   = reason.reason;
    selectedOptionId = reason.reasonId;
}
#pragma mark - Notifications -
/* UIApplication specific notifications are used to pause/resume the architect view rendering */
- (void)didReceiveApplicationWillResignActiveNotification:(NSNotification *)notification{
    if ([self.markerTimer isValid]) {
        UA_invalidateTimer(self.markerTimer);
        self.markerTimer = nil;
    }
}

- (void)didReceiveApplicationDidBecomeActiveNotification:(NSNotification *)notification{
    BOOL isOffline =  user_defaults_get_bool(ISOFFLINE);
    if (!isOffline) {
        if (![self.markerTimer isValid]) {
            [self startMarkerTimer];
        }
    }
    
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:WebView_Idintifire]) {
        WebViewController*WVC = (WebViewController *)[segue destinationViewController];
        WVC.webUrl = self.selectedURL;
    }else if ([segue.identifier isEqualToString:FARE_Idintifire]) {
        FareAndRatingView *vc = (FareAndRatingView *)[segue destinationViewController];
        vc.order   = self.selectedOrder;
        // vc.message   = _request.message;
    }else if ([[segue destinationViewController] isKindOfClass:[OrderInfoViewController class]]) {
        OrderInfoViewController *vc = (OrderInfoViewController *)[segue destinationViewController];
        vc.order   = self.selectedOrder;
    }else if ([[segue destinationViewController] isKindOfClass:[OrdersViewController class]]) {
        OrdersViewController *vc = (OrdersViewController *)[segue destinationViewController];
        self.ordersVC = vc;
        vc.orders   = self.orders;
        vc.driverAddress = self.driverAddress;
        vc.driverCoordinate = self.driverCoordinate;
        vc.driverLocation = self.driverLocation;
        //        DLog(@"** wk driverLocation: %f, %f", self.driverLocation.latitude, self.driverLocation.longitude);
        vc.delegate       = self;
    }else  if ([segue.identifier isEqualToString:CancelOrder_Idintifire]) {
        CancelOrderViewController*coVC = (CancelOrderViewController *)[segue destinationViewController];
        coVC.order = self.request.order;
        coVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ShowWithdrawVC"]) {
        //        [self.mainViewController performSegueWithIdentifier:@"ShowWithdrawVC" sender:self.mainViewController];
        WithdrawViewController *coVC = (WithdrawViewController *)[segue destinationViewController];
        coVC.dicWallet = self.dicWallet;
        //        DLog("** wk click for WithdrawViewController");
    } else if ([segue.identifier isEqualToString:@"ShowCountrySelectionVC"]) {
        CountrySelectionViewController *csVC = (CountrySelectionViewController *)segue.destinationViewController;
        csVC.isIBAN        = NO;//
        csVC.isCreditDebit = YES;
        csVC.selectedCurrency = SHAREMANAGER.user.defaultCurrency;
        //        DLog(@"** wk selectedCurrency: %@", self.selectedCurrency.name);
    }
    
    
}

- (void)showOrdersScreen {
    if (self.isOrderVCShown) {
        return;
    }
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3
                     animations:^{
        [self.ordersVC.view setHidden:NO];
        self.containerViewBottom.constant = 0;
        [self.view layoutIfNeeded]; // Called on parent view
    }];
    self.isOrderVCShown = TRUE;
}

- (void)hideOrdersScreen {
    if (!self.isOrderVCShown) {
        return;
    }
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3
                     animations:^{
        [self.ordersVC.view setHidden:YES];
        self.containerViewBottom.constant = - (ViewHeight(self.containerView) + 100);
        [self.view layoutIfNeeded]; // Called on parent view
    }];
    self.isOrderVCShown = FALSE;
}

-(void) drawPinsOnMap {
    NSLog(@"** wk map drawPinsOnMap 1");
    
    for (GMSMarker *marker in self.mapMarkers) {
        marker.map = nil; // This removes the marker from the map
    }
    
    [self.mapMarkers removeAllObjects];
    
    for (Order *order in self.orders) {
        //        DLog(@"** wk order: %@, %@", order.dropLocation.lat, order.dropLocation.lng);
        
        CLLocationDegrees latitude = [order.dropLocation.lat doubleValue];
        CLLocationDegrees longitude = [order.dropLocation.lng doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = coordinate;
        
        marker.title = [NSString stringWithFormat: @"%@", order.customer.name]; // Set a custom title if needed
        marker.snippet = [NSString stringWithFormat:@"%@\t%@", order.orderId, order.distance];
        //                    marker.icon = [UIImage imageNamed:@"imgDropPin"]; // Set custom image for the marker
        marker.icon = [self image:[UIImage imageNamed:@"imgDropPin"] scaledToSize:CGSizeMake(40.0, 40.0)];
        marker.map = self.mapView;
        [self.mapMarkers addObject:marker];
    }
}

// Helper method to resize image
- (UIImage *)image:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// hide functionality of Telegram
//-(void) showTelegramPopup: (User *)user {
//    if ([user.telegramRegistrationRequired isEqualToString:@"0"] && ![TelegramPopupUtil checkDontShowTelegramPopup]) {
//        self.isShowTelegramPopupFirstTime = true;
//        UITelegramPopupViewController *swiftVC = [[UITelegramPopupViewController alloc] init];
//        swiftVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        swiftVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:swiftVC animated:YES completion:nil];
//        
//    } else if ([user.telegramRegistrationRequired isEqualToString:@"1"]) {
//        self.isShowTelegramPopupFirstTime = true;
//        UITelegramPopupViewController *swiftVC = [[UITelegramPopupViewController alloc] init];
//        swiftVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        swiftVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:swiftVC animated:YES completion:nil];
//    }
//}

- (void)dismissAllPresentedControllers {
    NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;

            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    UIViewController *rootVC = window.rootViewController;

                    while (rootVC.presentedViewController) {
                        rootVC = rootVC.presentedViewController;
                    }

                    [rootVC dismissViewControllerAnimated:YES completion:nil];
                    return; // Exit after dismissing
                }
            }
        }
    }
}

-(void) clearUserCacheData {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self dismissAllPresentedControllers];
        
        [self offlineSetup];
        user_defaults_set_bool(ISONLINE, NO);
        user_defaults_set_bool(ISOFFLINE, YES);
        [self.webSocketManager disconnect];
        [DELG.updLoctionTimer invalidate];
        [self invalidateLocationTimer];
        UA_invalidateTimer(self.markerTimer);
        DELG.updLoctionTimer = nil;
        [SHAREMANAGER clearUserDefault];
        
        [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
    });
    
//    [self invalidateLocationTimer];
//    UA_invalidateTimer(self.markerTimer);
//    [SHAREMANAGER clearUserDefault];
//    [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
    
//    [self invalidateLocationTimer];
//    UA_invalidateTimer(self.markerTimer);
//    [SHAREMANAGER clearUserDefault];
//    [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
    
//    [self offlineSetup];
//    [self invalidateLocationTimer];
//    user_defaults_set_bool(ISONLINE, NO);
//    user_defaults_set_bool(ISOFFLINE, YES);
//    [self.navigationController setViewControllers:@[instantiateVC(@"MainView")] animated:NO];
//    [SHAREMANAGER clearUserDefault];
    
//    [DELG.updLoctionTimer invalidate];
//    DELG.updLoctionTimer = nil;
//    [SHAREMANAGER clearUserDefault];
//    
//    [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
}
@end
