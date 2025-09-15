//
//  CancelOrderViewController.m
//  XPEats
//
//  Created by Macbook on 10/04/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "Order.h"
#import "CancelOrderViewController.h"

@interface CancelOrderViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *reasonTextView;
@property (strong, nonatomic) IBOutlet RoundedButton *backButton;
@property (strong, nonatomic) IBOutlet RoundedButton *cancelButton;
- (IBAction)backButtonPressed:(RoundedButton *)sender;
- (IBAction)cancelButtonPressed:(RoundedButton *)sender;

@end

@implementation CancelOrderViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   // NSUInteger newLength = [textView.text length] + [text length] - range.length;
    // [self.cancelButton setEnabled:newLength != 0];
    return YES;
}
- (IBAction)backButtonPressed:(RoundedButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(RoundedButton *)sender {
    [self.view endEditing:YES];
    if (self.reasonTextView.text.length == 0) {
    }
    [self.cancelButton showLoading];
    [self cancelOrder];
}
- (void)cancelOrder{
    NSDictionary *parameters = @{@"command":@"driverCancelOrder",@"user_id":SHAREMANAGER.user.userId,@"order_id":self.order.orderId,@"reason":self.reasonTextView.text};
    [self.order cancelOrder:parameters Completion:^(NSString * _Nonnull error) {
        [self.cancelButton hideLoading];
//        [self dismissViewControllerAnimated:YES completion:^{
//                       [self.delegate orderCanceled];
//                   }];
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate orderCanceled:self.order];
            }];
        }else{
            [CommonFunctions showAlertWithTitel:@"" message:error inVC:self];
        }
    }];
   
}
@end
