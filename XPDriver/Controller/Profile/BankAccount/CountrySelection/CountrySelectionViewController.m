//
//  CountrySelectionViewController.m
//  XPFood
//
//  Created by Macbook on 02/06/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//
#import "BankAccountViewController.h"
#import "CreditDebitViewController.h"
#import "CountrySelectionViewController.h"

@interface CountrySelectionViewController ()
@property (nonatomic, strong) NSMutableArray* countries;
@property (nonatomic, strong) AvailableCountry * selectedCountry;
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@end

@implementation CountrySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countries = [NSMutableArray new];
    if (self.isIBAN) {
        self.countries = SHAREMANAGER.appData.ibanCountries;
    }else{
        self.countries = SHAREMANAGER.appData.availableCountries;
    }

    self.selectedCountry = self.countries[0];

}

#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension; // Zunaira Zia
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    AvailableCountry *country = self.countries[indexPath.row];
    cell.textLabel.text       = country.name;
    cell.tintColor = [UIColor appGreenColor];
    if ([country.name isEqualToString:self.selectedCountry.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCountry = self.countries[indexPath.row];
    [self.tableView reloadData];
}
-(IBAction)nextButtonPressed:(id)sender{
    if (self.isCreditDebit) {
        [self showCardVC];
    }else{
        [self showAddAccountVC];
    }

}

- (void)showAddAccountVC{
     [self performSegueWithIdentifier:@"ShowBankAccountVC" sender:self];
}
- (void)showCardVC{
     [self performSegueWithIdentifier:@"ShowCardVC" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowBankAccountVC"]) {
        BankAccountViewController *baVC = (BankAccountViewController *)segue.destinationViewController;
        baVC.selectedCountry = self.selectedCountry;
        baVC.selectedCurrency = self.selectedCurrency;
        baVC.isIBAN          = self.isIBAN;
    }else if ([segue.identifier isEqualToString:@"ShowCardVC"]) {
        CreditDebitViewController *baVC = (CreditDebitViewController *)segue.destinationViewController;
        baVC.selectedCountry = self.selectedCountry;
        baVC.selectedCurrency = self.selectedCurrency;
    }
}
@end
