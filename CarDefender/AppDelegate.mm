//
//  AppDelegate.m
//  车卫士
//
//  Created by 周子涵 on 15/3/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "AppDelegate.h"
#import "BNCoreServices.h"
#import "CWSWellcomeController.h"
//环信相关设置
#import "AppDelegate+EaseMob.h"
#import "ApplyViewController.h"
#import "CWSLoginController.h"

#import "LHPSideViewController.h"
#import "CWSMainViewController.h"
#import "CWSLeftController.h"
#import "CWSRightController.h"

#import "UMessage.h"//友盟推送
#import "UMFeedback.h"
#import "UMOpus.h"
#import "CWSFeedbackController.h"

#import "CWSCarManageController.h"
#import "MobClick.h"

#import "CWSGuideViewController.h"

#import "CWSAddCarController.h"


#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

#import <AlipaySDK/AlipaySDK.h>

//APP端签名相关头文件
//#import "payRequsestHandler.h"

#import "WXPay.h"
#import "WQAler.h"

//键盘
#import "IQKeyBoardManager.h"

//极光推送
#import "MyJPushService.h"
#import "JPushNote.h"
#import "UIImageView+WebCache.h"
#import "CWSCheckMessageCenterDetailViewController.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
#define kMoveTime 0.3
//55263830fd98c561c7000293  企业级账号的友盟appKey
//5577d5dc67e58eb24c0029db  上架的友盟推动appKey
//5577fc7867e58e30650052de   云驾appkey
#define kUmengAppKey @"5577d5dc67e58eb24c0029db"

//NSString* MAP_KEY = @"x04Mu9iPtpvHXkuiD14zOt1G";//企业版百度地图KEY
NSString* MAP_KEY = @"tVn5kiTok0runTCOrkOQEgU5ef7C6x1V";//AppStore版百度地图Key

BMKMapManager* _mapManager;

@interface AppDelegate (){

    BOOL isShutdownAlert;  //关闭警报推送
    BOOL isShutdownInformation; //关闭消息推送
    UIView *launchView;
    NSString* forceLogoutString;  //挤登录用语
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString* uuid = [SvUDIDTools UDID];
    NSLog(@"唯一标识：%@",uuid);

    
    [MyJPushService setupWithOption:launchOptions];
    [APService setDebugMode];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    
//    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    MyLog(@"程序未运行");

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //标记当前页面
        NSUserDefaults*user=[[NSUserDefaults alloc]init];
        [user setObject:@"" forKey:@"currentController"];
        [NSUserDefaults resetStandardUserDefaults];
        
        [Utils chargeNetWork];
        [self shareMsg];
        
        
    });
    //键盘处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
  //  [WXApi registerApp:APP_ID withDescription:@"2.0"];
    
    [MyJPushService resetBadge];
    
#pragma mark -  友盟的东东
//    //友盟统计
//    [MobClick startWithAppkey:kUmengAppKey reportPolicy:BATCH channelId:nil];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//version标识
//    [MobClick setAppVersion:version];
//    //友盟信息反馈
//    [UMOpus setAudioEnable:YES];
//    [UMFeedback setAppkey:kUmengAppKey];
//    [UMFeedback setLogEnabled:YES];
//    [[UMFeedback sharedInstance] setFeedbackViewController:[[CWSFeedbackController alloc] initWithNibName:@"CWSFeedbackController" bundle:nil] shouldPush:YES];
//    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
//    {
//        [UMFeedback didReceiveRemoteNotification:notificationDict];
//    }
    //搭建友盟推送环境
   // [self setUMessageJupshMsgWith:launchOptions];
    
#pragma mark - -- -- --- --- -- - - -- -- - -- - -- - --- -- - --- -- -- -- --- - -- - -- -- --
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:MAP_KEY generalDelegate:self];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;

    [_locService startUserLocationService];
    
    //判断
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//app第一次登陆
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        CWSGuideViewController*guideVC=[[CWSGuideViewController alloc]initWithNibName:@"CWSGuideViewController" bundle:nil];
        self.window.rootViewController = guideVC;
    }else{
        NSLog(@"不是第一次启动");
        CWSWellcomeController* lController = [[CWSWellcomeController alloc] init];
        self.window.rootViewController = lController;
    }
    backOrActive=NO;
    
    //判断是否在其他设备上登录
