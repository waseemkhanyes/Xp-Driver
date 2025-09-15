//
//  OrdersViewController.m
//  XPDriver
//
//  Created by Macbook on 27/10/2020.
//  Copyright © 2020 Syed zia. All rights reserved.
//
#import "OrderInfoViewController.h"
#import "OrdersViewController.h"
#import "XP_Driver-Swift.h"

@interface OrdersViewController ()<OrderTableViewCellDelegate,FareAndRatingViewDelegate>
@property (nonatomic,strong) RideRequest *request;
@property (nonatomic,strong) Order *selectedOrder;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)downButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (retain, nonatomic) IBOutlet UILabel *lblOrderNumberForNavigate;

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOrdersNotification:) name:KORDERS_NOTIFICATION_KEY object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UIOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"UIOrderTableViewCell"];
    
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    float displayAeraHeight = ScreenHeight - 300;
    BOOL isTableHeightGraterThenHalfScreen =  self.tableView.contentSize.height > displayAeraHeight;
    self.tableViewHeight.constant = isTableHeightGraterThenHalfScreen ? displayAeraHeight : self.tableView.contentSize.height;
}
-(void) receiveOrdersNotification:(NSNotification*)notification{
    
    if ([notification.name isEqualToString:KORDERS_NOTIFICATION_KEY]){
        NSDictionary* userInfo = notification.userInfo;
        NSMutableArray *orders = (NSMutableArray*)userInfo[@"orders"];
//        NSLog(@"wk orders: %@", orders);
        self.driverAddress = (NSString*)userInfo[@"driverAddress"];
        self.driverCoordinate = (NSString*)userInfo[@"driverCoordinate"];
        self.orders = orders;
        
        for (Order *order in self.orders) {
            if (order.isActive == YES) {
                self.selectedOrder = order;
                NSLog(@"** wk Active order found with orderId: %@", self.selectedOrder.orderId);
                self.lblOrderNumberForNavigate.text = [NSString stringWithFormat:@"Order #%@", order.orderId];
                break; // Exit the loop once the desired order is found
            }
        }
        [self.tableView reloadData];
    }
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    return self.orders.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self orderCell:indexPath];
    return [self orderCellNew:indexPath];
}
- (UIOrderTableViewCell *)orderCellNew:(NSIndexPath *)indexPath{
    UIOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:UIOrderTableViewCell.identifier forIndexPath:indexPath];
    Order *order = self.orders[indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell configureWith:order handler:^{
        self.selectedOrder = self.orders[indexPath.row];
        [self activeOrder:self.selectedOrder];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedOrder = self.orders[indexPath.row];
//    [self activeOrder:self.selectedOrder];
}
- (OrderTableViewCell *)orderCell:(NSIndexPath *)indexPath{
    OrderTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:OrderTableViewCell.identifier forIndexPath:indexPath];
    Order *order = self.orders[indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell configer:order];
    
    return cell;
}
- (IBAction)downButtonPressed:(UIButton *)sender {
    [self.delegate ordersViewControllerDismissed];
}
- (void)infoButtonPressed:(Order *)order{
    self.selectedOrder = order;
    [self performSegueWithIdentifier:@"ShowOrderInfo" sender:self];
}
- (void)statusButtonPressed:(Order *)order{
    KOrderStatus status = [self orderStatus:order];
    if ([order.paymentMethod isEqualToString:@"cod"] && order.status == KOrderStatusPickedup) {
        NSString *strValue = [OrderUtil.shared checkNeedToShowAlert:order];
        if (strValue) {
            [self showAlertWithTitle:@"XP Driver" message:strValue first:@"YES" second:@"NO" shouldTwo:YES handler:^{
                [self goToCodDeliverScreen: order];
            }];
        } else {
            [self goToCodDeliverScreen: order];
        }
    } else {
        [CommonFunctions showQuestionsAlertWithTitel:@"Alert" message:[self messageString:order] inVC:self completion:^(BOOL success) {
            if (success) {
                [self updateActivityStatus:status order:order];
                if (order.status == KOrderStatusReached || order.status == KOrderStatusPickedup) {
                    [self checkOrders:order];
                }
            }
        }];
    }
}

