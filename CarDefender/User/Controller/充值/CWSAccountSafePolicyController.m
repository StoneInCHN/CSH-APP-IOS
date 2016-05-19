//
//  CWSAccountSafePolicyController.m
//  CarDefender
//
//  Created by sky on 15/10/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAccountSafePolicyController.h"
#import "ModelTool.h"
@interface CWSAccountSafePolicyController ()

@end

@implementation CWSAccountSafePolicyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保障协议";
    [Utils changeBackBarButtonStyle:self];
    [self showHudInView:self.view hint:@"正在加载..."];
    [ModelTool httpAppGainPolicyRuleWithParameter:nil success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                UITextView*textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-44)];
                textView.text = object[@"data"][@"content"];
                textView.editable = NO;
                textView.font = [UIFont systemFontOfSize:16];
                [self.view addSubview:textView];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
    
    UIWebView*webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-44)];
    [self.view addSubview:webView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
