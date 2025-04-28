//
//  MenuView.m
//  XPDriver
//
//  Created by Syed zia on 25/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "WalletCell.h"
#import "SideMenuCell.h"
#import "WithdrawController.h"
#import "VPImageCropperViewController.h"
#import "MenuView.h"
#import "XP_Driver-Swift.h"

@interface MenuView()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,UIGestureRecognizerDelegate>{
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, assign) BOOL isShowActivity;
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) WithdrawController *withdrawController;
@property  (assign,nonatomic,setter=isPicSelestion:) BOOL isPicSelestion;
@property (assign, nonatomic) BOOL  isExpand;
@property (strong, nonatomic) id    mainViewController;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *settingArray;
- (IBAction)logoutButttonPressed:(UIButton *)sender;

@end
@implementation MenuView
@synthesize delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.shadowRadius  = 1.5f;
        self.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
        self.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0.9f;
        self.layer.masksToBounds = NO;
        UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
        UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, shadowInsets)];
        self.layer.shadowPath    = shadowPath.CGPath;
        
        
    }
    return self;
}
- (void)dataSetupWithDeleagte:(id<MenuViewDeleagte>)menuViewDeleagte{
    [self fetchDataFormServer];
    self.isShowActivity = YES;
    self.mainViewController = [self.superview nextResponder];
    [self.userImageView round];
    self.delegate = menuViewDeleagte;
    self.isExpand = YES;
    self.settingArray = [[NSMutableArray alloc] initWithObjects:@{@"titel":@"Privacy Policy", @"url":SHAREMANAGER.appData.privacyURL},@{@"titel":@"Terms & Conditions", @"url":SHAREMANAGER.appData.tremsURL},@{@"titel":@"Help & Support", @"url":[NSURL URLWithString:KContact_us]}, nil];
    self.user = [User info];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.userNameLabel setText:[NSString stringWithFormat:@"%@ %@",self.user.firstName,self.user.lastName]];
    [self fetchUserImage];
    [self.tableView  reloadData];
    if (strEquals(self.user.status, ONLINE)){
        [self.statusImageView setImage:ONLINE_IMAGE];
    } else if (strEquals(self.user.status, OFFLINE)){
        [self.statusImageView setImage:OFFLINE_IMAGE];
    }else if (strEquals(self.user.status, ONDUTY)){
        [self.statusImageView setImage:OnDuty_IMAGE];
    }
    [self addGusture];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
}
-(void)addGusture{
    
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [self.userImageView addGestureRecognizer:pgr];
    
    
}
- (void)handlePinch:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    [self showActionSheet];
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(20, 0,0.5,ViewWidth(tableView)-40)];
    [view setBackgroundColor:self.tableView.separatorColor];
    return view;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [SHAREMANAGER.user.testUser isEqualToString:@"1"] ? 3 : 2;
    }else if (section == 1) {
        return 5;//6;
    }else{
        return self.isExpand ? self.settingArray.count + 1 : 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self walletCell];
        } else if (indexPath.row == 1) {
            SideMenuCell* cell = [self.tableView dequeueReusableCellWithIdentifier:SideMenuCell.identifier forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.lable setText:@"Availability"];
            [cell.cellImageView setImage:[UIImage imageNamed:@"ic_user"]];
            return cell;
        } else {
            SideMenuCell* cell = [self.tableView dequeueReusableCellWithIdentifier:SideMenuCell.identifier forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.lable setText:@"Custom Location"];
            [cell.cellImageView setImage:[UIImage imageNamed:@"ic_user"]];
            return cell;
        }
    }
    SideMenuCell* cell = [self.tableView dequeueReusableCellWithIdentifier:SideMenuCell.identifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [cell.lable setText:@"Profile"];
                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_user"]];
                break;
            case 1:
                [cell.lable setText:@"My Earnings"];
                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_earnings"]];
                break;
            case 2:
                [cell.lable setText:@"Order History"];
                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_history"]];
                break;
            case 3:
                cell.lable.numberOfLines = 0;
                [cell.lable setAttributedText:[NSAttributedString attributedStringWithTitel:@"Share &" withFont:cell.textLabel.font titleColor:cell.textLabel.textColor subTitle:@"Get Paid" withfont:cell.textLabel.font subtitleColor:[UIColor appGreenColor] nextLine:YES]];
                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_share_paid"]];
                cell.lable.textAlignment = NSTextAlignmentLeft;
                break;
//            case 4:
//                [cell.lable setText:@"Batch Management"];
//                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_batch_management"]];
//                break;
//            case 5:
//                [cell.lable setText:@"Contact Us"];
//                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_contact_us"]];
//                break;a`
            case 4:
                [cell.lable setText:@"Contact Us"];
                [cell.cellImageView setImage:[UIImage imageNamed:@"ic_contact_us"]];
                break;
            default:
                break;
        }
    }else{
        if (indexPath.row == 0) {
            [cell.lable setText:@"Legal"];
            [cell.cellImageView setImage:nil];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSInteger index = indexPath.row - 1;
            [cell.lable setText:self.settingArray[index][@"titel"]];
            [cell.cellImageView setImage:nil];
        }
        
    }
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        [self.mainViewController performSegueWithIdentifier:@"ShowWithdrawVC" sender:self.mainViewController];
        if (indexPath.row == 0) {
            [self.delegate walletsClick];
        } else if (indexPath.row == 1) {
            [self.delegate clickDriverAvailability];
        } else {
            [self.delegate CustomLocationClick];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.delegate showView:SHOWPROFILE url:nil];
        }else  if (indexPath.row == 1) {
            [self.delegate showView:EARNING url:nil];
        }else  if (indexPath.row == 2) {
            [self.mainViewController performSegueWithIdentifier:@"ShowOrderHistoryVC" sender:self.mainViewController];
        }else  if (indexPath.row == 3) {
            [self.delegate showView:@"ShowInviteFriendVC" url:nil];
        }else  if (indexPath.row == 4) {
//            [self.delegate showView:@"ShowBatchManagementVC" url:nil];
//        }else  if (indexPath.row == 5) {
            NSURL *url = [NSURL URLWithString:@"https://xpeats.com/#contact"];
            if (url) {
                [self.delegate showView:WebView_Idintifire url:url];
            }
//            [self.delegate showView:WebView_Idintifire url:SHAREMANAGER.appData.contactUsURL];
        }
    }else{
        if (indexPath.row == 0) {
            self.isExpand = !self.isExpand;
            ///reload this section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSInteger index = indexPath.row - 1;
            [self.delegate showView:WebView_Idintifire url:self.settingArray[index][@"url"]];
        }
    }
}