#if USENEWVERSION
    if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
        NSString*remSgtring=dic[@"remember"];
        if ([remSgtring isEqualToString:@"1"]) {//记录密码
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"]];
            [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"baseUrl"] forKey:@"baseUrl"];
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"cid"] != nil){
                
                [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"cid"] forKey:@"cid"];
            }
            
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"userDefaultVehicle"] != nil){
                
                [dic setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"userDefaultVehicle"] forKey:@"defaultVehicle"];
            }
            
            if (dic.count) {
                UserNew* lUser = [[UserNew alloc] initWithDic:dic];
                KUserManager = lUser;
            }else{
                KUserManager = nil;
            }
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            KUserManager = nil;
        }
    }
#else
    [self checkLoginOrNo];
#endif
//    [self easeMobWith:application with:launchOptions];
    [self.window makeKeyAndVisible];
    
    //初始化导航SDK
    [BNCoreServices_Instance initServices:MAP_KEY];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(welcomeComeHere:) name:@"welcomeToRoot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightAddCar:) name:@"rightAddCar" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightAddCarBack:) name:@"addCarBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginToMainController:) name:@"loginToMainController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(otherDeviceLogin) name:@"accountLoginInOterDevice" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutdownAlertButtonClicke:) name:@"shutdownAlertButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutdownInformationButtonClicke:) name:@"shutdownInformationButton" object:nil];
    [self loadAdvertisment];
    return YES;
}
- (void)loadAdvertisment {
    launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    launchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:launchView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.window.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *str = @"http://d.lanrentuku.com/down/png/1512/star-wars-7-png/master-joda.png";
    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"welcome"]];
    [launchView addSubview:imageView];
    [self.window bringSubviewToFront:launchView];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
}
-(void)removeLun {
    [launchView removeFromSuperview];
}

-(void)otherDeviceLogin{
    [self loginOterDeviceNoteWithString:@"您的账号在其他设备上登录过，请重新登录"];
}

-(void)loginOterDeviceNoteWithString:(NSString*)msgString
{
    if ([msgString isEqualToString:@"账号在其他设备上登录,请重新登录"]) {
        KUserManager.uid = nil;
        [self buildMainFrame];
    }
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msgString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
    alert.tag=123;
    [alert show];
}
-(void)shareMsg
{
    [ShareSDK registerApp:@"76d2715ddfa2"];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1320991546"
                               appSecret:@"7eb9feccc58eb096472c8750e6e8fe3b"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx75b0585936937e4a"
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx75b0585936937e4a"
                           appSecret:@"46af7014eba838546bda76315f524503"
                           wechatCls:[WXApi class]];
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"1104523737"
                           appSecret:@"UvGBvu37FtWAM1Qe"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    //    [_mapView updateLocationData:userLocation];
//        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    KManager.mobileCurrentPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    NSString *latitudeString = [NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.latitude];
    NSString *longitudeeString = [NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.longitude];
    if ([latitudeString integerValue] == 0 && [longitudeeString integerValue] == 0) {
        [_locService startUserLocationService];
    }
    
    //    [self getLocationCity];
    
    
    //    MyLog(@"%@",userLocation.title);
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    UserInfo *userInfo = [UserInfo userDefault];
    userInfo.latitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    userInfo.longitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    NSLog(@"application didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    if ([userInfo.latitude integerValue] == 0 && [userInfo.longitude integerValue] == 0) {
        [_locService startUserLocationService];
    }
}


#pragma mark -=================================================PING++ IOS9.0及以上
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    [WXApi handleOpenURL:url delegate:self];
    
    return [ShareSDK handleOpenURL:url wxDelegate:self];


