//
//  ProfileViewController.m
//  FiveStarLuxuryCar_Driver
//
//  Created by Syed zia ur Rehman on 01/07/2014.
//  Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//


#define KProfile_Cell_Identifier @"Profile Cell"

#import "WebViewController.h"

#import "ProfileViewController.h"
#import "XP_Driver-Swift.h"
#import "AccountsViewController.h"


@interface ProfileViewController ()
@property (assign, nonatomic)  BOOL isGeneratingCode;
@property (strong, nonatomic)  UITableView *settingTableView;
@property (strong, nonatomic)  StarRatingView* starviewAnimated;
@property (strong, nonatomic)  IBOutlet UILabel *inactiveAccountLabel;
-(IBAction)showPopover:(UIButton *)sender;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGusture];
    UILabel *editLabel = [[UILabel alloc] initWithFrame:rect(0,ViewHeight(self.profileImage)-20, ViewWidth(self.profileImage), 20)];
    editLabel.text = @"Edit";
    editLabel.font = [UIFont small];
    editLabel.textColor = WHITE_COLOR;
    editLabel.textAlignment = NSTextAlignmentCenter;
    editLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.profileImage addSubview:editLabel];
    [self.profileImage bringSubviewToFront:editLabel];
    [self.profileImage  round];
    [self drawReatingViewWithRating];
    //[[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

