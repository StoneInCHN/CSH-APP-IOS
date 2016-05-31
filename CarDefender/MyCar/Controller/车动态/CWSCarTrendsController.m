//
//  CWSCarTrendsController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarTrendsController.h"
#import "CWSNavController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface CWSCarTrendsController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BOOL                     _btnStyle;
    BOOL                     _traffic;
    BMKMapView*              _mapView;
    bool                     isGeoSearch;
    BMKGeoCodeSearch*        _geocodesearch;
    BMKLocationService*      _locService;
//    BMKRouteSearch*          _routesearch;
    BMKPolyline*             _polyline;
    NSMutableArray*          _locationDicArray;
    BOOL                     _shouji;
    NSTimer*                 _timer;
    NSString*                _azimuth;
    CGFloat                  _temp;
    UIButton                 *rightButton;
}
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation CWSCarTrendsController
-(void)GPSNewCarInfoRun{
    MyLog(@"%@",KUserManager.car.carId);
    if (KUserManager.uid == nil) {//登录
        [self changeBtn:11];
        return;
    }
    
    if (KUserManager.userCID == nil) {
        [self changeBtn:11];
        return;
    }
    
    if (!_shouji) {
#if USENEWVERSION
        if (KUserManager.userDefaultVehicle[@"device"] == nil || [KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
//            [self changeBtn:11];
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能看到您爱车附近的车位噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:KUserManager.uid forKey:@"uid"];
        [dic setValue:KUserManager.mobile forKey:@"mobile"];
        [dic setValue:KUserManager.userCID forKey:@"cid"];
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        [ModelTool getLocationWithParameter:dic andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"%@",object);

                    KManager.currentPt = CLLocationCoordinate2DMake([object[@"data"][@"lat"] floatValue], [object[@"data"][@"lon"] floatValue]);
                    
//                    if ([dic[@"data"][@"isMode"] isEqualToString:@"0"]) {
//                        
//                        [rightButton setBackgroundImage:[UIImage imageNamed:@"dongtai_gps_1"] forState:UIControlStateNormal];
//                    }else{
//                        [rightButton setBackgroundImage:[UIImage imageNamed:@"dongtai_gprs_1"] forState:UIControlStateNormal];
//                    }
                    
                    self.timeLabel.text = @"--:--:--";
                    
                    
                    CLLocationCoordinate2D  lPoint = CLLocationCoordinate2DMake([object[@"data"][@"lat"] floatValue], [object[@"data"][@"lon"] floatValue]);
                    [_locationDicArray addObject:@{@"latitude":[NSString stringWithFormat:@"%f",lPoint.latitude],@"longitude":[NSString stringWithFormat:@"%f",lPoint.longitude]}];
                    self.mileageLabel.text = [NSString stringWithFormat:@"%.2f km",[object[@"data"][@"mile"] integerValue]/1000.0];
                    self.oilLabel.text = @"- L/km";
                    self.speedLabel.text = [NSString stringWithFormat:@"%@ km/h",object[@"data"][@"speed"]];
                    [self dingwei:lPoint];
                    
                }
                else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            });
            
        } andFail:^(NSError *err) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统有错误，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
        
        
#else
        if ([KUserManager.car.carId isEqualToString:@""]) {
            [self changeBtn:11];
            return;
        }
        MyLog(@"%@",KUserManager.car.carId);
        
        NSDictionary* dic;
        if (self.notiDic != nil) {
            dic = @{@"cid":self.notiDic[@"cid"],@"uid":KUserManager.uid,@"key":KUserManager.key};
        }else{
            dic = @{@"cid":KUserManager.car.cid,@"uid":KUserManager.uid,@"key":KUserManager.key};
        }
        [ModelTool httpGetGPSNewCarInfoWithParameter:dic success:^(id object) {
            NSDictionary* dic = object;
            MyLog(@"%@",dic);
            MyLog(@"%@",dic[@"data"][@"data"][@"body"][@"status"]);
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([dic[@"data"][@"isMode"] isEqualToString:@"0"]) {
                        
                        [rightButton setBackgroundImage:[UIImage imageNamed:@"dongtai_gps_1"] forState:UIControlStateNormal];
                    }else{
                        [rightButton setBackgroundImage:[UIImage imageNamed:@"dongtai_gprs_1"] forState:UIControlStateNormal];
                    }
                    if ([dic[@"data"][@"start"] isEqualToString:@""]  || [dic[@"data"][@"data"][@"body"][@"status"] isEqualToString:@"%u7184%u706b"]) {
                        self.timeLabel.text = @"--:--:--";
                    }else{
                        NSString* timeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",[Utils getTime][0],[Utils getTime][1],[Utils getTime][2],[Utils getTime][3],[Utils getTime][4],[Utils getTime][5]];
                        //                        self.timeLabel.text = [Utils getStartTime:[dic[@"data"][@"start"] currentTime:timeStr];
                        self.timeLabel.text = [Utils getStartTime:dic[@"data"][@"start"] currentTime:timeStr];
                    }
                    _azimuth = dic[@"data"][@"data"][@"body"][@"azimuth"];
                    CLLocationCoordinate2D  lPoint = (CLLocationCoordinate2D){29.565,106.549};
                    [_locationDicArray addObject:@{@"latitude":[NSString stringWithFormat:@"%f",lPoint.latitude],@"longitude":[NSString stringWithFormat:@"%f",lPoint.longitude]}];
                    self.mileageLabel.text = [NSString stringWithFormat:@"%@ km",dic[@"data"][@"data"][@"body"][@"mile"]];
                    self.oilLabel.text = [NSString stringWithFormat:@"%.1f L/km",[dic[@"data"][@"data"][@"body"][@"obdifc"] floatValue]];
                    self.speedLabel.text = [NSString stringWithFormat:@"%@ km/h",dic[@"data"][@"data"][@"body"][@"speed"]];
                    [self dingwei:lPoint];
                });
            }else{
                
            }
        } faile:^(NSError *err) {
            
        }];
        
