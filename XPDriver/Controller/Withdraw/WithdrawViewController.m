//
//  WithdrawViewController.m
//  XPDriver
//
//  Created by Macbook on 11/09/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "FTPopOverMenu.h"
#import "Transaction.h"
#import "AccountsViewController.h"
#import "HMSegmentedControl.h"
#import "WithdrawHeaderCell.h"
#import "WithdrawController.h"
#import "PayoutCell.h"
#import "Payments.h"


#import "WithdrawViewController.h"
#import "XP_Driver-Swift.h"
#define KADD_BANK_ACCOUNT @"Add bank account"
#define KEDIT @"Edit"
@interface WithdrawViewController ()
@property (nonatomic, assign) NSInteger selectedSegment;
@property (nonatomic,assign) BOOL isAddAccount;
@property (nonatomic,strong) UILabel *messageLbl;
@property (strong, nonatomic) NSArray *segmintTitles;
@property (strong, nonatomic) UserCurrency *selectedCurrency;
@property (nonatomic, strong) NSMutableArray <UserCurrency *>*currencies;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic,strong) WithdrawController *withdrawController;
@property (strong, nonatomic) IBOutlet ShadowView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *pendingBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLable;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *bankInfoLable;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic)  UIButton* currencyButton;

@property (strong, nonatomic) IBOutlet UILabel *lblOwingTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPayNowTitle;
@property (strong, nonatomic) IBOutlet UIView *viewPayNowBack;
@property (strong, nonatomic) IBOutlet UIButton *btnWithdraw;

@property (assign, nonatomic)  NSInteger totalPages;
@property (assign, nonatomic)  NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *lastPayments;

- (IBAction)withdrawButtonPressed:(RoundedButton *)sender;
- (IBAction)editButtonPressed:(UIButton *)sender;
@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.totalPages = 1;
    self.lastPayments = [[NSMutableArray alloc] init];
    
    [self defaultAccountSetup];
    [self drowSegmentedController];
    self.selectedCurrency = SHAREMANAGER.user.defaultCurrency;
    DLog(@"** wk self.selectedCurrency: %@", self.selectedCurrency);
