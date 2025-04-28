//
//  CreditDebitViewController.m
//  XPFood
//
//  Created by syed zia on 25/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//

#import "SZTextField.h"
#import "CountrySelectionViewController.h"
#import "AddressSelectionViewController.h"
#import "CreditDebitViewController.h"
#import "XP_Driver-Swift.h"

@import  Stripe;
@interface CreditDebitViewController ()<AddressViewControllerDelegate>

@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) NSArray *textFields;

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (nonatomic,strong)  MyLocation *slectedAddress;
@property (strong, nonatomic) NSString* stripeToken;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *dobField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *stateField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cityField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *postalCodeField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *bankNameField;
@property (strong, nonatomic) IBOutlet SZTextField* cardNumberField;
@property (strong, nonatomic) IBOutlet SZTextField* expirationDateTextField;
@property (strong, nonatomic) IBOutlet SZTextField* CVCNumberField;
@property (strong, nonatomic) IBOutlet RoundedButton *updateButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation CreditDebitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"** selectedCountry: %@", self.selectedCountry.name);
    DLog(@"** SHAREMANAGER.requiredStripKeyNew: %@", [SHAREMANAGER getStripeKeyAsPerCountry:self.selectedCountry.name]);
//    DLog(@"** SHAREMANAGER.requiredStripKey: %@", SHAREMANAGER.requiredStripKey);
//    NSString *stripeKey = SHAREMANAGER.requiredStripKey;
    NSString *stripeKey = [SHAREMANAGER getStripeKeyAsPerCountry:self.selectedCountry.name];
    [StripeAPI setDefaultPublishableKey:stripeKey];
    self.textFields = @[self.firstNameField,self.lastNameField,self.dobField,self.emailField,self.addressField,self.stateField,self.cityField,self.postalCodeField,self.bankNameField,self.cardNumberField,self.expirationDateTextField,self.CVCNumberField];

       self.user    = SHAREMANAGER.user;

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.CVCNumberField setBottomBorder];
    [self.expirationDateTextField setBottomBorder];
    [self.cardNumberField setBottomBorder];
}

