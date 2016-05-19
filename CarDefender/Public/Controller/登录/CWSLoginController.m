//
//  CWSLoginController.m
//  CarDefender
//
//  Created by 李散 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSLoginController.h"

#import "UserNew.h"
#import "UserManager.h"
#import "UserAdvertisementInfo.h"
#import "CWSRegistPhoneNubController.h"
#import "CWSForgetPswController.h"
#import <ShareSDK/ShareSDK.h>

#import "CWSReloginVerifyController.h"

#import <BaiduMapAPI/BMapKit.h>
#import "SecurityHelper.h"
#import "HBRSAHandler.h"
#import "CWSMainViewController.h"

@interface CWSLoginController ()<UITextFieldDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate>
{
    BOOL _isRemenberPassword;
    NSMutableDictionary*_bodyDic;//登录获取的参数
    NSString* tempUID;
    BOOL rememberAccount;
    BOOL loginNotBack;
    BOOL isRegister;
    UIScrollView*_scrollViewBaseView;
    
    NSString* currentUserCid;
     BMKLocationService*      _locService;
}
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *passwdView;

@end

@implementation CWSLoginController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.registSuccessOK isEqualToString:@"回来了"]) {
        self.registSuccessOK = @"";

        [UIView animateWithDuration:0.2 animations:^{
            CGRect registFrame = self.registSuccessView.frame;
            registFrame = CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20);
            [self.registSuccessView setFrame:registFrame];
        }];
    }
    self.navigationController.navigationBarHidden = YES;
    isRegister = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REGISTSUCEESS" object:nil];
}
-(void)httpTest{
    if(!isRegister){
        //判断手机号码是否合法正常
        if (![self judgeTheMobilePhoneNumberIsCorrect:self.telephoneTextField.text]) {
            return;
        }
        //判断密码是否符合规范
        if (![self judgeThePasswordNumberIsCorrect:self.passwordTextField.text]) {
            return;
        }
    }
    [_bodyDic setObject:self.telephoneTextField.text forKey:@"userName"];
    [_bodyDic setObject:self.passwordTextField.text forKey:@"passWord"];
    [_bodyDic setObject:[Utils getPhoneSystemInfo][@"appVersion"] forKey:@"appVersion"];
    [_bodyDic setObject:[Utils getPhoneSystemInfo][@"mobileVersion"] forKey:@"mobileVersion"];
    [_bodyDic setObject:[Utils getPhoneSystemInfo][@"mobileSystem"] forKey:@"mobileSystem"];
    [_bodyDic setObject:[SvUDIDTools UDID] forKey:@"imei"];
    [_bodyDic setObject:@"1" forKey:@"type"];
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    loginNotBack=NO;
    [MBProgressHUD showMessag:@"正在登录..." toView:self.view];
    
    self.loginBtn.userInteractionEnabled=NO;

    
    [SecurityHelper getPublicKeySuccess:^(AFHTTPRequestOperation *operation, NSString *publicKey) {
        
        HBRSAHandler *handler = [HBRSAHandler new];
        [handler importKeyWithType:KeyTypePublic andkeyString:publicKey];
        NSString *passwd = [handler encryptWithPublicKey:self.passwordTextField.text];
        
        [HttpHelper userLoginWithUserName:self.telephoneTextField.text
                                 password:passwd
                              deviceToken:[SvUDIDTools UDID]
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"user login response :%@",responseObject);
                                      NSDictionary *responseDic = (NSDictionary *)responseObject;
                                      if ([[responseDic objectForKey:@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                          
                                          [MBProgressHUD showSuccess:@"登陆成功" toView:self.view];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          
                                          [self saveUserInfo:responseDic];
                                          
                                          UserInfo *userInfo = [UserInfo userDefault];
                                          [userInfo loadDataWithDict:responseDic[@"msg"]];
                                          userInfo.token = responseDic[@"token"];
                                          userInfo.desc = responseDic[@"desc"];
                                          
                                          loginNotBack = YES;
                                          self.loginBtn.userInteractionEnabled = YES;
                                          CWSMainViewController *mainVC = [[CWSMainViewController alloc] init];
                                          [self.navigationController pushViewController:mainVC animated:YES];
                                          
                                      } else {
                                          [MBProgressHUD showError:@"登陆失败" toView:self.view];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.loginBtn.userInteractionEnabled = YES;
                                      }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"登陆失败" toView:self.view];
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  NSLog(@"error :%@",error);
                              }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get public key failed!");
    }];
}
#pragma mark 存储用户信息
- (void)saveUserInfo:(NSDictionary *)dict {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"isLogin"];
    [userDefaults setObject:dict[@"desc"] forKey:@"desc"];
    [userDefaults setObject:dict[@"token"] forKey:@"token"];
    for (NSString *key in [dict[@"msg"] allKeys]) {
        [userDefaults setObject:[PublicUtils checkNSNullWithgetString:[dict[@"msg"] objectForKey:key]] forKey:key];
    }
    [userDefaults synchronize];
    NSLog(@"msg :%@",dict[@"msg"]);
}
#pragma mark - 检测手机号码是否正常
-(BOOL)judgeTheMobilePhoneNumberIsCorrect:(NSString*)mobileNub
{
    //1、检测手机号码是否为空
    if (![mobileNub length]) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    //2、检测手机号码位数
    if (mobileNub.length!=11) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号输入有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //3、检测手机号码是否合法
    if (![Utils isValidateMobile:mobileNub]) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码含有非法字符，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
#pragma mark - 检测密码是否符合规范
-(BOOL)judgeThePasswordNumberIsCorrect:(NSString*)passwordNub
{
    //1、检测密码是否为空
    if (![passwordNub length]) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //2、检测密码是否只是字母和数字组合
    if (![Utils checkNubOrLetter:passwordNub]) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码只能由字母和数字组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //3、检测妈妈长度是否合法
    if (passwordNub.length>15 || passwordNub.length<6) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度应该是6-14位!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}
#pragma mark - 保存用户数据
-(void)setUserMsg:(NSDictionary*)dic{
    NSMutableDictionary* userInfoDict = dic[@"userInfo"];
    NSMutableDictionary* userDefaultVehicle = dic[@"defaultVehicle"];
    NSMutableArray* defaultStoresArray = dic[@"defaultStores"];
    NSMutableArray* advertisementInfoArray = dic[@"advertisementInfo"];
    NSString* baseUrlString = dic[@"baseUrl"];
    for (NSString* key in [userInfoDict allKeys]) {
        if([[userInfoDict valueForKey:key] isKindOfClass:[NSString class]] || [[userInfoDict valueForKey:key] isKindOfClass:[NSNull class]]){
            [userInfoDict setObject:[PublicUtils checkNSNullWithgetString:[userInfoDict valueForKey:key]] forKey:key];
        }
    }
    
    for (NSString* key in [userDefaultVehicle allKeys]) {
        if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSDictionary class]]){
            for (NSString* subKey in [[userDefaultVehicle valueForKey:key] allKeys]) {
                if([[[userDefaultVehicle valueForKey:key] valueForKey:subKey] isKindOfClass:[NSNull class]]){
                    [[userDefaultVehicle valueForKey:key] setObject:[PublicUtils checkNSNullWithgetString:[[userDefaultVehicle valueForKey:key] valueForKey:subKey]] forKey:subKey];
                }
            }
        }else{
            if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSNull class]]){
                [userDefaultVehicle setObject:[PublicUtils checkNSNullWithgetString:[userDefaultVehicle valueForKey:key]] forKey:key];
            }
        }
    }
    
    for (NSMutableDictionary* dict in [defaultStoresArray firstObject][@"commodity"]) {
        for (NSString* key in [dict allKeys]) {
            if([[dict valueForKey:key] isKindOfClass:[NSNull class]]){
                [dict setObject:[PublicUtils checkNSNullWithgetString:[dict valueForKey:key]] forKey:key];
            }
        }
    }
    
   
    MyLog(@"-------用户信息字典------->%@",userInfoDict);
    MyLog(@"-------用户默认车辆字典---->%@",userDefaultVehicle);
    MyLog(@"-------默认商店数组------->%@",defaultStoresArray);
    MyLog(@"-------广告信息数组------->%@",advertisementInfoArray);
    
    [userInfoDict setValue:userDefaultVehicle[@"id"] forKey:@"cid"];
    NSMutableDictionary* dicMsg = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];

    if(userDefaultVehicle.count){

        [dicMsg setObject:userDefaultVehicle forKey:@"defaultVehicle"];
    }
    [dicMsg setObject:defaultStoresArray forKey:@"defaultStores"];
    [dicMsg setObject:advertisementInfoArray forKey:@"advertisementInfo"];
    [dicMsg setObject:baseUrlString forKey:@"baseUrl"];
    MyLog(@"----------------------->%@",dicMsg);
    
