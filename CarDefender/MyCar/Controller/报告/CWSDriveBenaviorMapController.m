//
//  CWSDriveBenaviorMapController.m
//  CarDefender

//  查看地图
//
//  Created by 周子涵 on 15/5/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSDriveBenaviorMapController.h"

@interface CWSDriveBenaviorMapController ()

@end

@implementation CWSDriveBenaviorMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - 44)];
    [_mapView setZoomLevel:17];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.view insertSubview:_mapView atIndex:0];
    
    
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = (CLLocationCoordinate2D){[self.lat floatValue], [self.lon floatValue]};
    item.title = [NSString stringWithFormat:@"地址: %@",self.address];
    [_mapView addAnnotation:item];
    
    _mapView.centerCoordinate = (CLLocationCoordinate2D){[self.lat floatValue], [self.lon floatValue]};
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"driveBehaviorMap";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    annotationView.image = [UIImage imageNamed:@"zuji_loc"];
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
@end
