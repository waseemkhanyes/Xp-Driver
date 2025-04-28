//
//  WebViewController.m
//  Alrimaya
//
//  Created by Syed zia on 07/09/2018.
//  Copyright © 2018 Syed zia. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "WebViewController.h"


@interface WebViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation WebViewController

- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(UIProgressView *)progressView{
 if (!_progressView) {
  _progressView     = [[UIProgressView alloc]
           initWithProgressViewStyle:UIProgressViewStyleDefault];
  _progressView.frame    = CGRectMake(0,0, ScreenWidth, 5);

  [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
               green:240.0/255
               blue:240.0/255
               alpha:1.0]];
  _progressView.progressTintColor = [UIColor appBlueColor];


 }
 return _progressView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigatinBackgroundView];
    self.webView.frame = self.view.bounds;
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self
       forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
       options:0
       context:nil];
    [self loadTremsPage];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}
-(void)observeValueForKeyPath:(NSString *)keyPath
      ofObject:(id)object
      change:(NSDictionary<NSKeyValueChangeKey,id> *)change
      context:(void *)context{

 if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
  && object == self.webView) {
  [self.progressView setAlpha:1.0f];
  BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
  [self.progressView setProgress:self.webView.estimatedProgress
        animated:animated];

  if (self.webView.estimatedProgress >= 1.0f) {
   [UIView animateWithDuration:0.3f
         delay:0.3f
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
         [self.progressView setAlpha:0.0f];
        }
        completion:^(BOOL finished) {
         [self.progressView setProgress:0.0f animated:NO];
        }];
  }
 }else{
  [super observeValueForKeyPath:keyPath
        ofObject:object
        change:change
        context:context];
 }
}
- (void)loadTremsPage{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.webUrl];
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    self.title = webView.title;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
