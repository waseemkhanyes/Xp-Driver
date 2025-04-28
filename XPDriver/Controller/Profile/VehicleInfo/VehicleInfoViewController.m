//
//  VehicleInfoViewController.m
//  XPDriver
//
//  Created by Syed zia on 03/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "ShadowView.h"
#import "WebViewController.h"
#import "VehicleInfoViewController.h"
#import "XP_Driver-Swift.h"

@interface VehicleInfoViewController ()<ZSWTappableLabelTapDelegate>
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL isViewUp;
@property (assign, nonatomic) BOOL isAllTextFieldsValid;
@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (strong, nonatomic) IBOutlet ShadowView *containerView;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *carTypeField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *manufacturerFiled;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *enginePowerField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *modelField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *modelYearField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *colorFiled;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *chassisNumberField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *licensePlateField;
@property (strong, nonatomic) IBOutlet RoundedButton *updateButton;
@property (strong, nonatomic) IBOutlet ZSWTappableLabel *messageLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)updateButtonPressed:(id)sender;

@end

@implementation VehicleInfoViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = @[self.carTypeField,self.manufacturerFiled,self.modelField,self.modelYearField,self.colorFiled,self.licensePlateField];
    [self dataSteup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToHome)
                                                 name:kRide_Request_Notification object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)dataSteup{
    self.user    = [User info];
    if (self.user.isVehicelInfoUpdate) {
        [self.carTypeField setText:self.user.carName];
        [self.carTypeField setTag:[self.user.carId intValue]];
        [self.manufacturerFiled setText:self.user.carManufactured];
        [self.modelField setText:self.user.carModel];
        [self.modelYearField setText:self.user.carModelYear];
        [self.colorFiled setText:self.user.carColor];
        [self.licensePlateField setText:self.user.carNumber];
        [self.carTypeField setEnabled:NO];
        [self.carTypeField setEnabled:NO];
        [self.manufacturerFiled setEnabled:NO];
        [self.modelField setEnabled:NO];
        [self.modelYearField setEnabled:NO];
        [self.colorFiled setEnabled:NO];
        [self.licensePlateField setEnabled:NO];
        [self.updateButton setHidden:YES];
        [self setMessageLabelText];
    }else{
        [self.updateButton setHidden:NO];
        [self.messageLabel setText:@""];
    }
    
}
- (void)validateAllFields{
    for (ACFloatingTextField *field in self.textFields) {
        if (!field.isEmpty) {
            field.isVaild = YES;
        }
        
    }
}
- (BOOL)isOldInfo{
    return [self.carTypeField.text isEqualToString:self.user.carName] && [self.carTypeField.text isEqualToString:self.user.carName] &&  [self.carTypeField.text isEqualToString:self.user.carName]&&  [self.modelField.text isEqualToString:self.user.carModel] && [self.modelYearField.text isEqualToString:self.user.carModelYear] && [self.colorFiled.text isEqualToString:self.user.carColor] && [self.licensePlateField.text isEqualToString:self.user.carNumber];
}
- (void)updateSetup{
    [VehicleManager share].olderYear     = [self userCarType].olderYear;
    [VehicleManager share].models        = [self userCarCompany].modeles;
}
- (Vehicle *)userCarType{
    Vehicle *userCar = [Vehicle new];
    for ( Vehicle *car  in  [VehicleManager share].carTypres) {
        if ([car isKindOfClass:[Vehicle class]]) {
            if (strEquals(car.vId ,self.user.carId)) {
                userCar = car;
                [VehicleManager share].manufacturers = car.companies;
                [VehicleManager share].olderYear = car.olderYear;
                //DLog(@"%i",(int)[VehicleManager share].manufacturers.count);
            }
        }
        
    }
    return userCar;
}
- (Company *)userCarCompany{
    Company *userCompany = [Company new];
    for ( Company *co  in  [VehicleManager share].manufacturers) {
        if ([co isKindOfClass:[Company class]]) {
            
            if (strEquals(co.name,self.user.carManufactured)) {
                userCompany = co;
            }
        }
    }
    return userCompany;
}
- (Model *)userCarModel{
    Model *carModel= [Model new];
    for ( Model *model  in  [VehicleManager share].models) {
        if ([model isKindOfClass:[Model class]]) {
            if (strEquals(model.name,self.user.carModel)) {
                carModel = model;
            }
        }
    }
    return carModel;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.modelYearField && self.carTypeField.isEmpty) {
        [self showHudWithText:@"Please select vehicle type first"];
        return NO;
    }if (textField == self.colorFiled && self.carTypeField.isEmpty) {
        [self showHudWithText:@"Please select vehicle type first"];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.isViewUp) {
        if (textField == self.carTypeField || textField == self.manufacturerFiled || textField == self.modelField) {
            return;
        }
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
        [self updateButtonPressed:self];
    }
    return YES;
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
- (void) animatetexfieldUp: (BOOL) up{
    
    //    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
    //        CGFloat ypostion = 0 ;
    //        if (isiPhone5) {
    //             ypostion = 166;
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
-(void)setMessageLabelText{
    NSString *termsText = @"If you want to update your vehicle details, please <link type='Contact us'>Contact us</link>";
    ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions options];
    [options setDynamicAttributes:^NSDictionary *(NSString *tagName,
                                                  NSDictionary *tagAttributes,
                                                  NSDictionary *existingStringAttributes) {
        NSString *action;
        if ([tagAttributes[@"type"] isEqualToString:@"Contact us"]) {
            action = @"Contact us";
        }
        return @{
            ZSWTappableLabelTappableRegionAttributeName: @YES,
            ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
            ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor appBlueColor],
            NSForegroundColorAttributeName: [UIColor appBlueColor],
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
            @"action": action
        };
    } forTagName:@"link"];
    NSAttributedString *attributedString = [[ZSWTaggedString stringWithString:termsText] attributedStringWithOptions:options];
    [self.messageLabel setAttributedText:attributedString];
    self.messageLabel.tapDelegate = self;
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
    if (strEquals(action, @"Contact us")) {
        [self showWebViewController];
    }
    
}
- (void)showWebViewController{
    [self performSegueWithIdentifier:WebView_Idintifire sender:self];
}
#pragma mark- IBActions
- (void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateButtonPressed:(id)sender{
    [self.view endEditing:YES];
    if (_isViewUp) { [self animatetexfieldUp:NO];}
    if (!self.isAllTextFieldsValid) {return;}
    if ([self isOldInfo]) {
        [CommonFunctions showAlertWithTitel:@"No New information" message:@"You didn’t add or change any information." inVC:self];
        return;
    }
    
    [self updateVehicleInfo];
    
}
//- (void)updateVehicleInfo{
//    [self.updateButton showLoading];
//    [NetworkController apiPostWithParameters:self.parameters Completion:^(NSDictionary *json, NSString *error) {
//        [self.updateButton hideLoading];
//               if (![json objectForKey:@"error"]&&json!=nil) {
//                   [MBProgressHUD hideHUDForView:self.view animated:YES];
//                   [CommonFunctions showAlertWithTitel:@"Info Updated" message:@"Vehicle information updated successfully"inVC:self];
//                    NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//                   [User save:results];
//                   [self dataSteup];
//               }else{
//                   [MBProgressHUD hideHUDForView:self.view animated:YES];
//                   NSString *errorMsg =[json objectForKey:@"error"];
//                   if ([ErrorFunctions isError:errorMsg]){
//                       [self updateVehicleInfo];
//                   }
//                   else {
//                       [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                       [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self];
//                       ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
//                   }
//
//               }
//    }];
//
//}

- (void)updateVehicleInfo{
    [self.updateButton showLoading];

    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:self.parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        [self.updateButton hideLoading];
        if (![json objectForKey:@"error"]&&json!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [CommonFunctions showAlertWithTitel:@"Info Updated" message:@"Vehicle information updated successfully"inVC:self];
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            [self dataSteup];
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
    
    if ([ErrorFunctions isError:errorDescription]){
        [self updateVehicleInfo];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

- (NSMutableDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *carType = strFormat(@"%@",@(self.carTypeField.tag));
    [params setObject:@"updateProfile" forKey:@"command"];
    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
    [params setObject:carType forKey:@"vehicle_id"];
    [params setObject:self.licensePlateField.text forKey:@"vehicle_number"];
    [params setObject:self.modelField.text forKey:@"model"];
    [params setObject:self.manufacturerFiled.text forKey:@"company"];
    [params setObject:self.colorFiled.text forKey:@"color"];
    [params setObject:self.modelYearField.text forKey:@"year"];
    return params;
}

//-(void)fetchProfileDetail
//{
//    
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.user.userId,@"user_id", nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        NSArray *results  =[json objectForKey:RESULT];
//        if (![json objectForKey:@"error"] && json!=nil && results.count != 0){
//            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            NSString *status = [results objectForKey:@"loginStatus"];
//            [User save:results];
//            self.user = SHAREMANAGER.user;
//            if (strEquals(status, ONLINE)) {
//                
//                user_defaults_set_bool(ISONLINE, YES);
//                user_defaults_set_bool(ISOFFLINE, NO);
//                user_defaults_set_bool(ISONDUTY,  NO);
//            }else if (strEquals(status, OFFLINE)){
//                user_defaults_set_bool(ISONLINE, NO);
//                user_defaults_set_bool(ISOFFLINE,YES);
//                user_defaults_set_bool(ISONDUTY, NO);
//                
//            }
//            else if (strEquals(status, ONDUTY)){
//                user_defaults_set_bool(ISONLINE, NO);
//                user_defaults_set_bool(ISOFFLINE,NO);
//                user_defaults_set_bool(ISONDUTY, YES);
//            }
//        }else{
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self fetchProfileDetail];
//            }
//            
//        }
//        
//    }];
//    
//    
//}

-(void)fetchProfileDetail
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.user.userId,@"user_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        NSArray *results  =[json objectForKey:RESULT];
        if (![json objectForKey:@"error"] && json!=nil && results.count != 0){
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            NSString *status = [results objectForKey:@"loginStatus"];
            [User save:results];
            self.user = SHAREMANAGER.user;
            if (strEquals(status, ONLINE)) {
                
                user_defaults_set_bool(ISONLINE, YES);
                user_defaults_set_bool(ISOFFLINE, NO);
                user_defaults_set_bool(ISONDUTY,  NO);
            }else if (strEquals(status, OFFLINE)){
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE,YES);
                user_defaults_set_bool(ISONDUTY, NO);
                
            }
            else if (strEquals(status, ONDUTY)){
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE,NO);
                user_defaults_set_bool(ISONDUTY, YES);
            }
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                [self fetchProfileDetail];
            }
            
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        
        NSLog(@"Error: %@", error.localizedDescription);
        NSString *errorMsg = error.localizedDescription;
        if ([ErrorFunctions isError:errorMsg]){
            [self fetchProfileDetail];
        }
    }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:WebView_Idintifire]) {
        WebViewController*WVC = (WebViewController *)[segue destinationViewController];
        WVC.webUrl = [NSURL URLWithString:KContact_us];
        
    }
}
@end
