//
//  ABNNumberViewController.m
//  XPDriver
//
//  Created by Syed zia on 16/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "WebViewController.h"

#import "ABNNumberViewController.h"
#import "XP_Driver-Swift.h"

@interface ABNNumberViewController ()<ZSWTappableLabelTapDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet ZSWTappableLabel *messageLable  ;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *numberField;
@property (strong, nonatomic) IBOutlet RoundedButton *updateButton;

- (IBAction)updateButtonPressed:(RoundedButton *)sender;

@end

@implementation ABNNumberViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User info];
    if (strNotEmpty(self.user.abnNumber)) {
        [self.updateButton setHidden:YES];
        [self.numberField setEnabled:NO];
        [self setMessageLabelText];
    }else{
        [self.updateButton setHidden:NO];
        [self.numberField setEnabled:YES];
        [self.messageLable setText:@""];
    }
    [self.numberField setText:self.user.abnNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToHome)
                                                 name:kRide_Request_Notification object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)setMessageLabelText{
    NSString *termsText = @"If you want to update your ABN number Please <link type='Contact us'>Contact us</link>";
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
    [self.messageLable setAttributedText:attributedString];
    self.messageLable.tapDelegate = self;
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
- (IBAction)updateButtonPressed:(RoundedButton *)sender{
    [self.view endEditing:YES];
    if (!self.numberField.isEmpty) {
        [self updateABNNumber];
    }
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Web Services
- (NSMutableDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary new];
    //https://trip.myxpapp.com/services/index.php?command=update_info&user_id=787&abn_number=ABN123456
    [params setObject:@"update_info" forKey:@"command"];
    [params setObject:self.numberField.text forKey:@"abn_number"];
    [params setObject:self.user.userId forKey:@"user_id"];
    return params;
}
//- (void)updateABNNumber{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [NetworkController apiPostWithParameters:self.parameters Completion:^(NSDictionary *json, NSString *error) {
//        if (![json objectForKey:@"error"]&&json!=nil) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *message = json[@"result"][@"messages"];
//            [CommonFunctions showAlertWithTitel:@"ABN Number" message:message inVC:self];
//            [User save: json[@"result"][@"data"][0]];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateABNNumber];
//            }
//            else {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self];
//                ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
//            }
//            
//        }
//    }];
//}

- (void)updateABNNumber{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:self.parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *message = json[@"result"][@"messages"];
            [CommonFunctions showAlertWithTitel:@"ABN Number" message:message inVC:self];
            [User save: json[@"result"][@"data"][0]];
        }else{
            NSString *errorMsg =[json objectForKey:@"error"];
            [self handleError:errorMsg];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
}

-(void) handleError: (NSString *)errorDescrription {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([ErrorFunctions isError:errorDescrription]){
        [self updateABNNumber];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescrription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:WebView_Idintifire]) {
        WebViewController*WVC = (WebViewController *)[segue destinationViewController];
        WVC.webUrl = [NSURL URLWithString:KContact_us];
        
    }
}
@end
