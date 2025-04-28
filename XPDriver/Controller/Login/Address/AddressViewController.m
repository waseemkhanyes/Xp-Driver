//
//  AddressViewController.m
//  XPDriver
//
//  Created by Syed zia on 30/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "AddressSelectionViewController.h"
#import "DatePickerViewController.h"

#import "AddressViewController.h"

@interface AddressViewController ()<DatePickerViewControllerDelegate,AddressViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) BOOL isViewUp;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) NSMutableArray *textFields;
@property (nonatomic,assign)  UIDatePickerMode pickerMode;
@property (nonatomic,strong)  MyLocation *slectedAddress;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cnicField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *drivingLicenceField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *drevingLicenseExpiryDateField;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *addressField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *stateField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cityField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) IBOutlet UIView *viewLocations;
@property (weak, nonatomic) IBOutlet UITextField *dropdownTextField;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationWarning;

@property (strong, nonatomic) UIPickerView *pickerView;
//@property (strong, nonatomic) NSArray *dropdownOptions;
@property (strong, nonatomic) NSMutableArray *arrayLocaions;
@property (strong, nonatomic) NSDictionary *selectedLocation;

- (IBAction)contnueButtonPressed:(UIButton *)sender;
@end

@implementation AddressViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = [[NSMutableArray alloc] initWithObjects:self.cnicField,self.drivingLicenceField,self.drevingLicenseExpiryDateField,self.addressField, nil];
    self.pickerMode = UIDatePickerModeDate;
    //    if (!SHAREMANAGER.isPakistan) {
    //        [self.textFields removeObjectAtIndex:0];
    //        [self.cnicField removeFromSuperview];
    //    }
    // Do any additional setup after loading the view.
    
    //    self.dropdownOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4"];
    
    // Initialize picker view
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.arrayLocaions = [[NSMutableArray alloc] init];
    
    NSDictionary *dummyLocation = @{
        @"id": @0,
        @"name": @"No location",
    };
    
    self.arrayLocaions = [@[ dummyLocation ] mutableCopy];
    
    
    // Set picker view as input view for the text field
    self.dropdownTextField.inputView = self.pickerView;
    
    // Add a toolbar with Done button to dismiss the picker
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(doneButtonTapped)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    toolbar.items = @[flexibleSpace, doneButton];
    self.dropdownTextField.inputAccessoryView = toolbar;
    
#if DEBUG
    
#endif
    
    [self configLocationView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)doneButtonTapped {
    [self.dropdownTextField resignFirstResponder];
}

