//
//  VerificationViewController.m
//  ZoomsRideClient
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#define UPDATE_PASSWORD_VC_SEGUE_IDENTIFIER @"ShowResetPasswordVC"

#import "UpdatePasswordViewController.h"
#import "VerificationViewController.h"

@interface VerificationViewController (){
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}
@property (strong, nonatomic) IBOutlet UILabel *titelLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UITextField *codeField;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet RoundedButton *resendButton;
- (IBAction)resendButtonPressed:(id)sender;

@end

@implementation VerificationViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Verification";
    [self.titelLabel setText:strFormat(@"Enter the 4-digit code we sent to %@",self.email)];
    currMinute = 1;
    currSeconds=00;
    [self.resendButton setEnabled:NO];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNavigatinBackgroundView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.codeField setTextColor:CLEAR_COLOR];
    [self.codeField setTintColor:CLEAR_COLOR];
    [self.codeField becomeFirstResponder];
    [self start];
}
-(IBAction)textEditingChanged:(UITextField*)sender{
  
    if(sender.text.length==0){
        self.codeLabel.text=[NSString stringWithFormat:@"%@----",sender.text];
    }
    
    if(sender.text.length==1){
        self.codeLabel.text=[NSString stringWithFormat:@"%@---",sender.text];
    }
    if(sender.text.length==2){
        self.codeLabel.text=[NSString stringWithFormat:@"%@--",sender.text];
    }
    if(sender.text.length==3){
        self.codeLabel.text=[NSString stringWithFormat:@"%@-",sender.text];
    }
    if(sender.text.length==4){
        self.codeLabel.text=[NSString stringWithFormat:@"%@",sender.text];
        
        [self performSelector:@selector(showNameViewController) withObject:nil afterDelay:1];
    }
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setTextColor:CLEAR_COLOR];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField setTextColor:CLEAR_COLOR];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setTextColor:CLEAR_COLOR];
}
- (void)showNameViewController{
    if (!strEquals(self.codeField.text, self.verificatinCode)) {
         self.codeLabel.text= @"----";
        self.codeField.text = nil;
        [CommonFunctions showAlertWithTitel:@"Invalid Verification Code" message:@"Please enter valid verification code." inVC:self];
        return;
    }
    [self.codeField resignFirstResponder];
    [self showViewController:UPDATE_PASSWORD_VC_SEGUE_IDENTIFIER];
}
- (void)showViewController:(NSString *)identifier{
    [self performSegueWithIdentifier: identifier sender:self];
}
#pragma mark Timer
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired{
    
    if((currMinute>0 || currSeconds>=0) && currMinute>=0){
        if(currSeconds==0){
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
            {
            currSeconds-=1;
            }
        if(currMinute>-1)
            [self.progressLabel setTextWithAnimation:[NSString stringWithFormat:@"%d%@%02d",currMinute,@":",currSeconds]];
    }
    else{
        [self.resendButton setEnabled:YES];
        [timer invalidate];
    }
}
- (IBAction)resendButtonPressed:(id)sender {
   
    [self getVarificationCode];
}

#pragma mark- Webservices
-(void)getVarificationCode{
    [self.resendButton showLoading];
    NSMutableDictionary *paramers = [NSMutableDictionary new];
       [paramers setObject:self.email forKey:@"email"];
    [User verifiyEmailAddress:paramers completion:^(NSDictionary *JSON, NSString *error) {
        [self.resendButton hideLoading];
          if (error.isEmpty) {
              currMinute = 2;
              currSeconds=00;
              [self start];
              [self.codeField becomeFirstResponder];
              self.userId = JSON[RESULT][@"user_id"];
              self.verificatinCode = JSON[RESULT][@"code"];
          }else{
              [CommonFunctions showAlertWithTitel:@"" message:error inVC:self];
          }
    }];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        UpdatePasswordViewController *vc = (UpdatePasswordViewController *)[segue destinationViewController];
        vc.userId = self.userId;
    
}

@end
