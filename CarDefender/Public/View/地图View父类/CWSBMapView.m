//
//  CWSBMapView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSBMapView.h"


@implementation CWSBMapView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.初始化数据
        _levelArray = @[@"10米",@"20米",@"50米",@"100米",@"500米",@"1公里",@"2公里",@"5公里",@"10公里",@"20公里",@"25公里",@"50公里",@"100公里",@"200公里",@"500公里",@"1000公里",@"2000公里",@"2000公里"];
        //2.创建地图视图
        [self creatMapView];
    }
    return self;
}
- (void)dealloc {
    if (_mapView != nil) {
        _mapView = nil;
        _mapView.delegate = nil;
    }
}
#pragma mark - 创建地图
-(void)creatMapView{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:17];
    [self addSubview:_mapView];
}


#pragma mark - 改变地图显示大小
-(void)changeMapZoomLevel:(int)Level{
    int lChange = _mapView.zoomLevel + Level;
    if (lChange > 20) {
        lChange = 20;
    }else if (lChange < 3){
        lChange = 3;
    }
    _mapView.zoomLevel = lChange;
}
#pragma mark - 手机定位
-(void)shouji{
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.centerCoordinate = KManager.mobileCurrentPt;
}
#pragma mark - 定位
-(void)locationWithPoint:(CLLocationCoordinate2D)point Annotation:(CWSPointAnnotation*)annotation{
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    annotation.coordinate = point;
    _mapView.centerCoordinate = point;
    [_mapView addAnnotation:annotation];
}
#pragma mark - 地图代理协议

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
#pragma mark - 改变路况
-(void)changeTraffic:(BOOL)traffic{
    [_mapView setTrafficEnabled:traffic];
}
#pragma mark - 按钮点击事件
-(void)btnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        MyLog(@"回到默认点");
        _mapView.centerCoordinate = self.normalPoint;
    }else if (sender.tag == 2){
        [self changeMapZoomLevel:1];
    }else{
        [self changeMapZoomLevel:-1];
    }
}
@end
