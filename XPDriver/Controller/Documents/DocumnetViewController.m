//
//  DocumnetViewController.m
//  XPDriver
//
//  Created by Syed zia on 02/12/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "State.h"
#import "DocumentCell.h"
#import "DocumentDetailViewController.h"
#import "DatePickerViewController.h"

#import "DocumnetViewController.h"

@interface DocumnetViewController ()<UITableViewDelegate,UITableViewDataSource>{
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
@property (nonatomic, strong) Document *selectedDoument;
@property (nonatomic, strong) State *state;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *documentsImages;
@property (nonatomic, strong) NSMutableArray *selectedDocumentsArray;
@property (nonatomic, strong) NSMutableArray *documentsArray;
@property (nonatomic, strong) IBOutlet RoundedButton *uploadButton;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation DocumnetViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User info];
    self.documentsArray = [NSMutableArray new];
    //DLog(@"self.documentsArray  %@",self.documentsArray);
    self.documentsImages =   [NSMutableArray new];
    self.selectedDocumentsArray = [NSMutableArray new];
    [self.uploadButton setType:Disable];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backToHome)
                                                 name:kRide_Request_Notification object:nil];
   
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self fetchUserDocuments];
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.documentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Document *docment = self.documentsArray[indexPath.row];
    NSString* cellIdentifier = NSStringFromClass([DocumentCell class]);
    DocumentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configer:docment indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedDoument = self.documentsArray[indexPath.row];
    [self performSegueWithIdentifier:@"ShowDocDetail" sender:self];
}

- (void)backToHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

//#pragma mark - Webserivces -
- (void)fetchUserDocuments{
    [Document fetchUserDocments:^(NSMutableArray * _Nonnull documents, NSString * _Nonnull error) {
        if (documents.count != 0) {
            self.documentsArray = [NSMutableArray new];
            self.documentsArray = documents;
            [self.tableView reloadData];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[DocumentDetailViewController class]]) {
        DocumentDetailViewController *dpVC = (DocumentDetailViewController *)[segue destinationViewController];
        dpVC.selectedDoument = self.selectedDoument;
        
    }
}

@end
