//
//  CWSForgetPswController.m
//  CarDefender
//
//  Created by 李散 on 15/4/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSForgetPswController.h"
#import "CWSForgetSetPswController.h"
#import "HttpHelper.h"

@interface CWSForgetPswController ()<UITextFieldDelegate>
{
    NSTimer*_timer;
    int _minite;
    NSString* _verifyNumber;
    
    NSMutableDictionary*_voiceDic;
}
@end

@implementation CWSForgetPswController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    
    UIBarButtonItem*leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackBarButton:)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    [self buildUI];
}
-(void)goBackBarButton:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建视图
-(void)buildUI
{
    _voiceDic=[NSMutableDictionary dictionary];
    [Utils setViewRiders:self.leftLine riders:2];
    [Utils setViewRiders:self.rightLine riders:2];
    [Utils setViewRiders:self.nextStepBtn riders:4];
    [Utils changeBackBarButtonStyle:self];
    //创建手势-点击空白处收键盘
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture];
    
    if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
        self.phoneNubTextField.text=dic[@"tel"];
    }
    self.cancelPhoneBtn.userInteractionEnabled=NO;
    
}

-(void)Actiondo:(UITapGestureRecognizer*)sender
{
//    [self.view endEditing:YES];
    self.cancelPhoneBtn.userInteractionEnabled=NO;
    self.cancelPhoneImg.hidden=YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)nextStepClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if ([self.codeTextField.text isEqualToString:_verifyNumber]) {
        [HttpHelper confirmVerifyCodeWithUserTel:self.phoneNubTextField.text
                                        smsToken:_verifyNumber
                                         options:MODIFY_PASSWD_CODE
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             NSLog(@"forgot password page,confirm verfify code :%@",responseObject);
                                             NSDictionary *dict = (NSDictionary *)responseObject;
                                             if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                                 CWSForgetSetPswController *setPswVC=[[CWSForgetSetPswController alloc]initWithNibName:@"CWSForgetSetPswController" bundle:nil];
                                                 setPswVC.phoneNubString=self.phoneNubTextField.text;
                                                 [self.navigationController pushViewController:setPswVC animated:YES];
                                             } else {
                                                 [MBProgressHUD showError:@"验证码已过期" toView:self.view];
                                             }
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"confirm verify code error :%@",error);
                                         }];
        
    }else{
        if (self.phoneNubTextField.text.length==11) {
            [self buildMsg:@"验证码输入有误，请重新输入" withCancel:@"确定" withSure:nil];
        }else{
            [self buildMsg:@"手机号码有误，请重新输入" withCancel:@"确定" withSure:nil];
        }
    }
}

- (IBAction)getCodeBtn:(UIButton *)sender {
    //收键盘
    [self.view endEditing:YES];
    
    if (![self.phoneNubTextField.text length]) {
        
        [self buildMsg:@"请输入您的手机号码再获取验证" withCancel:@"取消" withSure:@"确定"];
        return;
    }
    if (![Utils isNumText:self.phoneNubTextField.text]) {
        [self buildMsg:@"手机号码含有非法字符，请重新输入" withCancel:@"取消" withSure:@"确定"];
        
        return;
    }
    if (![Utils isValidateMobile:self.phoneNubTextField.text] || self.phoneNubTextField.text.length!=11) {
        [self buildMsg:@"手机号码输入有误，请重新输入" withCancel:@"取消" withSure:@"确定"];
        
        return;
    }
    
    
    if (self.phoneNubTextField.text.length==11) {
//        [_voiceDic setObject:self.phoneNubTextField.text forKey:@"tel"];
//        [_voiceDic setObject:@"sms" forKey:@"path"];
//        [_voiceDic setObject:@"find_psw" forKey:@"type"];
        
        
        [_voiceDic setObject:self.phoneNubTextField.text forKey:@"called"];
        [_voiceDic setObject:@"1" forKey:@"type"];
        [_voiceDic setObject:@"sms" forKey:@"path"];
        
        //获取验证码
        [self getVoiceHttpMsgWithBtn:sender];
    }else{
        [self buildMsg:@"手机号码有误，请重新输入" withCancel:@"确定" withSure:nil];
    }
}



