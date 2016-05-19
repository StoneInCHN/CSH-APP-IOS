//
//  CWSFindMapView.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindMapView.h"


@interface RouteMarkAnnotation : BMKPointAnnotation
{
    int _type;  //0.普通标记  1.车辆标记  3.点击标记
    int _degree;
    NSString* currentTime;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@property (strong, nonatomic) NSDictionary* dic;
@end

@implementation RouteMarkAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@implementation CWSFindMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatMapView];
    }
    return self;
}
#pragma mark - 创建地图
-(void)creatMapView{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:17];
    [self addSubview:_mapView];
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark - 数据刷新
-(void)reloadData:(FindMapData*)findMapData type:(int)type{
    _type = type;
    _findMapData = findMapData;
    switch (type) {
        case 1:
        {
            [self addCoord:findMapData.coordArray type:1];
        }
            break;
        case 2:
        {
            [_mapView setTrafficEnabled:findMapData.traffic];
            return;
        }
            break;
        case 3:
        {
            [self addCoord:findMapData.coordArray type:3];
        }
            break;
            
        default:
            break;
    }
    if (findMapData.nearbyCar) {
        [self dingwei];
    }else{
        [self shouji];
    }
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
    _mapView.centerCoordinate = _findMapData.point;
}
#pragma mark - 定位
-(void)dingwei{
    
    if (_caritem == nil) {
        _caritem = [[RouteMarkAnnotation alloc]init];
        _caritem.type = 0;
    }
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _caritem.coordinate = _findMapData.point;
    _caritem.title = _findMapData.carAddress;
    _mapView.centerCoordinate = _findMapData.point;
    [_mapView addAnnotation:_caritem];
}
#pragma mark - 添加标注点
-(void)addCoord:(NSArray*)coordArray type:(int)type{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    for (int i = 0; i < coordArray.count; i++) {
        Interest* coordinate = coordArray[i];
        RouteMarkAnnotation* item = [[RouteMarkAnnotation alloc]init];
        if (i == 0) {
            item.type = type + 1;
        }else{
            item.type = type;
        }
        item.coordinate = (CLLocationCoordinate2D){[coordinate.lat floatValue], [coordinate.lng floatValue]};
        item.title = [NSString stringWithFormat:@"%i",i];
        [_mapView addAnnotation:item];

    }
}
#pragma mark - 改变地图显示大小
-(void)changeMapZoomLevel:(int)Level{
    if (_mapView.zoomLevel <= 19 && _mapView.zoomLevel >= 3) {
        _mapView.zoomLevel += Level;
    }
}
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
#pragma mark - 地图大头针点击
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSString* name = view.annotation.title;
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    for (RouteMarkAnnotation* pointAnnotation in array) {
        if (pointAnnotation.type != 0) {
            [_mapView removeAnnotation:pointAnnotation];
        }
    }
    //    [self addLocationPoint];
    int temp = 0;
    Interest* currentPoi;
    for (Interest* poi in _findMapData.coordArray) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.lat floatValue], [poi.lng floatValue]};
        RouteMarkAnnotation* pointAnnotation = [[RouteMarkAnnotation alloc]init];
        if ([[NSString stringWithFormat:@"%i",temp] isEqualToString:name]) {
            pointAnnotation.type = self.type + 1;
            currentPoi = poi;
        }else{
            pointAnnotation.type = self.type;
        }
        pointAnnotation.coordinate = pt;
        pointAnnotation.title = [NSString stringWithFormat:@"%i",temp];
        [_mapView addAnnotation:pointAnnotation];
        temp ++;
    }
    [self.delegate pointClick:currentPoi];
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteMarkAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"car"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"car"];
                view.image = [UIImage imageNamed:@"chedongtai_car"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"location"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"location"];
                view.image = [UIImage imageNamed:@"chewei_location"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"clickLocation"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"clickLocation"];
                view.image = [UIImage imageNamed:@"chewei_locationi_click"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"oilCoord"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"oilCoord"];
                view.image = [UIImage imageNamed:@"jiayouzhan"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"oilCoordClick"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"oilCoordClick"];
                view.image = [UIImage imageNamed:@"jiayouzhan_click"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[RouteMarkAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteMarkAnnotation*)annotation];
    }
    return nil;
}
@end
