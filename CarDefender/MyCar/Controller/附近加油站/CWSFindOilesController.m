//
//  CWSFindOilesController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/11.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindOilesController.h"
//#import "CWSParkCell.h"
#import "CWSOilCell.h"
#import <BaiduMapAPI/BMapKit.h>
#import "Park.h"
#import "Interest.h"
#import "MJRefresh.h"

@interface OilRouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
    NSString* currentTime;
    
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation OilRouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface CWSFindOilesController ()<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView*              _mapView;
    UITableView*             _tableView;
    UIView*                  _fenLanView;
    UIButton*                _currentBtn;
    NSMutableArray*          _dataArray;
    BMKLocationService*      _locService;
    CLLocationCoordinate2D   _oldPt;
    CLLocationCoordinate2D   _carPoint;
    CLLocationCoordinate2D   _newPt;
    bool                     isGeoSearch;
    BMKGeoCodeSearch*        _geocodesearch;
    BOOL                     _traffic;
    NSString*                _district;
    //    BMKPointAnnotation*      pointAnnotation;
    BOOL                     _temp;
    Interest*                _currentInterest;
}

@end

@implementation CWSFindOilesController

-(void)getData{
    _traffic = NO;
    _dataArray = [NSMutableArray array];
    
    if (KUserManager.uid == nil || [KUserManager.car.device isEqualToString:@""]) {
        UIButton* lBtn2 = (UIButton*)[self.view viewWithTag:11];
        [lBtn2 setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone1"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn2.tag-1];
        [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar1"] forState:UIControlStateNormal];
        
        [self showHudInView:self.view hint:@"数据加载中..."];
        NSDictionary* dic;
        if (KUserManager.uid != nil){
            dic = @{@"uid":KUserManager.uid,
                    @"cityName":[KManager.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    @"page":@"0",
                    @"size":@"20"};
        }else{
            dic = @{
                    @"cityName":[KManager.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    @"page":@"0",
                    @"size":@"20"};
        }
        MyLog(@"%@",dic);
        [ModelTool httpGainGasWithParameter:dic success:^(id object) {
            NSDictionary* dic = object;
            MyLog(@"%@",dic);
            [_dataArray removeAllObjects];
            for (NSDictionary* lDic in dic[@"data"][@"data"][@"pointList"]) {
                Interest* interest = [[Interest alloc] initWithDic:lDic];
                interest.telephone = lDic[@"additionalInformation"][@"telephone"];
                [_dataArray addObject:interest];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self shouji];
                [self reloadFootView];
                for (int i = 0; i < _dataArray.count; i++) {
                    for (int j = i + 1; j < _dataArray.count; j++) {
                        Interest* interest1 = _dataArray[i];
                        CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                        CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[interest1.lat floatValue] longitude:[interest1.lng floatValue]];
                        int meter1 = [Utils getMetersBefore:location1 Current:location2];
                        Interest* interest2 = _dataArray[j];
                        CLLocation * location3 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                        CLLocation * location4 = [[CLLocation alloc] initWithLatitude:[interest2.lat floatValue] longitude:[interest2.lng floatValue]];
                        int meter2 = [Utils getMetersBefore:location3 Current:location4];
                        if (meter1 > meter2) {
                            [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                        }
                    }
                }
                [_tableView reloadData];
                _temp = YES;
                [self addLocationPoint];
                [self hideHud];
            });
            
        } faile:^(NSError *err) {
            [self hideHud];
        }];
    }else{
        UIButton* lBtn = (UIButton*)[self.view viewWithTag:10];
        [lBtn setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn.tag+1];
        [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone"] forState:UIControlStateNormal];
        [self dingwei];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _fenLanView = [self creatFenLanView];
    self.navigationItem.titleView = _fenLanView;
    _temp = YES;
    [self creatMapView];
    [self creatTableView];
    [self getData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(navBack:) name:@"navBack" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parkGoNav:) name:@"parkGoNav" object:nil];

}
-(void)reloadFootView{
    Interest* interest;
    int lMeter = 10000000;
    for (Interest* point in _dataArray) {
        CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
        CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[point.lat floatValue] longitude:[point.lng floatValue]];
        int meter = [Utils getMetersBefore:location1 Current:location2];
        if (meter < lMeter) {
            lMeter = meter;
            interest = point;
            _currentInterest = point;
        }
    }
    self.footNameLabel.text = interest.name;
    self.footAddressLabel.text = interest.address;
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[interest.lat floatValue] longitude:[interest.lng floatValue]];
    int meter = [Utils getMetersBefore:location1 Current:location2];
    if (meter >= 1000) {
        [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %.2f 千米",(float)meter/1000] forState:UIControlStateNormal];
    }else{
        [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %i 米",meter] forState:UIControlStateNormal];
    }
//    self.footDistanceLabel.text = [NSString stringWithFormat:@"%i 米",meter];
    
    _newPt = (CLLocationCoordinate2D){[interest.lat floatValue], [interest.lng floatValue]};
}
-(void)navBack:(NSNotification*)sender
{
    
}
-(void)parkGoNav:(NSNotification*)sender{
    NSDictionary* dic = sender.object;
    _newPt = (CLLocationCoordinate2D){[dic[@"lat"] floatValue], [dic[@"lon"] floatValue]};
    [self startNavi];
}
#pragma mark - 创建tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [self.view insertSubview:_tableView atIndex:0];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
}
#pragma mark - 下拉刷新
-(void)headerRefreshing{
    [_tableView reloadData];
    [self loadShareDataInPage];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    
    [_tableView headerEndRefreshing];
}
#pragma mark - 创建mapView
-(void)creatMapView{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:17];
    [self.footView setFrame:CGRectMake(0, _mapView.frame.size.height - self.footView.frame.size.height, self.footView.frame.size.width, self.footView.frame.size.height)];
    
    [self.view insertSubview:_mapView atIndex:0];
    [self.view addSubview:self.footView];
}
-(void)setMapData{
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    isGeoSearch = YES;
    [_mapView setZoomLevel:17];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    _geocodesearch.delegate = self;
    [self dingwei];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    if (_fenLanView != nil) {
//        [self.navigationController.view addSubview:_fenLanView];
//    }
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    if (_fenLanView == nil) {
//        _fenLanView = [self creatFenLanView];
//        [self.navigationController.view addSubview:_fenLanView];
//    }
//    
//}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [_fenLanView removeFromSuperview];
//}
#pragma mark - 地图代理协议
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    OilRouteAnnotation* item = [[OilRouteAnnotation alloc]init];
    item.type = 1;
    item.coordinate = result.location;
    item.title = [NSString stringWithFormat:@"地址: %@",result.address];
    
    [_mapView addAnnotation:item];
    _mapView.centerCoordinate = result.location;
    _oldPt = result.location;
    //    [self addPoint];
    [self showHudInView:self.view hint:@"数据加载中..."];
    _district = result.addressDetail.district;
    NSDictionary* dic;
    if (KUserManager.uid != nil){
        dic = @{@"uid":KUserManager.uid,
                @"cityName":[result.addressDetail.district stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                @"page":@"0",
                @"size":@"20"};
    }else{
        dic = @{@"cityName":[result.addressDetail.district stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                @"page":@"0",
                @"size":@"20"};
    }
    [ModelTool httpGainGasWithParameter:dic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        [_dataArray removeAllObjects];
        for (NSDictionary* lDic in dic[@"data"][@"data"][@"pointList"]) {
            Interest* interest = [[Interest alloc] initWithDic:lDic];
            interest.telephone = lDic[@"additionalInformation"][@"telephone"];
            [_dataArray addObject:interest];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadFootView];
            [self addLocationPoint];
            for (int i = 0; i < _dataArray.count; i++) {
                for (int j = i + 1; j < _dataArray.count; j++) {
                    Interest* interest1 = _dataArray[i];
                    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[interest1.lat floatValue] longitude:[interest1.lng floatValue]];
                    int meter1 = [Utils getMetersBefore:location1 Current:location2];
                    Interest* interest2 = _dataArray[j];
                    CLLocation * location3 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                    CLLocation * location4 = [[CLLocation alloc] initWithLatitude:[interest2.lat floatValue] longitude:[interest2.lng floatValue]];
                    int meter2 = [Utils getMetersBefore:location3 Current:location4];
                    if (meter1 > meter2) {
                        [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
            }
            [_tableView reloadData];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });
    } faile:^(NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
        });
    }];
    
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(OilRouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"location"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"location"];
                view.image = [UIImage imageNamed:@"you_zuobiao"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
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
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"clickLocation"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"clickLocation"];
                view.image = [UIImage imageNamed:@"you_click"];
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
    if ([annotation isKindOfClass:[OilRouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(OilRouteAnnotation*)annotation];
    }
    return nil;
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
#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"oilCell";
    CWSOilCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSOilCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Interest* poi = _dataArray[indexPath.row];
    cell.parkNameLabel.text = [NSString stringWithFormat:@"%i.%@",(int)indexPath.row+1,poi.name];
    cell.parkAddressLabel.text = poi.address;
    cell.tel = poi.telephone;
    if ([poi.telephone isEqualToString:@""]) {
//        [cell.telBtn setBackgroundImage:[UIImage imageNamed:@"chewei_phone1.png"] forState:UIControlStateNormal];
        [cell.telBtn setImage:[UIImage imageNamed:@"chewei_phone1.png"] forState:UIControlStateNormal];
        [cell.telBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell.userInteractionEnabled = NO;
    }
//    cell.parkAddressLabel.text = poi.telephone;
    cell.lat = poi.lat;
    cell.lon = poi.lng;
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[poi.lat floatValue] longitude:[poi.lng floatValue]];
    int meter = [Utils getMetersBefore:location1 Current:location2];
//    [cell.distanceBtn setTitle:[NSString stringWithFormat:@" 相距%i米",meter] forState:UIControlStateNormal];
    NSString* meterStr;
    if (meter >= 1000) {
        meterStr = [NSString stringWithFormat:@" %.2f 千米",(float)meter/1000];
    }else{
        meterStr = [NSString stringWithFormat:@" %i 米",meter];
    }
    CGSize size = [Utils takeTheSizeOfString:meterStr withFont:kFontOfSize(13)];
    UILabel* lDistanLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 18 - size.width, 31, size.width, 12) withTitle:meterStr titleFontSize:kFontOfSize(13) textColor:[UIColor blackColor] alignment:NSTextAlignmentRight];
    [cell.contentView addSubview:lDistanLabel];
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width - 18 - size.width -  14, 31, 12, 12)];
    lImageView.image = [UIImage imageNamed:@"zhaochewei_ication"];
    [cell.contentView addSubview:lImageView];
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}
#pragma mark - 创建分栏选择View
-(UIView *)creatFenLanView{
    UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width/2 - 50, 27, 100, 30)];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, lView.frame.size.width/2, lView.frame.size.height)];
    leftBtn.titleLabel.font = kFontOfLetterMedium;
    [leftBtn setBackgroundColor:kCOLOR(255, 147, 25)];
    [leftBtn setTitle:@"地图" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 10;
    _currentBtn = leftBtn;
    [lView addSubview:leftBtn];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(lView.frame.size.width/2, 0, lView.frame.size.width/2, lView.frame.size.height)];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
    //    [rightBtn setImage:[UIImage imageNamed:@"navigation"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = kFontOfLetterMedium;
    [rightBtn setTitleColor:kCOLOR(255, 147, 25) forState:UIControlStateNormal];
    rightBtn.tag = 11;
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lView addSubview:rightBtn];
    [Utils setViewRiders:lView riders:4];
    [Utils setBianKuang:kCOLOR(255, 147, 25) Wide:1 view:lView];
    return lView;
}
#pragma mark - 按钮点击
-(void)btnClick:(UIButton*)sender{
    if (sender.tag == 10) {
        if (sender != _currentBtn) {
            [_currentBtn setBackgroundColor:[UIColor whiteColor]];
            [_currentBtn setTitleColor:kCOLOR(255, 147, 25) forState:UIControlStateNormal];
            [sender setBackgroundColor:kCOLOR(255, 147, 25)];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [_tableView removeFromSuperview];
            //            [self.view insertSubview:_mapView atIndex:0];
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            _footView.hidden = NO;
            self.trafficBtn.hidden = NO;
        }
    }else
    {
        if (sender != _currentBtn) {
            
            
            [_currentBtn setBackgroundColor:[UIColor whiteColor]];
            //            [_currentBtn setImage:[UIImage imageNamed:@"sd_map2"] forState:UIControlStateNormal];
            [_currentBtn setTitleColor:kCOLOR(255, 147, 25) forState:UIControlStateNormal];
            [sender setBackgroundColor:kCOLOR(255, 147, 25)];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [self.view addSubview:_tableView];
            //            [self.view insertSubview:_tableView atIndex:0];
            //            [_mapView removeFromSuperview];
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            _footView.hidden = YES;
            self.trafficBtn.hidden = YES;
        }
    }
    _currentBtn = sender;
}
-(void)dingwei{
//    [self showHudInView:self.view hint:@"数据加载中..."];
    NSDictionary* lDic = @{@"carId":KUserManager.car.carId,@"uid":KUserManager.uid,@"key":KUserManager.key,@"isMode":@"0"};
    [ModelTool httpGetGPSCarInfoWithParameter:lDic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_geocodesearch == nil) {
                    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
                    _geocodesearch.delegate = self;
                    isGeoSearch = false;
                    _carPoint = (CLLocationCoordinate2D){[dic[@"data"][@"data"][@"body"][@"lat"] floatValue], [dic[@"data"][@"data"][@"body"][@"lon"] floatValue]};
                }
                if (_locService != nil) {
                    [_locService stopUserLocationService];
                    _mapView.showsUserLocation = NO;
                }
                BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
                reverseGeocodeSearchOption.reverseGeoPoint = _carPoint;
                BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
                if(flag)
                {
                    MyLog(@"反geo检索发送成功");
                }
                else
                {
                    MyLog(@"反geo检索发送失败");
                }
            });
        }else{
            
        }
