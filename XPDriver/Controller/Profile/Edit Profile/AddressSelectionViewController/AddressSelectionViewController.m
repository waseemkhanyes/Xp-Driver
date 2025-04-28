//
//  AddressSelectionViewController.m
//  XPDriver
//
//  Created by Macbook on 18/03/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "PlacesCell.h"
static NSString *CellIdentifier = @"Places Cell";
#import "AddressSelectionViewController.h"

@interface AddressSelectionViewController ()<UITableViewDelegate,UITableViewDataSource,GMSAutocompleteFetcherDelegate>
@property (assign, nonatomic) CGFloat  keybordHeight;
@property (strong, nonatomic) GMSAutocompleteFetcher *fetcher;
@property (strong, nonatomic) GMSPlacesClient    *placesClient;
@property (strong, nonatomic) NSMutableArray *places;

@property (strong, nonatomic) UIActivityIndicatorView *searchLoadingActivityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *googleAutoCompleteTableView;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UILabel *addressLablel;

@property (strong, nonatomic) IBOutlet RoundedButton *saveButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
- (IBAction)textFieldDidChanged:(UITextField *)textField;
@end

@implementation AddressSelectionViewController

@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    [GMSPlacesClient provideAPIKey:GOOGLE_PLEACE_KEY];
    [self hideTableView];
    if (self.selectedAddress) {
        [self.addressField setText:self.selectedAddress.address];
    }
    [self setup];
    // Do any additional setup after loading the view.
}

#pragma mark-  Private -
- (void)setup{
    [self.googleAutoCompleteTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.googleAutoCompleteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.googleAutoCompleteTableView registerNib:[UINib nibWithNibName:@"PlacesCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.addressField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark- UITextField Delegate -

- (void)textFieldDidChanged:(UITextField *)textField{
    if ([textField.text length] == 0) {
        self.places = [NSMutableArray new];
        [self hideTableView];
    }
    [self.googleAutoCompleteTableView reloadData];
    [self fetchPlaces:textField.text];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    textField.rightView = nil;
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.addressField setText:self.addressLablel.text];
    [self.addressLablel setText:nil];
    [self.addressField setTextColor:[UIColor appBlackColor]];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
     textField.text = nil;
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
   
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
   
    return YES;
}
- (BOOL) textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)endEditing:(BOOL)force{
    return YES;
}
- (void)fetchPlaces:(NSString *)text{
    DLog(@"Country Code %@",SHAREMANAGER.appData.country.shortName);
    //GMSCoordinateBounds *bounds = self.coordinateBounds;
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
//    if (self.selectedCountry != nil) {
//        filter.country = self.selectedCountry.iso_code_2.lowercaseString;
//    }else{
//        filter.country = SHAREMANAGER.appData.country.shortName;
//    }
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithFilter:filter];
    _fetcher.delegate = self;
    GMSAutocompleteSessionToken *token  = [[GMSAutocompleteSessionToken alloc] init];
    [[GMSPlacesClient new]  findAutocompletePredictionsFromQuery:text filter:filter sessionToken:token callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
        if ([results count]>0) {
            self.places = [NSMutableArray new];
            [self showTableView];
            [self.places addObjectsFromArray:results];
            [self.googleAutoCompleteTableView reloadData];
       }else{
           self.places = [NSMutableArray new];
           [self.googleAutoCompleteTableView reloadData];
    
       }
    }];
    
    
}
#pragma mark - GMSAutocompleteFetcherDelegate -
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    self.places = [NSMutableArray new];
    if (predictions.count == 0) {return;}
    [self.googleAutoCompleteTableView reloadData];
    for (GMSAutocompletePrediction *prediction in predictions) {
        [self.places addObject:prediction];
        //[resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
    }
    //DLog(@"self.places %@",self.places);
    [self.googleAutoCompleteTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    
    DLog(@"%@",[NSString stringWithFormat:@"%@", error.localizedDescription]);
}
#pragma mark- WebServices -
- (void)getPlaceDetailByPlaceId:(NSString *)placeID{
    self.placesClient = [GMSPlacesClient sharedClient];
    [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        if (place != nil) {
            NSString *city = @"";
            NSString *state = @"";
            NSString *poctalCode = @"";
            for (int i = 0; i < [place.addressComponents count]; i++){
                if ([place.addressComponents[i].types[0] isEqualToString:@"locality"]) {
                    city = place.addressComponents[i].name;
                }else if ([place.addressComponents[i].types[0] isEqualToString:kGMSPlaceTypeAdministrativeAreaLevel1]) {
                    state = place.addressComponents[i].name;
                }else if ([place.addressComponents[i].types[0] isEqualToString:kGMSPlaceTypePostalCode]) {
                    poctalCode = place.addressComponents[i].name;
                }
                DLog(@"name %@ = type %@", place.addressComponents[i].name, place.addressComponents[i].types);
            }
            [self.addressField setTextColor:[UIColor clearColor]];
            [self.addressLablel setText:place.formattedAddress];
            MyLocation *myLocation = [[MyLocation alloc]initWithAddress:place.formattedAddress coordinate:place.coordinate state:state city:city];
            myLocation.postalCode = poctalCode;
            [self setSelectedAddress:myLocation];
           
        } else {
            //DLog(@"No place details for %@", placeID);
        }
    }];
}