//    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//    return canHandleURL;

}

#pragma mark -=================================================PING++ IOS8.0及以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    if([url.host isEqualToString:@"safepay"]||[url.host isEqualToString:@"platformapi"]){
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSLog(@"result = %@",resultDic);
                                                      }]; }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    [WXApi handleOpenURL:url delegate:self];
    

    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    
//    BOOL canHandleURL  = [Pingpp handleOpenURL:url withCompletion:nil];
//    return canHandleURL;

}

/**微信支付回调*/
-(void)onResp:(BaseResp *)resp{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    WXPay* thyWxPay = [WXPay shareInstance];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                MyLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if(!thyWxPay.isSuccess){
                    thyWxPay.paySucc();
                    thyWxPay.isSuccess = YES;
                }
                break;
                
            default:
                if(resp.errCode == (-2)){
                    strMsg = @"您已取消付款";
                    [WQAler Show:strMsg WithView:[[UIApplication sharedApplication].delegate window] ];
                }else{
                    strMsg = @"支付失败！";
                    [WQAler Show:strMsg WithView:[[UIApplication sharedApplication].delegate window] ];
                }
                
                MyLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

-(void)buildMainFrame
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"isLogin"]) {
        CWSLoginController *loginVC = [[CWSLoginController alloc] init];
        UINavigationController*navMain=[[UINavigationController alloc]initWithRootViewController:loginVC];
        navMain.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [navMain setNavigationBarHidden:YES];
        self.window.rootViewController = navMain;
    } else {
        UserInfo *userInfo = [UserInfo userDefault];
        userInfo.token = [userDefaults objectForKey:@"token"];
        NSLog(@"userInfo.token :%@",userInfo.token);
        userInfo.desc = [userDefaults objectForKey:@"desc"];
        userInfo.nickName = [userDefaults objectForKey:@"nickName"];
        userInfo.signature = [userDefaults objectForKey:@"signature"];
        userInfo.userName = [userDefaults objectForKey:@"userName"];
        userInfo.photo = [userDefaults objectForKey:@"photo"];
        userInfo.defaultVehicle = [userDefaults objectForKey:@"defaultVehicle"];
        userInfo.defaultVehiclePlate = [userDefaults objectForKey:@"defaultVehiclePlate"];
        userInfo.defaultDeviceNo = [userDefaults objectForKey:@"defaultDeviceNo"];
        userInfo.defaultVehicleIcon = [userDefaults objectForKey:@"defaultVehicleIcon"];
        userInfo.defaultVehicleId = [userDefaults objectForKey:@"defaultVehicleId"];
        
        CWSMainViewController *mainVC=[[CWSMainViewController alloc]init];
        UINavigationController*navMain=[[UINavigationController alloc]initWithRootViewController:mainVC];
        navMain.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [navMain setNavigationBarHidden:YES];
        self.window.rootViewController = navMain;
    }
}

