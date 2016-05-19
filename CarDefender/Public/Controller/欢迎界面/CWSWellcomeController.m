//
//  CWSWellcomeController.m
//  车卫士
//
//  Created by 周子涵 on 15/3/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSWellcomeController.h"

#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface CWSWellcomeController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
{
    NSTimer*_timer;
    int _minite;
}
//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;


@end

@implementation CWSWellcomeController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置3秒后自动跳转
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self selector:@selector(timerFireMethod:)
                                          userInfo:nil repeats:YES];
    [_timer fire];
    _minite=2;
}
#pragma mark - timer事件
-(void)timerFireMethod:(NSTimer*)sender
{
    _minite--;
    if (_minite==0) {
        [sender invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"welcomeToRoot" object:nil];
    }
}
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}
- (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = 113.948222;
    startNode.pos.y = 22.549555;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    
    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    midNode.pos = [[BNPosition alloc] init];
    midNode.pos.x = 113.977004;
    midNode.pos.y = 22.556393;
    midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = 114.089863;
    endNode.pos.y = 22.546236;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}
#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    MyLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    MyLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        MyLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        MyLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    MyLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    MyLog(@"退出导航");
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    MyLog(@"退出导航声明页面");
}

-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    MyLog(@"退出电子狗页面");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - 按钮点击事件
- (IBAction)btnClick:(UIButton *)sender {
}
@end