#if USENEWVERSION
    NSUserDefaults* user=[[NSUserDefaults alloc]init];
    [user setObject:userInfoDict forKey:@"user"];  //这是user信息没有baseUrl
    [user setValue:baseUrlString forKey:@"baseUrl"];
    if(userDefaultVehicle.count){
        [user setValue:userDefaultVehicle[@"id"] forKey:@"cid"];
        [user setObject:userDefaultVehicle forKey:@"userDefaultVehicle"];
    }else{
        [user setValue:[NSString stringWithFormat:@""] forKey:@"cid"];
        [user setObject:[NSDictionary dictionary] forKey:@"userDefaultVehicle"];
    }

    [user setObject:defaultStoresArray forKey:@"defaultStores"];
    [user setObject:advertisementInfoArray forKey:@"advertisementInfo"];
    [NSUserDefaults resetStandardUserDefaults];
    
    
#else
    NSDictionary*dic1=dicMsg[@"car"];
    NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
    [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
    [dicMsg setObject:carMsgDic forKey:@"car"];
    NSUserDefaults* user=[[NSUserDefaults alloc]init];
    [user setObject:dicMsg forKey:@"user"];
    [NSUserDefaults resetStandardUserDefaults];
#endif
    
    
    
    UserNew* lUser = [[UserNew alloc] initWithDic:dicMsg];
    KUserManager = lUser;
}
#pragma mark - 环信登录
-(void)loginWithEaseMsgWithDic:(NSDictionary*)dic
{
    //设置推送设置
    [[EaseMob sharedInstance].chatManager setApnsNickname:dic[@"nick"]];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:dic[@"no"] password:@"888888" completion:^(NSDictionary *loginInfo, EMError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        loginNotBack=YES;
        self.loginBtn.userInteractionEnabled=YES;
        if (loginInfo && !error) {
            [self setUserMsg:dic];
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];//设置不自动登录
            [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    [self getdata];
    loginNotBack=YES;
    
    self.phoneView.alpha = 0.8;
    self.phoneView.layer.borderWidth = 1.0;
    self.phoneView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.passwdView.alpha = 0.8;
    self.passwdView.layer.borderWidth = 1.0;
    self.passwdView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
//    //密码修改成功替换账号
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadPswBack:) name:@"uploadPsw" object:nil];
//    //注册成功
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registSuccessToLogin:) name:@"REGIST_SUCCESS" object:nil];
}
//-(void)registSuccessToLogin:(NSNotification*)sender
//{
//    if (KUserManager.uid!=nil) {//注册成功
//        UIView*viewRegist = sender.object;
//        CGRect viewRegistFrame= viewRegist.frame;
//        viewRegistFrame = CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20);
//        [self.registSuccessView setFrame:viewRegistFrame];
//        [self.view addSubview:viewRegist];
//        [self.view bringSubviewToFront:viewRegist];
//
//        CGRect registFrame = self.registSuccessView.frame;
//        registFrame = CGRectMake(kSizeOfScreen.width, 0, kSizeOfScreen.width, kSizeOfScreen.height+20);
//        [self.registSuccessView setFrame:registFrame];
//        [self.view addSubview:self.registSuccessView];
//        [self.view bringSubviewToFront:self.registSuccessView];
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect registFrame = self.registSuccessView.frame;
//            registFrame = CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20);
//            [self.registSuccessView setFrame:registFrame];
//        }];
//    }
//}
-(void)buildUI
{
    [Utils changeBackBarButtonStyle:self];
    self.title=@"登录";
    [Utils setViewRiders:self.bangdingBtn riders:4];
    [Utils setViewRiders:self.walkBtn riders:4];

    [Utils setViewRiders:self.loginBtn riders:4];
    [Utils setViewRiders:self.registBtn riders:10];
    [Utils setBianKuang:[UIColor whiteColor] Wide:1 view:self.registBtn];
    
    
    self.registBtn.titleLabel.textColor=[UIColor whiteColor];
    
    self.telephoneTextField.delegate=self;
    self.passwordTextField.delegate=self;
    
    
    _scrollViewBaseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20)];
    [self.view addSubview:_scrollViewBaseView];
    _scrollViewBaseView.bounces=NO;
    _scrollViewBaseView.contentSize=CGSizeMake(kSizeOfScreen.width, kSizeOfScreen.height+20);
    CGRect baseFrame=self.baseView.frame;
    baseFrame.size=CGSizeMake(kSizeOfScreen.width, kSizeOfScreen.height+20);
    baseFrame.origin=CGPointMake(0, 0);
    self.baseView.frame=baseFrame;
    [_scrollViewBaseView addSubview:self.baseView];
    
    [self.telephoneTextField addTarget:self action:@selector(telephoneEditingChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)telephoneEditingChange:(UITextField*)sender
{
    if (sender.text.length>11) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 11)];
    }
}
-(void)getdata
{
    rememberAccount=YES;
   // NSArray*array = [Utils getModelOrAppMsg];
    _bodyDic=[NSMutableDictionary dictionary];
//    [_bodyDic setObject:array[0] forKey:@"system"];
//    [_bodyDic setObject:array[1] forKey:@"phone"];
//    [_bodyDic setObject:array[2] forKey:@"app"];
//    [_bodyDic setObject:[Utils deviceTokenBack] forKey:@"imei"];
    [self.passwordTextField setSecureTextEntry:YES];
    _isRemenberPassword = YES;
    
    if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
        
        self.telephoneTextField.text=dic[@"tel"];
        self.passwordTextField.text=dic[@"psw"];
//        [_bodyDic setObject:self.telephoneTextField.text forKey:@"tel"];
//        [_bodyDic setObject:self.passwordTextField.text forKey:@"psw"];
    }
}
#pragma mark - 修改密码成功返回修改手机号码
//-(void)uploadPswBack:(NSNotification*)sender
//{
//    self.telephoneTextField.text=sender.object;
//    self.passwordTextField.text=@"";
//    [_bodyDic setObject:self.telephoneTextField.text forKey:@"tel"];
//    [_bodyDic setObject:@"" forKey:@"psw"];
//}

