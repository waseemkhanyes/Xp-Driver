//
//  AccountsViewController.m
//  XPDriver
//
//  Created by Macbook on 01/05/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "AddAccountCell.h"
#import "BankInfoCell.h"
#import "CardCell.h"
#import "StripeViewController.h"
#import "CountrySelectionViewController.h"
#import "AccountsViewController.h"

@interface AccountsViewController ()
@property (nonatomic, assign) BOOL isIBAN;
@property (nonatomic, assign) BOOL isCreditDebit;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *accountsArray;
@property (strong, nonatomic) NSMutableArray *ibansArray;
@property (strong, nonatomic) NSMutableArray *cardsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountsArray  = [NSMutableArray new];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataSetup];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)dataSetup{
    self.user = [User info];
    self.accountsArray = self.user.bankAccounts;
    self.ibansArray    = self.user.ibans;
    self.cardsArray    = self.user.debitCards;
    [self.tableView reloadData];
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension; // Zunaira Zia
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 3){
        if (section == 0 && self.accountsArray.count != 0) {
            return 45;
        }else if (section == 1 && self.ibansArray.count != 0) {
                return 45;
        }else if (section == 2 && self.cardsArray.count != 0) {
               return 45;
        }
        return  1;
    }
    return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 40;
    CGFloat width  = ViewWidth(self.tableView);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,height,width, height)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, height/2, width - 32, height/2)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor appGrayColor]];
    [label setFont:[UIFont heading1]];
    if (section < 3){
        if (section == 0) {
            [label setText: @"Saved Accounts"];
        }else if (section == 1) {
            [label setText: @"Saved IBAN"];
        }else if (section == 2) {
            [label setText: @"Saved Cards"];
        }
    }
    [view addSubview:label];
    if (section < 3){
        if (section == 0 && self.accountsArray.count != 0) {
            return view;
        }else if (section == 1 && self.ibansArray.count != 0) {
                return view;
        }else if (section == 2 && self.cardsArray.count != 0) {
               return view;
        }
        return  [UIView new];;
    }
    return  [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    if (indexPath.section != 0) {
//        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0) ;
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        // May also use separatorInset
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
      return self.accountsArray.count;
    }else if (section == 1) {
        return self.ibansArray.count;
      }else if (section == 2) {
          return self.cardsArray.count;
        }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return  [self bacnkCell:indexPath];
    }else if (indexPath.section == 1){
        return  [self bacnkCell:indexPath];
    }
    else if (indexPath.section == 2){
        return  [self cardCell:indexPath];
    }else{
        return [self addAccountCell:indexPath];
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section >= 3 ) {
        self.isIBAN = indexPath.section == 5;
        self.isCreditDebit = indexPath.section == 4;
        if (section != 4) {
            [self showCountrySelectionVC];
        }else if ( section == 4){
            [self showCountrySelectionVC];
        }

    }else{
        Bank *bank;
        SZCard *card;
        if (section == 0) {
            bank = self.accountsArray[row];
            [self.user updateBankAccount:bank];
        }else if (section == 1) {
            bank = self.ibansArray[row];
            [self.user updateBankAccount:bank];
        }else if (section == 2) {
            card = self.cardsArray[row];
            [self.user updateDebitCard:card];
        }
        self.accountsArray = self.user.bankAccounts;
        self.cardsArray    = self.user.debitCards;
        self.ibansArray    = self.user.ibans;

        [self.tableView reloadData];
        if (section == 2) {
            [self updatedebitCard:card];
        }else{
            [self updateBank:bank];
        }

    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
//    if (self.accountsArray.count != 0 && indexPath.section == 0) {
//        return YES;
//    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (AddAccountCell *)addAccountCell:(NSIndexPath *)indexPath{
    AddAccountCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddAccountCell class])];
    if (indexPath.section == 3) {
        cell.accountImageView.image = [UIImage imageNamed:@"bg_add_bank"];
    }else if (indexPath.section == 4){
        cell.accountImageView.image = [UIImage imageNamed:@"ic_add-debit-credit-card"];
    }else if (indexPath.section == 5){
        cell.accountImageView.image = [UIImage imageNamed:@"ic_add_iban"];
    }
    return cell;
}
- (BankInfoCell *)bacnkCell:(NSIndexPath *)indexPath{
    Bank *bank;
    if (indexPath.section == 0) {
        bank = self.accountsArray[indexPath.row];
    }else if (indexPath.section == 1) {
        bank = self.ibansArray[indexPath.row];
    }else if (indexPath.section == 2) {
        bank = self.cardsArray[indexPath.row];
    }

    BankInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BankInfoCell" forIndexPath:indexPath];
    [cell.bankNameLabel setText:bank.name];
    [cell.accountNumberLabel setText:bank.accountNumber];
    [cell.accountTypeLabel setText:bank.accountType];
    UIImage *image = [UIImage imageNamed:bank.isActive ? @"ic_card_selected" : @"ic_card_unselected"];
    UIColor *cellbackgroundColor = bank.isActive ? [UIColor bankCellSelectedColor] : [UIColor bankCellUnSelectedColor];
    [cell.statusImageView setImage:image];
    [cell.backView setBackgroundColor:cellbackgroundColor];
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0) ;

    return cell;
}
- (CardCell *)cardCell:(NSIndexPath *)indexPath{
    SZCard *card = self.cardsArray[indexPath.row];
    CardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CardCell class])];
    [cell.cardNameLabel setText:card.brand];
    [cell.cardNumberLabel setText:card.endingString];
    [cell.cardImageView setImage:card.brandImage];
    UIImage *image = [UIImage imageNamed:card.isActive ? @"ic_card_selected" : @"ic_card_unselected"];
    UIColor *cellbackgroundColor = card.isActive ? [UIColor creditCardCellSelectedColor] : [UIColor creditCardCellUnSelectedColor];
    [cell.removeButton setHidden:true];
    [cell.statusImageView setImage:image];
    [cell.backView setBackgroundColor:cellbackgroundColor];
  //  cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0) ;

    return cell;
}
- (void)showCountrySelectionVC{
     [self performSegueWithIdentifier:@"ShowCountrySelectionVC" sender:self];
}
#pragma mark - WebServices -

