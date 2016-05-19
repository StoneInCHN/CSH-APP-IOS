//
//  CWSAdInfoViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/14.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSAdInfoViewController.h"

@interface CWSAdInfoViewController () <UIWebViewDelegate>

@end

@implementation CWSAdInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看详情";
    [Utils changeBackBarButtonStyle:self];
    
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.webView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}

@end
