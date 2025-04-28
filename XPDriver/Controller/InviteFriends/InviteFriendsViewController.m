//
//  InviteFriendsViewController.m
// A1Rides
//
//  Created by Macbook on 23/07/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
#import "Invitation.h"
#import "UsernameViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h>
#import "InviteFriendsViewController.h"
#import "XP_Driver-Swift.h"

@interface InviteFriendsViewController ()<CNContactPickerDelegate,MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) MFMessageComposeViewController *controller;
@property (strong, nonatomic) Invitation *invitation;
@property (strong, nonatomic) NSMutableArray *recipients;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *referralCodeLabel;
- (IBAction)inviteButtonPressed:(RoundedButton *)sender;
- (IBAction)copyButtonPressed:(RoundedButton *)sender;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProfileDetail];
    self.invitation = [[Invitation alloc] init];
    [self.titleLabel setAttributedText:[NSAttributedString attributedStringWithTitel:@"The more " withFont:[UIFont heading1] titleColor:[UIColor appBlackColor] subTitle:@"you share," withfont:[UIFont heading1]  subtitleColor:[UIColor appGreenColor] nextLine:NO]];
    [self.subtitleLabel setAttributedText:[NSAttributedString attributedStringWithTitel:@"the more " withFont:[UIFont heading1] titleColor:[UIColor appBlackColor] subTitle:@"you earn!" withfont:[UIFont heading1]  subtitleColor:[UIColor appGreenColor] nextLine:NO]];
    [self.invitation setTitel:@"Special Offer"];//