//    [self fetchDataFormServer];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self defaultAccountSetup];
    [self fetchDataFormServer];
}
- (void)defaultAccountSetup{
    
    BOOL hasBankAccount   = (SHAREMANAGER.user.bankAccounts.count != 0 || SHAREMANAGER.user.ibans.count != 0 || SHAREMANAGER.user.debitCards.count != 0);
    BOOL isDefaultBankAccount        = SHAREMANAGER.user.DefaultbankAccount.accountNumber != nil;
    BOOL isDefaultCard     = SHAREMANAGER.user.defaultDebitCard.last4 != nil;
    NSString *buttonTitel = hasBankAccount ? KEDIT : KADD_BANK_ACCOUNT;
    [self.editButton setTitle:buttonTitel forState:UIControlStateNormal];
    if (isDefaultBankAccount) {
        self.bankInfoLable.text = isDefaultBankAccount ? [NSString stringWithFormat:@"%@   %@",SHAREMANAGER.user.DefaultbankAccount.name,SHAREMANAGER.user.DefaultbankAccount.accountNumber] : @"";
    }else if (isDefaultCard) {
        self.bankInfoLable.text = isDefaultCard ? [NSString stringWithFormat:@"%@   %@",SHAREMANAGER.user.defaultDebitCard.brand,SHAREMANAGER.user.defaultDebitCard.endingString] : @"";
    }
    
}
- (void)setup{
    
    NSArray *sortedArray = [SHAREMANAGER.user.userCurrencies sortedArrayUsingSelector:@selector(compare:)];
    self.currencies    = [NSMutableArray arrayWithArray:sortedArray];
    [self addCurrencyButtonItem];
    DLog(@"wk available_balance: %@", self.withdrawController.availableBalance);
//    [self.availableBalanceLable setText:self.withdrawController.availableBalance];
//    [self.availableBalanceLable setAttributedText:[self.withdrawController availableAttributedStringWithCurrency:self.selectedCurrency.name]];
    [self.availableBalanceLable setText:self.withdrawController.availableBalance];
    [self.availableBalanceLable setTextAlignment:NSTextAlignmentLeft];
    //   [self.pendingBalanceLabel setText:self.withdrawController.pendingAmount];
    [self.pendingBalanceLabel setAttributedText:[self.withdrawController pendingAttributedStringWithCurrency:self.selectedCurrency.name]];
    [self.pendingBalanceLabel setTextAlignment:NSTextAlignmentLeft];
    if (self.withdrawController.availableAmountValue >= 0.0) {
        [self.lblOwingTitle setText:@""];
        [self.lblPayNowTitle setText:@"Top Up"];
        self.viewPayNowBack.backgroundColor = [UIColor clearColor];
        [self.btnWithdraw setEnabled:true];
        [self.btnWithdraw setAlpha:1.0];
    } else {
//        [self.lblOwingTitle setText:[NSString stringWithFormat:@"%@ Owing", self.withdrawController.availableAmount]];
        [self.lblOwingTitle setText:self.withdrawController.availableBalance];
        [self.lblPayNowTitle setText:@"Pay Now"];
        self.viewPayNowBack.backgroundColor = [UIColor whiteColor];
        [self.btnWithdraw setEnabled:false];
        [self.btnWithdraw setAlpha:0.5];
    }
    [self.tableView reloadData];
    
}
- (void)addCurrencyButtonItem{
    self.currencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currencyButton.frame = CGRectMake(0, 0, 60, 40);
    
    UIImage *image = self.selectedCurrency.icon;
    [self.currencyButton setTitle:self.selectedCurrency.name forState:UIControlStateNormal];
    [self.currencyButton setTitleColor:[UIColor appBlackColor] forState:UIControlStateNormal];
    self.currencyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.currencyButton setImage:[image fitInSize:CGSizeMake( 25.0f,  25.0f)] forState:UIControlStateNormal];
    self.currencyButton.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    CGFloat spacing = 5; // the amount of spacing to appear between image and title
    self.currencyButton.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing, 0, 0);
    // self.currencyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, );
    [self.currencyButton addTarget:self action:@selector(showCurrancyAlert:event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.currencyButton];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}