-(void)loginToMainController:(NSNotification*)sender
{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
    UserNew* lUser = [[UserNew alloc] initWithDic:dic];
    KUserManager = lUser;
    [self buildMainFrame];
}
#pragma mark - 判断是否在其他设备上登录
-(void)checkLoginOrNo
{
    if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
        NSString*remSgtring=dic[@"remember"];
        if ([remSgtring isEqualToString:@"1"]) {//记录密码
            NSDictionary* dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
            if (dic.count) {
                UserNew* lUser = [[UserNew alloc] initWithDic:dic];
                KUserManager = lUser;
                [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                            NSDictionary*dic=object[@"data"];
                            NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:dic];
                            NSDictionary*dic1=dicMsg[@"car"];
                            NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
                            [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
                            [dicMsg setObject:carMsgDic forKey:@"car"];
                            MyLog(@"aaaaa");
                            UserNew* lUser = [[UserNew alloc] initWithDic:dic];
                            KUserManager = lUser;
                            NSUserDefaults*user=[[NSUserDefaults alloc]init];
                            [user setObject:dicMsg forKey:@"user"];
                            [NSUserDefaults resetStandardUserDefaults];
                            //[self loginWithEaseMsgWithDic:KUserManager.no];
                        }
                    });
                } faile:^(NSError *err) {
                }];
            }else{
                KUserManager = nil;
            }
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            KUserManager = nil;
        }
    }
}
//-(void)loginWithEaseMsgWithDic:(NSString*)dic
//{
//    //设置推送设置
//    [[EaseMob sharedInstance].chatManager setApnsNickname:KUserManager.nick];
//    
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:dic password:@"888888" completion:^(NSDictionary *loginInfo, EMError *error) {
//        if (loginInfo && !error) {
//            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];//设置不自动登录
//            //发送自动登录状态通知
////            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//            //将旧版的coredata数据导入新的数据库
//            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
//            if (!error) {
//                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
//            }
//        }else{
//        }
//    } onQueue:nil];
//}



//-(void)setUMessageJupshMsgWith:(NSDictionary*)launchOptions{
//    [UMessage startWithAppkey:kUmengAppKey launchOptions:launchOptions];
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//    {
//        //register remoteNotification types
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"category1";//这组动作的唯一标示
//        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//        
//    } else{
//        //register remoteNotification types
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
//    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkFinished:)
//                                                 name:UMFBCheckFinishedNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotification:)
//                                                 name:nil
//                                               object:nil];
//#else
//    
//    //register remoteNotification types
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
//    
//#endif
//    //for log
//    [UMessage setLogEnabled:YES];
//}


- (void)receiveNotification:(id)receiveNotification {
    //    NSLog(@"receiveNotification = %@", receiveNotification);
}



- (void)checkFinished:(NSNotification *)notification {
    NSLog(@"class checkFinished = %@", notification);
}

//-(void)easeMobWith:(UIApplication*)application with:(NSDictionary*)launchOptions{
//    
//    _connectionState = eEMConnectionConnected;
//    //登录状态改变通知方法
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginStateChange:)
//                                                 name:KNOTIFICATION_LOGINCHANGE
//                                               object:nil];
//    
//    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
//    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
//    //登陆状态改变
////    [self loginStateChange:nil];
//}

#pragma mark - ------------------------------------极光推送回调---------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString*deviceToken1=[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken1 forKey:@"deviceToken"];
    
    //   [UMessage registerDeviceToken:deviceToken];
   // [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    //    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
    //        if (error != nil) {
    //            NSLog(@"%@", error.localizedDescription);
    //        }
    //    }];
    
    
    /**极光推送DeviceToken*/
    [MyJPushService registerDeviceToken:deviceToken];
    MyLog(@"%@",[NSString stringWithFormat:@"Device Token:%@",deviceToken]);
    NSString *registrationID = [APService registrationID];
    NSLog(@"registration id is %@", registrationID);
    [userDefaults setObject:registrationID forKey:@"regId"];
    [userDefaults synchronize];
}

