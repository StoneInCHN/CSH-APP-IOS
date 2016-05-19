//
//  CWSForgetSetPswController.m
//  CarDefender
//
//  Created by 李散 on 15/4/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSForgetSetPswController.h"
#import "CWSForgetSetPswSuccessController.h"
#import "SecurityHelper.h"
#import "HBRSAHandler.h"

@interface CWSForgetSetPswController ()<UITextFieldDelegate>
{
    NSMutableDictionary*_bodyDic;
}
@end

@implementation CWSForgetSetPswController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"忘记密码";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.saveBtn riders:4];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)saveClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (!self.firstTextField.text.length) {
        [self buildAlertWithMessage:@"密码长度应该是6-14位!"];
        return;
    }
    if (!self.secondTextField.text.length) {
        [self buildAlertWithMessage:@"确认密码不能为空!"];
        return;
    }
    if (![Utils checkNubOrLetter:self.firstTextField.text]) {
        [self buildAlertWithMessage:@"密码含有非法字符，请重新输入"];
        return;
    }
    if (![Utils checkNubOrLetter:self.secondTextField.text]) {
        [self buildAlertWithMessage:@"确认密码含有非法字符，请重新输入"];
        return;
    }
    if ([self.firstTextField.text isEqualToString:self.secondTextField.text]) {
        [MBProgressHUD showMessag:@"提交中..." toView:self.view];
        
        sender.userInteractionEnabled=NO;
        [SecurityHelper getPublicKeySuccess:^(AFHTTPRequestOperation *operation, NSString *publicKey) {
            
            HBRSAHandler *handler = [HBRSAHandler new];
            [handler importKeyWithType:KeyTypePublic andkeyString:publicKey];
            NSString *passwd = [handler encryptWithPublicKey:self.firstTextField.text];
            [HttpHelper modifyPasswordWithUserName:self.phoneNubString
                                            passwd:passwd
                                     passwdConfirm:passwd
                                           success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                               NSLog(@"modify password :%@",responseObjcet);
                                               [self hideHud];
                                               sender.userInteractionEnabled=YES;
                                               NSDictionary *dict = (NSDictionary *)responseObjcet;
                                               if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                                   [self showHint:@"密码修改成功"];
                                                   CWSForgetSetPswSuccessController*setSuccess=[[CWSForgetSetPswSuccessController alloc]initWithNibName:@"CWSForgetSetPswSuccessController" bundle:nil];
                                                   setSuccess.title=@"忘记密码";
                                                   setSuccess.phoneNubString=self.phoneNubString;
                                                   [self.navigationController pushViewController:setSuccess animated:YES];
                                               } else {
                                                   [self buildAlertWithMessage:dict[@"desc"]];
                                               }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [self hideHud];
                                         sender.userInteractionEnabled=YES;
                                     }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"get public key error :%@",error);
        }];
    }else{
        [self buildAlertWithMessage:@"两次输入密码有误，请重新输入"];
    }
         
         
}
-(void)buildAlertWithMessage:(NSString*)messageString
{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        //收键盘
        [self.view endEditing:YES];
    }
}
@end