-(NSString *)currentAddress{
    return user_defaults_get_string(@"Address");
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.user = [User info];
    [self dataSetup];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backBtnPressed:)
                                                 name:kRide_Request_Notification object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated 
{
    
    [super viewDidDisappear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showPopover:(UIButton *)sender{
    if (SHAREMANAGER.isRide) {
        return;
    }
    [self signout];
}
-(void)drawReatingViewWithRating{
    DLog(@"self.user.rating %@",self.user.rating);
    float ratingViewXposition ;
    ratingViewXposition = ViewX(_nameLabel) ;
    self.starviewAnimated = [[StarRatingView alloc]initWithFrame:CGRectMake(0,0, kStarViewWidth, kStarViewHeight) andRating:[self.user.rating intValue] withLabel:NO animated:YES];
    [self.ratingView addSubview:self.starviewAnimated];
    
}


#pragma mark -
#pragma mark IBactions

-(IBAction)statusBtnPressed:(id)sender{
    if (!self.user.isApproved) {
        [CommonFunctions showAlertWithTitel:@"Inactive Account" message:@"Sorry, your account is inactive, contact your administrator to activate it" inVC:self];
        return;
    }
    [self.onlineOfflineBtn setEnabled:NO];
    if (self.isPicSelestion) {
        [self isPicSelestion:false];
        return;
    }
    [self updateStatus];
}
- (void)backToMainScreen:(NSNotification *)note {
    [self backBtnPressed:self];
}
- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Services
-(void)dataSetup{
    self.user = [User info];
    [self.inactiveAccountLabel setHidden:self.user.isApproved];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@",self.user.firstName,self.user.lastName]];
    [self.locationLabel setText:self.currentAddress != nil ? self.currentAddress : @"Not available" ];
    [self.totalPaidLabel setText:strFormat(@"%@ %@",SHAREMANAGER.appData.country.currencey,self.user.totalPaid)];
    [self.totalEarenedLabel setText:strFormat(@"%@ %@",SHAREMANAGER.appData.country.currencey,self.user.totalEarned)];
    [self.totalRidesLabel setText:self.user.numberOfRide];
    [self.joinedLabel setText:strFormat(@"Joined on:%@",self.user.joinedAt)];
    [self showProfilImageWithName:self.user.picNeme];
    if (strEquals(self.user.status, ONLINE)){
        [self.onlineOfflineBtn setEnabled:YES];
        [self.statusImage setImage:ONLINE_IMAGE];
        [self.onlineOfflineBtn setTitle:GO_OFFLINE forState:UIControlStateNormal];
        [self.onlineOfflineBtn setType:Ended];
    } else if (strEquals(self.user.status, OFFLINE)){
        [self.onlineOfflineBtn setEnabled:YES];
        [self.statusImage setImage:OFFLINE_IMAGE];
        [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
        [self.onlineOfflineBtn setType:Started];
    } else if (strEquals(self.user.status, ONDUTY)){
           [self.onlineOfflineBtn setEnabled:YES];
           [self.statusImage setImage:OnDuty_IMAGE];
           [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
           [self.onlineOfflineBtn setType:Started];
       }else {
        [self.onlineOfflineBtn setEnabled:NO];
        [self.onlineOfflineBtn setTitle:GO_OFFLINE forState:UIControlStateNormal];
        [self.onlineOfflineBtn setType:Semple];
    }
    [self.tableView reloadData];
    
}
//-(void)updateStatus
//{
//    
//    NSString *status;
//    NSString *st = self.onlineOfflineBtn.currentTitle;
//    if (strEquals(st,GO_OFFLINE))
//    {
//        status = OFFLINE;
//        
//    }
//    else if (strEquals(st,GO_ONLINE))
//    {
//        status = ONLINE;
//    }
//    
//    MBProgressHUD *hue = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hue.labelText = @"";
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_status",@"command",SHAREMANAGER.userId,@"user_id",status,@"status", nil];
//    
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error)
//     {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        if (![json objectForKey:@"error"]&&json!=nil)
//        {
//            NSArray *results=[json objectForKey:RESULT];
//            NSDictionary *res=[results objectAtIndex:0];
//            ////NSLog(@"res is %@",res);
//            NSString *UpdatedStatus =[res objectForKey:@"status"];
//            
//            
//            [self.statusImage setImage:imagify(UpdatedStatus)];
//            if (strEquals(UpdatedStatus, ONLINE)){
//                user_defaults_set_bool(ISONLINE, YES);
//                user_defaults_set_bool(ISOFFLINE, NO);
//                
//                [self.onlineOfflineBtn setTitle:GO_OFFLINE forState:UIControlStateNormal];
//                [self.onlineOfflineBtn setType:Ended];
//                [self startTrackingLocation];
//                
//            }else if (strEquals(UpdatedStatus, OFFLINE))
//            {
//                
//                user_defaults_set_bool(ISONLINE, NO);
//                user_defaults_set_bool(ISOFFLINE, YES);
//                [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
//                [self.onlineOfflineBtn setType:Started];
//                
//            }else if (strEquals(UpdatedStatus, ONDUTY))
//            {
//                
//                user_defaults_set_bool(ISONLINE, NO);
//                user_defaults_set_bool(ISOFFLINE, YES);
//                [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
//                [self.onlineOfflineBtn setType:Started];
//                
//            }
//            
//            [self performSelector:@selector(enableOnlineBtn) withObject:self afterDelay:5];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            
//            
//        }else
//        {
//            
//            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
//            
//        }
//    }];
//    
//    
//}

-(void)updateStatus
{
    
    NSString *status;
    NSString *st = self.onlineOfflineBtn.currentTitle;
    if (strEquals(st,GO_OFFLINE))
    {
        status = OFFLINE;
        
    }
    else if (strEquals(st,GO_ONLINE))
    {
        status = ONLINE;
    }
    
    MBProgressHUD *hue = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText = @"";
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"update_status",@"command",SHAREMANAGER.userId,@"user_id",status,@"status", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            NSArray *results=[json objectForKey:RESULT];
            NSDictionary *res=[results objectAtIndex:0];
            ////NSLog(@"res is %@",res);
            NSString *UpdatedStatus =[res objectForKey:@"status"];
            
            
            [self.statusImage setImage:imagify(UpdatedStatus)];
            if (strEquals(UpdatedStatus, ONLINE)){
                user_defaults_set_bool(ISONLINE, YES);
                user_defaults_set_bool(ISOFFLINE, NO);
                
                [self.onlineOfflineBtn setTitle:GO_OFFLINE forState:UIControlStateNormal];
                [self.onlineOfflineBtn setType:Ended];
                [self startTrackingLocation];
                
            }else if (strEquals(UpdatedStatus, OFFLINE))
            {
                
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE, YES);
                [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
                [self.onlineOfflineBtn setType:Started];
                
            }else if (strEquals(UpdatedStatus, ONDUTY))
            {
                
                user_defaults_set_bool(ISONLINE, NO);
                user_defaults_set_bool(ISOFFLINE, YES);
                [self.onlineOfflineBtn setTitle:GO_ONLINE forState:UIControlStateNormal];
                [self.onlineOfflineBtn setType:Started];
                
            }
            
            [self performSelector:@selector(enableOnlineBtn) withObject:self afterDelay:5];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else
        {
            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:error.localizedDescription];
    }];
    
    
}

-(void)enableOnlineBtn{
    
    [self.onlineOfflineBtn setEnabled:YES];
}
-(BOOL)isImageName{
    return strEquals(self.user.picNeme, @"0");
}
- (void)showCustomUIAlertViewWithtilet :(NSString *)titel andWithMessage:(NSString *)message {
    NSString *messageString = [NSString stringWithFormat:@"\n%@\n",message];
   NYAlertAction *okAction = [[NYAlertAction alloc] initWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction * _Nonnull action) {
       [self dismissViewControllerAnimated:YES completion:nil];
   }];
   NYAlertViewController * alertViewController = [[NYAlertViewController alloc] initWithOptions:nil title:titel message:messageString actions:@[okAction]];
   [self presentViewController:alertViewController animated:YES completion:nil];
}


