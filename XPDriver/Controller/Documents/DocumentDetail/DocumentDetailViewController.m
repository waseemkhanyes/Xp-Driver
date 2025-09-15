//
//  DocumentDetailViewController.m
//  A1Driver
//
//  Created by Macbook on 16/07/2019.
//  Copyright © 2019 Syed zia. All rights reserved.
//
#import "DatePickerViewController.h"
#import "DocumentDetailViewController.h"
#import "XP_Driver-Swift.h"

@interface DocumentDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,VPImageCropperDelegate,UITextFieldDelegate>
{
    UIImageView *selectedImgView;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic, assign) BOOL isBothImagesSelected;
@property (nonatomic, assign) BOOL isBackSidePicture;
@property (nonatomic, assign) BOOL isPlaceholderImage;

@property (nonatomic, assign) UIDatePickerMode pickerMode;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) ACFloatingTextField *selectedFiled;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) NSMutableArray *selectedDocumentsArray;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *docFrontImageView;
@property (strong, nonatomic) IBOutlet UIImageView *docBackImageView;
@property (nonatomic, strong) IBOutlet ACFloatingTextField *expiryDateField;
@property (strong, nonatomic) IBOutlet UIStackView *frontBackStackView;
- (IBAction)docImageViewTapped:(UITapGestureRecognizer *)sender;


@property (nonatomic, strong) IBOutlet RoundedButton *uploadButton;
- (IBAction)uploadButtonPressed:(id)sender;
@end

@implementation DocumentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self screenSetup];
}
- (void)screenSetup{
    //[self.uploadButton setEnabled:NO];
    [self.titleLabel setText:self.selectedDoument.name];
    self.selectedDocumentsArray = [NSMutableArray  new];
    [self.frontBackStackView setHidden:self.selectedDoument.isONeSidedDocument];
    [self.docBackImageView setHidden:self.selectedDoument.isONeSidedDocument];
    [self.expiryDateField setHidden:!self.selectedDoument.isExpiryDate];
}
#pragma mark- UITextFieldDelegate -
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}


#pragma mark Show Actionsheet
- (void)showActionSheet
{
    UIAlertController * view =   [UIAlertController
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
                                actionWithTitle:@"Choose Existing"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self selectPic];
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
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

-(void)TakePic
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)selectPic
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.sourceType=UIImagePickerControllerCameraCaptureModePhoto;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self.selectedImageView setImage:editedImage];
    [self saveImageForUploading];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}
- (void)saveImageForUploading{
    Document *doc  = self.selectedDoument;
    DocumentImage *docImage = [[DocumentImage alloc] initWithType:doc.type image:self.selectedImageView.image];
    docImage.isBackImage    = self.isBackSidePicture;
    docImage.isFrontImage   = !self.isBackSidePicture;
    [self updateSelectedDocumentInfo:docImage];
    if (doc.docSides == 2) {
    // [self.uploadButton setEnabled:self.isBothImagesSelected];
    } if (doc.docSides == 1) {
       // [self.uploadButton setEnabled:self.selectedDocumentsArray.count ==1];
    }
    
}
- (void)updateSelectedDocumentInfo:(DocumentImage *)docImage{
    if (self.selectedDocumentsArray.count != 0) {
      [self.selectedDocumentsArray addObject:docImage];
    }else if ([self.selectedDocumentsArray containsObject:docImage]) {
            int indax = (int) [self.selectedDocumentsArray indexOfObject:docImage];
            DocumentImage *selectedImage = [self.selectedDocumentsArray  objectAtIndex:indax];
            if (![selectedImage isEqual:docImage]) {
                [self.selectedDocumentsArray addObject:docImage];
            }else{
                [self.selectedDocumentsArray replaceObjectAtIndex:indax withObject:docImage];
            }
    }else{
      [self.selectedDocumentsArray addObject:docImage];
    }
    
}
- (BOOL)isBackSidePicture{
    return self.selectedImageView.tag == 2;
}
- (BOOL)isBothImagesSelected{
    
    return self.selectedDocumentsArray.count == self.selectedDoument.docSides;
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:self.cropFrame limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imgCropperVC];
        [self presentViewController:navigationController animated:YES completion:NULL];
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


