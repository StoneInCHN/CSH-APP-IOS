//
//  CWSNavController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSNavController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "FindParkSearchCell.h"
#import "CWSPointAnnotation.h"


@interface CWSNavController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>
{
    bool                      isGeoSearch;
    UISearchBar*             _serchBar;
    CLLocationCoordinate2D   _oldPt;
    CLLocationCoordinate2D   _newPt;
    UITableView*             _tableView;
    NSMutableArray*          _dataArray;
    UIButton*                _naviBtn;
    //地图类
    BMKLocationService*      _locService;
    BMKRouteSearch*          _routesearch;
    BMKSuggestionSearch*     _searcher;
    BMKMapView*              _mapView;
    BMKGeoCodeSearch*        _geocodesearch;
    BMKPolyline*             _polyline;
}
////导航类型，分为模拟导航和真实导航
//@property (assign, nonatomic) BN_NaviType naviType;

@end

@implementation CWSNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    _traffic = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    _city = KManager.currentCity;
    [self creatMapView];
    _serchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    _serchBar.delegate=self;
    [self.view addSubview:_serchBar];
    
    _oldPt = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    
    [self creatTableView];
    [self changeBtn:11];
}
-(void)run{
#if USENEWVERSION
    
#else
    [self showHudInView:self.view hint:@"数据加载中..."];
    NSDictionary* dic = @{@"carId":KUserManager.car.carId,@"uid":KUserManager.uid,@"key":KUserManager.key,@"isMode":@"0"};
    [ModelTool httpGetGPSCarInfoWithParameter:dic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        MyLog(@"%@",dic[@"data"][@"data"][@"body"][@"result"]);
        dispatch_async(dispatch_get_main_queue(), ^{
            CLLocationCoordinate2D lPoint = (CLLocationCoordinate2D){[dic[@"data"][@"data"][@"body"][@"lat"] floatValue], [dic[@"data"][@"data"][@"body"][@"lon"] floatValue]};
            [self dingwei:lPoint];
            [self hideHud];
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
    
#endif
    
    
    
}
#pragma mark - 百度地图点击事件
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [_serchBar resignFirstResponder];
}
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 , kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(void)creatMapView{
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    isGeoSearch = false;
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    _searcher =[[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    [_mapView setZoomLevel:17];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.view insertSubview:_mapView atIndex:0];
    [self.footBackgroundView setFrame:CGRectMake(0, kSizeOfScreen.height - self.footBackgroundView.frame.size.height + kSTATUS_BAR, self.footBackgroundView.frame.size.width, self.footBackgroundView.frame.size.height)];
    self.footBackgroundView.hidden = YES;
    [self.view addSubview:self.footBackgroundView];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark - 反向解码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.footBackgroundView.hidden = NO;
    NSArray* overkays = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overkays];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    if (error == 0) {
        CWSPointAnnotation* item2 = [[CWSPointAnnotation alloc]init];
        item2.type = 2;
        item2.coordinate = (CLLocationCoordinate2D){_oldPt.latitude, _oldPt.longitude};;
        //        item.title = result.address;
        [_mapView addAnnotation:item2];
        
        CWSPointAnnotation* item = [[CWSPointAnnotation alloc]init];
        item.type = 0;
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"地址: %@",result.address];
        self.footMarkLabel.text = @"车辆位置:";
        self.footAddressLabel.text = result.address;
        _city = result.addressDetail.city;
        _newPt = (CLLocationCoordinate2D){item.coordinate.latitude, item.coordinate.longitude};
        [self drawlayOldPt:_oldPt newPt:_newPt];
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
    }
}
#pragma mark - 划线的方法
-(void)drawlayOldPt:(CLLocationCoordinate2D)oldPt newPt:(CLLocationCoordinate2D)newpt{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = oldPt;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = newpt;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    
    if(flag)
    {
        MyLog(@"bus检索发送成功");
    }
    else
    {
        MyLog(@"bus检索发送失败");
    }
}
#pragma mark - 划线的代理方法
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //    [_mapView removeAnnotations:array];
    NSArray* array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        BMKMapPoint* temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(CWSPointAnnotation*)routeAnnotation{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"car"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"car"];
                view.image = [UIImage imageNamed:@"chedongtai_car"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"location"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"location"];
                view.image = [UIImage imageNamed:@"guiji_zhong_location"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"guiji_qi_location"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"guiji_qi_location"];
                view.image = [UIImage imageNamed:@"guiji_qi_location"];
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
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[CWSPointAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(CWSPointAnnotation*)annotation];
    }
    return nil;
}

