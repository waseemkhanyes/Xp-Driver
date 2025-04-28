//
//  JobRequestView.m
//  XPDriver
//
//  Created by Macbook on 07/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//

#import "JobRequestView.h"
#import "XP_Driver-Swift.h"

@interface JobRequestView ()
@property (strong, nonatomic) NSString *phoneNumaber;
@property (strong, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *clientLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *deliverTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *clientImgView;
@property (strong, nonatomic) IBOutlet UIImageView *locationImageView;
@property (strong, nonatomic) IBOutlet SZBorderView *orderInfoView;
@property (strong, nonatomic) IBOutlet SZBorderView *locationinfoView;
@property (strong, nonatomic) IBOutlet RoundedButton *skipButton;
@property (strong, nonatomic) IBOutlet RoundedButton *acceptButton;
 @property (strong, nonatomic) id      mainViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *infoButtonTrailing
;
@property (strong, nonatomic) IBOutlet UIView *acceptButtonContainerView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
// for JobRequestview
@property (strong, nonatomic) IBOutlet UILabel *countdownLable;
@property (nonatomic, assign) BOOL isAccepted;
@property (assign) int counter;
@property (strong,nonatomic)  AVAudioPlayer* theAudio;
@property (retain,retain)     NSTimer *countdownTimer;


- (IBAction)skipButtonPressed:(id)sender;
- (IBAction)acceptButtonPressed:(id)sender;

@end

@implementation JobRequestView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self.delegate;
    [self setup:self.order];
    // Do any additional setup after loading the view.
}
- (void)setup:(Order *)order{
     _counter    = 20;
    self.acceptButtonContainerView.hidden = NO;
    self.skipButton.hidden   = NO;
   [self startCountdown];
     [self.clientImgView roundCorner:10 borderColor:[UIColor clearColor]];
    [self.orderInfoView setHidden:YES];
    self.order = order;
    [self.orderNumberLabel setText:[NSString stringWithFormat:@"Order #%@",order.orderId]];
    [self.deliverTimeLabel setText:[NSString stringWithFormat:@"Delivery in %@",order.preparingtime]];
      [self.clientImgView roundCorner:10 borderColor:[UIColor clearColor]];
    [self.priceLabel setText:order.driverFee];
    if (order.isPickedUp || order.isDelivered) {
           [self.orderInfoView setHidden:NO];
           [self.addressLabel setHidden:YES];
         [self.clientNameLabel setText:order.customer.name];
           self.phoneNumaber = order.customer.phone;
        self.infoButtonTrailing.constant = 8;
       }else{
           self.phoneNumaber = order.restaurant.phone;
           [self.addressLabel setHidden:NO];
           [self.orderInfoView setHidden:NO];
           [self.clientNameLabel setText:order.restaurant.name];
           [self.addressLabel setText:order.restaurant.location.address];
           self.infoButtonTrailing.constant = -40;
       }
    [self getClientImage:order];
    if (order.isRequested || order.isAccepted) {
        [self.locationImageView setImage:TF_PICKUP_MARKER];
         [self.locationImageView setTintColor:[UIColor appGreenColor]];
        [self.clientLocationLabel setText:order.restaurant.location.formetedAddress];
        self.infoButtonTrailing.constant = -40;
    }
    else if (order.isArrived){
        [self.locationImageView setImage:TF_DESTINATION_MARKER];
        [self.locationImageView setTintColor:[UIColor appGreenColor]];
        [self.clientLocationLabel setText:order.restaurant.location.formetedAddress];
        self.infoButtonTrailing.constant = -40;
    } else if (order.isPickedUp ||order.isDelivered){
        [self.locationImageView setImage:TF_DESTINATION_MARKER];
        [self.locationImageView setTintColor:[UIColor appRedColor]];
        [self.clientLocationLabel setText:order.dropLocation.address];
        self.infoButtonTrailing.constant = 8;
        
    }
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
        [self stopCountdownTimerAndPlayer];
        [self.delegate skipedSetup:YES];
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
    [self dismissViewControllerAnimated:true completion:nil];
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
    [self.acceptButtonContainerView setHidden:YES];
    [self stopCountdownTimerAndPlayer];
    [self stopCountdownTimerAndPlayer];
    [self.delegate viewBookingBtnPressed:sender];
}

- (IBAction)acceptButtonPressed:(id)sender{
    [self.skipButton setHidden:YES];
     self.isAccepted = YES;
    [self stopCountdownTimerAndPlayer];
    [self stopCountdownTimerAndPlayer];
    [self.delegate viewBookingBtnPressed:sender];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