-(void) goToCodDeliverScreen:(Order *)order {
    UICodChargeToCustomerViewController *codCheck = [[UICodChargeToCustomerViewController alloc] init];
    codCheck.order = order;
    codCheck.latLong = self.driverCoordinate;
    codCheck.address = self.driverAddress;
    [codCheck setHandlerSuccess:^(NSDictionary * _Nonnull data) {
        NSLog(@"Handler success data: %@", data);
        
        Order *order = [[Order alloc] initWithAtrribute:[data dictionaryByReplacingNullsWithBlanks]];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Order *evaluatedObject, NSDictionary *bindings) {
            return ![evaluatedObject.orderId isEqualToString:order.orderId];
        }];
        self.orders = [[self.orders filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];

        [self.delegate pushToFareAndRank:order];
//            self.selectedOrder = order;
//            [self performSegueWithIdentifier:FARE_Idintifire sender:self];
//            UISubmitedSuccessfullyPopupViewController *success = [[UISubmitedSuccessfullyPopupViewController alloc] init];
//            success.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            success.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            [self presentViewController:success animated:YES completion:nil];
    }];
    [self.navigationController pushViewController:codCheck animated:true];
}

- (IBAction)currentLocationBtnPressed:(id)sender{
    [self.delegate clickToNavigate];
////    if (self.isDirectionBtn) {
//        [self openDirectionsInGoogleMaps];
////    }else{
////        [self.mapView animateToLocation:self.locationTracker.currentLocation];
////    }
}

- (IBAction)onClickScan:(id)sender{
    DLog(@"** wk scan click done");
    [self.delegate clickScanButtonfromOrders];
}

- (KOrderStatus)orderStatus:(Order *)order{
    switch (order.status) {
        case KOrderStatusAccepted:
            return KOrderStatusReached;
            break;
        case KOrderStatusReached:
            return KOrderStatusPickedup;
            break;
        case KOrderStatusPickedup:
            return KOrderStatusDelivered;
            break;
        default:
            break;
    }
    return KOrderStatusUnknow;
}
- (NSString *)messageString:(Order *)order{
    if (order.status ==  KOrderStatusAccepted) {
        return [NSString stringWithFormat:@"Have you arrived at %@?",order.restaurant.name];
    }else if (order.status ==  KOrderStatusReached){
        return [NSString stringWithFormat:@"You want to pick up order %@?",order.orderId];
    }else if (order.status ==  KOrderStatusPickedup){
        return [NSString stringWithFormat:@"You want to deliver order %@?",order.orderId];
    }
    return @"";
}
- (void)activeOrder:(Order *)order{
    self.selectedOrder = order;
    if (order.isActive) {
        return;
    }
//    NSString *titel = !order.isPickedUp ? [NSString stringWithFormat:@"You want to picking up order %@?",order.orderId] : [NSString stringWithFormat:@"You want to deliver order %@?",order.orderId];
    NSString *titel = [NSString stringWithFormat:@"You want to switch to order %@?", order.orderId];
    [CommonFunctions showQuestionsAlertWithTitel:@"Are you sure" message:titel inVC:self completion:^(BOOL success) {
        if (success){
            [self activeOrder];
        }
    }];
}
//https://xpeats.com/api/index.php?command=orderActive&order_id=2670&driver_id=1810
//- (void)activeOrder{
//    DLog(@"Called");
//    [self showHud];
//    [self.orders removeAllObjects];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"orderActive" forKey:@"command"];
//    [parameters setObject:self.selectedOrder.orderId forKey:@"order_id"];
//    [parameters setObject:SHAREMANAGER.userId forKey:@"driver_id"];
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        DLog(@"the json return is %@",json);
//        
//        if (![json objectForKey:@"error"] &&  json!=nil){
//            NSArray *resultArray = [json objectForKey:RESULT];
//            NSDictionary *res = @{@"orders":resultArray};
//            RideRequest *request = [[RideRequest alloc] initWithAttribute:res];
//            self.orders = request.orders;
//            [self.tableView reloadData];
//            [self hideHud];
//            //[self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
//        }else {
//            [self hideHud];
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