-(void)getVoiceHttpMsgWithBtn:(UIButton*)sender
{
    self.cancelPhoneBtn.userInteractionEnabled=NO;
    self.cancelPhoneImg.hidden=YES;
    //收键盘
    [self.view endEditing:YES];
    
    sender.userInteractionEnabled=NO;
    [MBProgressHUD showMessag:@"获取中..." toView:self.view];
    
    [HttpHelper getVerifyCodeWithMobileNo:self.phoneNubTextField.text
                                tokenType:@"FINDPWD"
                                 sendType:@"SMS"
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                      NSDictionary *dict = (NSDictionary *)responseObject;
                                      if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          _verifyNumber = [NSString stringWithFormat:@"%@",dict[@"desc"]];
                                          if (_minite>0) {
                                              [_timer invalidate];
                                          }
                                          [self buildCodeMsg];
                                      } else {
                                          [MBProgressHUD showError:@"获取验证码失败" toView:self.view];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.codeBtn.userInteractionEnabled=NO;
                                          self.voiceBtn.userInteractionEnabled=YES;
                                          sender.userInteractionEnabled=YES;
                                      }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [MBProgressHUD showError:@"网络连接错误" toView:self.view];
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                                    [self hideHud];
//                                    sender.userInteractionEnabled=YES;
                                    NSLog(@"forgot password page,get verify code error :%@",error);
                                }];
}
- (IBAction)voiceBtn:(UIButton*)sender
{
    if ([_voiceDic[@"path"] isEqualToString:@"sms"]) {
        [_voiceDic setObject:@"voice" forKey:@"path"];
    }
    [self getVoiceHttpMsgWithBtn:sender];
}
#pragma mark - 点击验证码事件
-(void)buildCodeMsg
{
    self.noGetMsgLabel.hidden=NO;
    self.tryLabel.hidden=NO;
    self.voiceBtn.hidden=NO;
    self.baLabel.hidden=NO;
    _minite=60;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self selector:@selector(timerFireMethod:)
                                          userInfo:nil repeats:YES];
    [_timer fire];
    self.codeBtn.userInteractionEnabled=NO;
    self.codeLabel.text=[NSString stringWithFormat:@"%d秒后重发",_minite];
}
#pragma mark - timer事件
-(void)timerFireMethod:(NSTimer*)sender
{
    self.codeLabel.text=[NSString stringWithFormat:@"%d秒后重发",_minite];
    _minite--;
    if (_minite==0) {
        [sender invalidate];
        _verifyNumber = nil;
        self.codeLabel.text=@"重新获取";
        self.codeBtn.userInteractionEnabled=YES;
        self.voiceBtn.userInteractionEnabled=YES;
        self.codeLabel.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)cancelPhoneClick:(id)sender {
    self.phoneNubTextField.text=@"";
}

- (IBAction)phoneTextChange:(UITextField *)sender {
    if (sender.text.length) {
        self.cancelPhoneBtn.userInteractionEnabled=YES;
        self.cancelPhoneImg.hidden=NO;
        if (sender.text.length>11) {
            sender.text=[sender.text substringWithRange:NSMakeRange(0, 11)];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.phoneNubTextField.text.length) {
        self.cancelPhoneBtn.userInteractionEnabled=YES;
        self.cancelPhoneImg.hidden=NO;
    }
    if ([self.codeTextField isFirstResponder]) {
        self.cancelPhoneBtn.userInteractionEnabled=NO;
        self.cancelPhoneImg.hidden=YES;
    }
}
-(void)buildMsg:(NSString*)message withCancel:(NSString*)cancle withSure:(NSString*)sureString
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:cancle otherButtonTitles:sureString, nil];
    [alert show];
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