#pragma mark - Auto Complete Helper Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0,ViewWidth(self.googleAutoCompleteTableView),40);
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    ShadowView *view = [[ShadowView alloc] initWithFrame:containerView.frame];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    view.borderColor = [UIColor appGrayColor];
    view.borderWidth = 0.5;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8,ViewWidth(view) - 16,ViewHeight(view) -8)];
    [headerLabel setNumberOfLines:0];
    headerLabel.textColor     = [UIColor appGrayColor];
    headerLabel.font          = [UIFont normal];
     [headerLabel setText:@"Search Results"];
    [view addSubview:headerLabel];
    [containerView addSubview:view];
    return containerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count != 0 ? self.places.count : 1;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self locationSearchResultCellForIndexPath:indexPath];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.addressField resignFirstResponder];
    if (self.places.count != 0) {
        GMSAutocompletePrediction *prediction = self.places[indexPath.row];
         self.addressField.text = prediction.attributedPrimaryText.string;
        [self getPlaceDetailByPlaceId:prediction.placeID];
    }
}

- (UITableViewCell *)locationSearchResultCellForIndexPath:(NSIndexPath *)indexPath {
    PlacesCell *cell =  (PlacesCell *)[PlacesCell cellFromNibNamed:@"PlacesCell"];
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        if (self.places.count != 0) {
            GMSAutocompletePrediction *prediction = self.places[indexPath.row];
            UIFont *regularFont = [UIFont normal];
            UIFont *boldFont = [UIFont heading1];
            NSMutableAttributedString *bolded = [prediction.attributedPrimaryText mutableCopy];
            [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute
                               inRange:NSMakeRange(0, bolded.length)
                               options:0
                            usingBlock:^(id value, NSRange range, BOOL *stop) {
                UIFont *font = (value == nil) ? regularFont : boldFont;
                [bolded addAttribute:NSFontAttributeName value:font range:range];
            }];
            cell.label.attributedText = bolded;
            cell.subLabel.attributedText = prediction.attributedSecondaryText;
            return cell;
        }

    
    return [UITableViewCell new];
}

- (void)hideTableView{
    [self.googleAutoCompleteTableView setAlpha:0.0];
}
- (void)showTableView{
    [self.googleAutoCompleteTableView setAlpha:1];
}

#pragma mark UIKeybordChangeFrameNotificationHandler
- (void)keyboardWillShowNotification:(NSNotification *)notification{
    self.tableBottom.constant += self.keybordHeight - (ViewHeight(self.saveButton) + 40);
}
- (void)keyboardWillHideNotification:(NSNotification *)notification{
     self.tableBottom.constant -= (self.keybordHeight  + (ViewHeight(self.saveButton) + 40));
}
#pragma mark UIKeybordChangeFrameNotificationHandler

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    self.keybordHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
   
  
}
#pragma mark- IBactions -
- (IBAction)saveBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate setSelectedAddress:self.selectedAddress];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
