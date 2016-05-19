//
//  CWSSituationInstructionsController.m
//  CarDefender
//  情况说明
//  Created by 万茜 on 15/11/26.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSSituationInstructionsController.h"
#import "OrderConfirmView.h"

@interface CWSSituationInstructionsController ()<UITextViewDelegate>
{
    UIButton *firstClickButton;//选择按钮1
    UIButton *sencondClickButton;//选择按钮2
    UIButton *submitButton;//提交按钮
    UITextView *reasonTextView;//原因输入框
    UILabel *messageLabel;//输入框提示语
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTop;

@end

@implementation CWSSituationInstructionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情况说明";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self showUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

#pragma mark - 界面
- (void)showUI
{
    //选择按钮1
    firstClickButton = (UIButton *)[self.view viewWithTag:1];
    [firstClickButton addTarget:self action:@selector(firstClickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //选择按钮2
    sencondClickButton = (UIButton *)[self.view viewWithTag:2];
    [sencondClickButton addTarget:self action:@selector(secondClickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //提交按钮
    submitButton = (UIButton *)[self.view viewWithTag:3];
    [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //原因输入框
    reasonTextView = (UITextView *)[self.view viewWithTag:4];
    reasonTextView.layer.borderWidth = 1.0;
    reasonTextView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    reasonTextView.layer.cornerRadius = 5;
    reasonTextView.delegate = self;
    //输入框提示语
    messageLabel = (UILabel *)[self.view viewWithTag:5];
    
}

#pragma mark - 选择按钮
- (void)firstClickButtonPressed:(UIButton *)sender
{

    sencondClickButton.selected = NO;
    sender.selected =YES;
    if (sender.selected) {

        [sencondClickButton setBackgroundImage:[UIImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
        //隐藏输入框
        reasonTextView.alpha = 0;
        messageLabel.alpha = 0;
        self.submitButtonTop.constant = 60;
        
    }
    
}

- (void)secondClickButtonPressed:(UIButton *)sender
{

    firstClickButton.selected = NO;
    sender.selected = YES;
    if (sender.selected) {
        
        //显示输入框
        reasonTextView.alpha = 1;
        messageLabel.alpha = 1;
        self.submitButtonTop.constant = 206;
        
        [firstClickButton setBackgroundImage:[UIImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
    }
    else {

        //隐藏输入框
        reasonTextView.alpha = 0;
        messageLabel.alpha = 0;
        self.submitButtonTop.constant = 60;
    }
}

#pragma mark - 提交
- (void)submitButtonPressed:(UIButton *)sender
{
    //选项1选择或者选项2选择并且文字不为空
    if (firstClickButton.selected == YES || (sencondClickButton.selected == YES && reasonTextView.text.length>0)) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:_dataDic[@"uid"] forKey:@"uid"];
        [dic setValue:_dataDic[@"key"] forKey:@"key"];
        [dic setValue:_dataDic[@"carwashId"] forKey:@"carwashId"];
        [dic setValue:_dataDic[@"uno"] forKey:@"orderNumber"];
        
        if (firstClickButton.selected) {
            
            [dic setValue:@"我还没有到店洗车" forKey:@"desc"];
            
        }
        else {
            [dic setValue:reasonTextView.text forKey:@"desc"];
            
        }
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        
        [ModelTool httpAppGainNotWashWithParameter:dic success:^(id object) {
            
            NSDictionary* dic = object;
            MyLog(@"%@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"] && [object[@"data"][@"msg"] isEqualToString:@"确认成功！"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            });
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
        
    }
    else if(firstClickButton.selected == NO && sencondClickButton.selected == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择情况说明" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if(firstClickButton.selected == NO && (sencondClickButton.selected == YES && reasonTextView.text.length == 0)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写原因" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    messageLabel.alpha = 0;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        messageLabel.alpha = 1;
    }
}

#pragma mark - 获取触摸点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];
    if (touch) {
        [self.view endEditing:YES];
    }
}

@end
