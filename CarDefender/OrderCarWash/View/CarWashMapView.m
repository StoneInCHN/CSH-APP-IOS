//
//  CarWashMapView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarWashMapView.h"
#import "ParkAnnotation.h"
#define kMARK_VIEW_WIDTH 73
#define kMARK_VIEW_HIGHT 48

@implementation CarWashMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.初始化数据
        _caritem = [[ParkAnnotation alloc]init];
        _caritem.type = 0;
        _normalHight = 106;
        //2.创建默认视图
        [self creatNormalView];
    }
    return self;
}
#pragma mark - 创建基本视图
-(void)creatNormalView{
    //1.创建level视图
    _levelWidth = 38;
    _levelBtn = [Utils buttonWithFrame:CGRectMake(51, self.frame.size.height - 133, 38, 27) title:nil titleColor:KBlackMainColor font:kFontOfSize(8)];
    _levelBtn.userInteractionEnabled = NO;
    [_levelBtn setBackgroundImage:[UIImage imageNamed:@"zhaochewei_dingwei_mi"] forState:UIControlStateNormal];
    [self addSubview:_levelBtn];
    //2.创建回到默认点视图
    [self creatBtn:CGRectMake(10, self.frame.size.height - _normalHight  - 34, 34, 34) imageName:@"zhaochewei_dingwei_icon" tag:1];
    //3.创建放大按钮
    [self creatBtn:CGRectMake(self.frame.size.width - 40, self.frame.size.height - _normalHight - 70, 30, 35) imageName:@"zhaochewei_fangda_click_up" tag:2];
    //4.创建缩小按钮
    [self creatBtn:CGRectMake(self.frame.size.width - 40, self.frame.size.height - _normalHight - 35, 30, 35) imageName:@"zhaochewei_fangda_click_down" tag:3];
}
#pragma mark - 创建按钮公共方法
-(void)creatBtn:(CGRect)frame imageName:(NSString*)imageName tag:(int)tag{
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [self addSubview:btn];
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
        [self locationWithPoint:_findMapData.point Annotation:_caritem];
    }else{
        [self shouji];
    }
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
    int currentTemp = -1;
    Park* currentPoi;
    for (Park* poi in _findMapData.coordArray) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.latitude floatValue], [poi.longitude floatValue]};
        if ([[NSString stringWithFormat:@"%i",temp] isEqualToString:name]) {
            currentTemp = temp;
        }else{
            ParkAnnotation* pointAnnotation = [[ParkAnnotation alloc]init];
            pointAnnotation.type = 1;
            pointAnnotation.leftNumber = poi.leftNum;
            pointAnnotation.coordinate = pt;
            pointAnnotation.title = [NSString stringWithFormat:@"%i",temp];
            [_mapView addAnnotation:pointAnnotation];
        }
        temp ++;
    }
    if (currentTemp != -1) {
        Park* poi = _findMapData.coordArray[currentTemp];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.latitude floatValue], [poi.longitude floatValue]};
        ParkAnnotation* pointAnnotation = [[ParkAnnotation alloc]init];
        pointAnnotation.type = 2;
        currentPoi = poi;
        pointAnnotation.leftNumber = poi.leftNum;
        pointAnnotation.coordinate = pt;
        pointAnnotation.title = [NSString stringWithFormat:@"%i",currentTemp];
        [_mapView addAnnotation:pointAnnotation];
    }
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
                view.image = [UIImage imageNamed:@"zhaochewei_weizhi"];
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

#pragma mark - 把获取地图描点视图
-(UIImage *)getAnnotationImageView:(int)type leftNumber:(NSString*)leftNumber{
    UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMARK_VIEW_WIDTH, kMARK_VIEW_HIGHT)];
    
    UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kMARK_VIEW_WIDTH - 30, 36)];
    lLabel.font = kFontOfSize(22);
    [lLabel setTextAlignment:NSTextAlignmentCenter];
    if ([leftNumber intValue] > 99) {
        lLabel.text = @"99";
    }else if ([leftNumber intValue] == -1){
        lLabel.text = @"--";
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
    return [Utils imageFromView:markView];
}
#pragma mark - 获取水滴视图
-(UIImage *)getMinorAnnotationImageView{
    UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMARK_VIEW_WIDTH, kMARK_VIEW_HIGHT)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, 9, 20, 30)];
    imageView.image = [UIImage imageNamed:@"zhaochewei_location"];
    [markView addSubview:imageView];
    return [Utils imageFromView:markView];
    
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[ParkAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(ParkAnnotation*)annotation];
    }
    return nil;
}
#pragma mark - 地图放大缩小代理协议
-(void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status
{
    [_levelBtn setTitle:[NSString stringWithFormat:@"%@",_levelArray[_levelArray.count + 2 - (int)mapView.zoomLevel]] forState:UIControlStateNormal];
    CGRect frame = _levelBtn.frame;
    frame.size.width = _levelWidth + _levelWidth*2/3*(mapView.zoomLevel - (int)mapView.zoomLevel);
    _levelBtn.frame = frame;
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