#endif
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _temp = 0;
    _azimuth = @"0";
    _traffic = NO;
    _shouji = NO;
    _locationDicArray = [NSMutableArray array];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"dongtai_gps_1"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gpsEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
//    [Utils changeBackBarButtonStyle:self];
//    UIBarButtonItem* nav = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chedongtai_daohang"] style:UIBarButtonItemStylePlain target:self action:@selector(navigation)];
//    self.navigationItem.rightBarButtonItem = nav;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.mapType = BMKMapTypeStandard;
    [_mapView setZoomLevel:16];
    [self.view insertSubview:_mapView atIndex:0];
    
//    _oldPt = (CLLocationCoordinate2D){29.565, 106.549};
//    [self GPSNewCarInfoRun];
//    if (_timer == nil) {
//         _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(GPSNewCarInfoRun) userInfo:nil repeats:YES];
//    }
    self.mileageLabel.text = @"0km";
    self.timeLabel.text = @"0s";
    self.speedLabel.text = @"0km/h";
    self.oilLabel.text = @"0/100km";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(carTrendNotiMsgBack:) name:@"currentIsCarTrend" object:nil];
    MyLog(@"%@",self.notiDic);
    [self initWithData];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(initWithData) userInfo:nil repeats:YES];
}
- (void)gpsEvent {
    [MBProgressHUD showSuccess:@"pgs clicked!" toView:self.view];
}
- (void)initWithData {
    UserInfo *userInfo = [UserInfo userDefault];
    if (!_shouji) {
        [HttpHelper carTrendsWithUserId:userInfo.desc
                                  token:userInfo.token
                               deviceNo:userInfo.defaultDeviceNo
                                success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                    NSLog(@"car trends response :%@",responseObjcet);
                                    NSDictionary *dict = (NSDictionary *)responseObjcet;
                                    userInfo.token = dict[@"token"];
                                    NSString *code = dict[@"code"];
                                    if ([code isEqualToString:SERVICE_SUCCESS]) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            _azimuth = dict[@"azimuth"];
                                            CLLocationCoordinate2D  lPoint = CLLocationCoordinate2DMake([dict[@"msg"][@"lat"] floatValue], [dict[@"msg"][@"lon"] floatValue]);
                                            [_locationDicArray addObject:@{@"latitude":[NSString stringWithFormat:@"%f",lPoint.latitude],@"longitude":[NSString stringWithFormat:@"%f",lPoint.longitude]}];
                                            NSLog(@"location dic array:%@",_locationDicArray);
                                            self.mileageLabel.text = [NSString stringWithFormat:@"%@km",dict[@"msg"][@"mileAge"]];
                                            self.timeLabel.text = [NSString stringWithFormat:@"%@s",dict[@"msg"][@"engineRuntime"]];
                                            self.speedLabel.text = [NSString stringWithFormat:@"%@km/h",dict[@"msg"][@"speed"]];
                                            self.oilLabel.text = [NSString stringWithFormat:@"%@/100km",dict[@"msg"][@"averageOil"]];
                                            [self dingwei:lPoint];
                                        });
                                    } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                    } else {
                                        [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"one key error :%@",error);
                                    [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                }];
    }
}

#pragma mark - 右键
- (void)rightBarButtonItemClick:(UIBarButtonItem *)item
{
    
}