- (void)removeCountrySelectionViewControllerFromStak{
    NSMutableArray * viewcontrollers = [NSMutableArray arrayWithArray:[self.navigationController.viewControllers copy]];
    for (id vc in viewcontrollers) {
        if ([vc isKindOfClass:[CountrySelectionViewController class]]) {
            [viewcontrollers removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = viewcontrollers;
}
#pragma mark- UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ACFloatingTextField *activeTextField = (ACFloatingTextField *)textField;
    if (activeTextField == self.addressField) {
        [self performSelector:@selector(showAddressSelectionVC) withObject:nil afterDelay:0.2];
      return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == self.cardNumberField) {
        if (newLength == 17) {
            [self.expirationDateTextField becomeFirstResponder];
        }
        return (newLength > 16) ? NO : YES;
    }else if (textField == self.expirationDateTextField){
        [self.CVCNumberField becomeFirstResponder];
    }else if (textField == self.CVCNumberField) {
        if (newLength == 4) {
            [self.CVCNumberField resignFirstResponder];
        }
        return (newLength > 3) ? NO : YES;

    }

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger selectedfiledindex = [self.textFields indexOfObject:textField];
    if (selectedfiledindex != self.textFields.count - 1) {
        [self.textFields[selectedfiledindex + 1] becomeFirstResponder];
    }else{

    }
    return YES;
}
- (BOOL)isAllTextFieldsValid{
    NSMutableArray *validTetxFields = [NSMutableArray new];
    for (UITextField *tf in self.textFields) {
        [tf resignFirstResponder];
    }
    for (UITextField *tf in self.textFields) {
        if ([tf isKindOfClass:[ACFloatingTextField class]]) {
            ACFloatingTextField *field = (ACFloatingTextField *)tf;
            if (!field.isVaild && field.isHidden == false) {
                if (tf == self.addressField) {
                    if (self.addressField.text.isEmpty) {
                        [validTetxFields addObject:tf];
                    }
                }else{
                    [validTetxFields addObject:tf];
                }

            }
        }
        else  if ([tf isKindOfClass:[SZTextField class]]) {
            SZTextField *field = (SZTextField *)tf;
            if (field.text.length == 0) {
                [validTetxFields addObject:field];

            }
        }

    }
    return validTetxFields.count == 0;
}
- (void)showAddressSelectionVC{
    [self performSegueWithIdentifier:@"ShowAddressSelectionView" sender:self];
}
#pragma mark - AddressViewControllerDelegate -
- (void)setSelectedAddress:(MyLocation *)address{
    self.slectedAddress = address;
    [self.addressField setText:self.slectedAddress.address];
    [self.stateField setText:self.slectedAddress.state];
    [self.cityField setText:self.slectedAddress.city];
    [self.postalCodeField setText:self.slectedAddress.postalCode];

    // Validation
    [self.addressField resignFirstResponder];
    [self.stateField resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self.postalCodeField resignFirstResponder];
    [self.stateField setHidden:NO];
    [self.cityField setHidden:NO];
    [self.postalCodeField setHidden:NO];
    [self.addressField setIsVaild:!self.addressField.isEmpty];
    [self.stateField setIsVaild:!self.stateField.isEmpty];
    [self.cityField setIsVaild:!self.cityField.isEmpty];
    [self.postalCodeField setIsVaild:!self.postalCodeField.isEmpty];

}
- (BOOL)isOldInfo{
    return NO;
   // return [self.bankNameField.text isEqualToString:self.user.accountTitle] && [self.accountNumberField.text isEqualToString:self.user.accountNumber] && [self.bsbNumberField.text isEqualToString:self.user.bsbNumber];
}
- (IBAction)updateButtonPressed:(id)sender {
    [self.view endEditing:YES];

    if (!self.isAllTextFieldsValid) {return;}
    if ([self isOldInfo]) {
        [self showAlertWithMessage:@"You didn't add or change any information." alertType:KAlertTypeInfo];
        return;
    }
    [self getStripeToken];
}
- (NSMutableDictionary *)parameters{

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"addDebitCardBankAccount" forKey:@"command"];
    [params setObject:self.firstNameField.text forKey:@"first_name"];
    [params setObject:self.lastNameField.text forKey:@"last_name"];
    [params setObject:self.emailField.text forKey:@"email"];
    [params setObject:self.dobField.text forKey:@"dob"];
    [params setObject:self.addressField.text forKey:@"address"];
    [params setObject:self.stateField.text forKey:@"state_name"];
    [params setObject:self.cityField.text forKey:@"city_name"];
    [params setObject:self.stateField.text forKey:@"state_name"];
    //[params setObject:self.bankNameField.text forKey:@"bank_name"];
    [params setObject:self.postalCodeField.text forKey:@"postal_code"];
    [params setObject:self.stripeToken forKey:@"cardToken"];
    [params setObject:self.selectedCountry.countryID forKey:@"country_id"];
    [params setObject:self.user.userId forKey:@"user_id"];
    [params setObject:@"9" forKey:@"app_id"];
    
//    DLog(@"** wk month: %@", self.expirationDateTextField.text);
//    NSArray *components = [self.expirationDateTextField.text componentsSeparatedByString:@"/"];
//
//    if (components.count >= 2) {
//        [params setObject:components[0] forKey:@"exp_month"];
//        [params setObject:components[1] forKey:@"exp_year"];
//    }
//        
//    [params setObject:self.cardNumberField.text forKey:@"card_number"];
////    [params setObject:self.expirationDateTextField.text forKey:@"exp_month"];
////    [params setObject:self.expirationDateTextField.text forKey:@"exp_year"];
//    [params setObject:self.CVCNumberField.text forKey:@"cvc"];
    return params;
}

- (void)getStripeToken{
    
    DLog(@"** wk self.selectedCountry.name %@", self.selectedCountry.name);
    NSString *currency = @"CAD";
    if (![self.selectedCountry.name isEqualToString:@"Canada"]) {
        currency = @"USD";
    }
    DLog(@"** wk currency %@", currency);
    
    
    [self.updateButton showLoading];
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    NSArray *expDate    = [self.expirationDateTextField.text componentsSeparatedByString:@"/"];
    cardParams.number   = self.cardNumberField.text;
    cardParams.expMonth = [expDate[0] intValue];
    cardParams.expYear  = [expDate[1] intValue];;
    cardParams.cvc      = self.CVCNumberField.text;
    cardParams.currency = currency;// self.selectedCurrency.name;
    DLog(@"** wk cardParams.Currency %@", currency);
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
        if (token == nil || error != nil) {
            [self.updateButton hideLoading];
            // Present error to user...
            [self showAlertWithMessage:error.localizedDescription alertType:KAlertTypeInfo];
            return;
        }
        STPCard *card = token.card;
        NSString *brandName = [STPCard stringFromBrand:card.brand];
        DLog(@"Card Info %@,%@,%@,%@",card.last4,brandName,@(card.expYear).stringValue,@(card.expMonth).stringValue);
        DLog(@"\nCard token: %@\n",token.tokenId);
        self.stripeToken = token.tokenId;
      //  [self.updateButton hideLoading];
       [self updateCardInfo];
    }];
}
//- (void)updateCardInfo{
//
//    [NetworkController apiPostWithParameters:self.parameters Completion:^(NSDictionary *json, NSString *error) {
//        [self.updateButton hideLoading];
//        if (![json objectForKey:@"error"]&&json!=nil && json[@"data"] != nil) {
//            if ( [json[@"success"] intValue] == 0){
//                [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
//            }else{
//                [self fetchProfileDetail:json[@"msg"]];
//            }
//        }else{
//            NSString *errorMsg =[json objectForKey:@"error"];
//            [self showAlertWithMessage:errorMsg alertType:KAlertTypeInfo];
//
//        }
//    }];
//}

