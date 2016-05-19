//
//  CWSMyCarController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMyCarController.h"
#import "CWSCarTrendsController.h"
#import "CWSFindCarLocationController.h"
#import "CWSFootprintController.h"
#import "CWSNavController.h"
#import "CWSCarReportViewController.h"
#import "CWSPhoneController.h"
#import "CWSCarManageController.h"
#import "CWSAddCarController.h"
#import "CWSDetectionController.h"
#import "CWSFindOilesController.h"
#import "CWSMessageViewController.h"
#import "CWSSettingController.h"
#import "CWSUserPersonalSignatureController.h"
#import "CWSUserInformationController.h"
#import "CWSFeedbackController.h"
#import "CWSMoodController.h"
#import "RebuildBtn.h"

#import "UIImageView+WebCache.h"

#import "CWSMyWealthController.h"

@interface CWSMyCarController ()
{
    BOOL   _btnClick;
    BOOL   _disappearMark;
    BOOL   _myCarOnce;
}
- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation CWSMyCarController


- (void)viewDidLoad {
    [super viewDidLoad];
    _btnClick = NO;
    _myCarOnce=YES;
    _reportTouch=NO;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=home.png"] placeholderImage:[UIImage imageNamed:@"moren.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    [Utils viewsBtnTouchOnceWithView:self.view];
    [Utils changeBackBarButtonStyle:self];
    //设置头像圆角
    [Utils setViewRiders:self.userHeadImage riders:15];

    [self creatUI];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftControllerBack:) name:@"leftControllerBack11" object:nil];
    //leftController跳转通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homeClick:) name:@"homeClick1" object:nil];
    //改变按钮方向
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRightBtn:) name:@"changeRightBtn" object:nil];
}

-(void)changeRightBtn:(NSNotification*)sender{
    NSString* lStr = sender.object;
    if ([lStr isEqualToString:@"0"]) {
        arrowsImageView.image = [UIImage imageNamed:@"youce1"];
    }else{
        arrowsImageView.image = [UIImage imageNamed:@"youce2"];
    }
}
-(void)homeClick:(NSNotification*)sender{
    _homeBackgroundControl.hidden = !_homeBackgroundControl.hidden;
}

-(void)Actiondo{
    _homeBackgroundControl.hidden = !_homeBackgroundControl.hidden;
}
-(void)viewWillAppear:(BOOL)animated{
    _disappearMark = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"1"];
    //设置头像
    if (KUserManager.uid!=nil) {
        [self.userHeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",KUserManager.photo]] placeholderImage:[UIImage imageNamed:@"infor_moren"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    }else{
        self.userHeadImage.image=[UIImage imageNamed:@"infor_moren"];
    }
    
    KManager.currentController = @"CWSMyCarController";
//    NSUserDefaults*user=[[NSUserDefaults alloc]init];
//    [user setObject:@"CWSMyCarController" forKey:@"currentController"];
//    [NSUserDefaults resetStandardUserDefaults];
}

