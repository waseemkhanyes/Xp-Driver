//
//  RiderInfoView.m
//  XPDriver
//
//  Created by Macbook on 15/02/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "JobRequestView.h"
#import "BottomBorderView.h"
#import "RiderInfoView.h"
#import "XP_Driver-Swift.h"
@interface RiderInfoView()
@property (strong, nonatomic) Order *order;

@property (strong, nonatomic) NSString *phoneNumaber;
@property (strong, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *clientLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *deliverTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *earnInCaseCodLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *clientImgView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet SZBorderView *orderInfoView;
@property (strong, nonatomic) IBOutlet SZBorderView *locationinfoView;
@property (strong, nonatomic) id      mainViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *infoButtonTrailing
;
// for JobRequestview
@property (strong, nonatomic) IBOutlet UILabel *countdownLable;
@property (nonatomic, assign) BOOL isAccepted;
@property (assign) int counter;
@property (strong,nonatomic)  AVAudioPlayer* theAudio;
@property (retain,retain)     NSTimer *countdownTimer;

- (IBAction)orderInfoButtonPressed:(id)sender;
- (IBAction)callButton:(id)sender;
- (IBAction)skipButtonPressed:(id)sender;
- (IBAction)acceptButtonPressed:(id)sender;
- (IBAction)infoButtonPressed:(UIButton *)sender;
@end
@implementation RiderInfoView
- (void)setup:(Order *)order totalEarning:(NSString *)totalEarning {
    NSLog(@"** wk driver earning: %@", totalEarning);
    _counter    = 16;
    //    if (self.delegate) {
    //        [self startCountdown];
    //    }
    self.mainViewController = [self.superview nextResponder];
    [self.clientImgView roundCorner:10 borderColor:[UIColor clearColor]];
    [self.orderInfoView setHidden:YES];
    self.order = order;
    [self.orderNumberLabel setText:[NSString stringWithFormat:@"Order #%@",order.orderId]];
    [self.deliverTimeLabel setText:[NSString stringWithFormat:@"%@",order.distance]];
    [self.clientImgView roundCorner:10 borderColor:[UIColor clearColor]];
    if ([order.paymentMethod isEqualToString:@"cod"]) {
        //        [self.priceLabel setText:order.totalAmount];
        [self.priceLabel setText:[NSString stringWithFormat:@"Collect %@", order.fullPriceWithoutCode]];
        [self.earnInCaseCodLabel setText:[NSString stringWithFormat:@"Earn %@", order.driverFee]];
    } else {
        [self.priceLabel setText:[NSString stringWithFormat:@"Earn %@", order.driverFee]];
        [self.earnInCaseCodLabel setText:@""];
    }
    
//    [self.addressLabel setHidden:NO];
    [self.addressLabel setHidden:YES];
//    [self.addressLabel setText:totalEarning];
    
    if (order.isPickedUp || order.isDelivered) {
        [self.orderInfoView setHidden:NO];
//        [self.addressLabel setHidden:YES];
        [self.clientNameLabel setText:order.customer.name];
        self.phoneNumaber = order.customer.phone;
        //        self.infoButtonTrailing.constant = order.note.isEmpty ? -40 : 8;
    }else{
        self.phoneNumaber = order.restaurant.phone;
//        [self.addressLabel setHidden:NO];
        [self.orderInfoView setHidden:NO];
        [self.clientNameLabel setText:order.restaurant.name];
//        [self.addressLabel setText:order.restaurant.location.address];
        //           self.infoButtonTrailing.constant = -40;
    }
    [self getClientImage:order];
    if (order.isRequested || order.isAccepted) {
        [self.locationImageView setImage:TF_PICKUP_MARKER];
        [self.locationImageView setTintColor:[UIColor appGreenColor]];
        [self.clientLocationLabel setText:order.restaurant.location.formetedAddress];
        //        self.infoButtonTrailing.constant = -40;
    }
    else if (order.isArrived){
        [self.locationImageView setImage:TF_DESTINATION_MARKER];
        [self.locationImageView setTintColor:[UIColor appGreenColor]];
        [self.clientLocationLabel setText:order.restaurant.location.formetedAddress];
        //        self.infoButtonTrailing.constant = -40;
    } else if (order.isPickedUp ||order.isDelivered){
        [self.locationImageView setImage:TF_DESTINATION_MARKER];
        [self.locationImageView setTintColor:[UIColor appRedColor]];
        BOOL isEvanetOrder = self.order.detailOptions.count != 0;
        NSString  *address = @"";
        if (isEvanetOrder) {
            if (!order.restaurant.isNone) {
                BOOL isPrakingOrSeatNumber = !self.order.parkingStopNumber.isEmpty;
                BOOL isVehicleInfoOrNotes  = !self.order.vehicleInfo.isEmpty;
                if (!isPrakingOrSeatNumber && !isVehicleInfoOrNotes) {
                    
                    if (!order.aptNumber.isEmpty) {
                        address = [NSString stringWithFormat:@"Apt.%@,",order.aptNumber];
                    }
                    address = [NSString stringWithFormat:@"%@ %@",address,order.dropLocation.address];
                    //                    DLog(@"wk addressNote1: %@", order.addressNote);
                    //                    if (!order.addressNote.isEmpty) {
                    //                        address = [NSString stringWithFormat:@"%@\n Note: %@",address, order.addressNote];
                    //                    }
                    if (!order.note.isEmpty) {
                        address = [NSString stringWithFormat:@"%@\n Note: %@",address, order.note];
                    }
                }else{
                    NSString *parkingOrSeatText =  order.restaurant.isForParking ? @"Parking Spot#" : @"Seat#";
                    NSString *vehicleInfoOrNotesText =  order.restaurant.isForParking ? @"Vehicle info:" : @"Notes:";
                    if (isPrakingOrSeatNumber && !order.parkingStopNumber.isEmpty) {
                        address = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ %@",parkingOrSeatText,order.parkingStopNumber]];
                    }
                    if (isVehicleInfoOrNotes && !order.vehicleInfo.isEmpty) {
                        address = [NSString stringWithFormat:@"%@\n%@",address,[NSString stringWithFormat:@"%@ %@",vehicleInfoOrNotesText,order.vehicleInfo]];
                    }
                    
                    
                }
                
            }else{
                address = [NSString stringWithFormat:@"%@%@",address,order.dropLocation.address];
                
                if (!order.aptNumber.isEmpty) {
                    address = [NSString stringWithFormat:@"%@\nApt.%@\n", address,order.aptNumber];
                }
                
                //                DLog(@"wk addressNote2: %@", order.addressNote);
                //                if (!order.addressNote.isEmpty) {
                //                    address = [NSString stringWithFormat:@"%@\n Note: %@",address, order.addressNote];
                //                }
                if (!order.note.isEmpty) {
                    address = [NSString stringWithFormat:@"%@\nNote: %@",address, order.note];
                }
            }
        }else{
            address = [NSString stringWithFormat:@"%@%@",address,order.dropLocation.address];
            
            if (!order.aptNumber.isEmpty) {
                address = [NSString stringWithFormat:@"%@\nApt.%@", address,order.aptNumber];
            }
            
            //            DLog(@"wk addressNote3: %@", order.addressNote);
            //            if (!order.addressNote.isEmpty) {
            //                address = [NSString stringWithFormat:@"%@\n Note: %@",address, order.addressNote];
            //            }
            
            if (!order.addressNote.isEmpty) {
                NSString *trimmedNote = order.addressNote.length > 50 ? [NSString stringWithFormat:@"%@...", [order.addressNote substringToIndex:50]] : order.addressNote;
                address = [NSString stringWithFormat:@"%@\nNote: %@", address, trimmedNote];
            }
            
//            if (!order.addressNote.isEmpty) {
//                if (order.addressNote.length > 55) {
//                    address = [NSString stringWithFormat:@"%@\nNote: %@",address, order.addressNote];
//                } else {
//                    address = [NSString stringWithFormat:@"%@\nNote: %@",address, order.addressNote];
//                }
//            }
            if (!order.note.isEmpty) {
                address = [NSString stringWithFormat:@"%@\nOrder Note: %@",address, order.note];
            }
        }
        NSAttributedString *attributedText = [[[NSAttributedString alloc] initWithString:address] withLineSpacing:10.0];
        [self.clientLocationLabel setAttributedText:attributedText];
        //         self.infoButtonTrailing.constant = order.note.isEmpty ? -40 : 8;
        
    }
}
- (IBAction)callButton:(id)sender{
    if (![self.phoneNumaber hasPrefix:@"+"]) {
        self.phoneNumaber = [NSString stringWithFormat:@"+%@",self.phoneNumaber];
    }
    [SHAREMANAGER makeCall:self.phoneNumaber];
}
- (IBAction)orderInfoButtonPressed:(id)sender{
    //    UIViewController *vc = self.mainViewController;
    //    NSString *titel   = [NSString stringWithFormat:@"Order #%@",self.order.orderId];
    //    NSString *message = [NSString stringWithFormat:@"%@",self.order.orderInfo];
    //    [CommonFunctions showAlertWithTitel:titel message:message inVC:vc];
    [self.delegate ShowOrderInfo:self.order];
}
-(void)getClientImage:(Order *)order{
    NSURL *imageUrl = (!order.isPickedUp && !order.isDelivered) ? order.brandLogoUrl : order.customer.imageURL;
    if (imageUrl) {
        //        [self.clientImgView  setImageWithURL:imageUrl placeholderImage:USER_PLACEHOLDER];
        
        NSString *imageUrlString = [imageUrl absoluteString];
        
        [AlamofireWrapper downloadImageFrom:imageUrlString completion:^(UIImage *downloadedImage) {
            // Handle downloadedImage or nil as needed
            if (downloadedImage) {
                // Do something with the downloaded image
                self.clientImgView.image = downloadedImage;
                
            } else {
                // Handle the case when the image download fails
                [self.clientImgView setImage:USER_PLACEHOLDER];
            }
        }];
        
    }else{
        [self.clientImgView setImage:USER_PLACEHOLDER];
    }
    
    
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

-(void)counterstart{
    [self.countdownLable setAlpha:1.0];
    [self setCounter:(_counter -1)];
    [self playSoundWithName:BOOKING_SOUND];
    [self.countdownLable setText:[NSString stringWithFormat:@"%d",_counter]];
    if (_counter == 0){
        [self dismiss];
        [self.delegate skipedSetup:NO];
    }
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
- (void)dismiss{
    [self stopCountdownTimerAndPlayer];
    JobRequestView *jobVC = (JobRequestView *)self.mainViewController;
    [jobVC dismissViewControllerAnimated:YES completion:^{
        if (!self.isAccepted) {
            return;
        }
        [SHAREMANAGER.rootViewController dismissViewControllerAnimated:NO completion:nil];
        [self.delegate backToMapScreen];
    }];
}
-(void)stopCountdownTimerAndPlayer{
    [self.countdownLable setText:nil];
    if(self.theAudio.playing){
        [self.theAudio stop];
    }
    UA_invalidateTimer(self.countdownTimer)
}

- (IBAction)skipButtonPressed:(id)sender{
    self.isAccepted = NO;
    [self dismiss];
    [self stopCountdownTimerAndPlayer];
    [self.delegate viewBookingBtnPressed:sender];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {
    //        UIViewController *vc = self.mainViewController;
    //        NSString *titel   = @"Special Note";
    //        NSString *message = [NSString stringWithFormat:@"%@",self.order.note];
    //        [CommonFunctions showAlertWithTitel:titel message:message inVC:vc];
    
    //    UIMessageToCustomerViewController *messageVC = [[UIMessageToCustomerViewController alloc] init];
    //    messageVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //    messageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    messageVC.orderId = self.order.orderId;
    //    [self.mainViewController presentViewController:messageVC animated:YES completion:nil];
    [self.delegate clickOnMessageButton: self.order];
}

- (IBAction)acceptButtonPressed:(id)sender{
    self.isAccepted = YES;
    [self dismiss];
    [self stopCountdownTimerAndPlayer];
    [self.delegate viewBookingBtnPressed:sender];
}
@end
