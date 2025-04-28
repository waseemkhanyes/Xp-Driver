//
//  EarningViewController.m
//  XPDriver
//
//  Created by Syed zia on 06/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//
#import "TripCell.h"
#import "FareCell.h"
#import "FareHeadingCell.h"
#import "HeaderView.h"
#import "OrdersHistoryViewController.h"
#import "TripEarningController.h"
#import "TripDetailViewController.h"
#import "EarningTitleController.h"
#import "DayAxisValueFormatter.h"
#import <Charts-umbrella.h>
@import Charts;

#import "EarningViewController.h"

@interface EarningViewController ()<ChartViewDelegate>{
     XYMarkerView *marker;
}
@property (nonatomic,retain) UILabel *messageLbl;
@property (nonatomic, strong) Page *selectedPage;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *totalEarningLabel;
@property (nonatomic, strong) IBOutlet BarChartView *chartView;
@property (assign, nonatomic) BOOL  isExpand;
@property (strong, nonatomic) NSMutableArray *earningDetailArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger selectedSegment;
@property (nonatomic, strong) EarningTitleController *earningController;
@property (nonatomic, strong) EarningTitle *selectedEarningTitle;
@property (nonatomic, strong) TripEarningController *tripEarningController;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UILabel *totalOrdersLabel;
- (IBAction)totalviewTapped:(UITapGestureRecognizer *)sender;
@end

@implementation EarningViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.totalOrdersLabel setText:@"0"];
    self.earningController = [EarningTitleController info];
    self.selectedEarningTitle = [self.earningController.earningTitles lastObject];
    [self.baseView setAlpha:0.0];
    [self drowSegmentedController];
    self.nextButton.enabled = self.earningController.isNext;
    [self fetchDataFormServer];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self addLabelViewToBackground];
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
- (void)showBaseView{
    [self.totalEarningLabel setText:self.tripEarningController.total];
    [self.totalOrdersLabel setText:[NSString stringWithFormat:@"%@",self.tripEarningController.totalOrders]];
    [self chartSetup];
    [self.chartView setHidden:NO];
    [self.baseView setAlpha:1];
    _messageLbl.hidden = YES;
    _messageLbl.text   = @"";
}

- (void)chartSetup{
    [self setupBarLineChartView:_chartView];
    UIColor *color = [UIColor appBlackColor];
    self.chartView.layer.zPosition = -1;
    _chartView.delegate = self;
    _chartView.borderColor  = [UIColor clearColor];
    _chartView.borderLineWidth = 0.0;
    _chartView.drawBordersEnabled     = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.pinchZoomEnabled       = NO;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = NO;
    _chartView.highlightFullBarEnabled = NO ;
    _chartView.fitBars = YES;
    _chartView.maxVisibleCount = 8;
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelTextColor = [UIColor appGrayColor];
    xAxis.labelFont = [UIFont heading2];
    xAxis.axisLineColor = color;
    xAxis.axisLineWidth = 2;
    xAxis.spaceMax = 0.5;
    xAxis.spaceMin = 0.5;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularityEnabled  = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = self.tripEarningController.chartData.count;
    xAxis.valueFormatter = [[BarChartFormatter alloc] initWithData:self.tripEarningController.chartDataKeys];
//   // marker = [[XYMarkerView alloc]
//              color:color
//              font: [UIFont heading2]
//              textColor: UIColor.whiteColor
//              insets: UIEdgeInsetsMake(10.0, 4.0,4.0, 4.0)
//              xAxisValueFormatter: _chartView.xAxis.valueFormatter currancy:self.tripEarningController.currenceySymbol];
    marker.arrowSize = CGSizeMake(3.0, 3.0);
    marker.chartView = _chartView;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    self.chartView.legend.enabled = false;
    _chartView.marker = marker;
    [self updateChartData];
}
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = NO;
    [chartView setScaleEnabled:NO];
    chartView.pinchZoomEnabled = NO;
    
    chartView.rightAxis.enabled = NO;
    chartView.leftAxis.enabled = NO;
}
- (void)updateChartData
{
    [_chartView highlightValue:nil callDelegate:false];
    [self setDataCount:(int)self.tripEarningController.orders.count range:[self.tripEarningController.total doubleValue]];
}

