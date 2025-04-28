//
//  LoadingView.m
//  NexiDriver
//
//  Created by Syed zia on 25/07/2016.
//  Copyright © 2016 Syed zia ur Rehman. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
@property (strong, nonatomic) IBOutlet UIView *hudView;
@end

@implementation LoadingView

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
