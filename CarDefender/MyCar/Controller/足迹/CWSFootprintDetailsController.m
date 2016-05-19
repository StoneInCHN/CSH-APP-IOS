//
//  CWSFootprintDetailsController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/21.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFootprintDetailsController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface FootprintAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
    NSString* currentTime;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation FootprintAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface CWSFootprintDetailsController ()
{
    BMKMapView* _mapView;
    BMKPolyline* polyline;
    NSString* _deviceNO;
    bool isGeoSearch;
}
@end

@implementation CWSFootprintDetailsController
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - 44)];
    [_mapView setZoomLevel:17];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.view insertSubview:_mapView atIndex:0];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    if (![self.footprint.type isEqualToString:@"0"]) {
        self.loacationArray = self.footprint.latAndlonDic[@"body"][@"results"];
        NSDictionary* lDic = [self.loacationArray lastObject];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){[lDic[@"lat"] floatValue], [lDic[@"lon"] floatValue]};
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            MyLog(@"反geo检索发送成功");
        }
        else
        {
            MyLog(@"反geo检索发送失败");
        }
        [self addPoint];
        [self addPointAnnotation];
    }else{
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        pt = (CLLocationCoordinate2D){[self.lat floatValue], [self.lon floatValue]};
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            MyLog(@"反geo检索发送成功");
        }
        else
        {
            MyLog(@"反geo检索发送失败");
        }
        CLLocationCoordinate2D coor;
        coor.latitude = [self.lat floatValue];
        coor.longitude = [self.lon floatValue];
        FootprintAnnotation* item = [[FootprintAnnotation alloc]init];
        item.coordinate = coor;
        item.title = self.footprint.addrStart;
        item.type = 3;
        [_mapView addAnnotation:item];
    }
}
-(void)addPoint{
    //轨迹点
    
    for (int i = 0; i<self.loacationArray.count - 1; i++) {
        CLLocationCoordinate2D coors[2] = {0};
        NSDictionary* locationDic1 = self.loacationArray[i];
        NSDictionary* locationDic2 = self.loacationArray[i+1];
        coors[1].latitude = [locationDic1[@"lat"] floatValue];
        coors[1].longitude = [locationDic1[@"lon"] floatValue];
        coors[0].latitude = [locationDic2[@"lat"] floatValue];
        coors[0].longitude = [locationDic2[@"lon"] floatValue];
        
        polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
        [_mapView addOverlay:polyline];
    }
}
- (void)addPointAnnotation
{
    NSDictionary* locationDic1 = self.loacationArray[0];
    CLLocationCoordinate2D coor;
    coor.latitude = [locationDic1[@"lat"] floatValue];
    coor.longitude = [locationDic1[@"lon"] floatValue];
    FootprintAnnotation* item = [[FootprintAnnotation alloc]init];
    item.coordinate = coor;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item];
    
    NSDictionary* locationDic2 = self.loacationArray[0];
    CLLocationCoordinate2D coor2;
    coor.latitude = [locationDic2[@"lat"] floatValue];
    coor.longitude = [locationDic2[@"lon"] floatValue];
    FootprintAnnotation* item2 = [[FootprintAnnotation alloc]init];
    item.coordinate = coor2;
    item.title = @"终点";
    item.type = 1;
    [_mapView addAnnotation:item2];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(FootprintAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"guiji_qi_location"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"guiji_zhong_location"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"zuji_location2"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"zuji_location2"];
                view.image = [UIImage imageNamed:@"zuji_loc"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[FootprintAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(FootprintAnnotation*)annotation];
    }
    return nil;
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        NSDictionary* locationDic1 = self.loacationArray[0];
        CLLocationCoordinate2D coor;
        coor.latitude = [locationDic1[@"lat"] floatValue];
        coor.longitude = [locationDic1[@"lon"] floatValue];
        FootprintAnnotation* item = [[FootprintAnnotation alloc]init];
        item.coordinate = coor;
        item.title = @"起点";
        item.type = 0;
        [_mapView addAnnotation:item];
        
        NSDictionary* locationDic2 = [self.loacationArray lastObject];
        CLLocationCoordinate2D coor2;
        coor2.latitude = [locationDic2[@"lat"] floatValue];
        coor2.longitude = [locationDic2[@"lon"] floatValue];
        FootprintAnnotation* item2 = [[FootprintAnnotation alloc]init];
        item2.coordinate = coor2;
        item2.title = @"终点";
        item2.type = 1;
        [_mapView addAnnotation:item2];
        _mapView.centerCoordinate = result.location;
    }
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
@end
