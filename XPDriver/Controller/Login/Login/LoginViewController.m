//
//  LoginViewController.m
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "SZTextField.h"
#import "VerificationViewController.h"
#import "LoginViewController.h"
#import "XP_Driver-Swift.h"

#define PHONE_NUMBER_FIELD_PLACEHOLDER   @"Enter mobile number"
#define VERIFICETION_VC_SEGUE_IDENTIFIER @"showVarificationVC"
#define PASSWORD_VC_SEGUE_IDENTIFIER     @"ShowPasswordVC"
#define COUNTRY_PICKER_SEGUE_IDENTIFIER  @"ShowCountryPicker"



@interface LoginViewController ()<UITextFieldDelegate>
@property (assign, nonatomic)  BOOL isViewUp;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) RoundedButton *forgotButton;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emilTextField;
@property (strong, nonatomic) IBOutlet RoundedButton *loginButton;
@property (strong, nonatomic) IBOutlet RoundedButton *registerButton;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)logBtnPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
@end

@implementation LoginViewController
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = @[self.emilTextField,self.passwordField];
    [self.emilTextField addBorder];
    [self.passwordField addBorder];
    [self.emilTextField addLeftPading];
    [self.passwordField addLeftPading];
    [self.passwordField addEyeButton];
    [self addGusture];
    // Do any additional setup after loading the view.
    
#if TARGET_IPHONE_SIMULATOR
    [self.emilTextField setText:@"onmc2000@gmail.com"];
    [self.passwordField setText:@"pakistan"];
#endif
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)addGusture{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pgr];
}
- (void)handlePinch:(UITapGestureRecognizer *)pinchGestureRecognizer{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.isViewUp){
        [self animatetexfieldUp:YES];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.isViewUp){
        [self animatetexfieldUp:NO];
    }
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger selectedfiledindex = [self.textFields indexOfObject:textField];
    if (selectedfiledindex != self.textFields.count - 1) {
        [self.textFields[selectedfiledindex +1] becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (void) animatetexfieldUp: (BOOL) up
{
    if (!isiPhone5) {return;}
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        CGFloat ypostion = 46;
        if (up) {
            self.topConstraint.constant -= ypostion;
        }else{
            self.topConstraint.constant += ypostion;
        }
        [self.view layoutIfNeeded];
        _isViewUp = !_isViewUp;
    } completion:nil];
}
- (void)forgotButtonPressed{
    [self performSegueWithIdentifier:@"ShowForgotPasswordVC" sender:self];
}
- (IBAction)logBtnPressed:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![self validEmail:self.emilTextField.text]) {
        [CommonFunctions showAlertWithTitel:@"Invaild Email Adrress" message:@"Please enter a vaild email address" inVC:self];
        return;
    }
    [self userLogin:true];
    
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    
}
- (void)loginSetup{
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.passwordField setAlpha:1];
        [self.passwordField setHidden:NO];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
    }];
}
- (void)registerSetup{
    [UIView animateWithDuration:0.8 delay:0.4 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.passwordField setAlpha:0.0];
        [self.passwordField setHidden:YES];
        [self.loginButton setTitle:@"Next" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
    }];
}
- (void)setButton:(RoundedButton *)button titel:(NSString *)titel{
    [button setTitle:titel forState:UIControlStateNormal];
}

// this func calle using AFNetworking

//- (void)userLogin{
//    [self.loginButton showLoading];
//#if TARGET_IPHONE_SIMULATOR
//    SHAREMANAGER.deviceToken = @"8e975ab4843980014273f98fc99522696d4d546a6da34306a39f2ed683fc5e5a";
//#endif
//    if (!SHAREMANAGER.deviceToken) {
//        SHAREMANAGER.deviceToken = @"";
//    }
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
////    NSString *countryId  = SHAREMANAGER.appData.country.countryId;
//    [params setObject:@"driverLogin" forKeyedSubscript:@"command"];
//    [params setObject:self.emilTextField.text forKey:@"email"];
//    [params setObject:self.passwordField.text forKeyedSubscript:@"password"];
////    [params setObject:countryId forKey:@"country_id"];
////    [params setObject:ROLE_ID forKey:@"role_id"];
//      [params setObject:@"IOS" forKey:@"device_name"];
//     [params setObject:SHAREMANAGER.deviceToken forKey:@"device_id"];
//     [params setObject:appVersion forKey:@"app_version"];
//     [params setObject:[NSNumber numberWithInt:[User appId]] forKey:@"app_id"];
//   [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil) {
//            [self.loginButton hideLoading];
//            if ([json[@"success"] intValue] == 0) {
//                [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:self];
//                return;
//            }
//            NSDictionary *results=[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            [User save:results];
//            [self.navigationController setViewControllers:@[instantiateVC(CURRENTLOCATION)] animated:YES];
//        }else{
//            [self.loginButton hideLoading];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self userLogin];
//            }
//            else {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self];
//                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
//            }
//            
//        }
//    }];
//}

