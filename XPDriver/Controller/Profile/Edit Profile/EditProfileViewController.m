//
//  EditProfileViewController.m
//  XPDriver
//
//  Created by Syed zia on 05/01/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#import "DatePickerViewController.h"
#import "AddressSelectionViewController.h"
#import "EditProfileViewController.h"
#import "XP_Driver-Swift.h"

@interface EditProfileViewController ()<DatePickerViewControllerDelegate,AddressViewControllerDelegate>
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL isViewUp;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) NSDate *dobDate;
@property (strong, nonatomic) NSDate *expiryDate;
@property (assign, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSMutableArray *textFields;
@property (nonatomic,assign)  UIDatePickerMode pickerMode;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) ACFloatingTextField *activeField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *dobField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *phoneField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cnicField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *drivingLicenseField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *drivingLicenseExpiryDateField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *addressField;
@property (strong, nonatomic) IBOutlet RoundedButton *updateButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)updateButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;

@end

@implementation EditProfileViewController

- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataSteup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToHome)
                                                 name:kRide_Request_Notification object:nil];
    // Do any additional setup after loading the view.
}
- (void)dataSteup{
    self.countryCode = SHAREMANAGER.appData.country.countryCode;
    self.textFields = [[NSMutableArray alloc] initWithObjects:self.firstNameField,self.lastNameField,self.dobField,self.phoneField,self.cnicField,self.drivingLicenseField,self.drivingLicenseExpiryDateField,self.addressField, nil];
    self.pickerMode = UIDatePickerModeDate;
    self.user    = SHAREMANAGER.user;
    [self.firstNameField setText:self.user.firstName];
    [self.lastNameField setText:self.user.lastName];
    [self.dobField setText:self.user.dob];
    [self.phoneField setText:self.user.phone];
    [self.phoneField setTextColor:[UIColor lightGrayColor]];
    [self.cnicField setText:self.user.cnicNumber];
    [self.addressField setText:self.user.address];
    [self.drivingLicenseField setText:self.user.drivingLicenseNumber];
    [self.drivingLicenseExpiryDateField setText:self.user.driver_licence_expiry];
    if (self.user.dob) {
        self.dobDate = [NSDate dateFromString:self.user.dob withFormat:DATE_ONLY_DISPLAY];
        self.dobField.selectedDate = self.dobDate;
        // self.dobDate = [NSDate dateFromString:[NSDate stringFromDate:selectedDate] withFormat:DATE_ONLY];
    }if (self.user.driver_licence_expiry) {
        self.expiryDate = [NSDate dateFromString:self.user.driver_licence_expiry withFormat:DATE_ONLY_DISPLAY];
        //self.expiryDate = [NSDate dateFromString:[NSDate stringFromDate:selectedDate] withFormat:DATE_ONLY];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self validateAllFields];
        
    });
}
- (void)validateAllFields{
    for (ACFloatingTextField *field in self.textFields) {
        if (!field.isEmpty) {
            field.isVaild = YES;
        }
        
    }
}
- (BOOL)isOldInfo{
    return [self.firstNameField.text isEqualToString:self.user.firstName] &&  [self.lastNameField.text isEqualToString:self.user.lastName]  && [self.dobField.text isEqualToString:self.user.dob]  &&  [self.cnicField.text isEqualToString:self.user.cnicNumber] &&  [self.phoneField.text isEqualToString:self.user.phone] && [self.drivingLicenseField.text isEqualToString:self.user.drivingLicenseNumber] && [self.drivingLicenseExpiryDateField.text isEqualToString:self.user.driver_licence_expiry] && [self.addressField.text isEqualToString:self.user.address];
}
#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    // NSUInteger textLenght = [textField.text length];
    // new check aaded
    textField.rightView = nil;
    if (textField == self.cnicField) {
        return (newLength > CNIC_NUMBER_LENGHT) ? NO : YES;
    }
//    if (textField == self.phoneField) {
//        if ([newText hasPrefix:self.countryCode] && newLength == self.countryCode.length){
//            return NO;
//        }
//        NSInteger requiredNumberLenght = SHAREMANAGER.appData.country.phoneLenght;
//        return (newLength > requiredNumberLenght) ? NO : YES;
//    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.activeField = (ACFloatingTextField *)textField;
    if (self.activeField == self.addressField) {
        [self performSegueWithIdentifier:@"ShowAddressSelectionView" sender:self];
        return NO;
    }
    if (textField == self.phoneField && textField.text.length == 0) {
        [textField setText:self.countryCode];
    }
    if (!self.isViewUp) {
        NSInteger selectedfiledindex = [self.textFields indexOfObject:textField];
        if (selectedfiledindex > 4) {
            [self animatetexfieldUp:YES];
        }
        
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
        [self.textFields[selectedfiledindex +1] becomeFirstResponder];
    }else{
        [self updateButtonPressed:self];
    }
    return YES;
}
- (BOOL)isAllTextFieldsValid{
    NSMutableArray *validTetxFields = [NSMutableArray new];
    for (ACFloatingTextField *tf in self.textFields) {
        if (!tf.isVaild) {
            if (tf == self.addressField.text && self.addressField.text.isEmpty) {
                [validTetxFields addObject:tf];
            }
           
        }
    }
    return validTetxFields.count == 0;
}
- (void) animatetexfieldUp: (BOOL) up{
    //
    //    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
    //        CGFloat ypostion = 0 ;
    //        if (isiPhone5) {
    //            ypostion = 166;
    //        }else{
    //            ypostion = 100;
    //        }
    //        if (up) {
    //            self.topConstraint.constant -= ypostion;
    //        }else{
    //            self.topConstraint.constant += ypostion;
    //        }
    //        [self.view layoutIfNeeded];
    //        _isViewUp = !_isViewUp;
    //    } completion:nil];
}
- (void)showDatePicker {
    [self.view endEditing:YES];
    self.pickerMode = UIDatePickerModeDate;
    [self showDatePickerView];
}
- (void)showDatePickerView{
    [self performSegueWithIdentifier:SHOW_DATE_PICKER sender:self];
}
#pragma mark - AddressViewControllerDelegate -
- (void)setSelectedAddress:(MyLocation *)address{
    [self.addressField setText:address.address];
}