- (IBAction)showCurrancyAlert:(UIBarButtonItem *)sender event:(UIEvent *)event{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.textColor = [UIColor appBlackColor];
    configuration.backgroundColor = [UIColor whiteColor];
    configuration.textAlignment = NSTextAlignmentCenter;
    
    [FTPopOverMenu showFromEvent:event withMenuArray:@[self.currencies[0].name,self.currencies[1].name] imageArray:@[self.currencies[0].icon,self.currencies[1].icon] configuration:configuration doneBlock:^(NSInteger selectedIndex) {
        self.selectedCurrency = SHAREMANAGER.user.userCurrencies[selectedIndex];
        if (selectedIndex == 0) {
            self.currencyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.currencyButton.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [self.currencyButton setImage:[self.currencies[0].icon fitInSize:CGSizeMake( 25.0f,  25.0f)] forState:UIControlStateNormal];
            [self.currencyButton setTitle:self.currencies[0].name forState:UIControlStateNormal];
        }else if (selectedIndex == 1) {
            self.currencyButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.currencyButton.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [self.currencyButton setImage:[self.currencies[1].icon fitInSize:CGSizeMake( 25.0f,  25.0f)] forState:UIControlStateNormal];
            [self.currencyButton setTitle:self.currencies[1].name forState:UIControlStateNormal];
        }
        [self fetchDataFormServer];
    } dismissBlock:^{
        DLog(@"dismissed");
    }];
    
    
}
-(void)drowSegmentedController{
    CGFloat viewWidth = CGRectGetWidth(self.bottomView.frame);
    CGFloat viewHeight = CGRectGetHeight(self.bottomView.frame);
    self.segmintTitles = @[@"Payments",@"Withdrawals",];
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,0, viewWidth,viewHeight)];
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.sectionTitles   = self.segmintTitles;
    self.segmentedControl.userDraggable = NO;
    self.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedControl.verticalDividerEnabled   = YES;
    self.segmentedControl.verticalDividerColor     = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
    self.segmentedControl.verticalDividerWidth     = 0.0f;
    self.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedControl.autoresizingMask         = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor appGrayColor],NSFontAttributeName : [UIFont normal]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor appGreenColor],NSFontAttributeName : [UIFont boldNormal]};
    self.segmentedControl.selectionIndicatorColor     = [UIColor appGreenColor];
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle    = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [_segmentedControl addTarget:self action:@selector(bottomSegmentedControllerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.bottomView addSubview:self.segmentedControl];
    self.selectedSegment = 0;
    [self.segmentedControl setSelectedSegmentIndex:0 animated:NO];
}
- (IBAction)bottomSegmentedControllerChanged:(HMSegmentedControl *)sender {
    self.selectedSegment = sender.selectedSegmentIndex;
    [self.tableView reloadData];
    
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = NSStringFromClass([WithdrawHeaderCell class]);
    WithdrawHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:identifier];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0,1,ViewWidth(tableView)-40)];
    // [view setBackgroundColor:self.tableView.separatorColor];
    return view;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isPayments = self.selectedSegment == 0;
    return isPayments ? self.withdrawController.payments.count : self.withdrawController.transactions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self paymentCell:indexPath];
}
- (PayoutCell *)paymentCell:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringFromClass([PayoutCell class]);
    PayoutCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    BOOL isPayments = self.selectedSegment == 0;
    if (isPayments) {
        Payments *payment = self.withdrawController.payments[indexPath.row];
        [cell configer:payment];
        
        if ((self.withdrawController.payments.count) == (indexPath.row + 1) && self.currentPage < self.totalPages) {
            self.currentPage += 1;
            CGPoint currentOffset = self.tableView.contentOffset;

            // Calculate the new content offset
            CGFloat newOffsetY = currentOffset.y - 15.0;

            // Ensure the new offset is not less than zero
            newOffsetY = MAX(newOffsetY, 0);

            // Set the new content offset
            [self.tableView setContentOffset:CGPointMake(currentOffset.x, newOffsetY) animated:NO];
            
            [self fetchDataFormServer];
        }
    }else{
        Transaction *transaction = self.withdrawController.transactions[indexPath.row];
        [cell configerWithTranction:transaction];
    }
    
    
    return cell;
}

#pragma mark- IBactions -
- (IBAction)withdrawButtonPressed:(RoundedButton *)sender {
    if (SHAREMANAGER.user.bankAccounts.count == 0) {
        [CommonFunctions showAlertWithTitel:@"Bank Accout missing" message:@"Please enter bank account first" inVC:self];
    }else if (self.withdrawController.availableBalanceValue  <= 0) {
        DLog(@"availableBalance  %@",@(self.withdrawController.availableBalanceValue).stringValue);
        [CommonFunctions showAlertWithTitel:@"Insufficient funds" message:@"Please increase your balance to withdraw funds" inVC:self];
    }else if (self.amountField.isEmpty || [self.amountField.text floatValue] <= 0) {
        [CommonFunctions showAlertWithTitel:@"Invaild Amount" message:@"Please enter a vaild amount" inVC:self];
    }else if ([self.amountField.text floatValue] < 20) {
        //minimum amount limit in sbi account
        [CommonFunctions showAlertWithTitel:@"Withdrawal Limit" message:@"Minimum withdrawal amount is $20.00 per transaction" inVC:self];
    }else{
        NSString *currancy = SHAREMANAGER.user.currency == nil ? @"" :SHAREMANAGER.user.currency;
        NSString *message = [NSString stringWithFormat:@"Do you want to withdraw %@ %@?",currancy,self.amountField.text];
        [CommonFunctions showQuestionsAlertWithTitel:@"Withdraw" message:message inVC:self completion:^(BOOL success) {
            if (success) {
                [self.view endEditing:YES];
                [self withdraw];
                self.amountField.text = nil;
            }
        }];
    }
}
- (IBAction)editButtonPressed:(UIButton *)sender{
    self.isAddAccount = [sender.currentTitle isEqualToString:KADD_BANK_ACCOUNT];
    [self showBankAccountsVC];
    
    
}
- (void)showBankAccountsVC{
    [self performSegueWithIdentifier:@"ShowBankInfoVc" sender:self];
}

