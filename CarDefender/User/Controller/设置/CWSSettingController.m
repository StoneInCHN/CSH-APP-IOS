//
//  CWSSettingController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSSettingController.h"
#import "CWSQianDaoController.h"
#import "CWSLoginController.h"
#import "CWSDetectionController.h"
#import "CWSPhoneController.h"
#import "CWSCarTrendsController.h"
#import "CWSAboutUsController.h"
#import "CWSPushMassageController.h"
#import "CWSAlarmController.h"
#import "CWSSOSSettingController.h"
#import "UIImageView+WebCache.h"

@interface CWSSettingController ()<UIAlertViewDelegate>
{
    UISwitch *_callSwitch;//报警开关
    UISwitch *_voiceSwitch;//声音开关
    UISwitch *_vibrationSwitch;//震动开关
    UISwitch *_pushSwitch;//推送开关
    UILabel  *_currentVersionLabel;//当前版本
    UserInfo *userInfo;
}

@property (weak, nonatomic) IBOutlet UIButton *loginOrOutBtn;


- (IBAction)btnClick:(UIButton *)sender;

@end

@implementation CWSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    userInfo = [UserInfo userDefault];
    [Utils changeBackBarButtonStyle:self];
    
    //设置当前试图同一时间只有一个按钮被点击
    [Utils viewsBtnTouchOnceWithView:self.view];
    [self initalizeUserInterface];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"1"];
    if (userInfo.desc!=nil) {
        [self.loginOrOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        [self.loginOrOutBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    _callSwitch = (UISwitch *)[self.view viewWithTag:10];
    _voiceSwitch = (UISwitch *)[self.view viewWithTag:11];
    _vibrationSwitch = (UISwitch *)[self.view viewWithTag:12];
    _pushSwitch = (UISwitch *)[self.view viewWithTag:13];
    
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    _currentVersionLabel = (UILabel *)[self.view viewWithTag:20];
    _currentVersionLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"CFBundleShortVersionString"]];
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            //报警设置
            MyLog(@"报警设置");
            if (userInfo.desc!=nil) {
                _callSwitch.on = !_callSwitch.on;
                
                
            }else{
                  
                [self turnToLoginVC];
            }
        }
            break;
        case 2:
        {
            //声音提醒
            MyLog(@"声音提醒");
            if (userInfo.desc!=nil) {
                _voiceSwitch.on = !_voiceSwitch.on;
                
            }else{
                
                [self turnToLoginVC];
            }
        }
            break;
        case 3:
        {
            //震动提醒
            MyLog(@"震动提醒");
            if (userInfo.desc!=nil) {
                 _vibrationSwitch.on = !_vibrationSwitch.on;
                
            }else{
                
                [self turnToLoginVC];
            }
        }
            break;
        case 4:
        {
            //接收推送消息
            MyLog(@"接收推送消息");
            if (userInfo.desc!=nil) {
                _pushSwitch.on = !_pushSwitch.on;
                
            }else{
                
                [self turnToLoginVC];
            }
        }
            break;
        case 5:
        {
            //5星好评
            //跳转到APPStore
            MyLog(@"5星好评");
//            if (KUserManager.uid!=nil) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/che-sheng-huo-wo-yao-wo-sheng/id990886965?l=en&mt=8"]];
//            }else{
//                [self turnToLoginVC];
//            }
        }
            break;
        case 6:
        {
            //当前版本
            MyLog(@"当前版本");
            
        }
            break;
        case 7:
        {
            //关于我们
            MyLog(@"关于我们");
            CWSAboutUsController* lController = [[CWSAboutUsController alloc] init];
            lController.title = @"关于我们";
            [self.navigationController pushViewController:lController animated:YES];

        }
            break;
        case 8:
        {
            //清除缓存
            MyLog(@"清除缓存");
            if (userInfo.desc!=nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 100;
                [alert show];
            }else{
                [self turnToLoginVC];
            }
        }
            break;
        case 9:
        {
            //退出登录
            if (userInfo.desc!=nil) {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 101;
                [alert show];
                
            }else{
                [self turnToLoginVC];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==101) {
        if (buttonIndex==1) {

//             CWSSettingController *weakSelf = self;
            [MBProgressHUD showMessag:@"退出登录中..." toView:self.view];
            
#if USENEWVERSION
            
//            [HttpTool postLogoutWithHttpBody:@{@"uid":KUserManager.uid} success:^(NSDictionary *data) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self loginSuccess];
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                });
//            } fail:^(NSError *err) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
////                [alert show];
//                [WCAlertView showAlertWithTitle:@"提示" message:@"退出失败，请稍后再试" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            }];
            
            [HttpHelper logoutWithUserId:userInfo.desc
                                   token:userInfo.token
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                     NSLog(@"logout response :%@", responseObjcet);
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     NSDictionary *resultDic = (NSDictionary *)responseObjcet;
                                     if ([resultDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                         [self loginSuccess];
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                     }else if ([resultDic[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                     }else{
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultDic[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                         [alert show];
                                     }
                                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    [WCAlertView showAlertWithTitle:@"提示" message:@"退出失败，请稍后再试" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                }
            ];
            
#else
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                if (error && error.errorCode != EMErrorServerNotLogin) {
                    [weakSelf hideHud];
                    [weakSelf showHint:error.description];
                }
                else{
                    [ModelTool httpGetAppLogoutWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
                        MyLog(@"%@",object);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self loginSuccess];
                            [weakSelf hideHud];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    } faile:^(NSError *err) {
                        [weakSelf hideHud];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出失败，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
                        [alert show];
                    }];
                }
            } onQueue:nil];
#endif
        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            [self clearCache:path];
        }
    }
    
}

#pragma mark - 清除缓存
- (void)clearCache:(NSString *)path{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       [[SDImageCache sharedImageCache] cleanDisk];
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
   
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"清除成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
}

#pragma mark - 登陆成功
-(void)loginSuccess
{
    [self.loginOrOutBtn setTitle:@"登录" forState:UIControlStateNormal];
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
    [self turnToLoginVC];
}

-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
