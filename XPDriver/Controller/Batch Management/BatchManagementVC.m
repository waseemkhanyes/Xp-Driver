//
//  BatchManagementVC.m
//  XPDriver
//
//  Created by Moghees on 10/10/2022.
//  Copyright © 2022 Syed zia. All rights reserved.
//

#import "BatchManagementVC.h"
#import "BatchManagementFilterCell.h"
#import "BatchManagementLocationCell.h"
#import "BatchManagementOrderCell.h"
#import "BatchManagementHeader.h"
#import "BatchManagementSelectAllCell.h"

@interface BatchManagementVC ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BatchManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName: @"BatchManagementOrderCell" bundle:nil] forCellReuseIdentifier: identifierBMO];
    [self.tableView registerNib:[UINib nibWithNibName: @"BatchManagementHeader" bundle:nil] forCellReuseIdentifier: HeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName: @"BatchManagementSelectAllCell" bundle:nil] forCellReuseIdentifier: SelectAlldentifier];
    
    
}




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return  1;
        case 2:
            return 1;
        case 3:
            return 3;
        case 4:
            return 10;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
        case 1:
            return  0;
        case 2:
            return UITableViewAutomaticDimension;
        case 3:
            return UITableViewAutomaticDimension;
        default:
            return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView  estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section > 2){
        BatchManagementHeader *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
        return cell;
    }
    else {return nil;}
   
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configerCell:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}
- (UITableViewCell *)configerCell:(NSIndexPath*)indexPath{
    switch (indexPath.section) {
        case 0:
            return  [self filterBatchManagement];
            break;
        case 1:
            return  [self locationBatchManagement];
            break;
        case 2:
            return [self selectAll];
            break;
        case 3:
            return  [self orderCell];
            break;
        case 4:
            return  [self orderCell];
            break;
        default:
            break;
    }
    return nil;
}

- (BatchManagementFilterCell *)filterBatchManagement{
    BatchManagementFilterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBM];
    return cell;
}

- (BatchManagementLocationCell *)locationBatchManagement{
    BatchManagementLocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBML];
    [cell configerBatchManagementLocationCell];
    return cell;
}

- (BatchManagementOrderCell *)orderCell{
    BatchManagementOrderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierBMO];
    return cell;
}
- (BatchManagementSelectAllCell *)selectAll{
    BatchManagementSelectAllCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SelectAlldentifier];
    return cell;
}
@end
