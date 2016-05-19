//
//  CWSUserPersonalSignatureController.m
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSUserPersonalSignatureController.h"

@interface CWSUserPersonalSignatureController ()<UITextViewDelegate>
{
    UserInfo *userInfo;
    NSString* _personalMsg;
}
@end

@implementation CWSUserPersonalSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的签名";
    [Utils changeBackBarButtonStyle:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.personalTextView becomeFirstResponder];
    self.personalTextView.delegate=self;
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(inputComplate:)];
    rightBtn.tintColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem=rightBtn;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
        self.textNubLabel.hidden = YES;
    }
    
    userInfo = [UserInfo userDefault];
    
    if ([Helper isStringEmpty:userInfo.signature]) {
        _personalMsg = @" ";
        self.personalTextView.text = @" ";
        self.textNubLabel.text = @"0/40";
    } else {
        _personalMsg = userInfo.signature;
        self.personalTextView.text = userInfo.signature;
        self.textNubLabel.text = [NSString stringWithFormat:@"%ld/40",(long)userInfo.signature.length];
    }
    if (self.noteString.length) {
        self.personalTextView.text=self.noteString;
    }
}

-(void)inputComplate:(UIBarButtonItem*)sender
{
    if ([Utils isContainsEmoji:_personalMsg]) {//含有
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的内容含有不能识别的字符，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }else{//不含有
        [[NSNotificationCenter defaultCenter]postNotificationName:@"personalMsgInputComplate" object:_personalMsg];
        [self.personalTextView resignFirstResponder];
        
        [MBProgressHUD showMessag:@"保存中..." toView:self.view];
        [HttpHelper changeUserInfoWithUserId:userInfo.desc
                                       token:userInfo.token
                                    nickName:userInfo.nickName
                                        sign:self.personalTextView.text
                                     success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         NSDictionary *dict = (NSDictionary *)responseObjcet;
                                         if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                             [self.navigationController popViewControllerAnimated:YES];
                                             userInfo.signature = dict[@"msg"][@"signature"];
                                         } else {
                                             [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求有问题,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                         [alert show];
                                     }];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        NSInteger number = [textView.text length];
        if (number > 40) {
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于126" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //        [alert show];
            //        CGFloat hight = self.textNubLabel.frame.origin.y + self.textNubLabel.frame.size.height + 10;
            //        [self showHint:@"字符个数不能大于126" yOffset:hight];
            textView.text = [textView.text substringToIndex:40];
            number = 40;
        }
        self.textNubLabel.text = [NSString stringWithFormat:@"%ld/40",(long)number];
        _personalMsg=textView.text;
    }
}


@end
