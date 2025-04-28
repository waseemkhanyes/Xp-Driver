//
//  BankAccountViewController.m
//  XPDriver
//
//  Created by Syed zia on 08/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#define Titel_lenght    36
#define IBAN_lenght     36
#define BSB_Lenght       6

#import "AddressSelectionViewController.h"
#import "CountrySelectionViewController.h"
#import "BankAccountViewController.h"
#import "XP_Driver-Swift.h"

@interface BankAccountViewController ()<AddressViewControllerDelegate>

@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL isViewUp;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) NSArray *textFields;

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (nonatomic,strong)  MyLocation *slectedAddress;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *dobField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *stateField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cityField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *postalCodeField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *bankNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *accountTypeField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *bankTransitNumberField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *institutionNamberField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *accountNumberField;
@property (strong, nonatomic) IBOutlet RoundedButton *updateButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet ShadowView *baseView;


- (IBAction)updateButtonPressed:(id)sender;


@end

@implementation BankAccountViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Bank account";
    [self setup];
    
}
- (void)setup{
    self.textFields = @[self.firstNameField,self.lastNameField,self.dobField,self.emailField,self.addressField,self.stateField,self.cityField,self.postalCodeField,self.bankNameField,self.accountTypeField,self.bankTransitNumberField,self.institutionNamberField,self.accountNumberField];
    self.user    = SHAREMANAGER.user;
    self.accountNumberField.isAllowValidate = !self.isIBAN;
    [self.stateField setHidden:YES];
    [self.cityField setHidden:YES];
    [self.postalCodeField setHidden:YES];
    if (self.isIBAN) {
        [self.institutionNamberField setHidden:YES];
        [self.bankTransitNumberField setHidden:YES];
        [self.accountNumberField setPlaceholder:@"IBAN"];
    }
    if (self.selectedCountry.isCanada) {
        [self.stateField setPlaceholder:@"State/Prov"];
        [self.postalCodeField setPlaceholder:@"Postal code"];
        [self.cityField setPlaceholder:@"City"];
        [self.bankTransitNumberField setPlaceholder:@"Bank Transit (5-9 digits)"];
        [self.bankTransitNumberField setHidden:NO];
    }else if (self.selectedCountry.isUSA) {
        [self.institutionNamberField setHidden:NO];
        [self.stateField setPlaceholder:@"State/Prov"];
        [self.postalCodeField setPlaceholder:@"Postcode"];
        [self.bankTransitNumberField setPlaceholder:@"Routing (6 digits)"];
        [self.cityField setPlaceholder:@"City"];
    }else if (self.selectedCountry.isUK) {
        [self.institutionNamberField setHidden:YES];
        [self.stateField setPlaceholder:@"State/Prov"];
        [self.postalCodeField setPlaceholder:@"Postcode"];
        [self.cityField setPlaceholder:@"City"];
        [self.bankTransitNumberField setPlaceholder:@"Sort"];
        [self.bankTransitNumberField setPlaceholder:@"Routing (6 digits)"];
    }
    [self removeCountrySelectionViewControllerFromStak];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
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
- (BOOL)isOldInfo{
    return NO;
    // return [self.bankNameField.text isEqualToString:self.user.accountTitle] && [self.accountNumberField.text isEqualToString:self.user.accountNumber] && [self.bsbNumberField.text isEqualToString:self.user.bsbNumber];
}
- (void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma mark- UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ACFloatingTextField *activeTextField = (ACFloatingTextField *)textField;
    if (activeTextField == self.addressField) {
        [self performSelector:@selector(showAddressSelectionVC) withObject:nil afterDelay:0.2];
        // return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == self.bankTransitNumberField) {
        return (newLength > 9) ? NO : YES;
    }else if (textField == self.institutionNamberField) {
        return (newLength > KInstitutionNumberLenght) ? NO : YES;
    }else if (textField == self.accountNumberField ) {
        NSString *accountString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (self.isIBAN) {
            if ([accountString isEqualToString:self.selectedCountry.iso_code_2]) {
                return  NO;
            }
            return YES;
        }else{
            return (newLength > KAccountNumberLenght) ? NO : YES;
        }
        
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.accountNumberField && self.isIBAN) {
        textField.text = self.selectedCountry.iso_code_2;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger selectedfiledindex = [self.textFields indexOfObject:textField];
    if (selectedfiledindex != self.textFields.count - 1) {
        [self.textFields[selectedfiledindex + 1] becomeFirstResponder];
    }else{
        [self updateButtonPressed:self];
    }
    return YES;
}
- (BOOL)isAllTextFieldsValid{
    NSMutableArray *validTetxFields = [NSMutableArray new];
    for (ACFloatingTextField *tf in self.textFields) {
        [tf resignFirstResponder];
    }
    for (ACFloatingTextField *tf in self.textFields) {
        if (!tf.isVaild && tf.isHidden == false) {
            if (tf == self.addressField) {
                if (self.addressField.text.isEmpty) {
                    [validTetxFields addObject:tf];
                }
            }else{
                [validTetxFields addObject:tf];
            }
            
        }
    }
    return validTetxFields.count == 0;
}
- (void)showAddressSelectionVC{
    [self performSegueWithIdentifier:@"ShowAddressSelectionView" sender:self];
}
- (IBAction)updateButtonPressed:(id)sender {
    [self.view endEditing:YES];
    
    if (!self.isAllTextFieldsValid) {return;}
    if ([self isOldInfo]) {
        [self showAlertWithMessage:@"You didn't add or change any information." alertType:KAlertTypeInfo];
        return;
    }
    [self updateBankAccountInfo];
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
- (NSMutableDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"addBankAccount" forKey:@"command"];
    [params setObject:self.firstNameField.text forKey:@"first_name"];
    [params setObject:self.lastNameField.text forKey:@"last_name"];
    [params setObject:self.emailField.text forKey:@"email"];
    [params setObject:self.dobField.text forKey:@"dob"];
    [params setObject:self.addressField.text forKey:@"address"];
    [params setObject:self.stateField.text forKey:@"state_name"];
    [params setObject:self.cityField.text forKey:@"city_name"];
    [params setObject:self.postalCodeField.text forKey:@"postal_code"];
    [params setObject:self.bankNameField.text forKey:@"bank_name"];
    DLog(@"** wk accountType: %@", self.accountTypeField.text);
    DLog(@"** wk accountType: %@", self.selectedCurrency);
    [params setObject:self.accountTypeField.text forKey:@"account_type"];
    [params setObject:self.accountNumberField.text forKey:@"account_number"];
    [params setObject:self.selectedCountry.countryID forKey:@"country_id"];
    [params setObject:self.selectedCurrency.name forKey:@"user_currency"];
    [params setObject:self.user.userId forKey:@"user_id"];
    if (self.isIBAN) {
        [params setObject:@"1" forKey:@"IBAN"];
    }else{
        [params setObject:self.institutionNamberField.text  forKey:@"institution_number"];
        [params setObject:self.bankTransitNumberField.text forKey:@"bank_transit_number"];
    }
    //    if (self.selectedCountry.isCanada) {
    //        [params setObject:self.institutionNamberField.text  forKey:@"institution_number"];
    //    }
    return params;
}
//- (void)updateBankAccountInfo{
//
//    [self.updateButton showLoading];
//    [NetworkController apiPostWithParameters:self.parameters Completion:^(NSDictionary *json, NSString *error) {
//        if (![json objectForKey:@"error"]&&json!=nil && json[@"data"] != nil) {
//            if ( [json[@"success"] intValue] == 0){
//                [self.updateButton hideLoading];
//                [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
//            }else{
//                [self fetchProfileDetail:json[@"msg"]];
//            }
//
//        }else{
//            NSString *errorMsg =[json objectForKey:@"error"];
//            [self showAlertWithMessage:errorMsg alertType:KAlertTypeInfo];
//
//        }
//    }];
//}

- (void)updateBankAccountInfo{
    
    [self.updateButton showLoading];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:self.parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil && json[@"data"] != nil) {
            if ( [json[@"success"] intValue] == 0){
                [self.updateButton hideLoading];
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
        [self.updateButton hideLoading];
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
//                 [self.navigationController popViewControllerAnimated:true];
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
                                        parameters:self.parameters
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
        NSString *errorMsg = error.localizedDescription;
        DLog(@"errorMsg %@",errorMsg);
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
