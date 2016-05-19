//
//  CWSWebController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSWebController.h"

@interface CWSWebController ()

@end

@implementation CWSWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    UIWebView *lWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    lWebView.scalesPageToFit = YES;
    NSString *lstr = @"http://www.chcws.com";
    NSURL *lURL=[NSURL URLWithString:lstr];
    NSURLRequest *lURLRequest=[NSURLRequest requestWithURL:lURL];
    [lWebView loadRequest:lURLRequest];
    [self.view addSubview:lWebView];
}

@end
