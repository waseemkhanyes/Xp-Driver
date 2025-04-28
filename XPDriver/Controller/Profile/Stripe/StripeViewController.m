//
//  StripeViewController.m
//  XPEats
//
//  Created by Macbook on 29/05/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
#import "SZTextField.h"
#import "ShadowView.h"
@import Stripe;
#import "StripeViewController.h"
////<CCCFormatterDelegateExtension>


@interface StripeViewController ()
@property (assign, nonatomic)  BOOL isViewUp;
@property (assign, nonatomic)  BOOL isSaveCard;
//@property (nonatomic, strong) CCCCardInfo *card;
@property (strong, nonatomic) IBOutlet ShadowView* fieldContainerView;
@property (strong, nonatomic) IBOutlet SZTextField* cardholderName;
@property (strong, nonatomic) IBOutlet SZTextField* cardNumber;
@property (strong, nonatomic) IBOutlet SZTextField* expirationDateTextField;
@property (strong, nonatomic) IBOutlet SZTextField* CVCNumber;
@property (strong, nonatomic) IBOutlet RoundedButton* saveButton;
@property (strong, nonatomic) IBOutlet UIButton *saveCardButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
//@property (strong, nonatomic) IBOutlet CCCCardFormatterDelegate *cardFormatterDelegate;
//@property (strong, nonatomic) IBOutlet CCCExpirationDateFormatterDelegate *expirationFormatterDelegate;
//@property (strong, nonatomic) IBOutlet CCCCVVFormatterDelegate *cvvFormatterDelegate;
-(IBAction)saveButtonPressed:(id)sender;
- (IBAction)saveCardButtonPressed:(UIButton *)sender;

@end

@implementation StripeViewController
@synthesize delegate;

- (void)setCurrency:(NSString *)currency{
    _currency = currency;
    self.selectedCurrency = [SHAREMANAGER.user getCurrencyByCode:currency];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton setEnabled:NO];
    //self.card = [CCCCardInfo new];
    NSString *stripeKey = @"";
    if (self.selectedCurrency == nil) {
        stripeKey = SHAREMANAGER.requiredStripKey;
        [StripeAPI setDefaultPublishableKey:stripeKey];
    }else{
        stripeKey = [SHAREMANAGER.appData getStripeKeyByCurrency:self.selectedCurrency];
        [StripeAPI setDefaultPublishableKey:stripeKey];
    }
    DLog(@"SHAREMANAGER.appData.stripeKey %@",stripeKey);


    if (self.isFromDebitCard || self.isFromProfile ) {
        [self.saveCardButton setHidden:YES];
    }else{
        [self.saveCardButton setHidden:false];
    }
   
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark CCCFormatterDelegateExtension

//- (void)didChangeCharactersInRangeForFormatter:(CCCTextFieldDelegateProxy *)formatter {
//    if (formatter == self.cardFormatterDelegate)
//    {
//        if (self.cardNumber.text.length > 0 && !self.cardFormatterDelegate.isValidCard){
//           // [self.cardNumber addLeftIcon:[UIImage imageNamed:@"ic_item_cancel"]];
//        } else  {
//            self.cardNumber.rightView = nil;
//            [self.cardFormatterDelegate setCardNumberOnCardInfo:self.card];
//        }
//    }
//    else if (formatter == self.expirationFormatterDelegate) {
//        if (self.expirationDateTextField.text.length > 0 &&
//            !self.expirationFormatterDelegate.isValidExpirationDate) {
//          // [self.expirationDateTextField addLeftIcon:[UIImage imageNamed:@"ic_item_cancel"]];
//        }
//        else  {
//            self.expirationDateTextField.rightView = nil;
//            [self.expirationFormatterDelegate setExpirationDateOnCardInfo:self.card];
//        }
//    }
//    else if (formatter == self.cvvFormatterDelegate) {
//        if (self.CVCNumber.text.length > 0 &&
//            ![self.cvvFormatterDelegate isValidCVVWithCardFormatter:self.cardFormatterDelegate]) {
//          //  [self.CVCNumber addLeftIcon:[UIImage imageNamed:@"ic_item_cancel"]];
//        }  else {
//            self.CVCNumber.rightView = nil;
//            [self.cvvFormatterDelegate setCVVOnCardInfo:self.card];
//        }
//    }
//
//    [self i_updateCreateButton];
//}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.cardNumber){
       // self.card.cardNumber = nil;
    }
    else if (textField == self.expirationDateTextField){
      //  self.card.expirationDate = nil;
    }
    else if (textField == self.CVCNumber){
      //  self.card.CVV = nil;
    }
   // [self i_updateCreateButton];

    return YES;
}
//- (void)i_updateCreateButton{
//    self.saveButton.enabled =   self.cardFormatterDelegate.isValidCard &&
//    self.expirationFormatterDelegate.isValidExpirationDate &&
//    self.cvvFormatterDelegate.isValidCVV;
//}
#pragma mark UITextField delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == self.cardNumber) {
        if (newLength == 17) {
            [self.expirationDateTextField becomeFirstResponder];
        }
        return (newLength > 16) ? NO : YES;
    }else if (textField == self.expirationDateTextField){
        [self.CVCNumber becomeFirstResponder];
    }else if (textField == self.CVCNumber) {
        if (newLength == 4) {
            [self.CVCNumber resignFirstResponder];
        }
        return (newLength > 3) ? NO : YES;

    }

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.isViewUp){
        [self animatetexfieldUp:YES];
    }

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (!self.cardNumber.isEmpty && !self.expirationDateTextField.isEmpty && !self.CVCNumber.isEmpty) {
        [self.saveButton setEnabled:YES];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.isViewUp && textField == self.CVCNumber){
        [self animatetexfieldUp:NO];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void) animatetexfieldUp: (BOOL) up{
//
//    CGFloat ypostion = 120;
//    if (up) {
//        self.topConstraint.constant -= ypostion;
//    }else{
//        self.topConstraint.constant += ypostion;
//    }
//    [UIView transitionWithView:self.fieldContainerView
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//        [self.view layoutIfNeeded];
//        _isViewUp = !_isViewUp;
//    } completion:nil];
}
- (IBAction)saveButtonPressed:(id)sender{
    if (self.isViewUp){
        [self animatetexfieldUp:NO];
    }
    [self getStripeToken];
   // [self getToken];
}