- (void)activeOrder{
    DLog(@"Called");
    [self showHud];
    NSMutableArray *tmpOrders = [self.orders mutableCopy];
    [self.orders removeAllObjects];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"orderActiveOptimized" forKey:@"command"];
    [parameters setObject:self.selectedOrder.orderId forKey:@"order_id"];
    [parameters setObject:SHAREMANAGER.userId forKey:@"driver_id"];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:parameters
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response fetchDictionryData JSON: %@", json);
        if (![json objectForKey:@"error"] &&  json!=nil){
            for (Order *order in tmpOrders) {
                Order *newOrder = order;
                if (newOrder.orderId == self.selectedOrder.orderId) {
                    newOrder.isActive = 1;
                } else {
                    newOrder.isActive = 0;
                }
                [self.orders addObject:newOrder];
            }
            
//            [self.orders sortUsingComparator:^NSComparisonResult(Order *order1, Order *order2) {
//                if (order1.isActive && !order2.isActive) {
//                    return NSOrderedAscending;
//                } else if (!order1.isActive && order2.isActive) {
//                    return NSOrderedDescending;
//                } else {
//                    return NSOrderedSame;
//                }
//            }];
            
//            NSArray *resultArray = [json objectForKey:RESULT];
//            NSDictionary *res = @{@"orders":resultArray};
//            RideRequest *request = [[RideRequest alloc] initWithAttribute:res];
////            self.orders = request.orders;
//            [self.delegate changeActiveOrder: json];
            [self.delegate changeActiveOrder];
            [self.tableView reloadData];
            [self hideHud];
            //[self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
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
    [self hideHud];
    if ([ErrorFunctions isError:errorDescription]){
        
    }else {
        DLog(@"Error %@",errorDescription);
    }
}


- (void)dismiss{
    [self hideHud];
    [self.delegate ordersViewControllerDismissed];
}
- (void)checkOrders:(Order *)order{
    if (order.status == KOrderStatusPickedup) {
        [self showDeliveryAlert:[self isMoreDeliveriesForSameUser:order] order:order];
        return;
    }
    NSInteger moreORdersForPickdup = [self isMoreOrderFormSameRestuarentSameStatus:order] - 1;
    if (moreORdersForPickdup > 0) {
        NSString * orderString = moreORdersForPickdup  == 1 ? @"Additional order requires pick up" : [NSString stringWithFormat:@"%@ Additional orders requires pick up",@(moreORdersForPickdup).stringValue];
        NSString *message = [NSString stringWithFormat:@"%@\n%@  ",orderString,order.restaurant.name];
        [CommonFunctions showAlertWithTitel:@"Alert" message:message inVC:self completion:^(BOOL success) {
           
        }];
    }
}
- (NSInteger)isMoreOrderFormSameRestuarentSameStatus:(Order *)order{
    if (self.orders.count == 1) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"restaurant.restaurentId == %@", order.restaurant.restaurentId];
    NSArray *filteredArray = [self.orders filteredArrayUsingPredicate:predicate];
    
    NSPredicate *statuspredicate = [NSPredicate predicateWithFormat:@"statusName == %@", order.statusName];
    NSArray *statusFilteredArray = [filteredArray filteredArrayUsingPredicate:statuspredicate];
    return statusFilteredArray.count ;
}
- (NSInteger )isMoreDeliveriesForSameUser:(Order *)order{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customer.clientId == %@", order.customer.clientId];
    NSArray *filteredArray = [self.orders filteredArrayUsingPredicate:predicate];
    return filteredArray.count;
}
- (void)showDeliveryAlert:(NSInteger)orders order:(Order *)order{
    NSInteger moreORdersForPickdup = orders - 1;
       if (moreORdersForPickdup > 0) {
           NSString * orderString = moreORdersForPickdup  == 1 ? @"Additional order requires delivery to" : [NSString stringWithFormat:@"%@ Additional order requires delivery to",@(moreORdersForPickdup).stringValue];
           NSString *message = [NSString stringWithFormat:@"%@\n%@  ",orderString,order.customer.name];
           [CommonFunctions showAlertWithTitel:@"Alert" message:message inVC:self];
       }
}
//-(void)updateActivityStatus:(KOrderStatus)currentAction order:(Order *)order{
//    
//    [self showHud];
//    NSArray *latlong= [self.driverCoordinate componentsSeparatedByString:@","];
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"parcelDelivery",@"command",order.orderId,@"order_id",[NSNumber numberWithInt:currentAction],@"current_activity",SHAREMANAGER.userId,@"driver_id",latlong[0],@"lat",latlong[1],@"long",self.driverAddress,@"address", nil];
//    [NetworkController apiPostWithParameters:params Completion:^(NSDictionary *json, NSString *error) {
//        [self hideHud];
//        if (json != nil && ![json objectForKey:@"error"]){
//            NSArray *resultArray = [json objectForKey:RESULT];
//            NSDictionary *res = @{@"orders":resultArray};
//            self.request = [[RideRequest alloc] initWithAttribute:res];
//            self.orders = self.request.orders;
//            [self.tableView reloadData];
//        }else{
//            NSString *errorMsg = [json objectForKey:@"error"] ;
//            if ([ErrorFunctions isError:errorMsg]){
//                [self updateActivityStatus:currentAction order:order];
//            }else{
//                if (!errorMsg.isEmpty) {
//                    [CommonFunctions showAlertWithTitel:@"Oops!" message:errorMsg inVC:self];
//                }
//            }
//            
//            
//            
//        }
//        
//        
//    }];
//    
//}