#pragma mark - textField代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //移动scrollview  让界面可以滑动
    CGRect scrollFrame=_scrollViewBaseView.frame;
    scrollFrame=CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20-214);
    _scrollViewBaseView.frame=scrollFrame;
    
    if (textField.tag==11) {
        if (kSizeOfScreen.height<500) {
            CGRect frameView=self.view.frame;
            frameView.origin.y=-kDockHeight;
            self.view.frame=frameView;
        }
    }
    if ([self.telephoneTextField isFirstResponder]) {
        if (self.telephoneTextField.text.length) {
            self.cancelPhoneImgView.hidden=NO;
        }
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==11){//密码框
        if (kSizeOfScreen.height<500) {
            CGRect frameView=self.view.frame;
            frameView.origin.y=64;
            self.view.frame=frameView;
        }
    }else{
        
        self.cancelPhoneImgView.hidden=YES;
    }
    CGRect scrollFrame=_scrollViewBaseView.frame;
    scrollFrame=CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20);
    _scrollViewBaseView.frame=scrollFrame;
}
#pragma mark - 三方登录（暂时没用）
- (IBAction)thirdLogin:(UIButton *)sender
{
    ShareType type = 0;
    if (sender.tag==80) {//QQ
        type = ShareTypeQQSpace;
    }else if (sender.tag==81){//sinawb
        type = ShareTypeSinaWeibo;
    }
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权登陆成功，已获取用户信息");
            NSString *uid = [userInfo uid];
            NSString *nickname = [userInfo nickname];
            NSString *profileImage = [userInfo profileImage];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code4App" message:[NSString stringWithFormat:@"授权登陆成功,用户ID:%@,昵称:%@,头像:%@",uid,nickname,profileImage] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"source:%@",[userInfo sourceData]);
            NSLog(@"uid:%@",[userInfo uid]);
        }else{
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Code4App" message:@"授权失败，请看日记错误描述" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
#pragma mark - 登录按钮触发事件
- (IBAction)loginClick {
    [self.view endEditing:YES];
    [LHPShaheObject saveAccountMsgWithName:kAccountMsg andWithMsg:@{@"tel":self.telephoneTextField.text,@"psw":self.passwordTextField.text,@"remember":[NSString stringWithFormat:@"%d",1]}];
    [self httpTest];
}
#pragma mark - 注册按钮触发事件
- (IBAction)registerClick {
    CWSRegistPhoneNubController* lController = [[CWSRegistPhoneNubController alloc] initWithNibName:@"CWSRegistPhoneNubController" bundle:nil];
    lController.title=@"注册账户";
    isRegister = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:@"REGISTSUCEESS" object:nil];
//    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:lController];
//    //左边返回键设置
//    self.navigationItem.backBarButtonItem = ({
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
//        item.tintColor = [UIColor lightGrayColor];
//        item;
//    });
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:lController animated:YES];
}

