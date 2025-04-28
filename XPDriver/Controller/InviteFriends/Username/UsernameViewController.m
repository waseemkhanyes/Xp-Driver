//
//  UsernameViewController.m
//  XPFood
//
//  Created by Macbook on 13/08/2020.
//  Copyright © 2020 WelldoneApps. All rights reserved.
//
#import "LoginViewController.h"
#import "UsernameViewController.h"

@interface UsernameViewController ()
@property (nonnull,nonatomic,strong) NSMutableDictionary *parameters;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *usernameField;
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender;

- (IBAction)createButtonPressed:(RoundedButton *)sender;

@end

@implementation UsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (SHAREMANAGER.user.username != nil) {
        self.usernameField.text = SHAREMANAGER.user.username;
    }else{
        self.usernameField.placeholder = @"Enter username";
    }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.usernameField) {
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];

        if (lowercaseCharRange.location != NSNotFound) {
            // some uppercase chars where found, need to replace

            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
            // new cursor location after insert/paste/typing
            NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;

            // convert whole text to lowercase and update the textfield
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string lowercaseString]];

            // now reposition the cursor
            UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
            UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
            [textField setSelectedTextRange:newSelectedRange];
            return NO;
        }
    }
    return YES;
}

- (IBAction)createButtonPressed:(RoundedButton *)sender{
    [self updateUsername:sender];
//    if (!self.usernameField.isEmpty) {
//        
//    }
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)updateUsername:(RoundedButton *)sender{
    [sender showLoading];
    NSMutableDictionary *params = [NSMutableDictionary new];
     [params setObject:self.usernameField.text forKey:@"username"];
    
    [User updateUsername:params completion:^(NSString * _Nullable message) {
        [sender hideLoading];
        if (message) {
            [CommonFunctions showAlertWithTitel:@"" message:message inVC:self];
        }
    }];
    
}
- (void)backTologinScreen{
    NSMutableArray *viewcontrollers  = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in viewcontrollers) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
              [self.navigationController popToViewController:vc animated:YES];
            break;
        }else{
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
