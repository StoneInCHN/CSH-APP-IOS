//
//  CWSInternetPhoneViewController.m
//  CarDefender
//
//  Created by 万茜 on 16/1/5.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSInternetPhoneViewController.h"

@interface CWSInternetPhoneViewController ()

- (IBAction)downloadButtonClick:(UIButton *)sender;

@end

@implementation CWSInternetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络电话";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.numberLabel.text = @"";
    self.passwdLabel.text = @"";
    [self initalizeUserInterface];
}

- (void)initalizeUserInterface
{
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpTool postInternetPhoneMessageWithParameter:@{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile} success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([data[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.numberLabel.text = [NSString stringWithFormat:@"卡号:%@",data[@"data"][@"code"]];
                self.passwdLabel.text = [NSString stringWithFormat:@"密码:%@",data[@"data"][@"pass"]];
            }
            else  {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [WCAlertView showAlertWithTitle:@"提示" message:data[@"message"] customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            }
            
            
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [WCAlertView showAlertWithTitle:@"提示" message:@"网络出错，请重新加载" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }];
    
}

#pragma mark - 下载按钮
- (IBAction)downloadButtonClick:(UIButton *)sender {

//    NSURL *url = [[NSURL alloc]initWithString:@"http://www.baidu.com"];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [self.view addSubview: webView];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://139.129.9.175:9999/czy/"]];
}
@end
