//
//  CWSUserMsgSettingController.m
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSUserMsgSettingController.h"
#import "CWSUserSetAgeController.h"
#import "CWSUserChooseCityController.h"
#import "CWSUserPersonalSignatureController.h"
#import "CWSUserInformationController.h"
#import "CWSUserCenterObject.h"
@interface CWSUserMsgSettingController ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>//,UIImagePickerControllerDelegate
{
    NSString*sexString;
    NSMutableDictionary*_bodyDic;
    UIButton*backBtn;
    int nickLenght;
    NSString*nickString;
    
    BOOL _touchDown;
}
@end

@implementation CWSUserMsgSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    _touchDown=NO;
    [Utils changeBackBarButtonStyle:self];
    CGRect groundFrame=self.groundView.frame;
    groundFrame.origin.y=kTO_TOP_DISTANCE;
    self.groundView.frame=groundFrame;
    
    _bodyDic=[NSMutableDictionary dictionary];
    self.nickNameText.delegate = self;
    self.emileTextField.delegate = self;
    sexString=@"0";
    nickLenght=0;
    [_bodyDic setObject:sexString forKey:@"sex"];
    [_bodyDic setObject:KUserManager.uid forKey:@"uid"];
    [_bodyDic setObject:KUserManager.key forKey:@"key"];
    [Utils setViewRiders:self.boyView riders:4];
    [Utils setViewRiders:self.girlView riders:4];

    
    [Utils setViewRiders:self.boyBackView riders:9];
    [Utils setViewRiders:self.girlbackView riders:9];
    [Utils setBianKuang:kMainColor Wide:1 view:self.boyBackView];
    [Utils setBianKuang:kMainColor Wide:1 view:self.girlbackView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseCityBack:) name:@"chooseCityMsgBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseAgeMsgBack:) name:@"chooseAgeMsgBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personalMsgInputComplate:) name:@"personalMsgInputComplate" object:nil];
    
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnEvent:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [self.cityBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    [self.ageBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    
    //编辑用户数据
    [self editUserMsg];
}



#pragma mark - 编辑用户数据
-(void)editUserMsg
{
    //编辑填充数据
    if (self.userCenter) {
        //昵称
        self.nickNameText.text=KUserManager.nick;
        [_bodyDic setObject:[KUserManager.nick stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"nick"];
        
        //性别
        sexString=[NSString stringWithFormat:@"%@",self.userCenter.sex];
        if ([sexString isEqualToString:@"1"]) {
            self.boyView.backgroundColor=kMainColor;
            self.girlView.backgroundColor=[UIColor whiteColor];
        }else if ([sexString isEqualToString:@"2"]){
            self.girlView.backgroundColor=kMainColor;
            self.boyView.backgroundColor=[UIColor whiteColor];
        }
        [_bodyDic setObject:self.userCenter.sex forKey:@"sex"];
        //年龄
        NSString*stringAge=[NSString stringWithFormat:@"%@",self.userCenter.age];
        if (![stringAge isEqualToString:@"0"]) {
            self.ageLabel.text=stringAge;
            [_bodyDic setObject:[self.userCenter.birth stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"birth"];
            [_bodyDic setObject:[NSString stringWithFormat:@"%@",self.userCenter.age] forKey:@"age"];
        }
        //城市
        self.cityLabel.text=self.userCenter.city;
        [_bodyDic setObject:self.userCenter.cityId forKey:@"city"];
        
        //邮箱
        self.emileTextField.text=self.userCenter.email;
        [_bodyDic setObject:[self.userCenter.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect frame = self.groundView.frame;
    frame.origin.y = kTO_TOP_DISTANCE;
    self.groundView.frame = frame;
    
    if ([self.chooseMsgBack isEqualToString:@"回来了"]) {
        self.chooseMsgBack = @"";
        self.cityLabel.text=[NSString stringWithFormat:@"%@",self.cityMsgBack[1][@"name"]];
        [_bodyDic setObject:self.cityMsgBack[1][@"cid"] forKey:@"city"];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (backBtn==nil) {
        backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 90, kDockHeight)];
        backBtn.backgroundColor=[UIColor clearColor];
        [backBtn addTarget:self action:@selector(backEventRebuild:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.view addSubview:backBtn];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [backBtn removeFromSuperview];
    [ModelTool stopAllOperation];
}
-(void)backEventRebuild:(UIButton*)sender
{
    if (!_touchDown) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃编辑个人信息？" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续添加", nil];
        alert.tag=88;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==88) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)rightBtnEvent:(NSNotification*)sender
{
    CGFloat height = -(kSizeOfScreen.height-kTO_TOP_DISTANCE)/2;
    [self.nickNameText resignFirstResponder];
    [self.emileTextField resignFirstResponder];
    if (!self.nickNameText.text.length) {//判断昵称是否填写
        [self showHint:@"昵称不能为空" yOffset:height];
        return;
    }else{
        if (![self isChinesecharacter:self.nickNameText.text]) {//含有
            [self showHint:@"昵称只能含中文,字母,数字" yOffset:height];
            return;
        }else{//不含有
            [_bodyDic setObject:[self.nickNameText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"nick"];
        }
    }
    if (![sexString intValue]) {
        [self showHint:@"请选择您的性别信息" yOffset:height];
        return;
    }
    
    if (!self.ageLabel.text.length) {
        [self showHint:@"年龄不能为空，请选择您的年龄" yOffset:height];
        return;
    }
    
    if (!self.cityLabel.text.length) {
        [self showHint:@"城市不能为空，请选择您的城市" yOffset:height];
        return;
    }
    if (!self.emileTextField.text.length) {
        [_bodyDic setObject:@"" forKey:@"email"];
    }else{
        if (![Utils isValidateEmail:self.emileTextField.text]) {
            [self showHint:@"邮箱格式有误，请重新输入您的邮箱" yOffset:height];
            return;
        }else{
            [_bodyDic setObject:self.emileTextField.text forKey:@"email"];
        }
    }
    [self showHudInView:self.view hint:@"保存中..."];
    [ModelTool httpGetAppUpPersonNewWithParameter:_bodyDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                //刷新数据
                [self getUserMsg];
            }else{
                [self hideHud];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
#pragma mark - 刷新用户数据
-(void)getUserMsg
{
    [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSDictionary*dic=object[@"data"];
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
            [self hideHud];
            [self setUserMsgBack];
        });
    } faile:^(NSError *err) {
        [self hideHud];
        [self setUserMsgBack];
    }];
}
-(void)setUserMsgBack
{
    CWSUserInformationController*userInformationVC = (CWSUserInformationController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    
    [self.navigationController popToViewController:userInformationVC animated:YES];
}
#pragma mark - 获取城市信息返回数据
-(void)chooseCityBack:(NSNotification*)sender
{
    self.cityLabel.text=[NSString stringWithFormat:@"%@",sender.object[1][@"name"]];
    [_bodyDic setObject:sender.object[1][@"cid"] forKey:@"city"];

}
#pragma mark - 选择年龄返回
-(void)chooseAgeMsgBack:(NSNotification*)sender
{
    self.ageLabel.text=sender.object[@"age"];
    [_bodyDic setObject:sender.object[@"age"] forKey:@"age"];
    [_bodyDic setObject:[sender.object[@"birthday"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"birth"];
}
#pragma mark - 个性签名数据
-(void)personalMsgInputComplate:(NSNotification*)sender
{
    self.personalSignText.text=sender.object;
    [_bodyDic setObject:[sender.object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"note"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nickNameText resignFirstResponder];
    [self.emileTextField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.groundView.frame;
        frame.origin.y = kTO_TOP_DISTANCE;
        self.groundView.frame = frame;
    }];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _touchDown=YES;
    if (textField == self.emileTextField) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.groundView.frame;
            frame.origin.y = - 120+kTO_TOP_DISTANCE;
            self.groundView.frame = frame;
        }];
    }
}
#pragma mark - 选择年龄
- (IBAction)chooseAge:(id)sender {
    _touchDown=YES;
    [self.nickNameText resignFirstResponder];
        [self.emileTextField resignFirstResponder];
    CWSUserSetAgeController*ageVC=[[CWSUserSetAgeController alloc]initWithNibName:@"CWSUserSetAgeController" bundle:nil];
    ageVC.title=@"选择出生日期";
    [self.navigationController pushViewController:ageVC animated:YES];
}
#pragma mark - 选择城市
- (IBAction)chooseCity:(id)sender {
    _touchDown=YES;
    [self.view endEditing:YES];
    CWSUserChooseCityController*cityVC=[[CWSUserChooseCityController alloc]initWithNibName:@"CWSUserChooseCityController" bundle:nil];
    cityVC.title=@"城市选择";
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (IBAction)setSingleSign:(id)sender {
    [self.view endEditing:YES];
    CWSUserPersonalSignatureController*personalVC=[[CWSUserPersonalSignatureController alloc]initWithNibName:@"CWSUserPersonalSignatureController" bundle:nil];
    personalVC.title=@"个人说明";
    [self.navigationController pushViewController:personalVC animated:YES];
}
- (IBAction)sexBtn:(UIButton *)sender {
    _touchDown=YES;
    [self.nickNameText resignFirstResponder];
        [self.emileTextField resignFirstResponder];
    if (sender.tag==21) {//男
        self.boyView.backgroundColor=kMainColor;
        self.girlView.backgroundColor=[UIColor whiteColor];
        sexString=@"1";
    }else if (sender.tag==22){//女
        self.girlView.backgroundColor=kMainColor;
        self.boyView.backgroundColor=[UIColor whiteColor];
        sexString=@"2";
    }
    [_bodyDic setObject:sexString forKey:@"sex"];
}
- (IBAction)saveBtn:(id)sender {
    [self.nickNameText resignFirstResponder];
        [self.emileTextField resignFirstResponder];
    if (!self.nickNameText.text.length) {//判断昵称是否填写
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        [_bodyDic setObject:[self.nickNameText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"nick"];
    }
    [self showHudInView:self.view hint:@"保存中..."];
    [ModelTool httpGetAppUpPersonNewWithParameter:_bodyDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [self setUserMsgBack];
            }else{
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}

- (IBAction)choosePicClick:(UIButton *)sender {
}
- (IBAction)groundControlTouchDown {
    [self.nickNameText resignFirstResponder];
    [self.emileTextField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.groundView.frame;
        frame.origin.y = kTO_TOP_DISTANCE;
        self.groundView.frame = frame;
    }];
}
- (IBAction)nickNameChange:(UITextField *)sender {
    if (!sender.text.length) {
        return;
    }
    int chinese=0;
    int character=0;
    chinese=[self chineseCountOfString:sender.text];
    character=[self characterCountOfString:sender.text];
    if ((chinese+character) == (int)sender.text.length) {
        if ((chinese*2 + character)>15) {
            sender.text=nickString;
        }else{
            nickString=sender.text;
        }
    }
}
-(BOOL)checkNubOrLetter:(NSString*)lStr
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        NSString * regex = @"^[A-Za-z0-9]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [predicate evaluateWithObject:lStr];

        if (isMatch == YES) {
            
            return YES;
        }else{//^[\u4E00-\u9FA5]*$
            NSString * regex = @"^[\u4E00-\u9FA5]*$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [predicate evaluateWithObject:lStr];
            if (isMatch == YES) {
                return YES;
            }else{
                return NO;
            }
        }
    }else{
        return YES;
    }
}
//判断是否为汉字
- (BOOL)isChinesecharacter:(NSString *)string{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        NSString * regex = @"^[A-Za-z0-9\u4e00-\u9fa5]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        if (isMatch) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}
//计算汉字的个数
- (int)chineseCountOfString:(NSString *)string{
    int ChineseCount = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        if (string.length == 0) {
            return 0;
        }
        for (int i = 0; i<string.length; i++) {
            NSRange lRange=NSMakeRange(i, 1);
            NSString *lString=[string substringWithRange:lRange];
            NSString * regex = @"^[\u4e00-\u9fa5]+$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:lString];
            if (isMatch) {
                ChineseCount++ ;//汉字
            }
        }
    }else{
        return YES;
    }
    return ChineseCount;
}
        
        //计算字母的个数
- (int)characterCountOfString:(NSString *)string{
    int characterCount = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        if (string.length == 0) {
            return 0;
        }
        for (int i = 0; i<string.length; i++) {
            NSRange lRange=NSMakeRange(i, 1);
            NSString *lString=[string substringWithRange:lRange];
            NSString * regex = @"^[A-Za-z0-9]+$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:lString];
            if (isMatch) {
                characterCount++ ;//英文
            }
        }
    }else{
        return YES;
    }
    
    return characterCount;
}
@end
