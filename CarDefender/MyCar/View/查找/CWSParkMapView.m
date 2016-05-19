//
//  CWSParkMapView.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSParkMapView.h"
#define kMARK_VIEW_WIDTH 73
#define kMARK_VIEW_HIGHT 48

@interface ParkAnnotation : BMKPointAnnotation
{
    int _type;  //0.普通标记  1.车辆标记  3.点击标记
    int _degree;
    NSString* leftNumber;
    NSString* currentTime;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@property (nonatomic) NSString* leftNumber;
@property (strong, nonatomic) NSDictionary* dic;
@end

@implementation ParkAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@synthesize leftNumber = _leftNumber;
@end

@implementation CWSParkMapView

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
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
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
    self.type = type;
    _findMapData = findMapData;
    switch (type) {
        case 1:
        {
            [self addCoord:findMapData type:1];
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
            [self addCoord:findMapData type:3];
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
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    //    _mapView.centerCoordinate = _findMapData.point;
}
#pragma mark - 定位
-(void)dingwei{
    
    if (_caritem == nil) {
        _caritem = [[ParkAnnotation alloc]init];
        _caritem.type = 0;
    }
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _caritem.coordinate = _findMapData.point;
    _caritem.title = _findMapData.carAddress;
    _mapView.centerCoordinate = _findMapData.point;
    [_mapView addAnnotation:_caritem];
}
#pragma mark - 添加标注点
-(void)addCoord:(FindMapData*)findMaptData type:(int)type{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    int currentTemp = 0;
    for (int i = 0; i < findMaptData.coordArray.count; i++) {
        if (i == 0) {
//            item.type = type + 1;
            currentTemp = i;
        }else{
            Park* coordinate = findMaptData.coordArray[i];
            ParkAnnotation* item = [[ParkAnnotation alloc]init];
            item.type = type;
            item.leftNumber = coordinate.leftNum;
            item.coordinate = (CLLocationCoordinate2D){[coordinate.latitude floatValue], [coordinate.longitude floatValue]};
            item.title = [NSString stringWithFormat:@"%i",i];
            [_mapView addAnnotation:item];
        }
    }
    
    int temp = 10;
    for (Park* coordinate in findMaptData.minorCoordArray) {
        ParkAnnotation* item = [[ParkAnnotation alloc]init];
        item.type = 5;
        item.leftNumber = coordinate.leftNum;
        item.coordinate = (CLLocationCoordinate2D){[coordinate.latitude floatValue], [coordinate.longitude floatValue]};
        item.title = [NSString stringWithFormat:@"%i",temp];
        [_mapView addAnnotation:item];
        temp ++;
    }
    Park* coordinate = findMaptData.coordArray[currentTemp];
    ParkAnnotation* item = [[ParkAnnotation alloc]init];
    item.type = type + 1;
    item.leftNumber = coordinate.leftNum;
    item.coordinate = (CLLocationCoordinate2D){[coordinate.latitude floatValue], [coordinate.longitude floatValue]};
    item.title = [NSString stringWithFormat:@"%i",currentTemp];
    [_mapView addAnnotation:item];
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
#pragma mark - 返回地图中心位置
-(void)backPoint:(CLLocationCoordinate2D)point{
    _mapView.centerCoordinate = point;
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
#pragma mark - 地图大头针点击事件
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSString* name = view.annotation.title;
    [self.delegate pointClick:name];
    [self reloadParkAnnotation:name];
}
-(void)reloadParkAnnotation:(NSString*)name{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    for (ParkAnnotation* pointAnnotation in array) {
        if (pointAnnotation.type != 0) {
            [_mapView removeAnnotation:pointAnnotation];
        }
    }
    int temp = 0;
    int currentTemp = 0;
    Park* currentPoi;
    for (Park* poi in _findMapData.coordArray) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.latitude floatValue], [poi.longitude floatValue]};
        
        if ([[NSString stringWithFormat:@"%i",temp] isEqualToString:name]) {
            //            pointAnnotation.type = self.type + 1;
            //            currentPoi = poi;
            currentTemp = temp;
        }else{
            ParkAnnotation* pointAnnotation = [[ParkAnnotation alloc]init];
            pointAnnotation.type = self.type;
            pointAnnotation.leftNumber = poi.leftNum;
            pointAnnotation.coordinate = pt;
            pointAnnotation.title = [NSString stringWithFormat:@"%i",temp];
            [_mapView addAnnotation:pointAnnotation];
        }
        temp ++;
    }
    Park* poi = _findMapData.coordArray[currentTemp];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.latitude floatValue], [poi.longitude floatValue]};
    ParkAnnotation* pointAnnotation = [[ParkAnnotation alloc]init];
    pointAnnotation.type = self.type + 1;
    currentPoi = poi;
    pointAnnotation.leftNumber = poi.leftNum;
    pointAnnotation.coordinate = pt;
    pointAnnotation.title = [NSString stringWithFormat:@"%i",currentTemp];
    [_mapView addAnnotation:pointAnnotation];
    
    for (Park* coordinate in _findMapData.minorCoordArray) {
        ParkAnnotation* pointAnnotation = [[ParkAnnotation alloc]init];
        pointAnnotation.type = 5;
        if ([[NSString stringWithFormat:@"%i",temp] isEqualToString:name]) {
            currentPoi = coordinate;
        }
        pointAnnotation.leftNumber = coordinate.leftNum;
        pointAnnotation.coordinate = (CLLocationCoordinate2D){[coordinate.latitude floatValue], [coordinate.longitude floatValue]};
        pointAnnotation.title = [NSString stringWithFormat:@"%i",temp];;
        [_mapView addAnnotation:pointAnnotation];
        temp ++;
    }
    
    _mapView.centerCoordinate = (CLLocationCoordinate2D){[currentPoi.latitude floatValue], [currentPoi.longitude floatValue]};
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(ParkAnnotation*)routeAnnotation
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
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.image = [self getAnnotationImageView:1 leftNumber:routeAnnotation.leftNumber];
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"clickLocation"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"clickLocation"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.image = [self getAnnotationImageView:2 leftNumber:routeAnnotation.leftNumber];
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"oilCoord"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"oilCoord"];
                view.image = [UIImage imageNamed:@"you_zuobiao"];
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
                view.image = [UIImage imageNamed:@"you_click"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = YES;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"minorCoord"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"minorCoord"];
                view.image = [self getMinorAnnotationImageView];
                //                view.image = [UIImage imageNamed:@"zhaochewei_location"];
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
-(UIImage *)getAnnotationImageView:(int)type leftNumber:(NSString*)leftNumber{
    UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMARK_VIEW_WIDTH, kMARK_VIEW_HIGHT)];
    
    UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kMARK_VIEW_WIDTH - 30, 36)];
    lLabel.font = kFontOfSize(22);
    [lLabel setTextAlignment:NSTextAlignmentCenter];
    if ([leftNumber intValue] > 99) {
        lLabel.text = @"99";
    }else{
        lLabel.text = leftNumber;
    }
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:markView.frame];
    switch (type) {
        case 1:
        {
            lImageView.image = [UIImage imageNamed:@"zhaochewei_p2-"];
            lLabel.textColor = kMainColor;
        }
            break;
        case 2:
        {
            lImageView.image = [UIImage imageNamed:@"zhaochewei_p_click2"];
            lLabel.textColor = kInsertRedColor;
        }
            break;
            
        default:
            break;
    }
    [markView addSubview:lImageView];
    [markView addSubview:lLabel];
    return [self getImageFromView:markView];
}
-(UIImage *)getMinorAnnotationImageView{
    UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMARK_VIEW_WIDTH, kMARK_VIEW_HIGHT)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, 9, 20, 30)];
    imageView.image = [UIImage imageNamed:@"zhaochewei_location"];
    [markView addSubview:imageView];
    return [self getImageFromView:markView];
    
}
#pragma mark - 将VIEW转换成图片
-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[ParkAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(ParkAnnotation*)annotation];
    }
    return nil;
}
#pragma mark - 地图
-(void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status
{
    [self.delegate mapZoomLevel:mapView.zoomLevel];
}
@end
