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
#import "CWSBMapView.h"

@class ParkAnnotation;

@protocol CWSFindMapDelegate <NSObject>
@optional
-(void)pointClick:(NSString*)name;
@end

@interface CWSParkMapView : CWSBMapView<BMKGeoCodeSearchDelegate>
{
    FindMapData*             _findMapData; //数据
//    BMKLocationService*      _locService;  //定位
    ParkAnnotation*          _caritem;     //地图描点
}
@property (assign, nonatomic) id<CWSFindMapDelegate>    delegate;
@property (assign, nonatomic) int                       type;
#pragma mark - 数据刷新
-(void)reloadData:(FindMapData*)findMapData type:(int)type;
//刷新选中点
-(void)reloadParkAnnotation:(NSString*)name;

@end