- (WalletCell *)walletCell{
    WalletCell* cell  = [self.tableView dequeueReusableCellWithIdentifier:WalletCell.identifier];
    if (self.withdrawController == nil) {
        DLog(@"wk check value nil");
    } else {
        DLog(@"wk check value not nil");
    }
    [cell.balanceLable setTextWithAnimation:self.withdrawController == nil ? @"$0.00" : self.withdrawController.availableAmount];
    [self showActivityIndicator:self.isShowActivity forTableViewCell:cell];
    //:[NSString stringWithFormat:@"%@%@",SHAREMANAGER.appData.country.currenceySymbol,SHAREMANAGER.user.balance]
    return cell;
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
    [self.parentViewController presentViewController:view animated:YES completion:nil];
    
    
}


-(void)TakePic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.parentViewController presentViewController:picker animated:YES completion:NULL];
}
-(void)selectPic
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.sourceType=UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.delegate = self;
    [self.parentViewController presentViewController:imagePickerController animated:YES completion:nil];
    
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.userImageView.image = editedImage;
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
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.width) limitScaleRatio:11.0];
        
        imgCropperVC.delegate = self;
        [self.parentViewController presentViewController:imgCropperVC animated:YES completion:^{
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
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText=@"Uploading Image";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(image,0.6), @"file", nil];
    
    [AlamofireWrapper uploadImageWithParameters:params completion:^(NSString *fileName, NSString *error) {
        if (fileName) {
            [self updateProfileInfo:fileName];
        } else {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if ([@"Authorization required" compare:error] == NSOrderedSame){
            }
        }
    }];
    
    
//    [[AFAppDotNetAPIClient sharedClient] uploadImage:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(image,0.6), @"file", nil] :^(NSString * _Nullable imageName, NSString * _Nullable error) {
//        if (!error) {
//            [self updateProfileInfo:imageName];
//        }else{
//            [MBProgressHUD hideHUDForView:self animated:YES];
//            if ([@"Authorization required" compare:error] == NSOrderedSame){
//            }
//        }
//        
//    }];
    
    //    [[NetworkHelper sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", UIImageJPEGRepresentation(image,0.6), @"file", nil] onCompletion:^(NSDictionary *json){
    //        if (![json objectForKey:@"error"]&&[json objectForKey:RESULT]!=nil){
    //            [self updateProfileInfo:json[RESULT][@"file_name"]];
    //        } else {
    //            [MBProgressHUD hideHUDForView:self animated:YES];
    //            NSString* errorMsg = [json objectForKey:@"error"];
    //            if ([@"Authorization required" compare:errorMsg]==NSOrderedSame){
    //            }
    //        }
    //    }];
    
}
- (void)showActivityIndicator:(BOOL)show forTableViewCell:(UITableViewCell *)cell{
    if (show) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView startAnimating];
        cell.accessoryView = activityIndicatorView;
    }
    else {
        cell.accessoryView = nil;
    }
}

