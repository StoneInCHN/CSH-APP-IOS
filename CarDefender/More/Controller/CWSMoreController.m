//
//  CWSMoreController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMoreController.h"
#import "CWSQianDaoController.h"
#import "CWSLoginController.h"
#import "CWSDetectionController.h"
#import "CWSPhoneController.h"
#import "CWSCarTrendsController.h"
#import "CWSAboutUsController.h"
#import "CWSPushMassageController.h"
@interface CWSMoreController ()
{
    BOOL HXOutBool;
    BOOL CarLifeOutBool;
}
@end

@implementation CWSMoreController


- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    //创建视图
    [self creatUI];
    //设置当前试图同一时间只有一个按钮被点击
    [Utils viewsBtnTouchOnceWithView:self.view];
}

-(void)creatUI{
    self.title = @"更多";
    [Utils changeBackBarButtonStyle:self];
    
    self.backgroundScrollerView.contentSize = CGSizeMake(0, self.groundView.frame.size.height);
    self.groundView.frame = CGRectMake(0, 0, self.groundView.frame.size.width, self.groundView.frame.size.height);
    [self.backgroundScrollerView addSubview:self.groundView];
    
    [self.signBtn setBackgroundImage:[UIImage imageNamed:@"d9"] forState:UIControlStateHighlighted];
    [self.aboutUsBtn setBackgroundImage:[UIImage imageNamed:@"d9"] forState:UIControlStateHighlighted];
    [self.privacyBtn setBackgroundImage:[UIImage imageNamed:@"d9"] forState:UIControlStateHighlighted];
}


-(void)viewDidAppear:(BOOL)animated{
    KManager.currentController = @"CWSMoreController";
}

-(void)viewWillAppear:(BOOL)animated{
    if (KUserManager.uid!=nil) {
        [self.loginOrOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }else{
        [self.loginOrOutBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            MyLog(@"签到详情");
            if (KUserManager.uid!=nil) {//登录
                CWSQianDaoController* lController = [[CWSQianDaoController alloc] init];
                lController.title = @"签到详情";
                [self.navigationController pushViewController:lController animated:YES];
                
            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                    [self showHint:@"请先登录后再使用本功能"];
                    [self turnToLoginVC];
            }
        }
            break;
        case 2:
        {
            MyLog(@"关于我们");
            CWSAboutUsController* lController = [[CWSAboutUsController alloc] init];
            lController.title = @"关于我们";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 3://退出登录
        {
            if (KUserManager.uid!=nil) {//登录
                UIAlertView*alert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert1 show];
                alert1.tag=500;
            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                [self turnToLoginVC];
            }
        }
            break;
        case 4:
        {
            CWSPushMassageController* lController = [[CWSPushMassageController alloc] init];
            lController.title = @"消息通知";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            __weak CWSMoreController *weakSelf = self;
            [weakSelf showHudInView:self.view hint:@"退出登录中..."];
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                if (error && error.errorCode != EMErrorServerNotLogin) {
                    [weakSelf hideHud];
                    [weakSelf showHint:error.description];
                }else{
                    [ModelTool httpGetAppLogoutWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
                        MyLog(@"%@",object);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self loginSuccess];
                            [weakSelf hideHud];
                        });
                    } faile:^(NSError *err) {
                        [self loginSuccess];
                        [weakSelf hideHud];
                    }];
                }
            } onQueue:nil];
        }
    }
//    else{
//        if(buttonIndex==1){//登录
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            [self showHint:@"请先登录后再使用本功能"];
//        }
//    }
}
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    [self turnToLoginVC];
}
@end