/**这是7.0以后才有的方法*/
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"收到推送消息回调啦");
    
    [MyJPushService handleRemoteNotification:userInfo completion:completionHandler];
    
    //判断是否是挤登录
    if([userInfo[@"type"] intValue] == 10 && [userInfo[@"cid"] stringValue] == nil){
        forceLogoutString = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]];
        [self forceLogout];
    }else{
        NSMutableArray* userInformationsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"userInformations"]];
        if(!userInformationsArray.count){
            NSMutableArray* tempArray = @[].mutableCopy;
            [tempArray addObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"userInformations"];
        }else{
            [userInformationsArray addObject:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:userInformationsArray forKey:@"userInformations"];
        }
        [NSUserDefaults resetStandardUserDefaults];
    }
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if(application.applicationState == UIApplicationStateActive){
        if([userInfo[@"type"] intValue] != 10 && [userInfo[@"cid"] stringValue] != nil ){
            [WCAlertView showAlertWithTitle:@"消息提示" message:userInfo[@"aps"][@"alert"] customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if(buttonIndex ==1){
                    CWSCheckMessageCenterDetailViewController* messageDetailVc = [[CWSCheckMessageCenterDetailViewController alloc]init];
                    messageDetailVc.messageContent = userInfo[@"aps"][@"alert"];
                    UINavigationController* rootNav = (UINavigationController*)self.window.rootViewController;
                    [rootNav pushViewController:messageDetailVc animated:YES];
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"查看详情", nil];
        }
    }
    MyLog(@"Receive Message2:%@",[self logDic:userInfo]);
    NSString *alert = userInfo[@"aps"][@"alert"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息" message:alert delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{

    NSLog(@"收到推送消息回调啦");
    /**极光推送设置*/
    NSDictionary* aps = [userInfo valueForKey:@"aps"]; //取得APNs标准信息内容
    NSString* content = [aps valueForKey:@"alert"];  //推送显示内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString* sound = [aps valueForKey:@"sound"]; //播放的声音
    
    NSLog(@"推送内容:%@", content);
    
    
    [MyJPushService handleRemoteNotification:userInfo completion:nil];
    MyLog(@"Receive Message:%@",[self logDic:userInfo]);

//    if (KUserManager.uid!=nil) {
//        [ModelTool httpAppGainPushNewWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                MyLog(@"%@",object);
//                NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
//                int totalCount=0;
//                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                    NSArray*messageArray=object[@"data"][@"data"];
//                    int getNub=(int)messageArray.count;
//                    //显示多少条未读
//                    if ([LHPShaheObject checkPathIsOk:namePath]) {
//                        int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
//                        countNub+=getNub;
//                        totalCount=countNub;
//                    }else{
//                        [LHPShaheObject saveUnreadMsgWithName:namePath andCount:getNub];
//                        totalCount=getNub;
//                    }
//                    
//                    //存数据
//                    NSString*pathName=[NSString stringWithFormat:@"%@%@",@"kMessageCenterMsg",KUserManager.uid];
//                    if ([LHPShaheObject checkPathIsOk:pathName]) {
//                        NSMutableArray*arrayMsg=[NSMutableArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:pathName]];
//                        for (int i=(int)(messageArray.count-1); i<messageArray.count; i--) {
//                            [arrayMsg insertObject:messageArray[i] atIndex:0];
//                        }
//                        [LHPShaheObject saveMsgWithName:pathName andWithMsg:arrayMsg];
//                    }else{
//                        [LHPShaheObject saveMsgWithName:pathName andWithMsg:object[@"data"][@"data"]];
//                    }
//                    
//                }else{
//                    totalCount=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
//                }
//                [LHPShaheObject saveUnreadMsgWithName:namePath andCount:totalCount];
//                NSString* dic1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentController"];
//                if ([dic1 isEqualToString:@"CWSMainViewController"]) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTI_UNREAD_NUB" object:nil];
//                }
//            });
//        } faile:^(NSError *err) {
//        }];
//    }
//    
//    NSArray*keyArray=[userInfo allKeys];
//    if ([keyArray containsObject:@"msgType"]) {//警告推送或者解绑推送
//        //推送内容
//        NSString*contentString;
//        [UMessage setAutoAlert:NO];
//        [UMessage didReceiveRemoteNotification:userInfo];
//        
//        if ([userInfo[@"msgType"] isEqualToString:@"1"]) {//警告消息
//            contentString=userInfo[@"aps"][@"alert"];
//            notiDic=[NSDictionary dictionaryWithDictionary:userInfo];
//            if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//应用程序处于前台
//            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告"
//                                                                 message:contentString
//                                                                delegate:self
//                                                       cancelButtonTitle:@"点击查看"
//                                                       otherButtonTitles:@"我知道了",nil];
//                alert.tag=999;
//                [alert show];
//            }
//            
//            if(backOrActive)//应用程序在后台，用户从通知中心点击消息将程序从后台调至前台
//            {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActiveCarTrend" object:nil];
//            }
//            
//        }else if ([userInfo[@"msgType"] isEqualToString:@"0"]){//广播消息
//            
//        }else if ([userInfo[@"msgType"] isEqualToString:@"2"]){//解绑消息
//
//            notiDic=[NSDictionary dictionaryWithDictionary:userInfo];
//            
//            contentString=[NSString stringWithFormat:@"您的爱车%@设备已被解绑，点击查看或致电客服电话400-793-0888了解详情",userInfo[@"msgValue"]];
//            if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//应用程序处于前台
//            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:contentString
//                                                                delegate:self
//                                                       cancelButtonTitle:@"点击查看"
//                                                       otherButtonTitles:@"我知道了",nil];
//                alert.tag=998;
//                [alert show];
//            }
//            if(backOrActive)//应用程序在后台，用户从通知中心点击消息将程序从后台调至前台
//            {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActive" object:nil];
//            }
//        }else if ([userInfo[@"msgType"] isEqualToString:@"3"]){//年检推送
//            NSUserDefaults*user=[[NSUserDefaults alloc]init];
//            NSString*currentVC=[user objectForKey:@"currentController"];
//            MyLog(@"%@",currentVC);
//            if ([currentVC isEqualToString:@"CWSDetectionDetailController"]) {
//            }else if([currentVC isEqualToString:@"CWSDetectionController"]){
//            }else{
//                contentString=userInfo[@"aps"][@"alert"];
//                notiDic=[NSDictionary dictionaryWithDictionary:userInfo];
//                if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//应用程序处于前台
//                {
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告"
//                                                                     message:contentString
//                                                                    delegate:self
//                                                           cancelButtonTitle:@"点击查看"
//                                                           otherButtonTitles:@"我知道了",nil];
//                    alert.tag=997;
//                    [alert show];
//                }
//            }
//            if(backOrActive)//应用程序在后台，用户从通知中心点击消息将程序从后台调至前台
//            {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActiveCarCheck" object:nil];
//            }
//        }
//    }else{//其他的推送消息
//        [UMFeedback didReceiveRemoteNotification:userInfo];
//    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [UMessage sendClickReportForRemoteNotification:notiDic];
//    if (alertView.tag==998) {//解绑消息
//        if (buttonIndex!=1) {
//            NSString* dic1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentController"];
//            if ([dic1 isEqualToString:@"CWSCarManageController"]) {
//                MyLog(@"是在carManager");
//                //当前界面是车辆管理界面
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"currentIsCarManager" object:notiDic];
//            }else{
//                MyLog(@"不在carManager");
//                //当前界面不是车辆管理界面
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActive" object:notiDic];
//            }
//        }
//    }else if (alertView.tag==999){//警告消息
//        if (buttonIndex==0) {
//            NSString* dic1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentController"];
//            if ([dic1 isEqualToString:@"CWSCarTrendsController"]) {
//                //当前界面是动态界面
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"currentIsCarTrend" object:notiDic];
//            }else{
//                //当前界面不是动态界面
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"warningNotiMsg" object:notiDic];
//            }
//        }
//    }else if (alertView.tag==997){//年检消息
//        if (buttonIndex==0) {
//            if ([KManager.currentController isEqualToString:@"CWSDetectionDetailController"]) {
//                //当前界面是检测界面
//            }else if([KManager.currentController isEqualToString:@"CWSDetectionController.h"]){
//            }else{
//                //当前界面不是检测界面
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationStateActiveCarCheck" object:nil];
//            }
//        }
//    }else if (alertView.tag==123){
//        if (buttonIndex==1) {
////            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            CWSMainViewController*mainVC=(CWSMainViewController*)_sideViewController.rootViewController;
//            [mainVC turnToLoginVC];
//        }
//    }
    if (alertView.tag==123){
        if (buttonIndex==1) {
            CWSMainViewController*mainVC=(CWSMainViewController*)_sideViewController.rootViewController;
            [mainVC turnToLoginVC];
        }
    }
}


