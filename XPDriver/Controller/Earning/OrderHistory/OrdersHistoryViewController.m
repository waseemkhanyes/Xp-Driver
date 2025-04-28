//
//  MyOrdersViewController.m
//  XPEats
//
//  Created by Muhammad Sajjad Zafar on 05/08/2019.
//  Copyright © 2019 WelldoneApps. All rights reserved.
//
#import "Order.h"
#import "ReceiptViewController.h"
#import "FareAndRatingView.h"
#import "TripEarningController.h"
#import "EarningTitleController.h"
#import "OrdersHistoryViewController.h"
#import "OrderHistoryCell.h"
#import "XP_Driver-Swift.h"
static NSString * const KReceiptVCIdentifier           = @"ShowReceiptVC";
@interface OrdersHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Page *selectedPage;
@property (nonatomic, assign) BOOL isRefreshing;
@property (strong, nonatomic) Order *selectedOrder;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic,retain) UILabel *messageLbl;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger selectedSegment;
@property (nonatomic, strong) EarningTitleController *earningController;
@property (nonatomic, strong) EarningTitle *selectedEarningTitle;
@property (nonatomic, strong) TripEarningController *tripEarningController;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@end

@implementation OrdersHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.earningController = [EarningTitleController info];
    self.selectedEarningTitle = [self.earningController.earningTitles lastObject];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshingTableView) forControlEvents:UIControlEventValueChanged];
    BOOL isFromEaringScreen = self.orders.count != 0;
    self.topViewHeight.constant = isFromEaringScreen ? 0 : 70 ;
    if (!isFromEaringScreen) {
        self.tableView.refreshControl = self.refreshControl;
        [self drowSegmentedController];
    }
    self.nextButton.enabled = self.earningController.isNext;
    [self setupNavigationBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self addLabelViewToBackground];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"Order History";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Oswald-Bold" size:19]}];
    //    self.navigationItem.leftBarButtonItem = [self setupLeftBarButtonItem];
}


