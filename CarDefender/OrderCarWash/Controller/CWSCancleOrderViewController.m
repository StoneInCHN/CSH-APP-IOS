//
//  CWSCancleOrderViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCancleOrderViewController.h"

@interface CWSCancleOrderViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
     NSArray *clickButtonArray;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTop;
- (IBAction)chooseButtonClick:(UIButton *)sender;

@end

@implementation CWSCancleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取消订单";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self initalizeUserInterface];
}


#pragma mark - 界面
- (void)initalizeUserInterface
{
    //以下为选项按钮
    self.firstClickButton = (UIButton *)[self.view viewWithTag:1];
    self.secondClickButton = (UIButton *)[self.view viewWithTag:2];
    self.thirdClickButton = (UIButton *)[self.view viewWithTag:3];
    clickButtonArray = @[self.firstClickButton,self.secondClickButton,self.thirdClickButton];
    
    //以下是textview视图
    self.textCustomView = (UIView *)[self.view viewWithTag:4];
    self.textView = (UITextView *)[self.view viewWithTag:5];
    self.textView.delegate = self;
    self.messageLabel = (UILabel *)[self.view viewWithTag:6];
    
    //提交按钮
    self.submitButton = (UIButton *)[self.view viewWithTag:7];
    [self.submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 选项按钮
- (IBAction)chooseButtonClick:(UIButton *)sender {
    for (UIButton *button in clickButtonArray) {
        button.selected = NO;
    }
    sender.selected = YES;
    //若点击以上都不是按钮
    if (sender == self.thirdClickButton && sender.selected == YES) {
        self.textCustomView.alpha = 1;
        self.textView.alpha = 1;
        self.messageLabel.alpha = 1;
        //更新约束
        self.submitButtonTop.constant  += 140;
        [self.view layoutIfNeeded];
    }
    else {
        self.textCustomView.alpha = 0;
        self.textView.alpha = 0;
        self.messageLabel.alpha = 0;
        self.submitButtonTop.constant  = 72;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - 提交按钮
- (void)submitButtonPressed:(UIButton *)sender
{
    NSDictionary *dic = @{@"tag":@"yes"};
    NSInteger tag = 0;//用来标志原因已填写
    NSMutableDictionary* lDic = [NSMutableDictionary dictionary];
    [lDic setValue:KUserManager.uid forKey:@"uid"];
    [lDic setValue:KUserManager.mobile forKey:@"mobile"];
    [lDic setValue:[NSString stringWithFormat:@"%ld",(long)self.orderId] forKey:@"orderId"];
    if (self.firstClickButton.selected == YES) {
        [lDic setValue:@"等待时间过长" forKey:@"cancel_reasons"];
        tag = 1;
    }
    else if (self.secondClickButton.selected == YES){
        [lDic setValue:@"我已不需要此服务" forKey:@"cancel_reasons"];
        tag = 1;
    }
    //点击吐槽
    else if (self.thirdClickButton.selected == YES){
        if (self.textView.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请吐槽" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            tag = 0;
        }
        else {
            [lDic setValue:self.textView.text forKey:@"cancel_reasons"];
            tag = 1;
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一项" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        tag = 0;
    }
    
    if (tag == 1) {
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        [ModelTool getCancleOrderWithParameter:lDic andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                    NSLog(@"%@",object);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancleOrder" object:nil userInfo:dic];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                
            });
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.messageLabel.alpha = 0;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textView.text.length == 0) {
        self.messageLabel.alpha = 1;
    }
}

@end
