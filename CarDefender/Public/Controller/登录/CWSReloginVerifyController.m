//
//  CWSRegistPhoneNubController.m
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSReloginVerifyController.h"
#import "CWSRegistPassWordController.h"
#import "CWSServeTermsController.h"
@interface CWSReloginVerifyController ()<UITextFieldDelegate>
{
    NSTimer*_timer;//计时器
    int _minite;//验证码倒计时
    NSString* _verifyNumber;//验证码
    BOOL _agree;//注册协议判断
    
    BOOL _isNextPage; //是否到下一步
    
    NSMutableDictionary*_voiceDic;
    
    NSString* thyUID;
}
@end

@implementation CWSReloginVerifyController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    _textField.text = self.verifyPhoneNumber;
    _textField.enabled = NO;
    thyUID = _userUID;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    _isNextPage = YES;
    [ModelTool stopAllOperation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _agree = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.agreeBtn.selected = NO;
    [Utils setViewRiders:self.nextTypeBtn riders:4];
    
    self.textField.delegate=self;
    self.dic = [NSMutableDictionary dictionary];
    _voiceDic=[NSMutableDictionary dictionary];
    UIBarButtonItem*leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackBarButton:)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}
-(void)goBackBarButton:(UIBarButtonItem*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)nextTypeClick:(UIButton *)sender {
    [self.view endEditing:YES];

//    if (self.agreeBtn.selected) {
//        [self buildAlertWithMessage:@"您还未阅读《服务条款》"];
//        return;
//    }
    
    if (![self.textField.text length]) {
        [self buildAlertWithMessage:@"手机号码不能为空"];
        return;
    }
    if (![Utils isNumText:self.textField.text]) {
        [self buildAlertWithMessage:@"手机号码含有非法字符，请重新输入"];
        return;
    }
    if (![Utils isValidateMobile:self.textField.text] || self.textField.text.length!=11) {
        [self buildAlertWithMessage:@"请输入正确的手机号码"];
        return;
    }
    
    if (self.textField.text.length==11) {
        if ([self.verifyNumberTextField.text isEqualToString:_verifyNumber]) {
            [self.dic setObject:thyUID forKey:@"uid"];
            [self.dic setObject:@"2" forKey:@"type"];
            [self.dic setObject:[SvUDIDTools UDID] forKey:@"imei"];
        
            MyLog(@"-----------------挤登录信息%@",self.dic);
            [MBProgressHUD showMessag:@"正在登录..." toView:self.view];
            
            [HttpTool postExceptionLoginWithHttpBody:self.dic andSuccess:^(NSDictionary *data) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary* rootDict = [[NSDictionary alloc] initWithDictionary:data];
                    MyLog(@"---------登录信息---------%@",rootDict);
                    if([rootDict[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                        self.reloginSuccess();

                    }else{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[PublicUtils showServiceReturnMessage:rootDict[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                });

                
            } andFail:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [WCAlertView showAlertWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",err] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            }];
            
            
        }else{
            [self buildAlertWithMessage:@"验证码输入有误,请重新输入"];
        }
    }else{
        [self buildAlertWithMessage:@"请输入您的手机号码再获取验证"];
    }
}
- (IBAction)getVerifyNumber:(UIButton *)sender {
    
    if (![self.textField.text length]) {
        [self buildAlertWithMessage:@"请输入您的手机号码再获取验证"];
        return;
    }
    if (![Utils isNumText:self.textField.text]) {
        [self buildAlertWithMessage:@"手机号码含有非法字符，请重新输入"];
        return;
    }
    if (![Utils isValidateMobile:self.textField.text] || self.textField.text.length!=11) {
        [self buildAlertWithMessage:@"手机号码输入有误，请重新输入"];
        return;
    }
    [_voiceDic setObject:self.textField.text forKey:@"called"];
    [_voiceDic setObject:@"2" forKey:@"type"];
    [_voiceDic setObject:@"sms" forKey:@"path"];
    
    [self getVoiceHttpMsgWithBtn:sender];
}
-(void)getVoiceHttpMsgWithBtn:(UIButton*)sender
{
    sender.userInteractionEnabled=NO;
    
    [MBProgressHUD showMessag:@"获取中..." toView:self.view];
#if USENEWVERSION
    [HttpTool postVerifyWithHttpBody:_voiceDic success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary* dict = [[NSDictionary alloc] initWithDictionary:data];
            MyLog(@"%@",dict);
            if ([dict[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                if ([_voiceDic[@"path"] isEqualToString:@"voice"]) {
                    self.voiceBtn.userInteractionEnabled=NO;
                    self.getCodeBtn.userInteractionEnabled=NO;
                }else{
                    self.getCodeBtn.userInteractionEnabled=NO;
                    self.voiceBtn.userInteractionEnabled=YES;
                }
                _verifyNumber = [NSString stringWithFormat:@"%@",dict[@"data"][@"code"]];
                if (_minite>0) {
                    [_timer invalidate];
                }
                [self buildCodeMsg];
            }else{
                [self buildAlertWithMessage:dict[@"message"]];
                sender.userInteractionEnabled=YES;
            }
        });
    } fail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        sender.userInteractionEnabled=YES;
    }];
    
#else
    [ModelTool httpGetAppGetVdCodeWithParameter:_voiceDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            NSDictionary* dic = object;
            MyLog(@"%@",dic);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if ([_voiceDic[@"path"] isEqualToString:@"voice"]) {
                    self.voiceBtn.userInteractionEnabled=NO;
                    self.getCodeBtn.userInteractionEnabled=NO;
                }else{
                    self.getCodeBtn.userInteractionEnabled=NO;
                    self.voiceBtn.userInteractionEnabled=YES;
                }
                _verifyNumber = [NSString stringWithFormat:@"%@",dic[@"data"][@"code"]];
                if (_minite>0) {
                    [_timer invalidate];
                }
                [self buildCodeMsg];
            }else{
                [self buildAlertWithMessage:object[@"data"][@"msg"]];
                sender.userInteractionEnabled=YES;
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
        sender.userInteractionEnabled=YES;
    }];
#endif
}
#pragma mark - 点击验证码事件
-(void)buildCodeMsg
{
    [self.textField resignFirstResponder];
    [self.verifyNumberTextField resignFirstResponder];
    
    self.noGetMsgLabel.hidden=NO;
    self.tryLabel.hidden=NO;
    self.voiceBtn.hidden=NO;
    self.baLabel.hidden=NO;
    _minite=60;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self selector:@selector(timerFireMethod:)
                                          userInfo:nil repeats:YES];
    [_timer fire];
    self.getCodeBtn.userInteractionEnabled=NO;
    [self.getCodeBtn setTitleColor:KBlackMainColor forState:UIControlStateNormal];
    self.getCodeLabel.text=[NSString stringWithFormat:@"%d秒后重发",_minite];
}
#pragma mark - timer事件
-(void)timerFireMethod:(NSTimer*)sender
{
    self.getCodeLabel.text=[NSString stringWithFormat:@"%d秒后重发",_minite];
    _minite--;
    if (_minite==0) {
        [sender invalidate];
        _verifyNumber = nil;
        if(!_isNextPage){
            [self buildAlertWithMessage:@"您的验证已超过1分钟，请重新获取验证码"];
        }
        self.getCodeLabel.text=@"重新获取";
        self.getCodeBtn.userInteractionEnabled=YES;
        self.voiceBtn.userInteractionEnabled=YES;
    }
}
- (IBAction)teleChange:(UITextField *)sender {
    if (sender.text.length>11) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 11)];
    }
}
//获取语音验证码
- (IBAction)voiceBtn:(UIButton*)sender {
    if ([_voiceDic[@"path"] isEqualToString:@"sms"]) {
        [_voiceDic setObject:@"voice" forKey:@"path"];
    }
    [self getVoiceHttpMsgWithBtn:sender];
}

- (IBAction)agreeBtnClick {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

- (IBAction)tiaoKuanBtnClick {
    CWSServeTermsController* lController = [[CWSServeTermsController alloc] init];
    lController.title = @"车生活用户协议";
    [self.navigationController pushViewController:lController animated:YES];
}
-(void)buildAlertWithMessage:(NSString*)messageString
{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
