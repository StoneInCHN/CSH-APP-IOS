//
//  CWSActivityDetailViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/17.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSActivityDetailViewController.h"

@interface CWSActivityDetailViewController () {
    UIWebView *_webViw;
}

@end

@implementation CWSActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠劵详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    [Utils changeBackBarButtonStyle:self];
    [self setupUI];
}

- (void)setupUI {
     _webViw = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    [_webViw loadHTMLString:self.htmlString baseURL:nil];
    _webViw.scalesPageToFit = YES;
    [self.view addSubview:_webViw];
}

@end