#pragma mark - 推荐地址代理方法
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        [_dataArray removeAllObjects];
        for (int i = 0; i < result.keyList.count; i++) {
            NSValue* value = result.ptList[i];
            NSDictionary* dataDic = @{@"key":result.keyList[i],
                                      @"city":result.cityList[i],
                                      @"district":result.districtList[i],
                                      @"lat":[NSString stringWithFormat:@"%f",value.CGPointValue.x],
                                      @"lng":[NSString stringWithFormat:@"%f",value.CGPointValue.y]};
            [_dataArray addObject:dataDic];
        }
    }else {
        NSLog(@"抱歉，未找到结果");
        [WCAlertView showAlertWithTitle:@"提示" message:@"抱歉，未找到结果" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        _tableView.hidden = YES;
    }
    [_tableView reloadData];
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    _oldPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _oldPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude};
    [_mapView updateLocationData:userLocation];
}
#pragma mark - searchBar代理协议
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        _tableView.hidden = YES;
    }else{
        _tableView.hidden = NO;
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = _city;
        option.keyword  = searchText;
        BOOL flag = [_searcher suggestionSearch:option];
        if(flag)
        {
            NSLog(@"建议检索发送成功");
        }
        else
        {
            NSLog(@"建议检索发送失败");
        }
    }
    
}
#pragma mark - tableview数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"FindParkSearchCell";
    FindParkSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindParkSearchCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"city"],dic[@"district"]];
    cell.nameLabel.text = dic[@"key"];
    cell.imageView.image = [UIImage imageNamed:@"zhaochewei_sousuo.png"];
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _dataArray[indexPath.row];
    if (![dic[@"city"] isEqualToString:_city]) {
        MyLog(@"城市不对");
    }
    self.footBackgroundView.hidden = NO;
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    NSArray* overlayArray = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overlayArray];
    _newPt = (CLLocationCoordinate2D){[dic[@"lat"] floatValue], [dic[@"lng"] floatValue]};
    
    CWSPointAnnotation* item = [[CWSPointAnnotation alloc]init];
    item.type = 1;
    item.coordinate = _newPt;
    item.title = dic[@"key"];
    self.footMarkLabel.text = @"目的地:";
    self.footAddressLabel.text = dic[@"key"];
    [_mapView addAnnotation:item];
    
    _newPt = (CLLocationCoordinate2D){item.coordinate.latitude, item.coordinate.longitude};
    _naviBtn.hidden = NO;
    
    [self drawlayOldPt:_oldPt newPt:_newPt];
    [_locService stopUserLocationService];
    _mapView.centerCoordinate = _newPt;
    _tableView.hidden = YES;
    [_serchBar resignFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (![searchBar.text isEqualToString:@""]) {
        _tableView.hidden = NO;
        
    }else{
        _naviBtn.hidden = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_serchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_serchBar resignFirstResponder];
}
-(void)dingwei:(CLLocationCoordinate2D)point{
    if (_locService != nil) {
        [_locService stopUserLocationService];
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
    }
}
-(void)shouji{
    NSArray* overlays = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overlays];
    
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
- (IBAction)qiehuanBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            if (KUserManager.uid == nil) {//登录
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后才能找到您的车噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            if ([KUserManager.car.device isEqualToString:@""]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能找到您的车噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self changeBtn:10];
        }
            break;
        case 11:
        {
            self.footBackgroundView.hidden = YES;
            [self changeBtn:11];
        }
            break;
        case 12:
        {
            MyLog(@"路况");
            [_mapView setTrafficEnabled:!_traffic];
            if (_traffic) {
                [sender setBackgroundImage:[UIImage imageNamed:@"chedongtai_lukuang1"] forState:UIControlStateNormal];
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"chedongtai_lukuang"] forState:UIControlStateNormal];
            }
            _traffic = !_traffic;
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)daohangBtnClick {
    [self startNaviWithNewPoint:_newPt OldPoint:_oldPt];
}

- (IBAction)addBtnClick:(UIButton *)sender {
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
-(void)changeBtn:(int)tag{
    if (tag == 10) {
        UIButton* lBtn = (UIButton*)[self.view viewWithTag:10];
        [lBtn setBackgroundImage:[UIImage imageNamed:@"daohang_zhaoche1.png"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn.tag+1];
        [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone"] forState:UIControlStateNormal];
        
        [self run];
    }else{
        UIButton* lBtn = (UIButton*)[self.view viewWithTag:11];
        [lBtn setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone1"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn.tag-1];
        [btn setBackgroundImage:[UIImage imageNamed:@"daohang_zhaoche.png"] forState:UIControlStateNormal];
        [self shouji];
    }
}
@end
