//
//  CountryPickerViewController.m
//  XPFood
//
//  Created by syed zia on 02/08/2021.
//  Copyright © 2021 WelldoneApps. All rights reserved.
//
#import "EMCCountry.h"
#import "EMCCountryManager.h"

#import "CountryPickerViewController.h"

@interface CountryPickerViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property BOOL isFilter;
@property CGFloat flagSize;
@property (copy) void (^onCountrySelected)(EMCCountry *country);
@property (copy) NSSet *availableCountryCodes;
@property (strong, nonatomic) NSMutableArray *filteredCountries;
@property (strong, nonatomic) NSMutableArray *countries;
@end

@implementation CountryPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self validateSettings];
    [self loadCountries];
    
    if (self.presentingViewController)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:UIKitLocalizedString(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}
// MARK:- Data Setup

- (void)loadDefaults
{
    
    self.flagSize = 40.0f;
}

- (void)validateSettings
{
    if (self.flagSize <= 0)
    {
        [NSException raise:@"Invalid flag size." format:@"Invalid flag size: %f.", self.flagSize];
    }
}
- (void)chooseCountry:(EMCCountry *)chosenCountry;
{
    self.selectedCountry = chosenCountry;
}

- (NSArray *)filterAvailableCountries:(NSSet *)countryCodes
{
    EMCCountryManager *countryManager = [EMCCountryManager countryManager];
    NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:[countryCodes count]];
    
    for (id code in self.availableCountryCodes)
    {
        if ([countryManager existsCountryWithCode:code])
        {
            [countries addObject:[countryManager countryWithCode:code]];
        }
        else
        {
            [NSException raise:@"Unknown country code" format:@"Unknown country code %@", code];
        }
    }
    
    return countries;
}

- (void)loadCountries
{
    NSArray *availableCountries;
    
    if (self.availableCountryCodes)
    {
        availableCountries = [self filterAvailableCountries:self.availableCountryCodes];
    }
    else
    {
        availableCountries = [[EMCCountryManager countryManager] allCountries];
    }
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
    _countries = [NSMutableArray arrayWithArray:[availableCountries sortedArrayUsingDescriptors:descriptors]];
}
#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFilter)
    {
        return [self.filteredCountries count];
    }
    
    // Return the number of rows in the section.
    return [_countries count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryPickerCell" forIndexPath:indexPath];
    
    EMCCountry *currentCountry;
    
    if (self.isFilter)
    {
        currentCountry = [self.filteredCountries objectAtIndex:indexPath.row];
    }
    else
    {
        currentCountry = [_countries objectAtIndex:indexPath.row];
    }
    
    NSString *countryCode = [currentCountry countryCode];
    cell.textLabel.text = [currentCountry name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [currentCountry dialingCode]];
    NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", countryCode];
    UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    cell.imageView.image = [image fitInSize:CGSizeMake(self.flagSize, self.flagSize)];

    if (_selectedCountry && [_selectedCountry isEqual:currentCountry])
    {
        NSLog(@"Selection is %ld:%ld.", (long)tableView.indexPathForSelectedRow.section, (long)tableView.indexPathForSelectedRow.row);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row: %ld", (long)indexPath.row);
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.isFilter){
        _selectedCountry = [self.filteredCountries objectAtIndex:indexPath.row];
        [self.tableview reloadData];
    } else{
        _selectedCountry = [_countries objectAtIndex:indexPath.row];
    }
    
    if (self.onCountrySelected) {
        self.onCountrySelected(_selectedCountry);
    }
    
    [self.view endEditing:YES];
    [self.delegate countryController:self didSelectCountry:_selectedCountry];
    [self dismissView];
}
#pragma mark- UISearchBarDelegate -
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isFilter = YES;
    self.searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    self.filteredCountries = [NSMutableArray arrayWithArray: [_countries filteredArrayUsingPredicate:resultPredicate]];
    self.isFilter = searchText.length == 0 ? NO : YES;
    [self.tableview reloadData];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    return  YES;
}
- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
@end