-(void)updateActivityStatus:(KOrderStatus)currentAction order:(Order *)order{
    
    [self showHud];
    NSArray *latlong= [self.driverCoordinate componentsSeparatedByString:@","];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"parcelDelivery",@"command",order.orderId,@"order_id",[NSNumber numberWithInt:currentAction],@"current_activity",SHAREMANAGER.userId,@"driver_id",latlong[0],@"lat",latlong[1],@"long",self.driverAddress,@"address", nil];
    
    [AlamofireWrapper performJSONRequestWithMethod:RequestMethodPost
                                         urlString:@"https://www.xpeats.com/api/index.php"
                                        parameters:params
                                          encoding:RequestParameterEncodingJson
                                           headers:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSDictionary * _Nonnull json) {
        // Handle success
        NSLog(@"wk Response fetchDictionryData JSON: %@", json);
        [self hideHud];
        if (json != nil && ![json objectForKey:@"error"]){
            NSArray *resultArray = [json objectForKey:RESULT];
            NSDictionary *res = @{@"orders":resultArray};
            self.request = [[RideRequest alloc] initWithAttribute:res];
            self.orders = self.request.orders;
            self.lblOrderNumberForNavigate.text = [NSString stringWithFormat:@"Order #%@", self.selectedOrder.orderId];
            [self.tableView reloadData];
        }else{
            NSString *errorMsg = [json objectForKey:@"error"] ;
            [self handleErrorUpdateStatus:errorMsg currentAction:currentAction order:order];
        }
    }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // Handle failure
        NSLog(@"Error: %@", error.localizedDescription);
        [self hideHud];
        [self handleErrorUpdateStatus:error.localizedDescription currentAction:currentAction order:order];
    }];
    
}

-(void) handleErrorUpdateStatus: (NSString *)errorDescription currentAction: (KOrderStatus) currentAction order: (Order *)order {
    if ([ErrorFunctions isError:errorDescription]){
        [self updateActivityStatus:currentAction order:order];
    }else{
        if (!errorDescription.isEmpty) {
            [CommonFunctions showAlertWithTitel:@"Oops!" message:errorDescription inVC:self];
        }
    }
}


#pragma merk - FareAndRatingViewDelegate -
- (void)deleteOrder:(Order *)order{
    NSInteger index = [self.orders indexOfObject:order];
    [self.orders removeObjectAtIndex:index];
    [self.tableView reloadData];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[OrderInfoViewController class]]) {
        OrderInfoViewController *vc = (OrderInfoViewController *)[segue destinationViewController];
        vc.order   = self.selectedOrder;
    } 
//    else if ([segue.identifier isEqualToString:FARE_Idintifire]) {
//        FareAndRatingView *vc = (FareAndRatingView *)[segue destinationViewController];
//        vc.order   = self.selectedOrder;
//    }
}

#pragma mark- Open Google Directions

- (void)openDirectionsInGoogleMaps {
    GoogleDirectionsDefinition *directionsDefinition = [[GoogleDirectionsDefinition alloc] init];
    NSString *endingString = self.selectedOrder.status != KOrderStatusPickedup ? self.selectedOrder.restaurant.location.address : self.selectedOrder.dropLocation.address;
    CLLocationCoordinate2D endingLocation = self.selectedOrder.status != KOrderStatusPickedup ? self.selectedOrder.restaurant.location.coordinate : self.selectedOrder.dropLocation.coordinate;
    GoogleDirectionsWaypoint *startingPoint = [[GoogleDirectionsWaypoint alloc] init];
    startingPoint.queryString = self.driverAddress;
    startingPoint.location = self.driverLocation;
    DLog(@"** wk startingPoint queryString: %@, location: %f,%f", startingPoint.queryString, startingPoint.location.latitude, startingPoint.location.longitude);
    directionsDefinition.startingPoint = startingPoint;
    GoogleDirectionsWaypoint *destination = [[GoogleDirectionsWaypoint alloc] init];
    destination.queryString = endingString;
    destination.location = endingLocation;
    DLog(@"** wk destination queryString: %@, location: %f,%f", destination.queryString, destination.location.latitude, destination.location.longitude);
    directionsDefinition.destinationPoint = destination;
    directionsDefinition.travelMode = self.selectedOrder.isEventOrder? kTravelModeWalking: kTravelModeDriving;
    [[OpenInGoogleMapsController sharedInstance] openDirections:directionsDefinition];
}
@end