-(void)setUI{
    
}
#pragma mark - 刷新数据
-(void)carTrendNotiMsgBack:(NSNotification*)sender
{
//    MyLog(@"刷新数据");
    self.notiDic=(NSDictionary*)sender.object;
//    [self GPSNewCarInfoRun];
    [self initWithData];
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [_timer invalidate];
//    _mapView.delegate = nil;
//    [ModelTool stopAllOperation];
//}
-(void)viewDidAppear:(BOOL)animated
{
    //存储当前界面标记
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"CWSCarTrendsController" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _shouji = NO;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _shouji = YES;
    [_timer fire];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //移除
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark - 添加轨迹点
-(void)addPoint{
    if (_locationDicArray.count > 1) {
        for (int i = 0; i <_locationDicArray.count - 1; i++) {
            CLLocationCoordinate2D coors[2] = {0};
            NSDictionary* locationDic1 = _locationDicArray[i];
            NSDictionary* locationDic2 = _locationDicArray[i+1];
            coors[1].latitude = [locationDic1[@"latitude"] floatValue];
            coors[1].longitude = [locationDic1[@"longitude"] floatValue];
            coors[0].latitude = [locationDic2[@"latitude"] floatValue];
            coors[0].longitude = [locationDic2[@"longitude"] floatValue];
            _polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
            [_mapView addOverlay:_polyline];
        }
    }
}
#pragma mark - 画轨迹代理方法
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
#pragma mark - 地图反向解码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (!_shouji) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
    }
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"地址: %@",result.address];
        self.addressLabel.text = result.address;
        if (!_shouji) {
            [_mapView addAnnotation:item];
            
            _mapView.centerCoordinate = result.location;
            _mapView.rotation = [_azimuth intValue];
            [self addPoint];
        }
    }
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.image = [UIImage imageNamed:@"chedongtai_car"];
//    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
//    annotationView.canShowCallout = TRUE;
    annotationView.transform = CGAffineTransformMakeRotation(34 * (M_PI / 180.0f));
//    annotationView.transform = CGAffineTransformRotate(annotationView.transform, M_PI_4);
    return annotationView;
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    CLLocationCoordinate2D point = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
//    [self dingwei:point];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

#pragma mark - 跳转到导航界面
-(void)navigation{
    CWSNavController* lController = [[CWSNavController alloc] init];
    lController.title = @"导航";
    [self.navigationController pushViewController:lController animated:YES];
}
-(void)dingwei:(CLLocationCoordinate2D)point{
    NSLog(@"longitude:%f,latitude%f",point.longitude,point.latitude);
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
        isGeoSearch = false;
    }
    if (_locService != nil) {
        _locService.delegate = self;
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = point;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        MyLog(@"反geo检索发送成功");
    }
    else
    {
        MyLog(@"反geo检索发送失败");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"地图检索出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
}
-(void)shouji{
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            [self changeBtn:10];
        }
            break;
        case 11:
        {
            [self changeBtn:11];
        }
            break;
        case 12:
        {
            MyLog(@"路况");
            [_mapView setTrafficEnabled:!_traffic];
            if (_traffic) {
                [sender setBackgroundImage:[UIImage imageNamed:@"dongtai_lukuang"] forState:UIControlStateNormal];
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"dongtai_lukuang_click"] forState:UIControlStateNormal];
            }
            _traffic = !_traffic;
        }
            break;
            
        default:
            break;
    }
}
-(void)changeBtn:(int)tag{
    if (tag == 10) {
        
        if ([KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能看到您爱车附近的车位噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        _shouji = NO;
        _backgroundView1.hidden = NO;
        _backgroundView2.hidden = NO;
        UIButton* lBtn = (UIButton*)[self.view viewWithTag:10];
        [lBtn setBackgroundImage:[UIImage imageNamed:@"dongtai_mycar_click"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn.tag+1];
        [btn setBackgroundImage:[UIImage imageNamed:@"dongtai_myphone"] forState:UIControlStateNormal];
        
//        [self GPSNewCarInfoRun];
        [self initWithData];
    }else{
        _shouji = YES;
        [_locationDicArray removeAllObjects];
        MyLog(@"手机");
//        _backgroundView1.hidden = YES;
//        _backgroundView2.hidden = YES;
        UIButton* lBtn = (UIButton*)[self.view viewWithTag:11];
        [lBtn setBackgroundImage:[UIImage imageNamed:@"dongtai_myphone_click"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn.tag-1];
        [btn setBackgroundImage:[UIImage imageNamed:@"dongtai_mycar"] forState:UIControlStateNormal];
        [self shouji];
    }
}


- (IBAction)addBtnClcik:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1) {
        if (_mapView.zoomLevel <= 19) {
            _mapView.zoomLevel += 1;
        }
    }else{
        if (_mapView.zoomLevel >= 3) {
            _mapView.zoomLevel -= 1;
        }
    }
}
@end