//-(void)showProfilImageWithName:(NSString *)imageName{
//    
//    __weak typeof(self) weakSelf = self;
//    if (![SHAREMANAGER isImageName:imageName]) {
//        return;
//    }
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHAREMANAGER.profilePicPath,imageName]]];
//    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    [self.profileImage setImageWithURLRequest:request
//                             placeholderImage:nil
//                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.profileImage.image = image;
//            user_defaults_set_object(@"ProfiePic", UIImagePNGRepresentation(image));
//        });
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"failed loading image: %@", error);
//    }];
//    
//    
//    
//}

-(void)showProfilImageWithName:(NSString *)imageName{
    
    __weak typeof(self) weakSelf = self;
    if (![SHAREMANAGER isImageName:imageName]) {
        return;
    }
    
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SHAREMANAGER.profilePicPath,imageName]]];
    
    NSString *requestString = request.URL.absoluteString;
    [AlamofireWrapper downloadImageFrom:requestString completion:^(UIImage *downloadedImage) {
        // Handle downloadedImage or nil as needed
        if (downloadedImage) {
            // Do something with the downloaded image
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.profileImage.image = downloadedImage;
                user_defaults_set_object(@"ProfiePic", UIImagePNGRepresentation(downloadedImage));
            });
            
        } else {
            NSLog(@"failed loading image");
        }
    }];
    
//    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    [self.profileImage setImageWithURLRequest:request
//                             placeholderImage:nil
//                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakSelf.profileImage.image = image;
//            user_defaults_set_object(@"ProfiePic", UIImagePNGRepresentation(image));
//        });
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"failed loading image: %@", error);
//    }];
    
}
#pragma mark IBActions
- (void)signout{
    
    [CommonFunctions showQuestionsAlertWithTitel:@"Are you sure?" message:@"Do you really want to log out?" inVC:self completion:^(BOOL success) {
        if (success) {
            [self logout];
        }
    }];
    
}