- (IBAction)onClickPaynowOrTopUp:(UIButton *)sender{
    DLog(@"wk button click");
    UITopUpViewController *topUP = [[UITopUpViewController alloc] init];
    topUP.amount = self.withdrawController.availableBalanceValue;
    topUP.dicWallet = self.dicWallet;
    [self.navigationController pushViewController:topUP animated:true];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowBankInfoVc"]) {
        AccountsViewController *aVC = (AccountsViewController *)segue.destinationViewController;
        aVC.isAddAccount = self.isAddAccount;
        aVC.selectedCurrency = self.selectedCurrency;
        DLog(@"** wk selectedCurrency: %@", self.selectedCurrency.name);
    }
}

#pragma mark-WebServices -
//- (void)fetchDataFormServer{
//    DLog(@"Called");
//    [self showHud];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"my_account" forKey:@"command"];
//    [parameters setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    if (self.selectedCurrency.name){
//        [parameters setObject:self.selectedCurrency.name forKey:@"currency"];
//    }
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        DLog(@"the json return is %@",json);
//        [self hideHud];
//        if (![json objectForKey:@"error"]&& json!=nil){
//
//            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
//            [self setup];
//        }else {
//            NSString *errorMsg =[json objectForKey:@"error"];
//            DLog(@"Error %@",errorMsg);
//
//        }
//    }];
//
//}

- (void)fetchDataFormServer{
    DLog(@"Called");
    [self showHud];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"my_account1" forKey:@"command"];
    [parameters setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", self.currentPage] forKey:@"page"];
    [parameters setObject:@"40" forKey:@"limit"];
    if (self.selectedCurrency.name){
        [parameters setObject:self.selectedCurrency.name forKey:@"currency"];
    }
    
    NSString *strWalet = self.dicWallet[@"currency_code"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response withdrawVC fetchDataFormServer JSON: %@", json);
        [self hideHud];
        if (![json objectForKey:@"error"]&&json!=nil) {
//            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
            NSArray *items = json[@"data"][@"user_wallets"];
            
            self.totalPages = [json[@"data"][@"total_pages"] integerValue];
            self.currentPage = [json[@"data"][@"current_page"] integerValue];
            
//            DLog("** wk items: %@", items);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currency_code == %@", strWalet];
            NSArray *filteredItems = [items filteredArrayUsingPredicate:predicate];

            NSDictionary *firstItem = [filteredItems firstObject];
//            DLog("** wk item: %@", firstItem);
            BOOL isAdd = (self.currentPage != 1);
            DLog("** wk isAdd: %d", isAdd);
            NSMutableArray *jsonPayments = [firstItem[@"payments"] mutableCopy];
            if (firstItem) {
                NSMutableArray *latestPayments = self.lastPayments;
                if (isAdd) {
                    [latestPayments addObjectsFromArray:jsonPayments];
                } else {
                    latestPayments = jsonPayments;
                }
                
                NSMutableDictionary *updatedFirstItem = [firstItem mutableCopy];
                updatedFirstItem[@"payments"] = latestPayments;
                self.lastPayments = latestPayments;
                
                // Initialize WithdrawController with the updated firstItem
                self.withdrawController = [[WithdrawController alloc] initWithAttribute:updatedFirstItem];
            } else {
                self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
            }
            [self setup];
        }else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            ///DLog(@"Error %@",errorMsg);
            DLog(@"Error %@",[json objectForKey:@"error"]);
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self hideHud];
        DLog(@"Error: %@", error.localizedDescription);
    }];
}