//        [self hideHud];
    } faile:^(NSError *err) {
//        [self hideHud];
    }];
}
-(void)shouji{
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _oldPt = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
}
-(void)addLocationPoint{
    for (Interest* poi in _dataArray) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.lat floatValue], [poi.lng floatValue]};
        OilRouteAnnotation* pointAnnotation = [[OilRouteAnnotation alloc]init];
        if (_temp) {
            if (poi == _currentInterest) {
//                _currentInterest = poi;
                pointAnnotation.type = 2;
                _temp = NO;
            }else{
                pointAnnotation.type = 0;
            }
            
        }else{
            pointAnnotation.type = 0;
        }
        pointAnnotation.coordinate = pt;
        pointAnnotation.title = poi.name;
        [_mapView addAnnotation:pointAnnotation];
    }
}
#pragma mark - 地图按钮切换
- (IBAction)qiehuanbtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            if (KUserManager.uid == nil) {//登录
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后才能看到您爱车附近的加油站噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            if ([KUserManager.car.device isEqualToString:@""]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能看到您爱车附近的加油站噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
//            if (KUserManager.car.carId != nil) {
                MyLog(@"车");
            [sender setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar"] forState:UIControlStateNormal];
            UIButton* btn = (UIButton*)[self.view viewWithTag:sender.tag+1];
            [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone"] forState:UIControlStateNormal];
            _temp = YES;
            [self dingwei];
//            }else{
//                MyLog(@"请登录");
//            }
            
        }
            break;
        case 11:
        {
            MyLog(@"手机");
            if (KManager.currentCity == nil || [KManager.currentCity isEqualToString:@""]) {
                return;
            }
            [sender setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone1"] forState:UIControlStateNormal];
            UIButton* btn = (UIButton*)[self.view viewWithTag:sender.tag-1];
            [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar1"] forState:UIControlStateNormal];
            MyLog(@"%@",KManager.currentCity);
            [self showHudInView:self.view hint:@"数据加载中..."];
            
            NSDictionary* dic;
            if (KUserManager.uid != nil) {
                dic = @{@"uid":KUserManager.uid,
                        @"cityName":[KManager.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"page":@"0",
                        @"size":@"20"};
            }else{
                dic = @{@"cityName":[KManager.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        @"page":@"0",
                        @"size":@"20"};
            }
            MyLog(@"%@",dic);
            NSArray* lArray = [NSArray arrayWithArray:_mapView.annotations];
            [_mapView removeAnnotations:lArray];
            [ModelTool httpGainGasWithParameter:dic success:^(id object) {
                NSDictionary* dic = object;
                MyLog(@"%@",dic);
                [_dataArray removeAllObjects];
                for (NSDictionary* lDic in dic[@"data"][@"data"][@"pointList"]) {
                    Interest* interest = [[Interest alloc] initWithDic:lDic];
                    interest.telephone = lDic[@"additionalInformation"][@"telephone"];
                    [_dataArray addObject:interest];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self shouji];
                    [self reloadFootView];
                    for (int i = 0; i < _dataArray.count; i++) {
                        for (int j = i + 1; j < _dataArray.count; j++) {
                            Interest* interest1 = _dataArray[i];
                            CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                            CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[interest1.lat floatValue] longitude:[interest1.lng floatValue]];
                            int meter1 = [Utils getMetersBefore:location1 Current:location2];
                            Interest* interest2 = _dataArray[j];
                            CLLocation * location3 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
                            CLLocation * location4 = [[CLLocation alloc] initWithLatitude:[interest2.lat floatValue] longitude:[interest2.lng floatValue]];
                            int meter2 = [Utils getMetersBefore:location3 Current:location4];
                            if (meter1 > meter2) {
                                [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                            }
                        }
                    }
                    [_tableView reloadData];
                    _temp = YES;
                    [self addLocationPoint];
                    
                });
                [self hideHud];
            } faile:^(NSError *err) {
                [self hideHud];
            }];
            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
            for (OilRouteAnnotation* pointAnnotation in array) {
                if (pointAnnotation.type == 1) {
                    [_mapView removeAnnotation:pointAnnotation];
                }
            }
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

#pragma mark - 地图大头针点击
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSString* name = view.annotation.title;
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    for (OilRouteAnnotation* pointAnnotation in array) {
        if (pointAnnotation.type != 1) {
            [_mapView removeAnnotation:pointAnnotation];
        }
    }
//    [self addLocationPoint];
    for (Interest* poi in _dataArray) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[poi.lat floatValue], [poi.lng floatValue]};
        OilRouteAnnotation* pointAnnotation = [[OilRouteAnnotation alloc]init];
        if ([name isEqualToString:poi.name]) {
            pointAnnotation.type = 2;
            _currentInterest = poi;
            self.footNameLabel.text = [NSString stringWithFormat:@"%@",poi.name];
            self.footAddressLabel.text = [NSString stringWithFormat:@"%@",poi.address];
            CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
            CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[poi.lat floatValue] longitude:[poi.lng floatValue]];
            int meter = [Utils getMetersBefore:location1 Current:location2];
//            self.footDistanceLabel.text = [NSString stringWithFormat:@"%i 米",meter];
            if (meter >= 1000) {
                [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %.2f 千米",(float)meter/1000] forState:UIControlStateNormal];
            }else{
                [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %i 米",meter] forState:UIControlStateNormal];
            }
//            [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %i 米",meter] forState:UIControlStateNormal];
            _newPt = (CLLocationCoordinate2D){[poi.lat floatValue], [poi.lng floatValue]};
        }else{
            pointAnnotation.type = 0;
        }
        
        pointAnnotation.coordinate = pt;
        pointAnnotation.title = poi.name;
        [_mapView addAnnotation:pointAnnotation];
    }
}

#pragma mark - 地图导航按钮
- (IBAction)goBtnClick {
    [self startNavi];
    
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
#pragma mark - 导航
- (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = _oldPt.longitude;
    startNode.pos.y = _oldPt.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    
    //    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    //    midNode.pos = [[BNPosition alloc] init];
    //    midNode.pos.x = 113.977004;
    //    midNode.pos.y = 22.556393;
    //    midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = _newPt.longitude;
    endNode.pos.y = _newPt.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}
//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出电子狗页面");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
