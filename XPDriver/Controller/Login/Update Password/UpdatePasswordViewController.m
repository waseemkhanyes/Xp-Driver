//
//  UpdatePasswordViewController.m
//  XPDriver
//
//  Created by Syed zia on 11/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()
@property (assign, nonatomic) BOOL isViewUp;
@property (strong, nonatomic) NSArray *textFields;

@property (strong, nonatomic) IBOutlet ACFloatingTextField *passwordField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *confirmPasswordField;
@property (strong, nonatomic) IBOutlet RoundedButton *submitButton;
- (IBAction)registeButtonPressed:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
@end

@implementation UpdatePasswordViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
     [super viewDidLoad];
   
    self.textFields = @[self.passwordField,self.confirmPasswordField];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark UITextField delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.passwordField && self.passwordField.text.length == 0) {
        [self.confirmPasswordField setText:nil];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (!self.isViewUp) {
//        [self animatetexfieldUp:YES];
//    }
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
   if (self.passwordField.isVaild && self.confirmPasswordField.isVaild) {
       if (self.passwordField.text.length < 8){
          [CommonFunctions showAlertWithTitel:@"" message:@"Password must be atlest 8 chahracters." inVC:self];
          return false;
          }
       BOOL isMatch =[self.passwordField.text isEqualToString:self.confirmPasswordField.text];
       if (!isMatch) {
          [CommonFunctions showAlertWithTitel:@"" message:@"Confirm password doesn't match with password." inVC:self ];
           
       }
        return [self.passwordField.text isEqualToString:self.confirmPasswordField.text];;
   }
    return NO;
}

//- (void) animatetexfieldUp: (BOOL) up
//{
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
//}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registeButtonPressed:(UIButton *)sender{
    [self.view endEditing:YES];
//    if (_isViewUp) {[self animatetexfieldUp:NO];}
    if (!self.isAllTextFieldsValid) {return;}
    [self updateUserPassword];
}
- (void)updateUserPassword{
    [self.submitButton showLoading];
    //Modify password: command=&id=706&password=done
    NSMutableDictionary *parameters =  [NSMutableDictionary new];
    [parameters setObject:self.userId forKey:@"user_id"];
    [parameters setObject:self.passwordField.text forKey:@"password"];
    [User updatePassword:parameters completion:^(NSString *message, NSString *error) {
        [self.submitButton hideLoading];
        if (error.isEmpty) {
            [CommonFunctions showAlertWithTitel:@"" message:message inVC:self completion:^(BOOL success) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }else{
            [CommonFunctions showAlertWithTitel:@"" message:error inVC:self];
        }
    }];
    
}

@end
