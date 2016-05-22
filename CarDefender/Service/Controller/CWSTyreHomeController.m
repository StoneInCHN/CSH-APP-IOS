//
//  CWSTyreHomeController.m
//  CarDefender
//
//  Created by 李散 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSTyreHomeController.h"
#import "CWSTyreDetailController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CWSBMapView.h"
#import "CWSSearchAddressViewController.h"
#import "UIImageView+WebCache.h"


@interface CWSTyreHomeController ()<UIAlertViewDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{

    BMKMapView *_mapView;
    BMKPointAnnotation *pointAnnotation;
    BMKLocationService *locationService;
    CLLocationCoordinate2D    nowLocation;
    BMKGeoCodeSearch*        _geocodesearch;
    UserInfo *userInfo;
}

@end

@implementation CWSTyreHomeController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectCityName" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    userInfo = [UserInfo userDefault];
    [Utils changeBackBarButtonStyle:self];
    self.title = @"紧急救援";
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"selectCityName" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    locationService.delegate = nil;
    [locationService stopUserLocationService];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectCityName" object:nil];
    [ModelTool stopAllOperation];
}

#pragma mark - 通知
- (void)notification:(NSNotification *)info
{
    //移除地图上所有标注点
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",info.userInfo[@"city"],info.userInfo[@"district"],info.userInfo[@"key"]];
    
    nowLocation = (CLLocationCoordinate2D ){[info.userInfo[@"lat"] floatValue], [info.userInfo[@"lng"] floatValue]};
    
    _mapView.delegate = self;
    locationService.delegate = self;
    [locationService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [_mapView setCenterCoordinate:nowLocation animated:YES];

    //标注1
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = nowLocation;
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.addressLabel = (UILabel *)[self.view viewWithTag:1];
    if (KManager.currentCity.length>0 || KManager.currentSubCity>0 || KManager.currentStreetName>0 || KManager.currentStreetNumber>0) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",KManager.currentCity,KManager.currentSubCity,KManager.currentStreetName,KManager.currentStreetNumber];
    }
    
    
    self.addressButton = (UIButton *)[self.view viewWithTag:2];
    [self.addressButton addTarget:self action:@selector(addressButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mapCustomView = (UIView *)[self.view viewWithTag:3];
    self.callSaveButton = (UIButton *)[self.view viewWithTag:4];
    [self.callSaveButton addTarget:self action:@selector(callSaveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //创建地图View
    [self creatMapView];
}

#pragma mark - 创建地图
- (void)creatMapView
{

    _mapView = [[BMKMapView alloc] initWithFrame:self.mapCustomView.bounds];
    [_mapView setZoomLevel:15];
    _mapView.delegate = self;
    
    [self.mapCustomView addSubview:_mapView];
    //定位跟地图为跟随状态，即随时定位
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    [_mapView setCenterCoordinate:KUserManager.currentPt];
    //定位
    locationService = [[BMKLocationService alloc] init];
    locationService.delegate = self;
    //启动定位
    [locationService startUserLocationService];
    //显示定位图层
    _mapView.showsUserLocation = NO;
    [_mapView setCenterCoordinate:KManager.currentPt animated:YES];
    [self addPointAnnotation];
    
//    if (_geocodesearch == nil) {
//        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//        _geocodesearch.delegate = self;
//    }
//
//    
//    
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = KUserManager.currentPt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag)
//    {
//        MyLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        MyLog(@"反geo检索发送失败");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"地图检索出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
}

#pragma mark - 添加标注
- (void)addPointAnnotation
{
    
    //移除地图上所有标注点
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
//    //标注1
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    
    pointAnnotation.coordinate = KManager.currentPt;
//    pointAnnotation.title = KUserManager.car.plate;
//    pointAnnotation.title = KUserManager.userDefaultVehicle[@"plate"];
    pointAnnotation.title = userInfo.defaultVehiclePlate;
    [_mapView addAnnotation:pointAnnotation];
    
    
}

#pragma mark - 地址按钮
- (void)addressButtonPressed:(UIButton *)sender
{
    
    CWSSearchAddressViewController *vc = [[CWSSearchAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 紧急救援
- (void)callSaveButtonPressed:(UIButton *)sender
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"4007930888" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    [alert show];
}


#pragma mark - 地图反向解码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
    
        //移除地图上所有标注点
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        
        //    //标注1
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        
        pointAnnotation.coordinate = KManager.currentPt;
        //    pointAnnotation.title = KUserManager.car.plate;
//        pointAnnotation.title = KUserManager.userDefaultVehicle[@"plate"];
        pointAnnotation.title = userInfo.defaultVehiclePlate;
        [_mapView addAnnotation:pointAnnotation];
        _mapView.centerCoordinate = KUserManager.currentPt;
        
    }
}

#pragma mark - <BMKMapViewDelegate>
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    BMKAnnotationView* view = nil;
    view = [_mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    if (view == nil) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"identifier"];
//        view.image = [UIImage imageNamed:@"jiuyuan_chepaihao"];
        view.image = [self getAnnotationImageView];
        view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
        view.canShowCallout = YES;
    }
    
    //自定义气泡
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiuyuan_kuang"]];
    [imageView setFrame:backView.frame];
    [backView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, backView.frame.size.width, backView.frame.size.height)];
//    label.text = KUserManager.car.plate;
//    label.text = KUserManager.userDefaultVehicle[@"plate"];
    label.text = userInfo.defaultVehiclePlate;
    label.textColor = kMainColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [backView addSubview:label];
    
    BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:backView];
    view.paopaoView = nil;
    view.paopaoView = paopaoView;
    
    view.annotation = annotation;
    return view;
}

- (UIImage *)getAnnotationImageView
{
    UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 110)];
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 90, 100)];
    lImageView.image = [UIImage imageNamed:@"jiuyuan_chepaihao"];
    [markView addSubview:lImageView];
    
    UIImageView* logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 20, 40, 40)];
    
//    NSLog(@"%@",KUserManager.car.logo);
//    [logoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],KUserManager.car.logo]] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageLowPriority];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS, userInfo.photo]];
    [logoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"infor_moren.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageRefreshCached];
    
    [markView addSubview:logoImageView];
    
    return [Utils imageFromView:markView];
}


#pragma mark - 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    
    NSLog(@"点击气泡");
}


#pragma mark - BMKLocationServiceDelegate
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"启动定位");
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"停止定位");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"方向更新");
    
    [_mapView updateLocationData:userLocation];
    
    
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"位置更新");
    
    [_mapView updateLocationData:userLocation];
    
}


/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
    [alert show];
    
}

#pragma mark - <UIAlertViewDelegate>
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){//拨打
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
        ;
    }
    
}


@end