- (void)setDataCount:(int)count range:(double)range
{
    double start = 0;
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSArray * keys  = self.tripEarningController.chartDataKeys;
    NSArray * values;
    values  = self.tripEarningController.earningChartDataValues;
    for (int i = start; i < keys.count; i++) {
        double val = [values[i] doubleValue];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:(double)i y:val data:keys]];
    }
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0){
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        UIColor *color =  [UIColor appBlackColor];
        [set1 setColors:@[color]];
        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        [set1 replaceEntries: yVals];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    } else {
        NSString *lableText   = self.selectedEarningTitle.title;
        set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:lableText];
        UIColor *color = [UIColor appBlackColor];
        [set1 setColors:@[color]];
        set1.drawIconsEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.formLineDashPhase  = 2.0f;
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont small]];
        data.barWidth = 0.9f;
        _chartView.data = data;
        
    }
    [_chartView animateWithYAxisDuration:2.0];
    [self performSelector:@selector(defaultHightLight) withObject:nil afterDelay:1];
    
}
- (void)defaultHightLight{
 //   double start = 0;
    for (id dataset in [_chartView.data.dataSets reverseObjectEnumerator]){
        BarChartDataSet *set = (BarChartDataSet *)dataset;
        NSInteger setIndex = [_chartView.data.dataSets indexOfObject:set];
        for (id dataEntry in [set.entries reverseObjectEnumerator]){
            ChartDataEntry *entry = (ChartDataEntry *)dataEntry;
            NSInteger entryIndex = [set.entries indexOfObject:entry];
            if (entry.y > 0.0) {
                [_chartView highlightValueWithX:entry.x dataSetIndex:setIndex dataIndex:entryIndex];
                return;
            }
        }
    }
    
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight{
    if (entry.y == 0.0) {
        [_chartView highlightValue:nil callDelegate:false];
    }
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)showDetailView{
    [self performSegueWithIdentifier:@"ShowTripDetail" sender:self];
}
#pragma mark- IBActions
- (IBAction)backBtnPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)previousButtonPressed:(UIButton *)sender {
    self.selectedPage = self.earningController.pervious;
    [self getEarningTabs];
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    self.selectedPage = self.earningController.next;
    [self getEarningTabs];
}
- (NSMutableDictionary *)paramerts{
    NSMutableDictionary  *params = [NSMutableDictionary new];
    [params setObject:self.selectedPage.weeks forKey:@"weeks"];
    [params setObject:self.selectedPage.descending forKey: @"dec"];
    return  params;
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
//                [self.baseView setAlpha:0.0];
//                _messageLbl.hidden = NO;
//                _messageLbl.text   = @"No history";
//                return ;
//            }
//            self.tripEarningController = [[TripEarningController alloc] initWithAttrebute:json[RESULT]];
//            [self showBaseView];
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
        NSLog(@"wk Response updateVehicleInfo JSON: %@", json);
        if (![json objectForKey:@"error"]&& json!=nil){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSArray *trips = json[RESULT];
            if (trips.count == 0) {
                [self.baseView setAlpha:0.0];
                _messageLbl.hidden = NO;
                _messageLbl.text   = @"No history";
                return ;
            }
            self.tripEarningController = [[TripEarningController alloc] initWithAttrebute:json[RESULT]];
            [self showBaseView];
            DLog(@"Total orders %@",@(self.tripEarningController.orders.count));
        }else {
            [self handleError:[json objectForKey:@"error"]];
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

#pragma mark - Tableview Backgroun Label -
-(void)addLabelViewToBackground
{
    _messageLbl = [[UILabel alloc] initWithFrame:self.view.bounds];
    //set the message
    _messageLbl.textColor = [UIColor appGrayColor];
    _messageLbl.font = [UIFont heading2];
    _messageLbl.textAlignment = NSTextAlignmentCenter;
    //auto size the text
    //[_messageLbl sizeToFit];
    [self.view addSubview:_messageLbl];
    //[self.view sendSubviewToBack:_messageLbl];
    
}
#pragma mark - Navigation
- (IBAction)totalviewTapped:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"ShowOrderHistoryVC" sender:self];
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue destinationViewController] isKindOfClass:[OrdersHistoryViewController class]]) {
        OrdersHistoryViewController *tdVC = (OrdersHistoryViewController *)segue.destinationViewController;
        tdVC.orders = self.tripEarningController.orders;
    }
}



@end