-(CGRect)cropFrame{
    NSInteger imgtag = selectedImgView.tag;
    CGRect frame;
    if (imgtag == 1 || imgtag == 2) {
        
    }else {
        frame = rect(0, 100, self.view.frame.size.width, self.view.frame.size.width);
        
    }
    return  frame = rect(0, 200, self.view.frame.size.width, 200);;
}
-(void)upLoadDocImage:(DocumentImage *)docImage{

    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Uploading Document";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"upload", @"command", docImage.imageDate, @"file", nil];
    
    [AlamofireWrapper uploadImageWithParameters:params completion:^(NSString *fileName, NSString *error) {
        if (fileName) {
            docImage.name = fileName;
            [self updateDocumentInfo:docImage];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//             NSString* errorMsg = [json objectForKey:@"error"];
//             //DLog(@"error :%@",errorMsg);
            [self upLoadDocImage:docImage];
        }
    }];
    
//    [[AFAppDotNetAPIClient sharedClient] uploadImage:prams :^(NSString * _Nullable imageName, NSString * _Nullable error) {
//        if (!error) {
//            docImage.name = imageName;
//            [self updateDocumentInfo:docImage];
//        }else{
//                     [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //             NSString* errorMsg = [json objectForKey:@"error"];
//        //             //DLog(@"error :%@",errorMsg);
//                     [self upLoadDocImage:docImage];
//
//                 }
//
//    }];
    
    
//    [[API sharedInstance] commandWithParams:prams onCompletion:^(NSDictionary *json){
//     if (![json objectForKey:@"error"] && [json objectForKey:RESULT] !=nil) {
//         docImage.name = json[RESULT][@"file_name"];
//         [self updateDocumentInfo:docImage];
//         } else{
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
////             NSString* errorMsg = [json objectForKey:@"error"];
////             //DLog(@"error :%@",errorMsg);
//             [self upLoadDocImage:docImage];
//
//         }
//
//     }];

    //
}
//- (void)updateDocumentInfo:(DocumentImage *)docImage{
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:@"updateDocuments" forKey:@"command"];
//    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [params setObject:docImage.name forKey:@"doc_name"];
//    [params setObject:docImage.type forKey:@"doc_key"];
//    [params setObject:docImage.side forKey:@"side"];
//    if (docImage.expiryDate) {
//        [params setObject:docImage.expiryDate forKey:@"expiry"];
//    }
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
//           
//            NSString *message = @"Image uploaded successfully.";
//            [self removeUploadedImageFormArray:docImage];
//            [self updloadSelectedImages:message];
//        }else{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateDocumentInfo:docImage];
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
- (void)updateDocumentInfo:(DocumentImage *)docImage{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"updateDocuments" forKey:@"command"];
    [params setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
    [params setObject:docImage.name forKey:@"doc_name"];
    [params setObject:docImage.type forKey:@"doc_key"];
    [params setObject:docImage.side forKey:@"side"];
    if (docImage.expiryDate) {
        [params setObject:docImage.expiryDate forKey:@"expiry"];
    }
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateDocumentInfo JSON: %@", json);
        if (![json objectForKey:@"error"] && json!=nil && [json[@"success"] intValue] != 0){
           
            NSString *message = @"Image uploaded successfully.";
            [self removeUploadedImageFormArray:docImage];
            [self updloadSelectedImages:message];
        }else{
            [self handleError:[json objectForKey:@"error"] documentImage:docImage];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription documentImage:docImage];
    }];
}

- (void)handleError:(NSString *)errorDescription documentImage:(DocumentImage *)image {
    // Your implementation here
    NSLog(@"Error: %@", errorDescription);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([ErrorFunctions isError:errorDescription]){
        [self updateDocumentInfo:image];
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        ////NSLog(@"Error is %@",[json objectForKey:@"error"]);
    }
}

- (void)removeUploadedImageFormArray:(DocumentImage *)docImage{
    for (DocumentImage *docimg in [self.selectedDocumentsArray reverseObjectEnumerator]) {
        BOOL isExisting = strEquals(docimg.type, docImage.type);
        if ((isExisting && docimg.isBackImage && docImage.isBackImage) || (isExisting && docimg.isFrontImage && docImage.isFrontImage)) {
            [self.selectedDocumentsArray removeObject:docimg];
            break;
        }
    }
}
- (void)updloadSelectedImages:(NSString *)successMessage{
    if (self.selectedDocumentsArray.count != 0) {
        DocumentImage *docImage = self.selectedDocumentsArray[0];
        //DLog(@"Image Titel : %@ side: %@",docImage.titel,docImage.side);
        [self upLoadDocImage:docImage];
    }else{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //[self.uploadButton setEnabled:NO];
        [CommonFunctions showAlertWithTitel:@"" message:successMessage inVC:self completion:^(BOOL success) {
           [self.navigationController popViewControllerAnimated:NO];
        }];
    }
}
- (void)imageTaped:(UIImageView *)imageView{
    self.selectedImageView = imageView;
    [self showActionSheet];
}
- (IBAction)docImageViewTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    UIImageView *tapedImageView = (UIImageView *)sender.view;
    [self imageTaped:tapedImageView];
}
- (IBAction)uploadButtonPressed:(id)sender{
    [self.view endEditing:YES];
    Document *doc  = self.selectedDoument;
    if (doc.docSides == 2 && self.selectedDocumentsArray.count != 2) {
        [CommonFunctions showAlertWithTitel:@"" message:strFormat(@"%@ front & back sides pictures required.",doc.name) inVC:self];
        return;
       }
    else if (doc.docSides == 1 && self.selectedDocumentsArray.count == 0) {
         [CommonFunctions showAlertWithTitel:@"" message:@"Please select picture." inVC:self];
        return;
       }
    if (self.selectedDoument.isExpiryDate && !self.expiryDateField.isVaild) {
        NSString *message = [NSString stringWithFormat:@"Please select %@'s expiry date",self.selectedDoument.name];
        [CommonFunctions showAlertWithTitel:@"" message:message inVC:self];
        return;
    }
    [self updloadSelectedImages:@""];
}


@end