//- (void)updateProfileInfo:(NSString *)imageName{
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:@"updateProfile" forKey:@"command"];
//    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [params setObject:imageName forKey:@"photo"];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
//            [MBProgressHUD hideHUDForView:self animated:YES];
//            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
//            [User save:results];
//            self.user = [User info];
//            [CommonFunctions showAlertWithTitel:@"" message:@"Picture uploaded successfully." inVC:self.parentViewController];
//        }else{
//            [MBProgressHUD hideHUDForView:self animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateProfileInfo:imageName];
//            }
//            else {
//                [MBProgressHUD hideHUDForView:self animated:YES];
//
//                [CommonFunctions showAlertWithTitel:@"Oops!" message:[json objectForKey:@"error"] inVC:self.parentViewController];
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
        NSLog(@"wk Response updateProfileInfo JSON: %@", json);
        
        if (![json objectForKey:@"error"]&&json!=nil) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            NSDictionary *results =[[json objectForKey:RESULT] dictionaryByReplacingNullsWithBlanks];
            [User save:results];
            self.user = [User info];
            [CommonFunctions showAlertWithTitel:@"" message:@"Picture uploaded successfully." inVC:self.parentViewController];
        }else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            [self handleError:[json objectForKey:@"error"] imageName:imageName];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription imageName:imageName];
    }];
}

- (void)handleError:(NSString *)errorDescription imageName: (NSString *)imageName {
    NSLog(@"Error: %@", errorDescription);
    [MBProgressHUD hideHUDForView:self animated:YES];
    
    if ([ErrorFunctions isError:errorDescription]){
        [self updateProfileInfo:imageName];
    }
    else {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self.parentViewController];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

#pragma mark-WebServices -
//- (void)fetchDataFormServer{
//    DLog(@"Called");
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"my_account" forKey:@"command"];
//    [parameters setObject:SHAREMANAGER.userId forKey:@"user_id"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"]&& json!=nil){
//            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[RESULT]];
//            self.isShowActivity = NO;
//            [self.tableView reloadData];
//        }else {
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//
//            }else {
//                DLog(@"Error %@",errorMsg);
//            }
//
//        }
//    }];
//
//}

