/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "CWSCarTrendsController.h"
#import "CWSDetectionController.h"
#import "CWSCarManageController.h"
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import "CWSLoginController.h"
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


-(void)dateLate
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *pageName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:pageName];
}
-(void)viewWillDisappear:(BOOL)animated
{
     NSString *pageName = NSStringFromClass([self class]);
    [MobClick endLogPageView:pageName];
}
#pragma mark 设置超时信息重新登陆通知
-(void)turnToLoginVC
{
    CWSLoginController*loginVC = [[CWSLoginController alloc]initWithNibName:@"CWSLoginController" bundle:nil];
    
    UINavigationController* rootLoginNavVc = [[UINavigationController alloc]initWithRootViewController:loginVC];
    rootLoginNavVc.navigationBarHidden = YES;
    //左边返回键设置
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        item.tintColor = [UIColor lightGrayColor];
        item;
    });
    [self presentViewController:rootLoginNavVc animated:YES completion:nil];

}
#pragma clang diagnostic pop

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}
- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
//    hud.backgroundColor=kCOLOR(217, 217, 217);
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
- (void)hideHud{
    [[self HUD] hide:YES];
}
-(void)setRemoteNotiEvent
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveRemoteMsg:) name:@"warningNotiMsg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveRemoteMsg:) name:@"applicationStateActiveCarTrend" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveRemoteMsgToCarChcek:) name:@"applicationStateActiveCarCheck" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoCarManager:) name:@"applicationStateActive" object:nil];
}
-(void)gotoCarManager:(NSNotification*)sender
{
    CWSCarManageController*carTrecdVC=[[CWSCarManageController alloc]initWithNibName:@"CWSCarManageController" bundle:nil];
    [self.navigationController pushViewController:carTrecdVC animated:YES];
}
-(void)receiveRemoteMsg:(NSNotification*)sender
{
    CWSCarTrendsController*carTrecdVC=[[CWSCarTrendsController alloc]initWithNibName:@"CWSCarTrendsController" bundle:nil];
    carTrecdVC.notiDic=(NSDictionary*)sender.object;
    carTrecdVC.title=@"车辆动态";
    [self.navigationController pushViewController:carTrecdVC animated:YES];
}
-(void)receiveRemoteMsgToCarChcek:(NSNotification*)sender
{
    if (self.navigationController.viewControllers.count !=1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)shareMsgWithImage:(NSString*)imageName
             withContent:(NSString*)content
      withDefaultContent:(NSString*)defaultContent
               withTitle:(NSString*)title
                 withUrl:(NSString*)url
         withDescription:(NSString*)description
{
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navBackImg"] forBarMetrics:UIBarMetricsDefault];
//    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObject:kCOLOR(255, 147, 25) forKey:UITextAttributeTextColor]];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:defaultContent
                                                image:nil
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeText];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                UINavigationBar *bar = [UINavigationBar appearance];
//                                [bar setBackgroundImage:[UIImage imageNamed:@"navigation.png"] forBarMetrics:UIBarMetricsDefault];
//                                [bar setTitleTextAttributes:[NSDictionary dictionaryWithObject:kCOLOR(255, 147, 25) forKey:UITextAttributeTextColor]];
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    [self showHint:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    [self showHint:@"分享成功"];
                                }
                            }];
}
@end