#pragma mark -=======================================收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [MyJPushService showLocalNotificationAtFront:notification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    UserInfo *userInfo = [UserInfo userDefault];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:@"token"];
    NSLog(@"---applicationDidEnterBackground----save last token :%@",userInfo.token);
    //进入后台
    backOrActive=YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    UserInfo *userInfo = [UserInfo userDefault];
    userInfo.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"---applicationWillEnterForeground----get last token :%@",userInfo.token);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnterForeground" object:nil];
    [self loadAdvertisment];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    backOrActive=NO;
    [application setApplicationIconBadgeNumber:0];
}
#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification{
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];//是否自动登录
    BOOL loginSuccess = [notification.object boolValue];//是否登录成功
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (_cwsMainVC == nil) {
            [self buildMainFrame];
        }else{
        }
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"user"];
        UserNew* lUser = [[UserNew alloc] initWithDic:dic];
        KUserManager = lUser;
        self.window.rootViewController=self.sideViewController;
    }else{//登陆失败加载登陆页面控制器
        _mainController = nil;
        CWSLoginController *loginController = [[CWSLoginController alloc] initWithNibName:@"CWSLoginController" bundle:nil];
    
        //上移动画
        [self.window.rootViewController.view addSubview:loginController.view];
        loginController.view.frame=CGRectMake(0, self.window.bounds.size.height, kSizeOfScreen.width, self.window.bounds.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            loginController.view.frame=CGRectMake(0, 0, kSizeOfScreen.width, self.window.bounds.size.height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIView*view in self.window.rootViewController.view.subviews) {
                [view removeFromSuperview];
            }
            self.window.rootViewController = loginController;
        });
    }
    
}