#pragma mark - DatePickerViewControllerDelegate
- (void)dismissWithDateOrTime:(NSString *)dateTime{
    if (_isViewUp) { [self animatetexfieldUp:NO];}
    NSDate *selectedData = [NSDate dateFromString:dateTime withFormat:DATE_ONLY];
    [self.activeField setText:[NSDate stringFromDate:selectedData withFormat:DATE_ONLY_DISPLAY]];
    self.activeField.isVaild = YES;
}
#pragma mark - IBACtions -
- (IBAction)updateButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if (_isViewUp) { [self animatetexfieldUp:NO];}
    if (!self.isAllTextFieldsValid) {return;}
    if ([self isOldInfo]) {
        [CommonFunctions showAlertWithTitel:@"No New Information" message:@"You didn’t add or change any information." inVC:self];
        return;
    }
    NSInteger yearDefrance = [NSDate earlierYear:self.dobField.selectedDate];
    BOOL isolderThen16 = (yearDefrance < -16);
    if (!isolderThen16) {
        [CommonFunctions showAlertWithTitel:@"" message:@"You may not be old enough for XP Driver" inVC:SHAREMANAGER.rootViewController];
        return;
    }
    [self updateProfileInfo];
}
- (void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- WebSerives -

//- (void)updateProfileInfo{
//    [self.updateButton showLoading];
//    [NetworkController apiPostWithParameters:self.parameters Completion:^(NSDictionary *json, NSString *error) {
//        [self.updateButton hideLoading];
//        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [CommonFunctions showAlertWithTitel:@"Info Updated" message:json[@"msg"] inVC:self];
//            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            [User save:results];
//            self.user = [User info];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateProfileInfo];
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

- (void)updateProfileInfo{
    [self.updateButton showLoading];
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:self.parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateProfileInfo JSON: %@", json);
        [self.updateButton hideLoading];
        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [CommonFunctions showAlertWithTitel:@"Info Updated" message:json[@"msg"] inVC:self];
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            self.user = [User info];
        }else{
            [self handleError:[json objectForKey:@"error"]];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self.updateButton hideLoading];
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
}

- (void)handleError:(NSString *)errorDescription {
    NSLog(@"Error: %@", errorDescription);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSString *errorMsg =[json objectForKey:@"error"];
    if ([ErrorFunctions isError:errorDescription]){
        [self updateProfileInfo];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

- (NSMutableDictionary *)parameters{
    NSString *phone = self.phoneField.text;
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSDate *selectedDOBDate = [NSDate dateFromString:self.dobField.text withFormat:DATE_ONLY_DISPLAY];
    NSString *dob = [NSDate stringFromDate:selectedDOBDate withFormat:DATE_ONLY];
    NSDate *selectedExpiryDate = [NSDate dateFromString:self.drivingLicenseExpiryDateField.text withFormat:DATE_ONLY_DISPLAY];
    NSString *expiry = [NSDate stringFromDate:selectedExpiryDate withFormat:DATE_ONLY];
    NSString *phoneNum = strFormat(@"%@",phone);
    phoneNum =  [phoneNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [params setObject:@"updateProfile" forKey:@"command"];
    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
    [params setObject:self.firstNameField.text forKey:@"firstname"];
    [params setObject:self.lastNameField.text forKey:@"lastname"];
    [params setObject:dob forKey:@"dob"];
    [params setObject:phoneNum forKey:@"phone"];
    [params setObject:self.cnicField.text forKey:@"NID"];
    [params setObject:self.drivingLicenseField.text forKey:@"license_number"];
    [params setObject:expiry forKey:@"license_expiry"];
    [params setObject:self.addressField.text forKey:@"address"];
    return params;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DatePickerViewController class]]) {
        DatePickerViewController *dpVC = (DatePickerViewController *)[segue destinationViewController];
        dpVC.DatePickerMode = self.pickerMode;
        dpVC.isDOB          = self.activeField == self.dobField;
        dpVC.isExpiryDate   = self.activeField == self.drivingLicenseExpiryDateField;
        dpVC.pickerDate     = dpVC.isDOB ? self.dobDate : self.expiryDate;
        dpVC.delegate       = self;
        
    }else  if ([[segue destinationViewController] isKindOfClass:[AddressSelectionViewController class]]) {
        AddressSelectionViewController *asVC = (AddressSelectionViewController *)[segue destinationViewController];
        asVC.delegate = self;
        
        
    }
}


@end
