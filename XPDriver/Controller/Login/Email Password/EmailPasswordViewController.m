//
//  EmailPasswordViewController.m
//  XPDriver
//
//  Created by Syed zia on 30/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "WebViewController.h"
#import "XP_Driver-Swift.h"
#import "EmailPasswordViewController.h"

@interface EmailPasswordViewController ()<ZSWTappableLabelTapDelegate>
@property (assign, nonatomic)  int isAgreed;
@property (assign, nonatomic)  BOOL isViewUp;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) IBOutlet ZSWTappableLabel *termsLable;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *currencyField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *passwordField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *confirmPasswordField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *referralCodeField;
@property (strong, nonatomic) IBOutlet RoundedButton *suubmitButton;
@property (strong, nonatomic) IBOutlet UIButton *tremsButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)tremsButtonPressed:(UIButton *)sender;
- (IBAction)registeButtonPressed:(UIButton *)sender;

@end

@implementation EmailPasswordViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgreed = 0;
    self.currencyField.selectedCurrency = @"CAD";
    self.textFields = @[self.emailField,self.currencyField,self.passwordField,self.confirmPasswordField,self.referralCodeField];
    [self setTermsText];
    // Do any additional setup after loading the view.
}
#pragma mark UITextField delegate methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.isViewUp) {
        [self animatetexfieldUp:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
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
- (BOOL)isAllTextFieldsValid{
    if (!self.currencyField.isVaild) {
        [CommonFunctions showAlertWithTitel:@"Currency Missing" message:@"Please select currency" inVC:self];
         return NO;
    }else if (!self.emailField.isEmpty) {
      
        BOOL isPasswordMatch = strEquals(self.passwordField.text, self.confirmPasswordField.text);
        
        if (!isPasswordMatch) {
            [self.passwordField addimageToTextfield:isPasswordMatch ? RIGHT_IMAGE : WRONG_IMAGE];
            [self.confirmPasswordField addimageToTextfield:isPasswordMatch ? RIGHT_IMAGE : WRONG_IMAGE];
            [CommonFunctions showAlertWithTitel:@"Mismatched Password" message:@"Password and confirm password doesn’t match." inVC:self];
             return NO;
        }
         if (self.emailField.isVaild  && self.passwordField.isVaild && self.confirmPasswordField.isVaild) {

            return  isPasswordMatch;
        }else{
            return NO;
        }
    }else if (self.passwordField.isVaild && self.confirmPasswordField.isVaild) {
        return strEquals(self.passwordField.text, self.passwordField.text);
    }else if (self.isAgreed == 0) {
        [CommonFunctions showAlertWithTitel:@"Terms & Conditions" message:@"Please indicate that you have read and agree to these Terms & Conditions and Privacy Policy" inVC:self];
        return NO;
    }
    return NO;
}

- (void) animatetexfieldUp: (BOOL) up
{
    if (!isiPhone5) {return;}
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        CGFloat ypostion = 106;
        if (up) {
            self.topConstraint.constant -= ypostion;
        }else{
            self.topConstraint.constant += ypostion;
        }
        [self.view layoutIfNeeded];
        _isViewUp = !_isViewUp;
    } completion:nil];
}
-(void)setTermsText{
    NSString *termsText = @"I accept the <link type='terms'>Terms & Conditions</link>.";
    ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
    [options setDynamicAttributes:^NSDictionary *(NSString *tagName,
                                                  NSDictionary *tagAttributes,
                                                  NSDictionary *existingStringAttributes) {
        NSString *action;
        if ([tagAttributes[@"type"] isEqualToString:@"terms"]) {
            action = @"terms";
        }
        return @{
                 ZSWTappableLabelTappableRegionAttributeName: @YES,
                 ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor appBlackColor],
                 ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor appBlackColor],
                 NSForegroundColorAttributeName: [UIColor appBlackColor],
                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                 @"action": action
                 };
    } forTagName:@"link"];
     NSAttributedString *attributedString = [[ZSWTaggedString stringWithString:termsText] attributedStringWithOptions:options];
    [self.termsLable setAttributedText:attributedString];
    self.termsLable.tapDelegate = self;
}
- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes {
    NSURL *URL;
    
    NSTextCheckingResult *result = attributes[TextCheckingResultAttributeName];
    NSString *action = attributes[@"action"];
    if ([result isKindOfClass:[NSTextCheckingResult class]]) {
        switch (result.resultType) {
            case NSTextCheckingTypeAddress:
                NSLog(@"Address components: %@", result.addressComponents);
                break;
                
            case NSTextCheckingTypePhoneNumber: {
                NSURLComponents *components = [[NSURLComponents alloc] init];
                components.scheme = @"tel";
                components.host = result.phoneNumber;
                URL = components.URL;
                break;
            }
                
            case NSTextCheckingTypeDate:
                NSLog(@"Date: %@", result.date);
                break;
                
            case NSTextCheckingTypeLink:
                URL = result.URL;
                break;
                
            default:
                break;
        }
    }
    if (strEquals(action, @"terms")) {
        [self showWebViewController];
    }
    
}
- (void)showWebViewController{
    [self performSegueWithIdentifier:WebView_Idintifire sender:self];
}