-(void)rightAddCar:(NSNotification*)sender{
    CWSAddCarController *addCarController = [[CWSAddCarController alloc] initWithNibName:@"CWSAddCarController" bundle:nil];
    addCarController.rightAddCar=@"rightAdd";
    addCarController.title=@"添加车辆";
    UINavigationController*nav = [[UINavigationController alloc] initWithRootViewController:addCarController];
    
    self.window.rootViewController = nav;
}

-(void)rightAddCarBack:(NSNotification*)sender{
    self.window.rootViewController=_sideViewController;
}


-(void)welcomeComeHere:(NSNotification*)sender{
    [self buildMainFrame];
}

#pragma mark - 在打电话等待回拨时 回拨电话进入后台时调用
- (void)applicationWillResignActive:(UIApplication *)application {
    if ([KManager.currentController isEqualToString:@"CWSPhoneWaitController"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"phoneCallConnect" object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        MyLog(@"联网成功");
    }
    else{
        MyLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        MyLog(@"授权成功");
    }
    else {
        MyLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark -=============================消息或警报推送关闭按钮回调
//shutdownAlertButtonClicke
//shutdownInformationButtonClicke:
-(void)shutdownAlertButtonClicke:(NSNotification*)notification{
    isShutdownAlert = !isShutdownAlert;
}

-(void)shutdownInformationButtonClicke:(NSNotification*)notification{
    isShutdownInformation = !isShutdownInformation;
}

#pragma mark -=============================挤挤登录
-(void)forceLogout{
    [HttpTool postLogoutWithHttpBody:@{@"uid":KUserManager.uid} success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([data[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                KUserManager.uid=nil;
                //移除密码
                if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
                    NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
                    NSMutableDictionary*dic1=[NSMutableDictionary dictionaryWithDictionary:dic];
                    [dic1 setObject:@"" forKey:@"psw"];
                    [LHPShaheObject saveAccountMsgWithName:kAccountMsg andWithMsg:dic1];
                }
                [self.window.rootViewController turnToLoginVC];
                [WCAlertView showAlertWithTitle:@"消息提示" message:forceLogoutString customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            }
        });
    } fail:^(NSError *err) {
        [self forceLogout];
    }];
}

@end