#pragma mark- UpdatePhoneNuberWebService
#pragma mark - Web Services
-(void)userInfoSetup{
    self.profileImage.image = USER_PLACEHOLDER;
    [self.nameLabel setText:self.user.name];
    
    
    
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView  estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    if (tableView == self.settingTableView && section == 0) {
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(20, 0,1,ViewWidth(tableView)-40)];
        [view setBackgroundColor:self.settingTableView.separatorColor];
        return view;
    }
    
    return [UIView new];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.settingTableView) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9; //SHAREMANAGER.isPakistan ? 9 : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ProfileCell* cell = [tableView dequeueReusableCellWithIdentifier:KProfile_Cell_Identifier forIndexPath:indexPath];
    [cell.detailImage setAlpha:0.0];
    [cell.titelLab setText:nil];
    [cell.label setText:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.activityIndicator stopAnimating];
        [cell.activityIndicator setHidden:YES];
    });
    switch (indexPath.row) {
            
        case 0:
            
            [cell.titelLab setText:@"Mobile"];
            [cell.label setText:self.user.phone];
            
            break;
        case 1:
            
            [cell.titelLab setText:@"Email"];
            [cell.label setText:self.user.email];
            
            break;
        case 2:
            
            [cell.titelLab setText:@"Date of Birth"];
            [cell.label setText:self.user.dob];
            
            break;
        case 3:
            
            [cell.titelLab setText:@"Currency"];
            [cell.label setText:self.user.currency];
            
            break;
        case 4:
            [cell.label setNumberOfLines:0];
            [cell.titelLab setText:@"Address"];
            [cell.label setText:self.user.address];
            
            break;
        case 5:
            
            [cell.titelLab setText:@"Edit Profile"];
            [cell.detailImage setAlpha:1.0];
            break;
        case 6:
            
            [cell.titelLab setText:@"Vehicle Info"];
            [cell.detailImage setAlpha:1.0];
            break;
        case 7:
            
            [cell.detailImage setAlpha:1.0];
            [cell.titelLab setText:@"Manage Documents"];
            break;
        case 8:
            [cell.detailImage setAlpha:1.0];
            [cell.titelLab setText:@"Bank Accounts"];
            break;
        case 9:
            if (self.isGeneratingCode) {
                [cell.detailImage setAlpha:0.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.activityIndicator startAnimating];
                    [cell.activityIndicator setHidden:NO];
                });
                [cell.titelLab setText:@"Generating Referral Code"];
            }
            else if (strEmpty(self.user.referralCode)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.activityIndicator stopAnimating];
                    [cell.activityIndicator setHidden:YES];
                });
                [cell.detailImage setAlpha:1.0];
                [cell.titelLab setText:@"Referral Code"];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.activityIndicator stopAnimating];
                    [cell.activityIndicator setHidden:YES];
                });
                [cell.titelLab setText:@"Referral Code"];
                [cell.label setText:self.user.referralCode];
            }
            
            break;
        case 10:
            if (self.isGeneratingCode) {
                [cell.detailImage setAlpha:0.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.activityIndicator startAnimating];
                    [cell.activityIndicator setHidden:NO];
                });
                [cell.titelLab setText:@"Generating Referral Code"];
            }else if (strEmpty(self.user.referralCode)) {
                [cell.detailImage setAlpha:1.0];
                [cell.titelLab setText:@"Referral Code"];
            }else{
                [cell.titelLab setText:@"Referral Code"];
                [cell.label setText:self.user.referralCode];
            }
            break;
        default:
            break;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5){
        [self showEditProfileView];
    }else if (indexPath.row == 6){
        [self showVehicelInfoView];
    }else if (indexPath.row == 7) {
        [self showDocumentsView];
    }else if (indexPath.row == 8) {
        [self showBackInfoView];
    }else if (indexPath.row == 9) {
        if (!strEmpty(self.user.referralCode)) {
            return;
        }
        self.isGeneratingCode = YES;
        [self.tableView reloadData];
        [self generateReferralCode];
    }else if (indexPath.row == 10) {
        if (!strEmpty(self.user.referralCode)) {
            return;
        }
        self.isGeneratingCode = YES;
        [self.tableView reloadData];
        [self generateReferralCode];
    }
    
}
- (void)showWebViewController{
    [self performSegueWithIdentifier:WebView_Idintifire sender:self];
}
//- (void)generateReferralCode{
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:@"update_info" forKey:@"command"];
//    [params setObject:self.user.userId forKey:@"user_id"];
//    [params setObject:@"generate" forKey:@"reffarl_no"];
//    //https://trip.myxpapp.com/services/index.php?command=update_info&user_id=787&reffarl_no=generate
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"]&&json!=nil){
//            NSDictionary *result = json[@"result"];
//            self.isGeneratingCode = NO;
//            [User save:result[@"data"][0]];
//            self.user = [User info];
//            [self.tableView reloadData];
//        }else{
//            self.isGeneratingCode = NO;
//            [self.tableView reloadData];
//            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
//        }
//    }];
//}

