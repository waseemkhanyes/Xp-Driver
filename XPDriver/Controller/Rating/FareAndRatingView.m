
//
//  FairAndRatingView.m
//  fivestartdriver
//
//  Created by Syed zia ur Rehman on 26/07/2014.
//  Copyright (c) 2014 Syed zia ur Rehman. All rights reserved.
//
#import "FareCell.h"
#import "InvoiceCell.h"
#import "ShadowView.h"
#import "BottomBorderView.h"
#import "AppDelegate.h"
#import "XP_Driver-Swift.h"

@interface FareAndRatingView () {
    float oldyPostion;
}

@property (strong, nonatomic) IBOutlet ShadowView *addressView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet ShadowView *fareView;
@property (strong, nonatomic) IBOutlet UITableView *tabelVeiw;
@property (retain, nonatomic) IBOutlet  UILabel  *pickupTimeLabel;
@property (retain, nonatomic) IBOutlet  UILabel  *dropTimeLabel;
@property (retain, nonatomic) IBOutlet  UIStackView  *buttonStackView;
@property (strong, nonatomic) IBOutlet  UILabel  *pikupLabel;
@property (strong, nonatomic) IBOutlet  UILabel  *dropLabel;
@property (strong, nonatomic) IBOutlet  RoundedButton *confirmButton;
@property (strong, nonatomic) IBOutlet  RoundedButton *problimFareButton;
@property (strong, nonatomic) IBOutlet  RoundedButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *titelLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@end

@implementation FareAndRatingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self addRatingStars];
    [self.confirmButton setHidden:YES];
    if (SHAREMANAGER.isPakistan) {
        [self.problimFareButton setHidden:YES];
    }
    self.ratingIs = @"1.0";
    [self.starRatingView setScore:1.0 withAnimation:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabelVeiw addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    NSDate *tripDate = [NSDate dateFromString:self.order.pickedUpTime withFormat:DATE_TIME_DISPLAY];
    NSString *tripDateString = [NSDate stringFromDate:tripDate withFormat:DATE_ONLY_DISPLAY];
    NSString *ordernumber = [NSString stringWithFormat:@"Order #%@",self.order.orderId];
    NSAttributedString *titel = [NSAttributedString attributedString:ordernumber withFont:[UIFont normal] subTitle:tripDateString withfont:[UIFont small] nextLine:YES];
    [self.titelLabel setAttributedText:titel];
    [self fareInfoSetup];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
}

- (void)fareInfoSetup {
    
    // [self.tabelVeiw addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self.pikupLabel setText:self.order.restaurant.location.formetedAddress];
    [self.dropLabel setText:self.order.dropLocation.address];
    NSDate *pickupDate = [NSDate dateFromString:self.order.pickedUpTime withFormat:DATE_TIME_DISPLAY];
    NSString *pickTime = [NSDate stringFromDate:pickupDate withFormat:TIME_ONLY];
    NSString *dropTime = [NSDate stringFromDate:[NSDate dateFromString:self.order.deliveredTime withFormat:DATE_TIME_DISPLAY] withFormat:TIME_ONLY];
    [self.pickupTimeLabel setText:pickTime];
    [self.dropTimeLabel setText:dropTime];
}

-(BOOL)isHideConfirmBtn {
    
    if (_isCash || _isUser) {
        return NO;
    }else{
        return YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    self.tableViewHeight.constant = self.tabelVeiw.contentSize.height;
}

-(void)addRatingStars {
    float xPostion = 0;
    float yPostion = 0;
    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(xPostion,yPostion,ViewWidth(self.ratingView), ViewHeight(self.ratingView)) numberOfStar:5];
    NSLog(@"%@",_starRatingView);
    [self.starRatingView setScore:0.0f withAnimation:YES];
    _starRatingView.delegate = self;
    [self.ratingView addSubview:_starRatingView];
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:WHITE_COLOR];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    _reviewTextView.inputAccessoryView = toolbar;
    _reviewTextView.placeholder = @"Leave a comment";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (textView == self.reviewTextView) {
        [self toggleUp:YES];
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
}

-(void)textViewDidChange:(UITextView *)textView {
    
}

-(void)textViewDidChangeSelection:(UITextView *)textView {
    
    /*YOUR CODE HERE*/
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _reviewTextView) {
        [self toggleUp:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

-(void)toggleUp:(BOOL)up{
    
    CGRect frame = self.review.frame;
    
    __block  CGRect tvFrame = self.reviewTextView.frame;
    UIColor *bgColor;
    if (up) {
        oldyPostion = frame.origin.y;
        frame.origin.y     = 64;
        frame.size.height  += KReviewHight;
    }else {
        frame.origin.y    = oldyPostion; //ViewY(_fareView) + ViewHeight(_fareView) + 30;
        frame.size.height -= KReviewHight;
    }
    bgColor = up ? BG_COLOR : CLEAR_COLOR;
    [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        if (up) {
            [self.review setBackgroundColor:bgColor];
        }
        tvFrame.origin.y = up ? 0.0 : 5.0;
        [self.review setFrame:frame];
        [self.reviewTextView setFrame:tvFrame];
        
        if (!up) {
            [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.review setBackgroundColor:CLEAR_COLOR];
                [self.review setBackgroundColor:bgColor];
            } completion:^(BOOL finished) {
            }];}
    } completion:^(BOOL finished) {
        isShowen = up;
    }];
}