-(void)viewDidAppear:(BOOL)animated{
    //推送消息app关闭情况
    if ([LHPShaheObject checkPathIsOk:kCarTrendAppToActionNotification]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCarTrendAppToActionNotification]];
        if (dic.count) {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kAppToActionNotification object:nil];
            CWSCarTrendsController*carTrend=[[CWSCarTrendsController alloc]initWithNibName:@"CWSCarTrendsController" bundle:nil];
            [self.navigationController pushViewController:carTrend animated:YES];
            [LHPShaheObject saveAccountMsgWithName:kCarTrendAppToActionNotification andWithMsg:@{}];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    //    [self Actiondo];
    if (!_homeBackgroundControl.hidden) {
        [self Actiondo];
    }
    if (!_reportTouch) {
        if (_disappearMark) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"0"];
    
    //    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    //    [user setObject:@"" forKey:@"currentController"];
    //    [NSUserDefaults resetStandardUserDefaults];

}
-(void)viewDidDisappear:(BOOL)animated{
    _myCarOnce=YES;
    if (_reportTouch) {
        _reportTouch=NO;
        if (_disappearMark) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
}
-(void)creatUI{
    CGFloat wight = 224;
    CGFloat y = kSizeOfScreen.height - kDockHeight - (kSizeOfScreen.height - kDockHeight - 214) / 2 - wight/2 + 12;
    [self.btnView setFrame:CGRectMake(kSizeOfScreen.width/2 - wight/2, y, wight, wight)];
    [self.view addSubview:self.btnView];
    
    //创建按钮
    [self creatRebuildBtn:CGRectMake(0, 0, 60, 90) imageArray:@[@"weixiu_chewei",@"mycar_chewei"] title:@"找车位" tag:3];
    [self creatRebuildBtn:CGRectMake(164, 0, 60, 90) imageArray:@[@"weixiu_daohang",@"mycar_daohang"] title:@"导  航" tag:2];
    [self creatRebuildBtn:CGRectMake(82, 72, 60, 90) imageArray:@[@"weixiu_dongtai",@"mycar_dongtai"] title:@"车动态" tag:1];
    [self creatRebuildBtn:CGRectMake(0, 134, 60, 90) imageArray:@[@"weixiu_zuji",@"mycar_zuji"] title:@"我的足迹" tag:4];
    [self creatRebuildBtn:CGRectMake(164, 134, 60, 90) imageArray:@[@"weixiu_baogao",@"mycar_baogao"] title:@"车辆报告" tag:5];
}
-(void)creatRebuildBtn:(CGRect)frame imageArray:(NSArray*)imageArray title:(NSString*)title tag:(int)tag{
    RebuildBtn*btn=[[RebuildBtn alloc]initWithFrame:frame];
    [btn setTitle:title withColorNormalAndHighlight:@[[UIColor blackColor],[UIColor lightGrayColor]] withImageNormalAndHighlight:@[imageArray[0],imageArray[1]]];
    btn.tag = tag;
    [btn addTarget:self action:@selector(rebuildBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:btn];
}
-(void)addBtn:(NSString*)title frame:(CGRect)frame image:(UIImage*)image tag:(int)tag{
    
}
-(void)leftControllerBack:(NSNotification*)sender
{
    UIViewController* lController = sender.object;
    if ([lController isKindOfClass:[CWSCarManageController class]]) {
        _disappearMark = YES;
    }
    if (_myCarOnce) {
        if ([lController isKindOfClass:[CWSCarManageController class]]) {
            CWSCarManageController*carManagerVC=[[CWSCarManageController alloc]initWithNibName:@"CWSCarManageController" bundle:nil];
            [self.navigationController pushViewController:carManagerVC animated:YES];
        }else if ([lController isKindOfClass:[CWSUserInformationController class]]){
            CWSUserInformationController*carManagerVC=[[CWSUserInformationController alloc]initWithNibName:@"CWSUserInformationController" bundle:nil];
            [self.navigationController pushViewController:carManagerVC animated:YES];
        }else if ([lController isKindOfClass:[CWSPhoneController class]]){
            CWSPhoneController*carManagerVC=[[CWSPhoneController alloc]initWithNibName:@"CWSPhoneController" bundle:nil];
            [self.navigationController pushViewController:carManagerVC animated:YES];
        }else if ([lController isKindOfClass:[CWSFeedbackController class]]){
            CWSFeedbackController*carManagerVC=[[CWSFeedbackController alloc]initWithNibName:@"CWSFeedbackController" bundle:nil];
            [self.navigationController pushViewController:carManagerVC animated:YES];
        }else if ([lController isKindOfClass:[CWSMessageViewController class]]){
            CWSMessageViewController*carManagerVC=[[CWSMessageViewController alloc]initWithNibName:@"CWSMessageViewController" bundle:nil];
            [self.navigationController pushViewController:carManagerVC animated:YES];
        }else if ([lController isKindOfClass:[CWSMyWealthController class]]){
            CWSMyWealthController* messageCenterVC = [[CWSMyWealthController alloc]initWithNibName:@"CWSMyWealthController" bundle:nil];
            [self.navigationController pushViewController:messageCenterVC animated:YES];
        }else if ([lController isKindOfClass:[CWSSettingController class]]){
            CWSSettingController* settingController = [[CWSSettingController alloc]initWithNibName:@"CWSSettingController" bundle:nil];
            [self.navigationController pushViewController:settingController animated:YES];
        }else if ([lController isKindOfClass:[CWSUserPersonalSignatureController class]]){
            CWSUserPersonalSignatureController* settingController = [[CWSUserPersonalSignatureController alloc]initWithNibName:@"CWSUserPersonalSignatureController" bundle:nil];
            [self.navigationController pushViewController:settingController animated:YES];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
        _myCarOnce=NO;
        
    }else{
        _myCarOnce=YES;
    }
    
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 6:
        {
//            if (KUserManager.uid!=nil) {//登录
//                //这里写登录后对该事件的操作
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"leftMark" object:@"1"];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"itemLeftClic" object:nil];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//                [self showHint:@"请先登录后再使用本功能"];
//            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"leftMark" object:@"1"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"itemLeftClic" object:nil];
        }
            break;
        case 7:
        {
            //跳转到右侧滑动
            [[NSNotificationCenter defaultCenter] postNotificationName:@"itemRigthClic" object:nil];
            //            if (KUserManager.uid!=nil) {//登录
            //这里写登录后对该事件的操作
            //                CWSPhoneController*phoneVC=[[CWSPhoneController alloc]initWithNibName:@"CWSPhoneController" bundle:nil];
            //                phoneVC.title=@"电话";
            //                [self.navigationController pushViewController:phoneVC animated:YES];
            //            }else{
            //                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            //                [self showHint:@"请先登录后再使用本功能"];
            //            }
            
        }
            break;
        case 8:
        {
            MyLog(@"广告");
        }
            break;
            
        default:
            break;
    }
}
-(void)rebuildBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            if (KUserManager.uid!=nil) {//登录
                //这里写登录后对该事件的操作
                if ([KUserManager.car.device isEqualToString:@""]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先绑定设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往绑定", nil];
                    alertView.tag = 1000;
                    [alertView show];
                    return;
                }
                CWSCarTrendsController* lController = [[CWSCarTrendsController alloc] init];
                lController.title = @"车动态";
                [self.navigationController pushViewController:lController animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                [self showHint:@"请先登录后再使用本功能"];
            }
        }
            break;
        case 2:
        {
            CWSNavController* lController = [[CWSNavController alloc] init];
            lController.title = @"导航";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 3:
        {
            _disappearMark = YES;
            CWSFindCarLocationController* lController = [[CWSFindCarLocationController alloc] init];
            lController.type = @"停车场";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 4:
        {
            if (KUserManager.uid!=nil) {//登录
                //这里写登录后对该事件的操作
                if ([KUserManager.car.device isEqualToString:@""]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先绑定设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往绑定", nil];
                    alertView.tag = 1000;
                    [alertView show];
                    return;
                }
                CWSFootprintController* lController = [[CWSFootprintController alloc] init];
                [self.navigationController pushViewController:lController animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                [self showHint:@"请先登录后再使用本功能"];
            }
        }
            break;
        case 5:
        {
            if (KUserManager.uid!=nil) {//登录
                if ([KUserManager.car.device isEqualToString:@""]) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先绑定设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往绑定", nil];
                    alertView.tag = 1000;
                    [alertView show];
                    return;
                }
                
                CWSCarReportViewController*reportVC=[[CWSCarReportViewController alloc]init];
//                reportVC.title=@"报告";
                _reportTouch=YES;
                UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:reportVC];
//                [self.navigationController pushViewController:reportVC animated:YES];
//                reportVC.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:nav animated:YES completion:nil];
                
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                [self showHint:@"请先登录后再使用本功能"];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1&&alertView.tag==1000) {
        MyLog(@"添加设备");
        CWSAddCarController* lController = [[CWSAddCarController alloc] init];
        lController.title = @"添加车辆";
        [self.navigationController pushViewController:lController animated:YES];
    }
}
@end
