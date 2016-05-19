//
//  AppDelegate+EaseMob.m
//  EasMobSample
//
//  Created by dujiepeng on 12/5/14.
//  Copyright (c) 2014 dujiepeng. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EMGroup.h"
#import "EaseMob.h"
#import "ApplyViewController.h"
//#import "UMessage.h"
//#import "UMFeedback.h"

//#import "APService.h"



#import "APService.h"

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)
- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions) {//启动选项
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [self didReiveceRemoteNotificatison:userInfo];//收到推送消息
        }
    }
    _connectionState = eEMConnectionConnected;//链接状态--链接
    
  //  [self registerRemoteNotification];//注册远程通知
    
    
    //本协议主要处理：录音、播放录音、停止录音、震动等操作
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"changhongcws#cheweishi"
                                       apnsCertName:@"cheweishi_developer"
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];//自动获取好友列表
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application
            didFinishLaunchingWithOptions:launchOptions];
    
    [self setupNotifiers];
}


// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    //跳转到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    //将要进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //在应用程序启动后直接进行应用程序级编码的主要方式
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    //应用程序按下主屏幕按钮后想要将应用程序切换到前台时调用，应用 程序启动时也会调用，可以在其中添加一些应用程序初始化代码
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //从活动状态过度到不活动状态，是启用或禁用任何动画、应用程序那的音频 或其他处理应用程序表示（向用户）的项目的不错位置。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    //在应用程序委托对象中接收内存警告消息，需要重写applicationDidReceiveMemoryWarning:方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    //希望在app退出时保存当前View中的UITextView的值，以便在app重新打开时显示用户退出前编辑的内容。 在AppDelegate的applicationWillTerminate中已经包含了保存NSUserDefaults的代码，仅需View在app退出时将UITextView的值保存在NSUserDefaults中。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}


// 将得到的deviceToken传给SDK

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    
//    NSString*deviceToken1=[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                           stringByReplacingOccurrencesOfString: @">" withString: @""]
//                          stringByReplacingOccurrencesOfString: @" " withString: @""];
//    MyLog(@"%@",deviceToken1);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:deviceToken1 forKey:@"deviceToken"];
//    
// //   [UMessage registerDeviceToken:deviceToken];
//    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
////    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
////        if (error != nil) {
////            NSLog(@"%@", error.localizedDescription);
////        }
////    }];
//    
//    
//    /**极光推送DeviceToken*/
//    [APService registerDeviceToken:deviceToken];
//    NSLog(@"%@",[NSString stringWithFormat:@"Device Token:%@",deviceToken]);
//}



//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    
//    NSString*deviceToken1=[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                           stringByReplacingOccurrencesOfString: @">" withString: @""]
//                          stringByReplacingOccurrencesOfString: @" " withString: @""];
//    MyLog(@"%@",deviceToken1);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:deviceToken1 forKey:@"deviceToken"];
//    
// //   [UMessage registerDeviceToken:deviceToken];
//    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
////    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
////        if (error != nil) {
////            NSLog(@"%@", error.localizedDescription);
////        }
////    }];
//    
//    
//    /**极光推送DeviceToken*/
//    [APService registerDeviceToken:deviceToken];
//    NSLog(@"%@",[NSString stringWithFormat:@"Device Token:%@",deviceToken]);
//
////    [APService registerDeviceToken:deviceToken];
//
//}
//
//-(void)didLoginFromOtherDevice
//{
//    MyLog(@"被挤掉登录");
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        if (KUserManager.uid!=nil) {
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
//            KUserManager.uid=nil;
//            [[NSUserDefaults standardUserDefaults] synchronize];
////            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            
//            //移除密码
//            if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
//                NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
//                NSMutableDictionary*dic1=[NSMutableDictionary dictionaryWithDictionary:dic];
//                [dic1 setObject:@"" forKey:@"psw"];
//                [LHPShaheObject saveAccountMsgWithName:kAccountMsg andWithMsg:dic1];
//            }
//            [self buildMainFrame];
//            [self loginOterDeviceNoteWithString:@"账号在其他设备上登录,请重新登录"];
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginToMainController" object:@"账号在其他设备上登录,请重新登录"];
//        }
//    } onQueue:nil];
//}
// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    MyLog(@"%@",error.description);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
}


-(void)application:(UIApplication*)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    
//    [APService handleRemoteNotification:userInfo];
    MyLog(@"Receive Message:%@",[self logDic:userInfo]);
    
}

//-(void)application:(UIApplication*)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
//    
//
//}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//
//
////    
////    [APService handleRemoteNotification:userInfo];
//
//    
//    
//     /**极光推送设置（IOS7.0）*/
//    [APService handleRemoteNotification:userInfo];
//
//    MyLog(@"收到通知:%@", [self logDic:userInfo]);
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}



// 注册推送
//- (void)registerRemoteNotification{
//    UIApplication *application = [UIApplication sharedApplication];
//    application.applicationIconBadgeNumber = 0;//推送消息图标展示0条
//
//    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
//    {
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//
//#if !TARGET_IPHONE_SIMULATOR
//    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//    }else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
//#endif
//}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
//    UIAlertView *alertView = nil;
//    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    else{
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.beginAutoLogin", @"Start automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    
//    [alertView show];
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
//    UIAlertView *alertView = nil;
//    if (error) {
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.errorAutoLogin", @"Automatic logon failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    else{
//        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"login.endAutoLogin", @"End automatic login...") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//    }
//    
//    [alertView show];
}

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    if (self.cwsMainVC) {
    }
}

// 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    }
    if (str.length > 0) {
//        TTAlertNoTitle(str);
    }
}

// 申请加入群组被拒绝回调
- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
                                   groupname:(NSString *)groupname
                                      reason:(NSString *)reason
                                       error:(EMError *)error{
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), groupname];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:reason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!groupId || !username) {
        return;
    }
    
    if (!reason || reason.length == 0) {
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), username, groupname];
    }
    else{
        reason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), username, groupname, reason];
    }
    
    if (error) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.sendApplyFail", @"send application failure:%@\nreason：%@"), reason, error.description];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        [[ApplyViewController shareController] addNewApply:dic];
//        if (self.mainController) {
//            [self.mainController setupUntreatedApplyCount];
//        }
    }
}

// 已经同意并且加入群组后的回调
- (void)didAcceptInvitationFromGroup:(EMGroup *)group
                               error:(EMError *)error
{
    if(error)
    {
        return;
    }
    
    NSString *groupTag = group.groupSubject;
    if ([groupTag length] == 0) {
        groupTag = group.groupId;
    }
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed and joined the group of \'%@\'"), groupTag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}


// 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        TTAlertNoTitle(NSLocalizedString(@"apns.failToBindDeviceToken", @"Fail to bind device token"));
    }
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
//    [self.mainController networkChanged:connectionState];
}

// 打印收到的apns信息


-(void)didReiveceRemoteNotificatison:(NSDictionary *)userInfo{
    
    
    
//    NSError *parseError = nil;
//    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
//                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容"
//                                                    message:str
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
    
#warning 推送消息
//    if ([userInfo[@"msgType"] isEqualToString:@"1"]) {//警告消息
//        [LHPShaheObject saveAccountMsgWithName:kCarTrendAppToActionNotification andWithMsg:userInfo];
//    }else if ([userInfo[@"msgType"] isEqualToString:@"0"]){//广播消息
//        
//    }else if ([userInfo[@"msgType"] isEqualToString:@"2"]){//解绑消息
//        [LHPShaheObject saveAccountMsgWithName:kAppToActionNotification andWithMsg:userInfo];
//    }
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