-(void)drowSegmentedController{
    CGFloat viewWidth = CGRectGetWidth(self.topView.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0,0, viewWidth, 50)];
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.sectionTitles   = [self.earningController.titles mutableCopy];
    self.segmentedControl.userDraggable   = YES;
    self.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedControl.verticalDividerEnabled   = NO;
    self.segmentedControl.verticalDividerColor     = [UIColor appBlackColor];
    self.segmentedControl.verticalDividerWidth     = 2.0f;
    self.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedControl.autoresizingMask         = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor appBlackColor],NSFontAttributeName : [UIFont normal]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor appBlackColor],NSFontAttributeName : [UIFont boldNormal]};
    self.segmentedControl.selectionIndicatorColor     = [UIColor appBlackColor];
    self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.segmentedControl.selectionStyle    = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:self.segmentedControl];
    [self.segmentedControl setSelectedSegmentIndex:self.segmentedControl.sectionTitles.count-1 animated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.selectedSegment = segmentedControl.selectedSegmentIndex;
     self.selectedEarningTitle = self.earningController.earningTitles[self.selectedSegment];
   [self fetchDataFormServer];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView  estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self ordersCell:indexPath];;
}
- (OrderHistoryCell *)ordersCell:(NSIndexPath *)indexPath{
    OrderHistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OrderHistoryCell.identifier];
    [cell.receiptButton setTag:indexPath.row];
    [cell.receiptButton addTarget:self action:@selector(showReceiptViewController:) forControlEvents:UIControlEventTouchUpInside];
    [cell configerCell:self.orders[indexPath.row]];
    return cell;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (void)showReceiptViewController:(UIButton *)sender{
     self.selectedOrder = self.orders[sender.tag];
    [self performSegueWithIdentifier:KReceiptVCIdentifier sender:self];
}
#pragma  mark - Webserivecs
- (void)refreshingTableView{
    self.isRefreshing = YES;
    [self fetchDataFormServer];
    
}
#pragma mark-WebServices
//- (void)fetchDataFormServer{
//    DLog(@"Called");
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"getEarnings" forKey:@"command"];
//    [parameters setObject:SHAREMANAGER.userId forKey:@"user_id"];
//    [parameters setObject:self.selectedEarningTitle.fromDate forKey:@"from"];
//    [parameters setObject:self.selectedEarningTitle.toDate forKey:@"to"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        DLog(@"the json return is %@",json);
//        if (![json objectForKey:@"error"]&& json!=nil){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSArray *trips = json[RESULT];
//            if (trips.count == 0) {
//                self.orders = [NSMutableArray new];
//                [self.tableView reloadData];
//                _messageLbl.hidden = NO;
//                _messageLbl.text   = @"No history";
//                return ;
//            }
//            self.tripEarningController = [[TripEarningController alloc] initWithAttrebute:json[RESULT]];
//            self.orders = self.tripEarningController.orders;
//            [self.tableView reloadData];
//            DLog(@"Total orders %@",@(self.tripEarningController.orders.count));
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"getEarnings" forKey:@"command"];
    [parameters setObject:SHAREMANAGER.userId forKey:@"user_id"];
    [parameters setObject:self.selectedEarningTitle.fromDate forKey:@"from"];
    [parameters setObject:self.selectedEarningTitle.toDate forKey:@"to"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response updateDocumentInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&& json!=nil){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSArray *trips = json[RESULT];
            if (trips.count == 0) {
                self.orders = [NSMutableArray new];
                [self.tableView reloadData];
                _messageLbl.hidden = NO;
                _messageLbl.text   = @"No history";
                return ;
            }
            self.tripEarningController = [[TripEarningController alloc] initWithAttrebute:json[RESULT]];
            self.orders = self.tripEarningController.orders;
            [self.tableView reloadData];
            DLog(@"Total orders %@",@(self.tripEarningController.orders.count));
        }else {
            NSString *errorMsg =[json objectForKey:@"error"];
            [self handleError:errorMsg];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self handleError:error.localizedDescription];
    }];
    
}

-(void) handleError: (NSString *)errorDescription {
    if ([ErrorFunctions isError:errorDescription]){
        
    }else {
        DLog(@"Error %@",errorDescription);
    }
}

- (NSMutableDictionary *)paramerts{
    NSMutableDictionary  *params = [NSMutableDictionary new];
    [params setObject:self.selectedPage.weeks forKey:@"weeks"];
    [params setObject:self.selectedPage.descending forKey: @"dec"];
    return  params;
}
- (IBAction)previousButtonPressed:(UIButton *)sender {
    self.selectedPage = self.earningController.pervious;
    [self getEarningTabs];
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    self.selectedPage = self.earningController.next;
    [self getEarningTabs];
}
- (void)getEarningTabs{
    [self showHud];
    [EarningTitleController fetchDataFormServer:[self paramerts] WithCompletion:^(BOOL success) {
        [self hideHud];
        if (success) {
            self.earningController = [EarningTitleController info];
            self.nextButton.enabled = self.earningController.isNext;
            self.selectedEarningTitle = [self.earningController.earningTitles lastObject];
            [self drowSegmentedController];
        }
    }];
}
-(void)addLabelViewToBackground
{
    _messageLbl = [[UILabel alloc] initWithFrame:self.view.bounds];
    //set the message
    _messageLbl.textColor = [UIColor appGrayColor];
    _messageLbl.font = [UIFont heading2];
    _messageLbl.textAlignment = NSTextAlignmentCenter;
    //auto size the text
    //[_messageLbl sizeToFit];
    [self.tableView.backgroundView addSubview:_messageLbl];
    //[self.view sendSubviewToBack:_messageLbl];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:KReceiptVCIdentifier]){
         ReceiptViewController *vc = (ReceiptViewController *)[segue destinationViewController];
         vc.order   = self.selectedOrder;
    }
}
@end