-(void)toggleUpFareView:(BOOL)up {
    CGRect frame = self.review.frame;
    UIColor *bgColor;
    if (up) {
        frame.origin.y    -= KReviewYPostion;
        frame.size.height += KReviewHight;
    } else {
        frame.origin.y    += KReviewYPostion;
        frame.size.height -= KReviewHight;
    }
    bgColor = up ? BG_COLOR : CLEAR_COLOR;
    [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        if (up) {
            [self.review setBackgroundColor:bgColor];
        }
        
        [self.review setFrame:frame];
        
        if (!up) {
            [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.review setBackgroundColor:CLEAR_COLOR];
                [self.review setBackgroundColor:bgColor];
            } completion:^(BOOL finished) {
            }];
        }
    } completion:^(BOOL finished) {
        isShowen = up;
    }];
}

-(void)doneClicked:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    NSLog(@"** wk rating: %f, string: %@", score, [NSString stringWithFormat:@"%f",score]);
    _ratingIs = strFormat(@"%f",score);
}

#pragma mark- UITableView Data Source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5; //70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0,ViewWidth(self.tabelVeiw),70)];
    //    [view setBackgroundColor:[UIColor whiteColor]];
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ViewWidth(view),ViewHeight(view))];
    //    [label setNumberOfLines:0];
    //    label.textColor     = [UIColor appGrayColor];
    //    FareInfo *fareInfo  = self.fare.lastObject;
    //    BOOL isCash = self.paymetnMode == 0;
    //    NSString *paymentMode = [NSString stringWithFormat:@"Payment via %@",isCash ? @"cash": @"credit card"];
    //    NSString *fareMessage = [NSString stringWithFormat:@"%@",fareInfo.subTitle];
    //    NSAttributedString *headerTitel = [NSAttributedString attributedString:strFormat(@"%@",fareMessage) withFont:[UIFont heading1] subTitle:strFormat(@"%@ \n%@ | %@",paymentMode,self.distance,self.duration) withfont:[UIFont normal] nextLine:YES];
    //    [label setAttributedText:headerTitel];
    //    [view addSubview:label];
    SZBorderView *view =[[SZBorderView alloc] initWithFrame:CGRectMake(20, 0,0.5,ViewWidth(tableView)-40)];
    view.backgroundColor = tableView.separatorColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    SZBorderView *view =[[SZBorderView alloc] initWithFrame:CGRectMake(20, 0,1,ViewWidth(tableView)-40)];
    view.backgroundColor = tableView.separatorColor;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.order.priceInvoiceItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  [self invoiceCell:indexPath];
}

- (InvoiceCell *)invoiceCell:(NSIndexPath *)indexPath{
    InvoiceCell *cell = [self.tabelVeiw dequeueReusableCellWithIdentifier:InvoiceCell.identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[InvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InvoiceCell.identifier];
        
    }
    cell.tableView = self.tabelVeiw;
    cell.tag = indexPath.row;
    InvoiceItem *invoiceItem = self.order.priceInvoiceItems[indexPath.row];
    [cell configer:invoiceItem];
    return cell;
}

- (IBAction)scoreButtonTouchUpInside:(id)sender {
    [self.starRatingView setScore:0.5f withAnimation:YES];
}

- (void)goToMapBtnPressed {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)ratingSetup {
    [self.confirmButton hideLoading];
    [self.buttonStackView setHidden:YES];
    [self.doneButton setHidden:NO];
    [self.starRatingView setAlpha:1.0];
    [self.reviewTextView setAlpha:1.0];
    [self.reviewTextView setPlaceholder:@"Leave a Comment"];
}

//-(void)updateActivity:(NSString *)activity{
//    NSString *review = _reviewTextView.text.length == 0 ? @"" :_reviewTextView.text;
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ratingAndReview",@"command",self.order.orderId,@"order_id",SHAREMANAGER.userId,@"user_id",_ratingIs,@"rating",review,@"review", nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error){
//        if (json != nil && ![json objectForKey:@"error"]){
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (strEquals(activity,Confirm_Fare )) {
//                [self ratingSetup];
//            }else if (strEquals(activity,RATING )) {
//                [self.doneButton hideLoading];
//                self.isRideCompleted = YES;
//                if (self.delegate) {
//                    [self.delegate deleteOrder:self.order];
//                }
//                if (self.isModal) {
//                    [self  dismissViewControllerAnimated:true completion:nil];
//                }else{
//                    [self.navigationController popViewControllerAnimated:false];
//                }
//
//            }
//
//
//        }
//        else{
//              [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errorMsg =[json objectForKey:@"error"];
//            if ([ErrorFunctions isError:errorMsg])
//            {
//                [self updateActivity:activity];
//            }else {
//
//            }
//
//        }
//
//    }];
//
//}

-(void)updateActivity:(NSString *)activity {
    NSString *review = _reviewTextView.text.length == 0 ? @"" :_reviewTextView.text;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ratingAndReviewOptimized",@"command",self.order.orderId,@"order_id",SHAREMANAGER.userId,@"user_id",_ratingIs,@"rating",review,@"review", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (json != nil && ![json objectForKey:@"error"]){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (strEquals(activity,Confirm_Fare )) {
                [self ratingSetup];
            } else if (strEquals(activity,RATING )) {
                [self.doneButton hideLoading];
                self.isRideCompleted = YES;
                if (self.delegate) {
                    [self.delegate deleteOrder:self.order];
                }
                if (self.isModal) {
                    [self  dismissViewControllerAnimated:true completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:false];
                }
            }
        } else{
            [self handleError:[json objectForKey:@"error"] activity:activity];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription activity:activity];
    }];
    
}

-(void) handleError: (NSString *)errorDescription activity: (NSString *)activity {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([ErrorFunctions isError:errorDescription]) {
        [self updateActivity:activity];
    } else {
        
    }
}

-(void)showCurrentLocationViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)confirmFareButtonPressed:(RoundedButton *)sender{
    [sender showLoading];
    [self updateActivity:Confirm_Fare];
}

- (IBAction)doneButtonPressed:(RoundedButton *)sender {
    [sender showLoading];
    [self updateActivity:RATING];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
