//
//  CWSBMapView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "CWSPointAnnotation.h"

@interface CWSBMapView : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView*              _mapView;      //地图
    BMKLocationService*      _locService;   //定位
    UIButton*                _levelBtn;     //比例尺视图
    NSArray*                 _levelArray;   //比例尺数据集
    CGFloat                  _levelWidth;   //比例尺视图宽度
    CGFloat                  _normalHight;  //视图高度
}
@property (assign, nonatomic)CLLocationCoordinate2D normalPoint;  //默认坐标

//改变地图显示大小
-(void)changeMapZoomLevel:(int)Level;
//车辆定位
-(void)locationWithPoint:(CLLocationCoordinate2D)point Annotation:(CWSPointAnnotation*)annotation;
//手机定位
-(void)shouji;
//改变路况方法
-(void)changeTraffic:(BOOL)traffic;
@end