- (void)fetchDataFormServer{
    DLog(@"Called");
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"my_account1" forKey:@"command"];
    [parameters setObject:SHAREMANAGER.userId forKey:@"user_id"];
    [parameters setObject:@"1" forKey:@"page"];
    [parameters setObject:@"20" forKey:@"limit"];
    
    if (SHAREMANAGER.user.defaultCurrency.name){
        [parameters setObject:SHAREMANAGER.user.defaultCurrency.name forKey:@"currency"];
    }else{
        [parameters setObject:SHAREMANAGER.user.currency forKey:@"currency"];
    }
    DLog(@"wk params: %@", parameters);
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response MenuView fetchDataFormServer JSON: %@", json);
        
        if (![json objectForKey:@"error"]&&json!=nil) {
            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[RESULT]];
            self.isShowActivity = NO;
            [self.tableView reloadData];
        }else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            NSString *errorMsg =[json objectForKey:@"error"];
            if ([ErrorFunctions isError:errorMsg]){
                
            }else {
                DLog(@"Error %@",errorMsg);
            }
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        
        if ([ErrorFunctions isError:error.localizedDescription]){
            
        }else {
            DLog(@"Error %@",error.localizedDescription);
        }
    }];
}

//-(void)fetchUserImage{
//    if (strEquals(self.user.picNeme, NO_PICTURE)) {
//        return;
//    }
//    NSString *imageUrl = strFormat(@"%@%@",SHAREMANAGER.profilePicPath,self.user.picNeme);
//    __weak typeof(self) weekSelf = self;
//
//    [self.userImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]]
//                             placeholderImage :USER_PLACEHOLDER
//                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//        weekSelf.userImageView .image = image;
//    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){}];
//    
//    
//}


//-(void)fetchUserImage{
//    if (strEquals(self.user.picNeme, NO_PICTURE)) {
//        return;
//    }
//    NSString *imageUrlString = strFormat(@"%@%@",SHAREMANAGER.profilePicPath,self.user.picNeme);
//    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
//    
//    __weak typeof(self) weekSelf = self;
//    
//    NSURLSessionDataTask *imageDataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (error) {
//                NSLog(@"Error downloading image: %@", error.localizedDescription);
//                return;
//            }
//            
//            // Check if the response is valid
//            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode == 200) {
//                // Convert the data to an image
//                UIImage *downloadedImage = [UIImage imageWithData:data];
//                
//                // Update the UI on the main thread
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Set the downloaded image to the UIImageView
//                    weekSelf.userImageView .image = downloadedImage;
//                });
//            }
//        }];
//        
//        // Start the URLSession task
//        [imageDataTask resume];
//}


-(void)fetchUserImage{
    if (strEquals(self.user.picNeme, NO_PICTURE)) {
        return;
    }
    NSString *imageUrlString = strFormat(@"%@%@",SHAREMANAGER.profilePicPath,self.user.picNeme);
    
    [AlamofireWrapper downloadImageFrom:imageUrlString completion:^(UIImage *downloadedImage) {
        // Handle downloadedImage or nil as needed
        if (downloadedImage) {
            // Do something with the downloaded image
            self.userImageView.image = downloadedImage;
            
        } else {
            // Handle the case when the image download fails
        }
    }];
    
//    __weak typeof(self) weekSelf = self;
//    
//    NSURLSessionDataTask *imageDataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (error) {
//                NSLog(@"Error downloading image: %@", error.localizedDescription);
//                return;
//            }
//            
//            // Check if the response is valid
//            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode == 200) {
//                // Convert the data to an image
//                UIImage *downloadedImage = [UIImage imageWithData:data];
//                
//                // Update the UI on the main thread
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    // Set the downloaded image to the UIImageView
//                    weekSelf.userImageView.image = downloadedImage;
//                });
//            }
//        }];
//        
//        // Start the URLSession task
//        [imageDataTask resume];
}


- (IBAction)logoutButttonPressed:(UIButton *)sender {
    [self.delegate showView:@"" url:nil];
}
@end
