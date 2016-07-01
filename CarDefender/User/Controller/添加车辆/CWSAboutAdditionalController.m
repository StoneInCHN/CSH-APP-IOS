//
//  CWSAboutAdditionalController.m
//  CarDefender
//
//  Created by 李散 on 15/5/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAboutAdditionalController.h"

@interface CWSAboutAdditionalController ()<UIAlertViewDelegate,UIWebViewDelegate>{
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
    UIWebView * webView;
    
}

@end

@implementation CWSAboutAdditionalController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title=@"附加项";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置导航
    
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.pointOne riders:4];
    [Utils setViewRiders:self.pointTwo riders:4];
    [Utils setViewRiders:self.pointThree riders:4];
    
}
//设置导航
//设置导航栏返回键

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToWeb:(UIButton *)sender {
    if (sender.tag==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.chcws.com"]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
        [self creatWebview];
    }else if (sender.tag==2){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"联系客服" message:@"拨打4007930888以获取客服支持，您确认要拨打吗？" delegate:self cancelButtonTitle:@"拨打客服" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

//创建WebView
-(void)creatWebview{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height)];
    webView.delegate = self;
    [webView setUserInteractionEnabled:YES];//是否支持交互
    [webView setOpaque:NO];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:webView];
    
    
   
    //加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:@"http://www.chcws.com"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    opaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height)];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width  , self.view.frame.size.height)];
    [activityIndicatorView setCenter:opaqueView.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [opaqueView setBackgroundColor:[UIColor whiteColor]];
    [opaqueView setAlpha:0.6];
    [self.view addSubview:opaqueView];
    [opaqueView addSubview:activityIndicatorView];
}
#pragma mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
    }
}

@end
