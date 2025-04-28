//
//  ForgotPasswordViewController.m
//  XPDriver
//
//  Created by Syed zia on 11/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "VerificationViewController.h"
#import "UpdatePasswordViewController.h"
#import "ForgotPasswordViewController.h"
#define KByEmail  @"Reset by email"
#define KByPhone  @"Reset by phone"

@interface ForgotPasswordViewController ()<UITextFieldDelegate,CountryCodeViewDelegate,EMCCountryDelegate>
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) BOOL isByEmail;
@property (assign, nonatomic) NSString *countryCode;
@property (strong, nonatomic) EMCCountry *selectedCountry;
@property (strong, nonatomic) CountryCodeView *countryCodeView;
@property (strong, nonatomic) IBOutlet UIButton *resetByEmail;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailField;
@property (strong, nonatomic) IBOutlet RoundedButton *submitButton;
- (IBAction)submitButtonPressed:(RoundedButton *)sender;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countryCode = SHAREMANAGER.appData.country.countryCode;
    self.selectedCountry = [[EMCCountryManager countryManager] getCountryFromName:SHAREMANAGER.appData.country.name];
    self.countryCodeView = [[[NSBundle mainBundle] loadNibNamed:@"CountryCodeView" owner:self options:nil] firstObject];
    self.countryCodeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.countryCodeView configerWithCountry:self.selectedCountry delegate:self];
    self.emailField.leftView = self.countryCodeView;
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   /// [self.submitButton setEnabled:textField.text.length > 0];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
}
- (IBAction)resetByEmailButtonPressed:(UIButton *)sender {
    [self.emailField resignFirstResponder];
    self.emailField.text = nil;
    self.emailField.rightView = nil;
    BOOL isEmail = [sender.currentTitle isEqualToString:KByEmail];
    NSString *title = isEmail ?  KByPhone : KByEmail;
    [self.resetByEmail setTitle:title forState:UIControlStateNormal];
    self.emailField.mode = isEmail ? Email : Phone;
    if (!self.emailField.isFirstResponder) {
        self.emailField.placeholder = isEmail ? @"Email" : @"Phone";
    }else{
        self.emailField.placeholder = nil;
    }
    self.isByEmail = self.emailField.mode == Email;
    self.emailField.leftView = self.isByEmail ?  nil : self.countryCodeView ;
    self.emailField.leftViewMode = self.isByEmail ? UITextFieldViewModeNever : UITextFieldViewModeAlways;
    
}
//- (IBAction)resetByEmailButtonPressed:(UIButton *)sender {
//    [self.view endEditing:true];
//    self.emailField.text = nil;
//    self.emailField.rightView = nil;
//    self.phoneField.text = nil;
//    self.phoneField.rightView = nil;
//    BOOL isRestByEmail = [sender.currentTitle isEqualToString:KByEmail];
//    NSString *title = isRestByEmail ?  KByPhone : KByEmail;
//    [self.resetByEmail setTitle:title forState:UIControlStateNormal];
//    BOOL isEmail = [self.resetByEmail.currentTitle  isEqualToString:KByEmail];
//    self.emailField.hidden = !isEmail;
//    self.phoneField.hidden = isEmail;
//}
- (IBAction)submitButtonPressed:(RoundedButton *)sender {
    [self.emailField resignFirstResponder];
    if (self.emailField.isVaild) {
        [self verifiyEmailAddress];
    }
}
- (void)verifiyEmailAddress{
    [self.submitButton showLoading];
    NSMutableDictionary *paramers = [NSMutableDictionary new];
    NSString *command = self.isByEmail ? @"userCheckForForgotPassword" : @"getUserByPhone";
    NSString *byKey = self.isByEmail ? @"email" : @"phone";
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@",self.selectedCountry.dialingCode,self.emailField.text];
    // 14167045449
    NSString *phoneOrEmail = self.isByEmail ? self.emailField.text : [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [paramers setObject:phoneOrEmail forKey:byKey];
    [paramers setObject:command forKey:@"command"];
    [paramers setObject:ROLE_ID forKey:@"usertype"];
 [User verifiyEmailAddress:paramers completion:^(NSDictionary *JSON, NSString *error) {
       [self.submitButton hideLoading];
         if (error.isEmpty) {
             self.userId = JSON[@"data"][@"user_id"];
             self.code = [NSString stringWithFormat:@"%@",JSON[@"data"][@"code"]];
             [CommonFunctions  showAlertWithTitel:@"Verification" message:[NSString stringWithFormat:@"Verification code sent to you via %@.",self.isByEmail ? @"Email" : @"SMS"] inVC:self completion:^(BOOL success) {
                 [self performSegueWithIdentifier:@"ShowVerificationVC" sender:self];
             }];
             
         }else{
             [CommonFunctions showAlertWithTitel:@"" message:error inVC:self];
         }
   }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[VerificationViewController class]]) {
        VerificationViewController *vc = (VerificationViewController *)[segue destinationViewController];
        vc.userId = self.userId;
        vc.email  = self.emailField.text;
        vc.verificatinCode = self.code;
    }else if ([[segue identifier] isEqualToString:KCountryPickerIdentifier]) {
        UINavigationController *NVC = (UINavigationController *)[segue destinationViewController];
        CountryPickerViewController *vc = NVC.viewControllers[0];
        vc.delegate = self;
        vc.selectedCountry = self.selectedCountry;
    }
}

- (void)showCountryPicker {
    [self performSegueWithIdentifier:KCountryPickerIdentifier sender:self];
}

- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCountry {
    self.selectedCountry = chosenCountry;
    [self.countryCodeView updateUI:self.selectedCountry];
}


@end