- (IBAction)saveCardButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isSaveCard = sender.selected;
}
- (void)getToken{
//    [self.saveButton showLoading];
//    [[CCCAPI instance] generateAccountForCard:self.card completion:^(CCCAccount * _Nullable account, NSError * _Nullable error) {
//        [self.cardFormatterDelegate clearTextField];
//        [self.expirationFormatterDelegate clearTextField];
//        [self.cvvFormatterDelegate clearTextField];
//        self.card = [CCCCardInfo new];
//        [self i_updateCreateButton];
//        if (!self.isFromProfile) {
//            [self.saveButton hideLoading];
//        }
//        if (account) {
//            NSLog(@"last4 %@,accountType %@,expirationDate %@",account.last4,account.accountType,account.expirationDate);
//            if (self.isFromProfile) {
//                //[self postStripeToken:account];
//                return;
//            }
//            [self.delegate dismissedWithAccountInfo:account isSaveCard:self.isSaveCard];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [self showErrorWithMessage:error.localizedDescription];
//        }
//    }];
}
- (void)getStripeToken{
   [self.saveButton showLoading];
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    NSArray *expDate = [self.expirationDateTextField.text componentsSeparatedByString:@"/"];
    // cardParams.name   = self.cardholderName.text;
    cardParams.number   = self.cardNumber.text;
    cardParams.expMonth = [expDate[0] intValue];
    cardParams.expYear  = [expDate[1] intValue];;
    cardParams.cvc      = self.CVCNumber.text;
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
        if (token == nil || error != nil) {
            [self.saveButton hideLoading];
            // Present error to user...
            [self showAlertWithMessage:error.localizedDescription alertType:KAlertTypeInfo];
            return;
        }
        STPCard *card = token.card;
        NSString *brandName = [STPCard stringFromBrand:card.brand];
        DLog(@"Card Info %@,%@,%@,%@",card.last4,brandName,@(card.expYear).stringValue,@(card.expMonth).stringValue);
        if (self.isFromProfile) {
           // [self.saveButton hideLoading];
            DLog(@"token.tokenId %@",token.tokenId);
          [self postStripeToken:token];
        }else if (self.isFromDebitCard){
            [self postDebitCardToken:token];
        }else if (!self.isFromProfile) {
            [self.saveButton hideLoading];
            [self.delegate dismissedWithCardInfo:token isSaveCard:self.isSaveCard];
            [self.navigationController popViewControllerAnimated:YES];;
        }
    }];
}
-(void)postStripeToken:(STPToken *)token{
    STPCard *card = token.card;
    NSMutableDictionary  *params= [[NSMutableDictionary alloc] init];
    [params setValue:token.tokenId forKey:@"stripe_token"];
    [params setValue:[STPCard stringFromBrand:card.brand] forKey:@"brand"];
    [params setValue:card.last4 forKey:@"last4"];
    [User updateUserStripeCustomerID:params completion:^(NSString * _Nullable error,BOOL success) {
        [self.saveButton hideLoading];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertWithMessage:error alertType:KAlertTypeError completion:^(BOOL success) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];

}
//https://www.xpeats.com/api/index.php?address=100%20City%20Centre%20Dr%2C%20Mississauga%2C%20ON%20L5B%202C9%2C%20Canada&bank_name=CAD&city_name=Mississauga&command=addDebitCardBankAccount&country_id=38&dob=14%20Jul%2C%202000&email=syedzia.81%40gmail.com&first_name=Syed&last_name=Zia&postal_code=L5B%202C9&state_name=Ontario&user_id=2428&cardToken=tok12365454
-(void)postDebitCardToken:(STPToken *)token{
    STPCard *card = token.card;
    NSMutableDictionary  *params= [[NSMutableDictionary alloc] init];
    [params setValue:token.tokenId forKey:@"cardToken"];
    [params setValue:[STPCard stringFromBrand:card.brand] forKey:@"brand"];
    [params setValue:card.last4 forKey:@"last4"];
    [params setValue:self.selectedCurrency.name forKey:@"user_currency"];
    [User addDebitCardBankAccount:params completion:^(NSString * _Nullable error,BOOL success) {
        [self.saveButton hideLoading];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertWithMessage:error alertType:KAlertTypeError completion:^(BOOL success) {
            }];
        }
    }];

}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
