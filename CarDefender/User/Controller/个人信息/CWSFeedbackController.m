//
//  CWSFeedbackController.m
//  CarDefender
//  意见反馈
//  Created by 李散 on 15/4/15.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFeedbackController.h"

@interface CWSFeedbackController ()<UITextViewDelegate>{
    UserInfo *userInfo;
}

@end

@implementation CWSFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户反馈";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    userInfo = [UserInfo userDefault];
    [Utils changeBackBarButtonStyle:self];
    [self initalizeUserInterface];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.textView = (UITextView *)[self.view viewWithTag:1];
    self.textView.delegate = self;
    
    self.countLabel = (UILabel *)[self.view viewWithTag:2];
    self.submitButton = (UIButton *)[self.view viewWithTag:3];
    [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - submitButtonPressed
- (void)submitButtonPressed:(UIButton *)sender

{
    if (self.textView.text.length>0 && self.textView.text.length<=100) {
//        NSDictionary *dic = @{@"uid":KUserManager.uid,
//                              @"body":self.textView.text};
        [MBProgressHUD showMessag:@"提交中..." toView:self.view];
        
//        [HttpTool postFeedbackMessageWithParameter:dic success:^(NSDictionary *data) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if ([data[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:data[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            });
//        } faile:^(NSError *err) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求有问题,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }];
        
        [HttpHelper postFeedbackWithUserId:userInfo.desc token:userInfo.token content:self.textView.text success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
            NSLog(@"feedback response :%@", responseObjcet);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *resultDic = (NSDictionary *)responseObjcet;
            if ([resultDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                userInfo.token = resultDic[@"token"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([resultDic[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultDic[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求有问题,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
    }
    else if (self.textView.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写意见" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.countLabel.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)self.textView.text.length];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textView.text.length > 100){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入100字以内的意见" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
