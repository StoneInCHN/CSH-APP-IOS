//
//  CWSServiceController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSServiceController.h"
#import "CWSRepairController.h"
#import "CWSTyreHomeController.h"
#import "CWSUserChooseCityController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "RebuildBtn.h"
#import "CWSCarWashDetileController.h"
#import "CWSServiceItem.h"
#import "CWSOrderCarWashController.h"
#import "CWSShopMallController.h"
#import <sqlite3.h>
#define kBtnWH 28
#define kDistance 20
@interface CWSServiceController ()<BMKGeoCodeSearchDelegate,UIAlertViewDelegate>
{
    NSString*                cityString;
    BMKGeoCodeSearch*        _geocodesearch;
    bool                     isGeoSearch;
    
    UIBarButtonItem*_rightBarBtn;//右侧按钮
    
    NSArray*arrayMsg;
    NSArray*arrayImgNor;
    NSArray*arrayImgHig;
}
@end

@implementation CWSServiceController

-(void)setBarButton{
    [Utils changeBackBarButtonStyle:self];
    _rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightChooseBtn)];
    self.navigationItem.rightBarButtonItem = _rightBarBtn;
}
-(void)rightChooseBtn{
    CWSUserChooseCityController*chooseCity=[[CWSUserChooseCityController alloc]initWithNibName:@"CWSUserChooseCityController" bundle:nil];
    chooseCity.title=@"城市选择";
    [self.navigationController pushViewController:chooseCity animated:YES];
}
-(void)getLocationCity{
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    isGeoSearch = false;
    NSLog(@"%f-%f",KManager.currentPt.latitude,KManager.currentPt.longitude);
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        MyLog(@"反geo检索发送成功");
    }
    else
    {
        MyLog(@"反geo检索发送失败");
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务大厅";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self setBarButton];
    
    [self creatUI];
    [self getLocationCity];
   
    if (KManager.currentCity!=nil || KManager.currentCity.length) {
        NSUserDefaults*user = [[NSUserDefaults alloc]init];
        NSString*string = [user objectForKey:@"SERVICE_CITYNAME"];
        if (string) {
            if (![string isEqualToString:KManager.currentCity]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"系统定位到您在%@，需要切换至%@吗",KManager.currentCity,KManager.currentCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                alert.tag = 100;
                [alert show];
                cityString=string;
            }else{
                cityString=KManager.currentCity;
            }
        }else{
            cityString=KManager.currentCity;
        }
        [self setCityBtnTitle:cityString];
    }else{
        cityString=@"定位失败";
        [self setCityBtnTitle:cityString];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftControllerBack:) name:@"leftControllerBack3" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseCityBack:) name:@"chooseCityMsgBack" object:nil];
    
    //设置当前试图同一时间只有一个按钮被点击
    [Utils viewsBtnTouchOnceWithView:self.backgroundScrollerView];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            cityString=KManager.currentCity;
            [self setCityBtnTitle:cityString];
            NSUserDefaults*user = [[NSUserDefaults alloc]init];
            [user setObject:KManager.currentCity forKey:@"SERVICE_CITYNAME"];
            [NSUserDefaults resetStandardUserDefaults];
        }
    }
}
-(void)buildUI
{
    for (int i=0; i<1; i++) {
        CWSServiceItem*btn=[[CWSServiceItem alloc]initWithFrame:CGRectMake(438, 345, kBtnWH, kBtnWH*2/3)];
        [btn setTitle:arrayMsg[i] forState:UIControlStateNormal];
        [btn setTitle:arrayMsg[i] forState:UIControlStateHighlighted];
        [btn setImage:arrayImgNor[i] forState:UIControlStateNormal];
        [btn setImage:arrayImgHig[i] forState:UIControlStateHighlighted];
        [btn setTitleColor:KBlackMainColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.backgroundScrollerView addSubview:btn];
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    MyLog(@"+++++%@",result.addressDetail.city);
}
-(void)chooseCityBack:(NSNotification*)sender
{
    NSArray*array=sender.object;
    NSArray*array1=@[@"重庆市",@"北京市",@"天津市",@"上海市",@"香港特别行政区",@"澳门特别行政区"];
    if ([array1 containsObject:array[0][@"name"]]) {
        cityString=array[0][@"name"];
    }else{
        cityString=array[1][@"name"];
    }
    NSUserDefaults*user = [[NSUserDefaults alloc]init];
    [user setObject:cityString forKey:@"SERVICE_CITYNAME"];
    [NSUserDefaults resetStandardUserDefaults];
    [self setCityBtnTitle:cityString];
}
-(void)setCityBtnTitle:(NSString*)title
{
//    [self.cityBtn setTitle:title forState:UIControlStateNormal];
    [_rightBarBtn setTitle:[NSString stringWithFormat:@"%@",title]];
}
-(void)homeClick:(NSNotification*)sender{
    _homeBackgroundControl.hidden = !_homeBackgroundControl.hidden;
}

#pragma mark - 试图将要显示-界面滑动和不滑动设置 0为不滑动，1为滑动
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"0"];
    KManager.currentController = @"CWSServiceController";
}
#pragma mark - 创建start开始方法
-(void)viewDidAppear:(BOOL)animated{
    MyLog(@"---%@",KManager.currentCity);
}
#pragma mark - 试图将要消失时移除start
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"0"];
    [ModelTool stopAllOperation];
}
#pragma mark - 创建试图
-(void)creatUI{
    arrayMsg=@[@"商城",@"预约洗车",@"紧急救援",@"维修保养",@"爱轮之家",@"代驾服务",@"违章代办"];
    arrayImgNor=@[@"jifenshangcheng",@"yuyuexiche@2x",@"fuwu_jiuyuan@2x",@"fuwu_fuwu@2x",@"fuwu_luntai@2x",@"fuwu_daijia@2x",@"fuwu_weizhang@2x"];
    arrayImgHig=@[@"jifenshangcheng_click",@"yuyuexiche_click@2x",@"fuwu_jijiu_highlight@2x",@"fuwu_fuwu_highlight@2x",@"fuwu_luntai_highlight@2x",@"fuwu_daijia_highlight@2x",@"fuwu_weizhang_highlight@2x"];
    for (int i=0; i<arrayMsg.count; i++) {
        float heghtAvrage=self.view.frame.size.width/3;
        float btnH=kBtnWH*3;
        float btnW=kBtnWH*2;
        int nubW=i%3;
        int nubH=i/3;
        float wightDistance = (heghtAvrage - btnW)/2;
        RebuildBtn*btn=[[RebuildBtn alloc]initWithFrame:CGRectMake(nubW*heghtAvrage+wightDistance, self.adventureView.frame.size.height+self.adventureView.frame.origin.y+kDistance+nubH*btnH+nubH*kDistance, btnW, btnH)];
        [btn setTitle:arrayMsg[i] withColorNormalAndHighlight:@[KBlackMainColor,[UIColor lightGrayColor]] withImageNormalAndHighlight:@[arrayImgNor[i],arrayImgHig[i]]];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundScrollerView addSubview:btn];
        if (i==arrayMsg.count-1) {
            self.backgroundScrollerView.contentSize=CGSizeMake(self.view.frame.size.width, btn.frame.size.height+btn.frame.origin.y);
        }
    }
}
-(void)leftControllerBack:(NSNotification*)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
    UIViewController* lController = sender.object;
    [self.navigationController pushViewController:lController animated:YES];
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if (sender.tag!=6 && sender.tag!=0) {
        
        if ([cityString isEqualToString:@"定位失败"]) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
       
    }
    
    switch (sender.tag) {
        case 0://商城
        {
            if (KUserManager.uid==nil) {//未登录
                [self turnToLoginVC];
                return;
            }
            CWSShopMallController*shopMall = [[CWSShopMallController alloc]init];
            [self.navigationController pushViewController:shopMall animated:YES];
        }
            break;
        case 1://免费洗车
        {
            if (KUserManager.uid==nil) {//未登录
                [self turnToLoginVC];
                return;
            }
            [MBProgressHUD showMessag:@"数据请求中..." toView:self.view];
            [ModelTool httpGetCheckOrderWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"cid":KUserManager.car.cid} success:^(id object) {
                MyLog(@"%@",object);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                        if ([object[@"data"][@"data"][@"state"] isEqualToString:@"0"]) {
                            OrderWash* orderWash = [[OrderWash alloc] initWithDic:object[@"data"][@"data"]];
                            CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
                            lController.orderWash = orderWash;
                            lController.state = 1;
                            [self.navigationController pushViewController:lController animated:YES];
                        }else{
                            CWSOrderCarWashController* lController = [[CWSOrderCarWashController alloc] init];
                            [self.navigationController pushViewController:lController animated:YES];
                        }
                    }
                });
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }
            break;
        case 2://紧急救援
        {

//            CWSTyreHomeController* cyreVC = [[CWSTyreHomeController alloc] initWithNibName:@"CWSTyreHomeController" bundle:nil];
//            cyreVC.title = @"紧急救援";
//            cyreVC.tyreCity=cityString;
//            cyreVC.httpKey=@"jy";
            //[self.navigationController pushViewController:cyreVC animated:YES];

            CWSTyreHomeController* cyreVC = [[CWSTyreHomeController alloc] initWithNibName:@"CWSTyreHomeController" bundle:nil];
            cyreVC.title = @"紧急救援";
            
            [self.navigationController pushViewController:cyreVC animated:YES];

//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
        }
            break;
        case 3://维修保养
        {
            CWSRepairController* lController = [[CWSRepairController alloc] init];
            lController.title = @"维修保养";
            lController.cityString = cityString;
            lController.keyWords=@"汽车维修";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 4://爱轮之家
        {

//            CWSTyreHomeController* cyreVC = [[CWSTyreHomeController alloc] initWithNibName:@"CWSTyreHomeController" bundle:nil];
//            cyreVC.title = @"爱轮之家";
//            cyreVC.tyreCity=cityString;
//            cyreVC.httpKey=@"lt";
           // [self.navigationController pushViewController:cyreVC animated:YES];
        }
            break;
        case 5://代驾服务
        {
            CWSRepairController* cyreVC = [[CWSRepairController alloc] initWithNibName:@"CWSRepairController" bundle:nil];
            cyreVC.title = @"代驾服务";
            cyreVC.cityString=cityString;
            cyreVC.keyWords=@"代驾";
            [self.navigationController pushViewController:cyreVC animated:YES];
        }
            break;
        case 6://违章代办
        {

//            CWSTyreHomeController* cyreVC = [[CWSTyreHomeController alloc] initWithNibName:@"CWSTyreHomeController" bundle:nil];
//            cyreVC.title = @"违章代办";
//            cyreVC.tyreCity=cityString;
//            cyreVC.httpKey=@"wz";
           // [self.navigationController pushViewController:cyreVC animated:YES];

        }
            break;
        case 7://地址点击
        {
            CWSUserChooseCityController*chooseCity=[[CWSUserChooseCityController alloc]initWithNibName:@"CWSUserChooseCityController" bundle:nil];
            chooseCity.title=@"城市选择";
            [self.navigationController pushViewController:chooseCity animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