- (void)generateReferralCode{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"update_info" forKey:@"command"];
    [params setObject:self.user.userId forKey:@"user_id"];
    [params setObject:@"generate" forKey:@"reffarl_no"];
    //https://trip.myxpapp.com/services/index.php?command=update_info&user_id=787&reffarl_no=generate
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil){
            NSDictionary *result = json[@"result"];
            self.isGeneratingCode = NO;
            [User save:result[@"data"][0]];
            self.user = [User info];
            [self.tableView reloadData];
        }else{
            [self handleGenerateReferalCodeError:[json objectForKey:@"error"]];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleGenerateReferalCodeError:error.localizedDescription];
    }];
}

-(void) handleGenerateReferalCodeError: (NSString *)errorDescription {
    self.isGeneratingCode = NO;
    [self.tableView reloadData];
    [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:errorDescription];
}

-(void)showAvilableRidesView{
    [self.navigationController pushViewController:instantiateVC(AVAILABLERIDES) animated:YES];
}
-(void)showDocumentsView{
    [self performSegueWithIdentifier:@"ShowDocumentVC" sender:self];
    // [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW)  animated:YES];
}
-(void)showEditProfileView{
    [self performSegueWithIdentifier:@"ShowEditProfileVC" sender:self];
    // [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW)  animated:YES];
}
-(void)showVehicelInfoView{
    [self performSegueWithIdentifier:@"ShowVehicleVC" sender:self];
    // [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW)  animated:YES];
}
-(void)showBackInfoView{
    [self performSegueWithIdentifier:@"ShowBankInfoVc" sender:self];
    // [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW)  animated:YES];
}
-(void)showABNNumberView{
    [self performSegueWithIdentifier:@"ShowAbnNumberVC" sender:self];
    // [self.navigationController pushViewController:instantiateVC(DOCUMENTS_VIEW)  animated:YES];
}
-(void)showFareManageView
{
    
    [self.navigationController pushViewController:instantiateVC(MANAGEFARE)  animated:YES];
}
-(void)addGusture{
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [self.profileImage addGestureRecognizer:pgr];
    
    
}
- (void)handlePinch:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    [self showActionSheet];
}
#pragma mark -
#pragma mark take pic
- (void)showActionSheet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Add Photo"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* SelectFormGallery = [UIAlertAction
                                        actionWithTitle:@"Take Photo"
                                        
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
        [self TakePic];
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    UIAlertAction* TakePhoto = [UIAlertAction
                                actionWithTitle:@"Choose Existing Photo"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
        [self selectPic];
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    [view addAction:SelectFormGallery];
    [view addAction:TakePhoto];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
    
}


-(void)TakePic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)selectPic
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.sourceType=UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.profileImage.image = editedImage;
    [self isPicSelestion:true];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [self upLoadImage:editedImage];
        
    }];
    
    
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    [self isPicSelestion:true];
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [portraitImg resizedImageToFitInSize:CGSizeMake(320, 320) scaleIfSmaller:NO];
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:11.0];
        
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark image scale utility


- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) //NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark - Web Services -
-(void)upLoadImage:(UIImage *) image
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Uploading Image";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(image,0.6), @"file", nil];
    
    [AlamofireWrapper uploadImageWithParameters:params completion:^(NSString *fileName, NSString *error) {
        if (fileName) {
            [self updateProfileInfo:fileName];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            if ([@"Authorization required" compare:error]==NSOrderedSame){
            }
        }
    }];
    
//    [[AFAppDotNetAPIClient sharedClient] uploadImage:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(image,0.6), @"file", nil] :^(NSString * _Nullable imageName, NSString * _Nullable error) {
//        if (!error) {
//             [self updateProfileInfo:imageName];
//        }else {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//           
//            if ([@"Authorization required" compare:error]==NSOrderedSame){
//            }
//        }
//        
//    }];
    
    
//    [[NetworkHelper sharedInstance] commandWithParams: onCompletion:^(NSDictionary *json){
//        if (![json objectForKey:@"error"]&&[json objectForKey:RESULT]!=nil){
//            [self updateProfileInfo:json[RESULT][@"file_name"]];
//        } else {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString* errorMsg = [json objectForKey:@"error"];
//            if ([@"Authorization required" compare:errorMsg]==NSOrderedSame){
//            }
//        }
//    }];
    
}