//    [self.invitation setInviteDescription:@"Become a driver with XP Driver app. Register to earn ongoing residual income when you refer other drivers. Food & Grocery delivery!"];
    [self.invitation setInviteDescription:@"I'm inviting you to register as an XP Driver. Download the app, and work on your own schedule. You will earn residual referral income when you share the app with other drivers."];
    self.recipients = [NSMutableArray new];
     [self.messageLabel setAttributedText:[NSAttributedString attributedString:self.invitation.inviteDescription withFont:[UIFont normal] subTitle:SHAREMANAGER.user.totalReferralString withfont:[UIFont boldNormal] nextLine:YES]];
  //  [self fetchInvationMessage];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.referralCodeLabel setText:SHAREMANAGER.user.username];
    if (SHAREMANAGER.user.username.isEmpty) {
        [self showUsernameView];
    }
    [self userNameSetup];
    
}
- (void)userNameSetup{
    [self.invitation setMessage:[NSString stringWithFormat:@"I'm inviting you to register as an XP Driver. Download the app, and work on your own schedule. You will earn residual referral income when you share the app with other drivers.\n\n https://xp.life/refer.php?_user=%@&r=d",SHAREMANAGER.user.username]];
     // [self.messageLabel setText:SHAREMANAGER.appData.inviteMessage];
      [self.referralCodeLabel setText:SHAREMANAGER.user.username];
     [self.messageLabel setAttributedText:[NSAttributedString attributedString:self.invitation.inviteDescription withFont:[UIFont normal] subTitle:SHAREMANAGER.user.totalReferralString withfont:[UIFont boldNormal] nextLine:YES]];
}
- (void)showUsernameView{
    UINavigationController *unVC = INVITE_instantiateVC(@"InviteNavigationController");
    [self.navigationController presentViewController:unVC animated:YES completion:nil];
}
- (void)showContacts{
   // [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
      CNContactPickerViewController *contactPickerController = [[CNContactPickerViewController alloc]init];
      contactPickerController.displayedPropertyKeys = @[CNContactGivenNameKey,CNContactMiddleNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
      [self presentViewController:contactPickerController animated:YES completion:nil];

      contactPickerController.delegate=self;
}
- (void)showActionSheet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* SelectFormGallery = [UIAlertAction
                                        actionWithTitle:@"Whatsapp"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
         [self openWhatsApp];
        [view dismissViewControllerAnimated:YES completion:^{
            DLog(@"openWhatsApp");
           
        }];
                                            }];
    UIAlertAction* TakePhoto = [UIAlertAction
                                actionWithTitle:@"SMS"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action){
         [self sendSMS];
        [view dismissViewControllerAnimated:YES completion:^{
            DLog(@"openWhatsApp");
           
        }];
                                }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action){
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:SelectFormGallery];
    [view addAction:TakePhoto];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
}
- (void)openWhatsApp{
    
    NSString *escapedString = [self.invitation.message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
       escapedString = [escapedString stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
       escapedString = [escapedString stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
       escapedString = [escapedString stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
       escapedString = [escapedString stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
       escapedString = [escapedString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSString *urlString = [NSString stringWithFormat:@"whatsapp://send?text=%@",escapedString];
    NSURL *whatsappURL = [NSURL URLWithString:urlString];
    //use this method stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding to convert it with escape char
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                
            }else{
                
            }
        }];
    }
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(nonnull NSArray<CNContact *> *)contacts{
    for (CNContact *contact in contacts) {
        [self parseContactWithContact:contact];
    }
    if (contacts.count != 0) {
       [self performSelector:@selector(sendSMS) withObject:nil afterDelay:1];
    }
    
   
}
- (void)parseContactWithContact:(CNContact* )contact{
    NSString * phone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    [self.recipients addObject:[NSString stringWithFormat:@"%@",phone]];
}
- (NSMutableArray *)parseAddressWithContac: (CNContact *)contact
{
    NSMutableArray * addressArray = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    
    if (addresses.count > 0) {
        for (CNPostalAddress* newAddress in addresses) {
            [addressArray addObject:[formatter stringFromPostalAddress:newAddress]];
        }
    }
    return addressArray;
}
- (void)sendSMS{
   self.controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        self.controller.body = self.invitation.message;
       // NSArray<NSString *> *recipients = [self.recipients mutableCopy];
       // [self.controller  setRecipients:recipients];
        self.controller .messageComposeDelegate = self;
        [self presentViewController:self.controller  animated:YES completion:nil];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- WebServices -

//-(void)fetchProfileDetail{
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.userId,@"user_id", nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        DLog(@"json result is %@",json);
//        NSArray *results  =[json objectForKey:RESULT];
//        if (![json objectForKey:@"error"] && json!=nil && results.count != 0) {
//            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            [User save:results];
//            [self userNameSetup];
//           
//        }else{
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self fetchProfileDetail];
//            }else{
//                
//                
//            }
//        }
//    }];
//    
//}

-(void)fetchProfileDetail{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getProfile",@"command",SHAREMANAGER.userId,@"user_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        DLog(@"json result is %@",json);
        NSArray *results  =[json objectForKey:RESULT];
        if (![json objectForKey:@"error"] && json!=nil && results.count != 0) {
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            [self userNameSetup];
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

-(void) handleError: (NSString *)errorDescription {
    if ([ErrorFunctions isError:errorDescription]){
        [self fetchProfileDetail];
    }else{
        
        
    }
}


/*
 decision = 0;
            description = "Get a 100 points. When you refer a friend to try A1rides.";
            "get_balance" = "";
            "get_points" = 100;
            id = 28;
            img = "LoV4qssD7Y.jpg";
            message = "Download A1rides for a safe, reliable and hassle free ride. Sign up & get Points 100. IOS # https://apps.apple.com/au/app/a1-rides/id1394497318 Andriod # https://play.google.com/store/apps/details?id=com.a1rides.a1ridesclient use referal code SYED346 for signup";
            title = "Special Offer";
 */
//- (void)fetchInvationMessage{
//    [Invitation fetchMessageCompletion:^(Invitation * _Nullable invitation) {
//        if (invitation) {
//            self.invitation = invitation;
//            [self.messageLabel setTextWithAnimation:invitation.inviteDescription];
//        }
//    }];
//}
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender{
    [self showUsernameView];
}
- (IBAction)inviteButtonPressed:(RoundedButton *)sender {
    [self showActionSheet];
}

- (IBAction)copyButtonPressed:(RoundedButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"https://xp.life/refer.php?_user=%@&r=d", self.referralCodeLabel.text]; //SHAREMANAGER.user.referralCode;
    [self showHudWithText:@"copied"];
}

@end
