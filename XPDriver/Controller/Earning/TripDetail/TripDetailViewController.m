//
//  TripDetailViewController.m
//  XPDriver
//
//  Created by Syed zia on 07/02/2019.
//  Copyright © 2019 Syed zia ur Rehman. All rights reserved.
//

#import "TripDetail.h"
#import "FareCell.h"
#import "FareHeadingCell.h"
#import "PaymentModeCell.h"
#import "ClientInfoCell.h"

#import "TripDetailViewController.h"
#import "XP_Driver-Swift.h"

@interface TripDetailViewController ()
@property (assign, nonatomic) BOOL  isExpand;
@property (strong, nonatomic) TripDetail *tripDetail;
@property (strong, nonatomic) GMSPolyline *polyline;
@property (strong, nonatomic) GMSMarker   *pickupMarker;
@property (strong, nonatomic) GMSMarker   *dropMarker;
@property (strong, nonatomic) NSMutableArray   *markers;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TripDetailViewController
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self fetchDetailFormServer];
}
- (void)loadMapView{
    GMSCameraPosition *camera   = [GMSCameraPosition cameraWithLatitude:self.tripDetail.pickupCoordinate.latitude longitude:self.tripDetail.pickupCoordinate.longitude zoom:18.0f];
    [self.mapView setUserInteractionEnabled:NO];
    [self.mapView.settings setAllGesturesEnabled:NO];
    [self.mapView animateToCameraPosition:camera];
    [self drawPolyLineOnPath:self.tripDetail.reoutePath];
}
- (void)drawPolyLineOnPath:(GMSMutablePath *)path{
    self.markers           = [NSMutableArray new];
    self.pickupMarker      = [GMSMarker new];
    self.dropMarker        = [GMSMarker new];
    self.pickupMarker.position          = self.tripDetail.pickupCoordinate;
    self.pickupMarker.title             = self.tripDetail.pickupAddress;
    self.pickupMarker.snippet           = @"Pickup";
    self.pickupMarker.appearAnimation   = kGMSMarkerAnimationPop;
    self.pickupMarker.icon              = PICKUP_MARKER_IMAGE;
    self.pickupMarker.map               = self.mapView;
    [self.markers addObject:self.pickupMarker];
    self.dropMarker.title             = @"Drop";
    self.dropMarker.snippet           = self.tripDetail.dropAddress;
    self.dropMarker.position         = self.tripDetail.dropCoordinate;
    self.dropMarker.appearAnimation  = kGMSMarkerAnimationPop;
    self.dropMarker.icon              = DESTINATION_MARKER_IMAGE;
    self.dropMarker.infoWindowAnchor = CGPointMake(0.0f, 0.0f);
    self.dropMarker.map              = self.mapView;
    [self.markers addObject:self.dropMarker];
    if (path.count == 0) {
        return;
    }
    self.polyline = [GMSPolyline new];
    self.polyline.path         = path;
    self.polyline.strokeWidth  = 4;
    self.polyline.strokeColor  = [UIColor appGrayColor];
    self.polyline.geodesic     = YES;
    self.polyline.map          = self.mapView;
    [self focusMapToShowAllMarkers];
    
}

- (void)focusMapToShowAllMarkers{
    if (self.markers.count == 0) {return;}
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in self.markers){
        bounds = [bounds includingCoordinate:marker.position];
    }
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(10.0 , 10.0 ,10.0 ,10.0)]];
    [self.mapView animateToZoom:10.0];
    
}
#pragma mark- UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //CGFloat headerWidth = CGRectGetWidth(self.view.frame);
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(20, 0,1,ViewWidth(tableView)-40)];
    [view setBackgroundColor:self.tableView.separatorColor];
    return view;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.tripDetail.fare.count == 0) {
            return 0;
        }
        return self.isExpand ? self.tripDetail.fare.count + 1 : 1;
    }else{
        if (!self.tripDetail) {
            return 0;
        }
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self fareHeadingCell:indexPath];
        }else{
            return [self fareCell:indexPath];
        }
    }else{
        if (indexPath.row == 0) {
            return [self paymentModeCell:indexPath];
        }else{
            return [self clientInfoCell:indexPath];
        }
        return [UITableViewCell new];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.isExpand = !self.isExpand;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
- (FareHeadingCell *)fareHeadingCell:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringFromClass([FareHeadingCell class]);
    FareHeadingCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configerWithTitel:@"Ride Fare" subTitel:self.tripDetail.totlaFare];
    
    return cell;
}
- (PaymentModeCell *)paymentModeCell:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringFromClass([PaymentModeCell class]);
    PaymentModeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configerWithTitel:self.tripDetail.paymetnMode subTitel:self.tripDetail.totlaFare];
    return cell;
}
- (ClientInfoCell *)clientInfoCell:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringFromClass([ClientInfoCell class]);
    ClientInfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell configerName:self.tripDetail.clientName picURL:self.tripDetail.clientImageURL carType:self.tripDetail.vehicleType carinfo:self.tripDetail.vehicleInfo];
    return cell;
}
- (FareCell *)fareCell:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringFromClass([FareCell class]);
    FareCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    FareInfo *info = self.tripDetail.fare[indexPath.row - 1];
    [cell.titleLabel setText:info.title];
    [cell.subTitleLable setText:info.subTitle];
    return cell;
}
#pragma mark- WebServices
//- (void)fetchDetailFormServer{
//    //https://trip.myxpapp.com/services/index.php?command=ride_detail&d_id=2&role_id=7
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setObject:@"ride_detail" forKey:@"command"];
//    [parameters setObject:self.rideID forKey:@"d_id"];
//    [parameters setObject:ROLE_ID forKey:@"role_id"];
//
//    [NetworkController apiPostWithParameters:parameters Completion:^(NSDictionary *json, NSString *error){
//        //NSLog(@"the json return is %@",json);
//        if (![json objectForKey:@"error"]&& json!=nil){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            self.tripDetail = [[TripDetail alloc] initWithAttrebute:json[RESULT]];
//            [self loadMapView];
//            [self.tableView reloadData];
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
//}


- (void)fetchDetailFormServer{
    //https://trip.myxpapp.com/services/index.php?command=ride_detail&d_id=2&role_id=7
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:@"ride_detail" forKey:@"command"];
    [parameters setObject:self.rideID forKey:@"d_id"];
    [parameters setObject:ROLE_ID forKey:@"role_id"];
    
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
            self.tripDetail = [[TripDetail alloc] initWithAttrebute:json[RESULT]];
            [self loadMapView];
            [self.tableView reloadData];
        }else {
            [self handleError: [json objectForKey:@"error"]];
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

- (void)hideHud{
    dispatch_sync(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
}
#pragma mark- IBActions
- (IBAction)backBtnPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
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