#pragma mark UITextField delegate methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    ACFloatingTextField *activeTextField = (ACFloatingTextField *)textField;
    if (activeTextField == self.addressField) {
        [self performSelector:@selector(showAddreSelectionVC) withObject:nil afterDelay:0.2];
        //  return NO;
    }
    if (textField == self.stateField) {
        self.cityField.text = nil;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger selectedfiledindex = [self.textFields indexOfObject:textField];
    if (!self.isViewUp && selectedfiledindex > 2) {
        [self animatetexfieldUp:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    // NSUInteger textLenght = [textField.text length];
    // new check aaded
    textField.rightView = nil;
    if (textField == self.cnicField) {
        return (newLength > CNIC_NUMBER_LENGHT) ? NO : YES;
    }
    
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
- (void)showAddreSelectionVC{
    [self performSegueWithIdentifier:@"ShowAddressSelectionView" sender:self];
}
- (void)animatetexfieldUp:(BOOL)up{
    //    __block CGFloat ypostion = 0.0 ;
    //    if (isiPhone5) {
    //        ypostion = 140;
    //    }if (isiPhone6) {ypostion = 45;}
    //    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
    //
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
        if (!tf.isVaild && tf.isEmpty) {
            [validTetxFields addObject:tf];
        }
    }
    return validTetxFields.count == 0;
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
    self.selectedLocation = nil;
    
    self.slectedAddress = address;
    [self.addressField setText:self.slectedAddress.address];
    [self getLocations];
    
}

-(void) configLocationView {
    [self.lblLocationWarning setHidden:YES];
    
    if (self.selectedLocation) {
        self.dropdownTextField.text = [self.selectedLocation objectForKey:@"name"];
    } else {
        self.dropdownTextField.text = @"";
    }
}

#pragma mark - DatePickerViewControllerDelegate
- (void)dismissWithDateOrTime:(NSString *)dateTime{
    [self.drevingLicenseExpiryDateField setText:dateTime];
    self.drevingLicenseExpiryDateField.isVaild = YES;
}
- (void)setRegisterParameters{
    
    NSString *address = self.addressField.text;
    NSString *stateID = [SHAREMANAGER.appData.country statIdByName:self.slectedAddress.state];
    [[RegisterController share].registerParametrs setObject:self.cnicField.text forKey:@"NID"];
    [[RegisterController share].registerParametrs setObject:self.drevingLicenseExpiryDateField.text forKey:@"license_expiry"];
    [[RegisterController share].registerParametrs setObject:self.drivingLicenceField.text forKey:@"license_number"];
    [[RegisterController share].registerParametrs setObject:address forKey:@"address"];
    [[RegisterController share].registerParametrs setObject:stateID forKey:@"province_id"];
    
    id locationID = [self.selectedLocation objectForKey:@"id"];
    
    if ([locationID isKindOfClass:[NSString class]]) {
        locationID = @([locationID integerValue]);
    }
    
    NSString *strLocationId = [NSString stringWithFormat:@"%@", locationID];
    DLog(@"** wk strLocationId: %@", strLocationId);
    
    [[RegisterController share].registerParametrs setObject:strLocationId forKey:@"location_id"];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)contnueButtonPressed:(UIButton *)sender{
    if (![self isAllTextFieldsValid]) {return;}
    
    if (self.arrayLocaions.count > 1 && self.selectedLocation == nil) {
        [self.lblLocationWarning setHidden:NO];
        return;
    }
    if (self.selectedLocation) {
        id locationID = [self.selectedLocation objectForKey:@"id"];
        
        // Ensure locationID is an NSNumber, convert it if it's an NSString
        if ([locationID isKindOfClass:[NSString class]]) {
            locationID = @([locationID integerValue]);
        }
        
        if ([locationID isEqualToNumber:@0] && self.arrayLocaions.count > 1) {
            [self.lblLocationWarning setHidden:NO];
            return;
        }
    }
    
    if (self.isViewUp) { [self animatetexfieldUp:NO];}
    [self setRegisterParameters];
    [self showEmailView];
}
- (void)showEmailView{
    [self performSegueWithIdentifier:@"ShowEmailVC" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DatePickerViewController class]]) {
        DatePickerViewController *dpVC = (DatePickerViewController *)[segue destinationViewController];
        dpVC.DatePickerMode = self.pickerMode;
        dpVC.isDOB          = NO;
        dpVC.isExpiryDate   = YES;
        dpVC.delegate       = self;
        
    }else  if ([[segue destinationViewController] isKindOfClass:[AddressSelectionViewController class]]) {
        AddressSelectionViewController *asVC = (AddressSelectionViewController *)[segue destinationViewController];
        asVC.delegate = self;
        if (self.addressField.text.length > 0) {
            asVC.selectedAddress = [[MyLocation alloc] initWithAddress:self.addressField.text coordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
        }
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1; // One column for options
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.arrayLocaions.count; //self.dropdownOptions.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arrayLocaions[row] objectForKey:@"name"];//self.dropdownOptions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedLocation = self.arrayLocaions[row];
    [self configLocationView];
    
    //    NSString *strText = [self.arrayLocaions[row] objectForKey:@"name"];
    //    self.dropdownTextField.text = strText; //self.dropdownOptions[row];
}

#pragma mark - Api Calls -

-(void)getLocations{
https://xpeats.com/api/index.php?command=&lat=43.1394191&long=-80.263623&app_id=9
    [self showHud];
    NSMutableDictionary *paramers = [NSMutableDictionary new];
    [paramers setObject:@"getNearbyLocationsByCoordinates" forKey:@"command"];
    [paramers setObject:self.slectedAddress.lat forKey:@"lat"];
    [paramers setObject:self.slectedAddress.lng forKey:@"long"];
    [paramers setObject:@"9" forKey:@"app_id"];
    
    [User getLocationsAsPerSelectedAddress:paramers completion:^(NSDictionary *JSON, NSString *error) {
        [self hideHud];
        DLog(@"** wk json: %@", JSON);
        if (error.isEmpty) {
            NSArray *dataArray = JSON[@"data"];
            
            if ([dataArray isKindOfClass:[NSArray class]]) {
                NSDictionary *dummyLocation = @{
                    @"id": @0,
                    @"name": @"No location",
                };
                
                self.arrayLocaions = [NSMutableArray arrayWithArray:dataArray];
                [self.arrayLocaions insertObject:dummyLocation atIndex:0];
                
                [self.dropdownTextField becomeFirstResponder];
                
                [self configLocationView];
                //                self.selectedLocation = self.arrayLocaions.firstObject;
            }
        } else{
            [CommonFunctions showAlertWithTitel:@"" message:error inVC:self];
        }
    }];
}

@end