//- (NSString *)randomKey:(int)length {
//    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
//    
//    for (int i = 0; i < length; i++) {
//        u_int32_t randomIndex = arc4random_uniform((uint32_t)[letters length]);
//        unichar randomChar = [letters characterAtIndex:randomIndex];
//        [randomString appendFormat:@"%C", randomChar];
//    }
//    
//    return randomString;
//}

- (void)userLogin: (BOOL)checkSession  {
    [self.loginButton showLoading];
#if TARGET_IPHONE_SIMULATOR
    SHAREMANAGER.deviceToken = @"8e975ab4843980014273f98fc99522696d4d546a6da34306a39f2ed683fc5e5a";
#endif
    if (!SHAREMANAGER.deviceToken) {
        SHAREMANAGER.deviceToken = @"";
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    NSString *countryId  = SHAREMANAGER.appData.country.countryId;
    [params setObject:@"driverLogin" forKeyedSubscript:@"command"];
    [params setObject:self.emilTextField.text forKey:@"email"];
    [params setObject:self.passwordField.text forKeyedSubscript:@"password"];
    //    [params setObject:countryId forKey:@"country_id"];
    //    [params setObject:ROLE_ID forKey:@"role_id"];
    [params setObject:@"IOS" forKey:@"device_name"];
    [params setObject:SHAREMANAGER.deviceToken forKey:@"device_id"];
    [params setObject:appVersion forKey:@"app_version"];
    [params setObject:[NSNumber numberWithInt:[User appId]] forKey:@"app_id"];
    
    NSString *idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [params setObject:idString forKey:@"session_id"];
    
    [params setObject:[NSNumber numberWithInt:checkSession ? 1 : 0] forKey:@"check_active_session"];
    
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
     //                                           headers:@{@"Accept": @"application/json", @"Content-Type": @"application/json"}
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response userLogin JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil) {
            [self.loginButton hideLoading];
            if ([json[@"success"] intValue] == 0) {
                [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:self];
                return;
            } else if ([json[@"success"] intValue] == 2) {
                [self showYesNoAlert];
                return;
            }
            
            NSDictionary *results=[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            [self.navigationController setViewControllers:@[instantiateVC(CURRENTLOCATION)] animated:YES];
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            [self handleError:errorMsg];
        }
        
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
}

- (void)handleError:(NSString *)errorDescription {
    NSLog(@"Error: %@", errorDescription);
    [self.loginButton hideLoading];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([ErrorFunctions isError:errorDescription]) {
        [self userLogin:true];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        // NSLog(@"Error is %@", [json objectForKey:@"error"]);
    }
}

- (void)showYesNoAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                             message:@"You are already logged in on another device.\nDo you want to login here?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // "Yes" action
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        // Code to handle "Yes" response
        NSLog(@"User pressed Yes");
        [self userLogin:false];
    }];
    
    // "No" action
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
        // Code to handle "No" response
        NSLog(@"User pressed No");
    }];
    
    // Add actions to the alert controller
    [alertController addAction:yesAction];
    [alertController addAction:noAction];
    
    // Present the alert
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (void)userRegister{
//    [self.loginButton showLoading];
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *countryId  = SHAREMANAGER.appData.country.countryId;
//    [params setObject:@"sms" forKeyedSubscript:@"command"];
//    [params setObject:self.numberWithCountryCode forKey:@"mobile"];
//    [params setObject:countryId forKey:@"country_id"];
//    [params setObject:@"IOS" forKey:@"device_name"];
//    [params setObject:ROLE_ID forKey:@"role_id"];
//    [params setObject:SHAREMANAGER.deviceToken forKey:@"device_id"];
//    [params setObject:appVersion forKey:@"app_version"];
//    [[NetworkHelper sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
//        if (![json objectForKey:@"error"]&&json!=nil) {
//            [self.loginButton hideLoading];
//            NSDictionary *results = [json objectForKey:@"result"];
//            if (strEquals(results[@"status"],@"error")) {
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:results[@"messages"] inVC:self];
//                return;
//            }
//            if (strEquals(results[@"user"],@"Exist")) {
//                self.userId = results[@"id"];
//                [CommonFunctions showAlertWithTitel:@"Already Exists" message:strFormat(@"This number %@  is already registered, please choose a different mobile number",self.phoneNumber) inVC:self];
//            }else{
//                //DLog(@"results :%@",results);
//                self.verificatinCode = strFormat(@"%@",results[@"code"]);
//                [self showVerificationCodeViewController];
//            }
//
//        }else{
//            [self.loginButton hideLoading];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self userRegister];
//            }
//            else {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self];
//                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
//            }
//
//        }
//    }];
//}
- (void)showVerificationCodeViewController{
    [self performSegueWithIdentifier:VERIFICETION_VC_SEGUE_IDENTIFIER sender:self];
}

-(BOOL)validEmail:(NSString*)emailStr{
    if(emailStr.isEmpty){
        return false;
        
    }
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    if(![emailTest evaluateWithObject:emailStr])
    {
        return false;
    }
    return TRUE;
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