-(void)registerSuccess:(NSNotification*)sender{
    NSDictionary* thyDict = sender.userInfo;
    self.telephoneTextField.text = thyDict[@"tel"];
    self.passwordTextField.text = thyDict[@"psw"];
    [self httpTest];
}

#pragma mark - 忘记密码
- (IBAction)passworedClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://记住密码按钮
        {
            if (_isRemenberPassword) {
                [self.remenberPasswordBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_click"] forState:UIControlStateNormal];
            }else{
                [self.remenberPasswordBtn setBackgroundImage:[UIImage imageNamed:@"login_icon_onclick"] forState:UIControlStateNormal];
            }
            _isRemenberPassword = !_isRemenberPassword;
        }
            break;
        case 2://忘记密码跳转事件
        {
            CWSForgetPswController*forgetVC=[[CWSForgetPswController alloc]initWithNibName:@"CWSForgetPswController" bundle:nil];
//            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:forgetVC];
            forgetVC.title=@"忘记密码";
//            [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 左上角取消按钮
- (IBAction)cancelClick:(UIButton *)sender {
    if (loginNotBack) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)phoneNubChange:(UITextField *)sender {
    if (sender.text.length) {
        if ([sender isFirstResponder]) {
           
            self.cancelPhoneImgView.hidden=NO;
            return;
        }
    }
    self.cancelPhoneImgView.hidden=YES;
}
- (IBAction)paswordChange:(UITextField *)sender {
    if (sender.text.length>14) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 14)];
    }
}
#pragma mark - 立即绑定
- (IBAction)bangDingClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //跳转到添加车辆界面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REGIST_TO_ADD_CAR" object:nil];
}
#pragma mark - 先逛逛
- (IBAction)walkClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"验证登录"]){
        CWSReloginVerifyController* reloginVerifyVc = [CWSReloginVerifyController new];
        reloginVerifyVc.title = @"验证登录";
        reloginVerifyVc.verifyPhoneNumber = self.telephoneTextField.text;
        reloginVerifyVc.userUID = [NSString stringWithFormat:@"%@",tempUID];
        [reloginVerifyVc setReloginSuccess:^{
            [self httpTest];
        }];
        [self.navigationController pushViewController:reloginVerifyVc animated:YES];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REGISTSUCEESS" object:nil];
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
        //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    KManager.mobileCurrentPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    KManager.mobileCurrentPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
}

@end