//-(void)logout
//{
//    
//    [DELG.updLoctionTimer invalidate];
//    DELG.updLoctionTimer = nil;
//    if ([DELG.updLoctionTimer isValid]){
//        //DLog(@"DELG.updLoctionTimer not validaye");
//    }
//    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hue.labelText=@"Logging out..";
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"logout",@"command",self.user.userId,@"user_id", nil];
//   [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"]&&json!=nil)
//        {
//            [DELG.updLoctionTimer invalidate];
//            DELG.updLoctionTimer = nil;
//            [SHAREMANAGER clearUserDefault];
//            [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            
//            
//        }else
//        {
//            
//            ////NSLog(@"Error :%@",[json objectForKey:@"error"]);
//            [self enableOnlineBtn];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:[json objectForKey:@"error"]];
//            
//        }
//    }];
//    
//}

-(void)logout
{
    
    [DELG.updLoctionTimer invalidate];
    DELG.updLoctionTimer = nil;
    if ([DELG.updLoctionTimer isValid]){
        //DLog(@"DELG.updLoctionTimer not validaye");
    }
    MBProgressHUD *hue=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hue.labelText=@"Logging out..";
    NSString *idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"logout",@"command",self.user.userId,@"user_id", idString, @"session_id", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&&json!=nil)
        {
            [DELG.updLoctionTimer invalidate];
            DELG.updLoctionTimer = nil;
            [SHAREMANAGER clearUserDefault];
            [self.navigationController setViewControllers:@[instantiateVC(LOGIN)] animated:NO];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            [self handleLogoutError:[json objectForKey:@"error"]];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleLogoutError:error.localizedDescription];
    }];
    
}

-(void) handleLogoutError: (NSString *)errorDescription {
    [self enableOnlineBtn];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showCustomUIAlertViewWithtilet:@"Info" andWithMessage:errorDescription];
}

//- (void)updateProfileInfo:(NSString *)imageName{
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:@"updateProfile" forKey:@"command"];
//    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [params setObject:imageName forKey:@"photo"];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            [User save:results];
//            self.user = [User info];
//            [CommonFunctions showAlertWithTitel:@"" message:@"Picture uploaded successfully." inVC:self];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateProfileInfo:imageName];
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

- (void)updateProfileInfo:(NSString *)imageName{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"updateProfile" forKey:@"command"];
    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
    [params setObject:imageName forKey:@"photo"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            self.user = [User info];
            [CommonFunctions showAlertWithTitel:@"" message:@"Picture uploaded successfully." inVC:self];
        }else{
            [self handleUpdateProfileInfoError:[json objectForKey:@"error"] imageName:imageName];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleUpdateProfileInfoError:error.localizedDescription imageName:imageName];
    }];
}

-(void) handleUpdateProfileInfoError: (NSString *)errorDescription imageName: (NSString *)imageName {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    NSString *errorMsg =[json objectForKey:@"error"];
    if ([ErrorFunctions isError:errorDescription]){
        [self updateProfileInfo:imageName];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}
- (void)showHudWithText:(NSString *)text{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(100, 50);
    hud.labelText = text;
    [hud hide:YES afterDelay:3];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowBankInfoVc"]) {
        AccountsViewController *aVC = (AccountsViewController *)segue.destinationViewController;
        aVC.isAddAccount = true;
        aVC.selectedCurrency = SHAREMANAGER.user.defaultCurrency;
        DLog(@"** wk selectedCurrency: %@", SHAREMANAGER.user.defaultCurrency.name);
    }
}

#pragma Start Tracking Location
-(void)startTrackingLocation{
    
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        [CommonFunctions showAlertWithTitel:@"" message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh" inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        [CommonFunctions showAlertWithTitel:@"" message: @"The functions of this app are limited because the Background App Refresh is disable." inVC:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
        
    } else{
        self.locationTracker =[[LocationTracker alloc] init];
        [self.locationTracker startLocationTracking];
        
    }
}



@end






















