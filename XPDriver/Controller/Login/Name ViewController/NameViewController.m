//
//  NameViewController.m
//  XPDriver
//
//  Created by Syed zia on 29/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//


#import "DatePickerViewController.h"
#import "NameViewController.h"

@interface NameViewController ()<DatePickerViewControllerDelegate,EMCCountryDelegate,CountryCodeViewDelegate>
@property (assign, nonatomic)  BOOL isViewUp;
@property (nonatomic,assign)   NSDate *selectedDate;
@property (nonatomic,assign)   UIDatePickerMode pickerMode;
@property (nonatomic,strong)   NSArray   *textFields;
@property (nonatomic,strong)   NSArray   *requiredFields;
@property (assign, nonatomic) NSString *countryCode;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) EMCCountry *selectedCountry;
@property (strong, nonatomic) CountryCodeView *countryCodeView;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *phoneField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *dobField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)continueButtonPressed:(UIButton *)sender;

@end

@implementation NameViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = @[_firstNameField,_lastNameField,_phoneField,_dobField];
    self.countryCode = SHAREMANAGER.appData.country.countryCode;
    self.selectedCountry = [[EMCCountryManager countryManager] getCountryFromName:SHAREMANAGER.appData.country.name];
    self.countryCodeView = [[[NSBundle mainBundle] loadNibNamed:@"CountryCodeView" owner:self options:nil] firstObject];
    self.countryCodeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.countryCodeView configerWithCountry:self.selectedCountry delegate:self];
    self.phoneField.leftView = self.countryCodeView;
    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
    
    #if DEBUG
    self.firstNameField.text = @"Waseem";
    self.lastNameField.text = @"Khan";
    self.phoneField.text = @"3136661241";
    self.dobField.text = @"12 Oct, 2000";
    self.firstNameField.isVaild = YES;
    self.lastNameField.isVaild = YES;
    self.phoneField.isVaild = YES;
    self.dobField.isVaild = YES;
    #endif
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark UITextField delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   // NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
       // Make sure that the currency symbol is always at the beginning of the string:
    if (textField == self.phoneField) {
    
//        NSInteger requiredNumberLenght = SHAREMANAGER.appData.country.phoneLenght + SHAREMANAGER.appData.country.countryCode.length;
//        return (newLength > requiredNumberLenght) ? NO : YES;
    }
    return YES;
}
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
    if (selectedfiledindex != self.textFields.count-1) {
        [self.textFields[selectedfiledindex +1] becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)showDatePicker {
    [self.view endEditing:YES];
    self.pickerMode = UIDatePickerModeDate;
    [self showDatePickerView];
}
- (void)showDatePickerView{
    [self performSegueWithIdentifier:SHOW_DATE_PICKER sender:self];
}
- (void) animatetexfieldUp: (BOOL) up
{
//    if (!isiPhone5) {return;}
//    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
//        CGFloat ypostion = 46;
//        if (up) {
//            self.topConstraint.constant -= ypostion;
//        }else{
//            self.topConstraint.constant += ypostion;
//        }
//        [self.view layoutIfNeeded];
//        _isViewUp = !_isViewUp;
//    } completion:nil];
}
- (BOOL)isAllTextFieldsValid{
    NSMutableArray *validTetxFields = [NSMutableArray new];
    for (ACFloatingTextField *tf in self.textFields) {
      if (!tf.isVaild) {
          [validTetxFields addObject:tf];
      }
    }
    return validTetxFields.count == 0;
}
- (void)setRegisterParameters{

    NSString *phone = [NSString stringWithFormat:@"%@%@",self.selectedCountry.dialingCode,self.phoneField.text];
    
    //firstname // lastname
    NSString *phoneNum =  [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSDate *selectedData = [NSDate dateFromString:self.dobField.text withFormat:DATE_ONLY_DISPLAY];
    NSString *dob = [NSDate stringFromDate:selectedData withFormat:DATE_ONLY];
    [[RegisterController share].registerParametrs setObject:phoneNum forKey:@"phone"];
    [[RegisterController share].registerParametrs setObject:self.firstNameField.text forKey:@"firstname"];
    [[RegisterController share].registerParametrs setObject:self.lastNameField.text forKey:@"lastname"];
    [[RegisterController share].registerParametrs setObject:dob forKey:@"dob"];
    
    //DLog(@"RegisterController share].registerParametrs %@",[RegisterController share].registerParametrs);
}
#pragma mark - DatePickerViewControllerDelegate
- (void)dismissWithDateOrTime:(NSString *)dateTime{
    NSDate *selectedData = [NSDate dateFromString:dateTime withFormat:DATE_ONLY];
    [self.dobField setText:[NSDate stringFromDate:selectedData withFormat:DATE_ONLY_DISPLAY]];
    self.dobField.isVaild = YES;
}

#pragma mark - IBACTIONS
- (IBAction)backButtonPressed:(UIButton *)sender {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    int currentViewControllerIndex  =  (int)[navigationArray indexOfObject:self];
    [navigationArray removeObjectAtIndex:currentViewControllerIndex-1];
    self.navigationController.viewControllers = navigationArray;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.isViewUp) {
        [self animatetexfieldUp:NO];
    }
    if (!self.isAllTextFieldsValid) {
        return;
    }
    NSInteger yearDefrance = [NSDate earlierYear:self.dobField.selectedDate];
    BOOL isolderThen16 = (yearDefrance < -16);
    if (!isolderThen16) {
        [CommonFunctions showAlertWithTitel:@"" message:@"You may not be old enough for XP Driver" inVC:SHAREMANAGER.rootViewController];
        return;
    }
    [self setRegisterParameters];
    [self showAddressView];
}
- (void)showAddressView{
    [self performSegueWithIdentifier:@"ShowAddressVC" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DatePickerViewController class]]) {
        DatePickerViewController *dpVC = (DatePickerViewController *)[segue destinationViewController];
        dpVC.DatePickerMode = self.pickerMode;
        dpVC.isDOB          = YES;
        dpVC.delegate       = self;
        
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
