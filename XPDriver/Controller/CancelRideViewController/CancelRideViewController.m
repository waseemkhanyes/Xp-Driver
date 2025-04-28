//
//  CancelRideViewController.m
//  XPDriver
//
//  Created by Syed zia on 05/11/2018.
//  Copyright © 2018 Syed zia ur Rehman. All rights reserved.
//
#import "DictionryData.h"
#import "Reasons.h"
#import "ReasonCell.h"
#import "CancelRideViewController.h"

@interface CancelRideViewController ()
@property(nonatomic,strong) Reasons *selectedReason;
@property(nonatomic,strong) NSMutableArray *optionsArray;
@property(nonatomic,strong) IBOutlet UITableView *tableview;
- (IBAction)backButtonPressed:(id)sender;

- (IBAction)cancelRideButtonPressed:(id)sender;

@end

@implementation CancelRideViewController
@synthesize delegate;
-(BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionsArray   = [[DictionryData appData] reasons];
     self.selectedReason = self.optionsArray[0];
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return UITableViewAutomaticDimension;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString* cellIdentifier = NSStringFromClass([ReasonCell class]);
    ReasonCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Reasons *reason = [self.optionsArray objectAtIndex:indexPath.row];
        cell.label.text = reason.reason;
    BOOL isSelected = [cell.label.text isEqualToString:self.selectedReason.reason];
    UIImage *image = isSelected ? [UIImage imageNamed:@"ic_ride_cancel_check"] : [UIImage imageNamed:@"ic_ride_cancel_uncheck"];
    [cell.imgView setImage:image];
        return cell;
}

#pragma mark- UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        self.selectedReason = [self.optionsArray objectAtIndex:indexPath.row];
        [self.tableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    [self dismiss];
}

- (IBAction)cancelRideButtonPressed:(id)sender {
    [self dismiss];
    [self.delegate cancelRideWithReason:self.selectedReason];
}
- (void)dismiss{
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
