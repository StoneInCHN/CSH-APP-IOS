//
//  SFBuyCarInsuranceViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/7/1.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFBuyCarInsuranceViewController.h"

@interface SFBuyCarInsuranceViewController ()<UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation SFBuyCarInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看详情";
    [self stepUI];
}
- (void)stepUI {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://app.car1615.com/app/insurance/page/788bf80951bb4b6f867ae5d281ea6807"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 20, 20)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}
@end