- (void)updateCardInfo{

    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:self.parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        [self.updateButton hideLoading];
        if (![json objectForKey:@"error"]&&json!=nil && json[@"data"] != nil) {
            if ( [json[@"success"] intValue] == 0){
                [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
            }else{
                [self fetchProfileDetail:json[@"msg"]];
            }
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            [self showAlertWithMessage:errorMsg alertType:KAlertTypeInfo];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self showAlertWithMessage:error.localizedDescription alertType:KAlertTypeInfo];
    }];
}

//-(void)fetchProfileDetail:(NSString *)message{
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.user.userId,@"user_id",ROLE_ID,@"role_id", nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//     NSArray *results  =[json objectForKey:@"data"];
//     if (![json objectForKey:@"error"] && json!=nil && results.count != 0) {
//         [self.updateButton hideLoading];
//         NSDictionary *results =[[json objectForKey:@"data"] dictionaryByReplacingNullsWithBlanks];
//         [User save:results];
//         self.user    = SHAREMANAGER.user;
//         [self showAlertWithMessage:message alertType:KAlertTypeInfo completion:^(BOOL success) {
//           if (success) {
//               [self removeCountrySelectionViewControllerFromStak];
//               [self.navigationController popViewControllerAnimated:true];
//             }
//         }];
//         }else{
//             NSString *errorMsg =[json objectForKey:@"error"];
//             DLog(@"errorMsg %@",errorMsg);
//         }
//
//     }];
//
//
//}

-(void)fetchProfileDetail:(NSString *)message{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.user.userId,@"user_id",ROLE_ID,@"role_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        NSArray *results  =[json objectForKey:@"data"];
        if (![json objectForKey:@"error"] && json!=nil && results.count != 0) {
            [self.updateButton hideLoading];
            NSDictionary *results =[[json objectForKey:@"data"] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            self.user    = SHAREMANAGER.user;
            [self showAlertWithMessage:message alertType:KAlertTypeInfo completion:^(BOOL success) {
              if (success) {
                  [self removeCountrySelectionViewControllerFromStak];
                  [self.navigationController popViewControllerAnimated:true];
                }
            }];
            }else{
                NSString *errorMsg =[json objectForKey:@"error"];
                DLog(@"errorMsg %@",errorMsg);
            }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
    }];


}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue destinationViewController] isKindOfClass:[AddressSelectionViewController class]]) {
       AddressSelectionViewController *asVC = (AddressSelectionViewController *)[segue destinationViewController];
       asVC.delegate = self;
     asVC.selectedCountry = self.selectedCountry;
    if (self.addressField.text.length > 0) {
        asVC.selectedAddress = [[MyLocation alloc] initWithAddress:self.addressField.text coordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
    }



   }
}
@end
