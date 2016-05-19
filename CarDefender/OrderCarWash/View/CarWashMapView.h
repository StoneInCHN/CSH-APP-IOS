//
//  CarWashMapView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "FindMapData.h"
#import "Park.h"
#import "CWSBMapView.h"

@class ParkAnnotation;

@protocol CWSCarWashMapDelegate <NSObject>
@optional
-(void)pointClick:(NSString*)name;
@end

@interface CarWashMapView : CWSBMapView<BMKGeoCodeSearchDelegate>
{
    FindMapData*             _findMapData; //数据
    ParkAnnotation*          _caritem;     //地图描点
}
@property (assign, nonatomic) id<CWSCarWashMapDelegate>    delegate;
@property (assign, nonatomic) int                          type;
#pragma mark - 数据刷新
-(void)reloadData:(FindMapData*)findMapData type:(int)type;
//刷新选中点
-(void)reloadParkAnnotation:(NSString*)name;


@end