//- (void)withdraw{
//    DLog(@"Called");
//    [self showHud];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"payout" forKey:@"command"];
//    [parameters setObject:self.amountField.text forKey:@"amount"];
//    [parameters setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [parameters setObject:self.selectedCurrency.name forKey:@"currency"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        [self hideHud];
//        if (![json objectForKey:@"error"]&& json!=nil){
//            NSString *success = json[@"success"];
//            if ([success intValue] != 1) {
//               // [self.tableView setAlpha:0.0];
//                _messageLbl.hidden = NO;
//                _messageLbl.text   = @"";
//                [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
//                return ;
//            }
//            [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
//            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
//            [self setup];
//        }else {
//            NSString *errorMsg =[json objectForKey:@"error"];
//            DLog(@"Error %@",errorMsg);
//
//        }
//    }];
//
//}

- (void)withdraw{
    DLog(@"Called");
    [self showHud];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"payout" forKey:@"command"];
    [parameters setObject:self.amountField.text forKey:@"amount"];
    [parameters setObject:SHAREMANAGER.user.userId forKey:@"user_id"];
//    [parameters setObject:self.selectedCurrency.name forKey:@"currency"];
    NSString *strWalet = self.dicWallet[@"currency_code"];
    DLog("** wk strWallet: %@", strWalet);
    if (strWalet) {
        [parameters setObject:strWalet forKey:@"currency"];
    }
    
    NSString *countryId = self.dicWallet[@"country_id"];
    DLog("** wk countryId: %@", countryId);
    if (countryId) {
        [parameters setObject:countryId forKey:@"country_id"];
    }
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response withdraw JSON: %@", json);
        [self hideHud];
        if (![json objectForKey:@"error"]&&json!=nil) {
            NSString *success = json[@"success"];
            if ([success intValue] != 1) {
               // [self.tableView setAlpha:0.0];
                _messageLbl.hidden = NO;
                _messageLbl.text   = @"";
                [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
                return ;
            }
            [self showAlertWithMessage:json[@"msg"] alertType:KAlertTypeInfo];
//            self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
            NSArray *items = json[@"data"][@"user_wallets"];
//            DLog("** wk items: %@", items);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currency_code == %@", strWalet];
            NSArray *filteredItems = [items filteredArrayUsingPredicate:predicate];

            NSDictionary *firstItem = [filteredItems firstObject];
//            DLog("** wk item: %@", firstItem);
            if (firstItem) {
                self.withdrawController = [[WithdrawController alloc] initWithAttribute:firstItem];
            } else {
                self.withdrawController = [[WithdrawController alloc] initWithAttribute:json[@"data"]];
            }
            [self setup];
        }else{
            ////NSLog(@"Error : %@",[json objectForKey:@"error"]);
            ///DLog(@"Error %@",errorMsg);
            DLog(@"Error %@",[json objectForKey:@"error"]);
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        [self hideHud];
        DLog(@"Error: %@", error.localizedDescription);
    }];

}
#pragma mark - Tableview Backgroun Label -
-(void)addLabelViewToBackground
{
    _messageLbl = [[UILabel alloc] initWithFrame:self.view.bounds];
    //set the message
    _messageLbl.textColor = [UIColor appGrayColor];
    _messageLbl.font = [UIFont heading];
    _messageLbl.textAlignment = NSTextAlignmentCenter;
    //auto size the text
    //[_messageLbl sizeToFit];
    [self.view addSubview:_messageLbl];
    [self.tableView setBackgroundView:_messageLbl];

}

@end
