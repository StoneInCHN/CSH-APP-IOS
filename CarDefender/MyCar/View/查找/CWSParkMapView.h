//
//  CWSParkMapView.h
//  CarDefender
//
//  Created by 周子涵 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "FindMapData.h"
#import "Park.h"

@class ParkAnnotation;

@protocol CWSFindMapDelegate <NSObject>
@optional
-(void)pointClick:(NSString*)name;
-(void)mapZoomLevel:(CGFloat)level;
@end

@interface CWSParkMapView : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    FindMapData*             _findMapData; //数据
    BMKMapView*              _mapView;     //地图
    BMKLocationService*      _locService;  //定位
    ParkAnnotation*          _caritem;     //
}
@property (assign, nonatomic) id<CWSFindMapDelegate>    delegate;
@property (assign, nonatomic) int                       type;
#pragma mark - 数据刷新
-(void)reloadData:(FindMapData*)findMapData type:(int)type;
-(void)changeMapZoomLevel:(int)Level;
-(void)backPoint:(CLLocationCoordinate2D)point;
-(void)reloadParkAnnotation:(NSString*)name;//刷新选中点
@end
