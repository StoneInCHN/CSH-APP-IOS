//
//  CWSFindMapView.h
//  CarDefender
//
//  Created by 周子涵 on 15/6/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "FindMapData.h"
#import "Interest.h"

@class RouteMarkAnnotation;

@protocol CWSFindMapDelegate <NSObject>
@optional
-(void)pointClick:(Interest*)interest;
@end
@interface CWSFindMapView : UIView <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    FindMapData*             _findMapData; //数据
    BMKMapView*              _mapView;     //地图
    BMKLocationService*      _locService;  //定位
    RouteMarkAnnotation*     _caritem;     //
}
@property (assign, nonatomic) id<CWSFindMapDelegate>    delegate;
@property (assign, nonatomic) int                       type;
#pragma mark - 数据刷新
-(void)reloadData:(FindMapData*)findMapData type:(int)type;
-(void)changeMapZoomLevel:(int)Level;
@end
