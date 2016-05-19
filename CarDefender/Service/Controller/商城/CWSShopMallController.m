//
//  CWSShopMallController.m
//  CarDefender
//
//  Created by 李散 on 15/8/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSShopMallController.h"
#import "ModelTool.h"
@interface CWSShopMallController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    NSDictionary*_dicMsg;
}
@end

@implementation CWSShopMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    [Utils changeBackBarButtonStyle:self];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
#if USENEWVERSION
    
#else
    
    [ModelTool httpGetShopMallUserMsgWithParameter:@{@"username":KUserManager.tel,@"password":@"123123",@"client":@"wap"} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _dicMsg = [NSDictionary dictionaryWithDictionary:object];
            [self loadWebViewWithDic:object[@"datas"]];
        });
    } faile:^(NSError *err) {
        MyLog(@"%@",err);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
#endif
    
    
}
#pragma mark - 添加WebView
- (void)loadWebViewWithDic:(NSDictionary*)dicMsg
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString*path = @"http://pay.chcws.com/wap/";
    for (int i = 0; i<dicMsg.count; i++) {
        if (i == 0) {
            NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:[NSDictionary dictionaryWithObject:[[NSString alloc] initWithFormat:@"%@=%@",@"key",dicMsg[@"key"]] forKey:@"Set-Cookie"] forURL:[NSURL URLWithString:path]];
            
            // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie forURL:[NSURL URLWithString:path] mainDocumentURL:nil];
        }else{
            NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:[NSDictionary dictionaryWithObject:[[NSString alloc] initWithFormat:@"%@=%@",@"username",dicMsg[@"username"]] forKey:@"Set-Cookie"] forURL:[NSURL URLWithString:path]];
            
            // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie forURL:[NSURL URLWithString:path] mainDocumentURL:nil];
        }
        
    }
    
    NSURL * url = [[NSURL alloc] initWithString:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