- (void)setRegisterParameters{
    [[RegisterController share].registerParametrs setObject:self.emailField.text forKey:@"email"];
    [[RegisterController share].registerParametrs setObject:self.passwordField.text forKey:@"password"];
    [[RegisterController share].registerParametrs setObject:self.currencyField.text forKey:@"currency"];
    if (!self.referralCodeField.isEmpty) {
         [[RegisterController share].registerParametrs setObject:self.referralCodeField.text forKeyedSubscript:@"refference_name"];
     }
    [[RegisterController share].registerParametrs setObject:[NSString stringWithFormat:@"%@",@(self.isAgreed)] forKey:@"agree"];
    DLog(@"RegisterController share].registerParametrs %@",[RegisterController share].registerParametrs);
}

- (IBAction)registeButtonPressed:(UIButton *)sender{
     [self.view endEditing:YES];
    if (_isViewUp) {[self animatetexfieldUp:NO];}
   
  if (!self.isAllTextFieldsValid) {return;}
    [self setRegisterParameters];
     [self registerUser];
}
- (IBAction)tremsButtonPressed:(UIButton *)sender {
    [sender setImage:sender.isChecked ? UNCHECKEDE_BTN_IMAGE : CHECKEDE_BTN_IMAGE forState:UIControlStateNormal];
    self.isAgreed = sender.isChecked ? 1 : 0;
}
//- (void)registerUser{
//    [self.suubmitButton showLoading];
//    NSMutableDictionary *params = [RegisterController share].registerParametrs;
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        [self.suubmitButton hideLoading];
//        if (![json objectForKey:@"error"]&&json!=nil) {
//            if ([json[@"success"] intValue] == 0) {
//                [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:self];
//                return;
//            }
//            [CommonFunctions showAlertWithTitel:@"Congratulations!" message:json[@"msg"] inVC:self completion:^(BOOL success) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
//        }else{
//            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
//            [self.suubmitButton hideLoading];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self registerUser];
//            }
//            else {
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self];
//                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
//            }
//            
//        }
//    }];
//}
- (void)registerUser{
    [self.suubmitButton showLoading];
    NSMutableDictionary *params = [RegisterController share].registerParametrs;
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response registerUser JSON: %@", json);
        [self.suubmitButton hideLoading];
        if (![json objectForKey:@"error"]&&json!=nil) {
            if ([json[@"success"] intValue] == 0) {
                [CommonFunctions showAlertWithTitel:@"" message:json[@"msg"] inVC:self];
                return;
            }
            [CommonFunctions showAlertWithTitel:@"Congratulations!" message:json[@"msg"] inVC:self completion:^(BOOL success) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [self handleError:[json objectForKey:@"error"]];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self.suubmitButton hideLoading];
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
}

- (void)handleError:(NSString *)errorDescription {
    NSLog(@"Error: %@", errorDescription);
    [self.suubmitButton hideLoading];
    
    if ([ErrorFunctions isError:errorDescription]){
        [self registerUser];
    }
    else {
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([segue.identifier isEqualToString:WebView_Idintifire]) {
        WebViewController*WVC = (WebViewController *)[segue destinationViewController];
       WVC.webUrl = SHAREMANAGER.appData.tremsURL;
        
    }
}



@end