-(void)updateBank:(Bank *)bank{
    [self showHud];
    NSMutableDictionary  *params= [[NSMutableDictionary alloc] init];
    [params setValue:bank.bankId forKey:@"id"];
    [User updateUserBankAccount:params completion:^(BOOL success, NSString * _Nullable error) {
        [self hideHud];
        if (success) {
            self.user = [User info];
            [self dataSetup];
            [self.tableView reloadData];
            NSString *messge = bank.isIBAN ? @"IBAN updated".uppercaseString : @"Bank account updated".uppercaseString;
            [self showSuccessWithMessage:messge];

        }
    }];
}
-(void)updatedebitCard:(SZCard *)card{
    [self showHud];
    NSMutableDictionary  *params= [[NSMutableDictionary alloc] init];
    [params setValue:card.cardID forKey:@"id"];
    [User updateUserBankAccount:params completion:^(BOOL success, NSString * _Nullable error) {
        [self hideHud];
        if (success) {
            self.user = [User info];
            [self dataSetup];
            [self.tableView reloadData];
            [self showSuccessWithMessage:@"Card updated".uppercaseString];

        }
    }];
}
- (void)removeBank:(Bank *)bank{
    NSMutableDictionary  *params= [[NSMutableDictionary alloc] init];
    [params setValue:bank.bankId forKey:@"id"];
    [User removeBankAccount:params completion:^(BOOL success, NSString * _Nullable error) {
        if (success) {
         [self dataSetup];
            [self.tableView reloadData];
        }else{
            [self dataSetup];
            [self showAlertWithMessage:error alertType:KAlertTypeInfo];
        }

    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowCountrySelectionVC"]) {
        CountrySelectionViewController *csVC = (CountrySelectionViewController *)segue.destinationViewController;
        csVC.isIBAN        = self.isIBAN;//
        csVC.isCreditDebit = self.isCreditDebit;
        csVC.selectedCurrency = self.selectedCurrency;
        DLog(@"** wk selectedCurrency: %@", self.selectedCurrency.name);
    }else if ([segue.identifier isEqualToString:@"ShowCardVC"]){
        //isFromDebitCard
        StripeViewController *sVC = (StripeViewController *)segue.destinationViewController;
        sVC.isFromDebitCard = true;
        sVC.selectedCurrency = self.selectedCurrency;
    }else if ([segue.identifier isEqualToString:@"ShowCardVC"]){
        //isFromDebitCard
        StripeViewController *sVC = (StripeViewController *)segue.destinationViewController;
        sVC.isFromDebitCard = true;
        sVC.selectedCurrency = self.selectedCurrency;
    }
}
@end
