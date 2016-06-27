//
//  CWSRegistPassWordController.m
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSRegistPassWordController.h"
#import "SecurityHelper.h"
#import "HBRSAHandler.h"

@interface CWSRegistPassWordController ()<UITextFieldDelegate>
{
    BOOL yanBool;
}

@end

@implementation CWSRegistPassWordController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.nextTypeBtn riders:4];
    self.textField.delegate = self;
    self.againPasswdField.delegate = self;
    self.cancelPhoneBtn.userInteractionEnabled=NO;
    self.cancelPhoneImg.hidden=YES;
    [self.errorImageView setHidden:YES];
    [self.errorMessageLabel setHidden:YES];
    yanBool=NO;
}

- (IBAction)deletePhoneBtnClick:(UIButton *)sender {
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textField.text.length) {
        self.cancelPhoneBtn.userInteractionEnabled=YES;
        self.cancelPhoneImg.hidden=NO;
    }
    else {
        self.cancelPhoneBtn.userInteractionEnabled=NO;
        self.cancelPhoneImg.hidden=YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textField) {
        if (self.textField.text.length>5) {
            if (self.textField.text.length>14) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度应该是6-14位!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            else if (![Utils checkNubOrLetter:self.textField.text]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码含有非法字符，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            else {
                self.cancelPhoneBtn.userInteractionEnabled=NO;
                self.cancelPhoneImg.hidden=YES;
            }
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码至少为6位或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    else if (textField == self.againPasswdField) {
        if ([self.againPasswdField.text isEqualToString:self.textField.text]) {
            [self.errorImageView setHidden:YES];
            [self.errorMessageLabel setHidden:YES];
            [self.view endEditing:YES];
        }
        else {
            [self.errorImageView setHidden:NO];
            [self.errorMessageLabel setHidden:NO];
        }
    }
}


- (IBAction)nextTypeClick:(UIButton *)sender {
    if ([self.againPasswdField.text isEqualToString:self.textField.text]) {
        
        [MBProgressHUD showMessag:@"注册中..." toView:self.view];
       
        NSString *userName = [self.dic objectForKey:@"userName"];
        //注册第二步，输入密码
        [SecurityHelper getPublicKeySuccess:^(AFHTTPRequestOperation *operation, NSString *publicKey) {
            
            HBRSAHandler *handler = [HBRSAHandler new];
            [handler importKeyWithType:KeyTypePublic andkeyString:publicKey];
            NSString *passwd = [handler encryptWithPublicKey:self.textField.text];
            
            [HttpHelper registerWithUserName:userName
                                    password:passwd
                               passwdConfirm:passwd
                                      sucess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSDictionary *dict = (NSDictionary *)responseObject;
                                          NSLog(@"register :%@",responseObject);
                                          if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                              [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                              NSDictionary* succesDict = @{@"tel":self.dic[@"userName"],@"psw":self.textField.text};
                                              NSNotification* registSuccessNote = [NSNotification notificationWithName:@"REGISTSUCEESS" object:nil userInfo:succesDict];
                                              [[NSNotificationCenter defaultCenter]postNotification:registSuccessNote];

                                          } else {
                                              [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [MBProgressHUD showError:@"注册失败" toView:self.view];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          NSLog(@"register error :%@",error);
                                      }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络错误" toView:self.view];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"register error :%@",error);
        }];
        
    } else {
        [self.errorImageView setHidden:NO];
        [self.errorMessageLabel setHidden:NO];
    }
}
-(void)loginWithEaseMsgWithDic:(NSDictionary*)dic
{
    //设置推送设置
    [[EaseMob sharedInstance].chatManager setApnsNickname:dic[@"nick"]];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:dic[@"no"] password:@"888888" completion:^(NSDictionary *loginInfo, EMError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (loginInfo && !error) {
            [self setUserMsg:dic];
            [LHPShaheObject saveAccountMsgWithName:kAccountMsg andWithMsg:@{@"tel":self.dic[@"tel"],@"psw":self.dic[@"psw"],@"remember":[NSString stringWithFormat:@"%d",1]}];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"REGIST_SUCCESS" object:self.view];
            [self dismissViewControllerAnimated:NO completion:nil];
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];//设置不自动登录
            //将旧版的coredata数据导入新的数据库
            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
            [alert show];
            
        }
    } onQueue:nil];
}
-(void)setUserMsg:(NSDictionary*)dic
{
    NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:dic];
    NSDictionary*dic1=dicMsg[@"car"];
    NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
    [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
    [dicMsg setObject:carMsgDic forKey:@"car"];
    UserNew* lUser = [[UserNew alloc] initWithDic:dic];
    KUserManager = lUser;
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:dicMsg forKey:@"user"];
    [NSUserDefaults resetStandardUserDefaults];
}

- (IBAction)pswChange:(UITextField *)sender {
    if (sender.text.length>15) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 14)];
    }
}


@end

