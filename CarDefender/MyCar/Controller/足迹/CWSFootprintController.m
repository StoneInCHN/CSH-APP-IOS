//
//  CWSFootprintController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFootprintController.h"
#import "CWSFootprintDetailsController.h"
#import "CWSTrajectoryLocationCell.h"
#import "CWSTrajectoryPointCell.h"
#import "Footprint.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MJRefresh.h"

@interface CWSFootprintController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService*      _locService;
    BMKGeoCodeSearch*        _geocodesearch;
    BMKMapView*              _mapView;
    CLLocationCoordinate2D   _oldPt;
    bool                     isGeoSearch;
    UITableView*             _tableView;
    NSArray*                 _dataArray;
    UIView*                  _headView;
    UIView*                  _navigationView;
    int                      _temp;
    NSMutableArray*          _pointArray;
}
//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end

@implementation CWSFootprintController
-(void)getData{
    
    [self showHudInView:self.view hint:@"数据加载中..."];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"device":KUserManager.car.device,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"size":@"10"};
    [ModelTool httpGainFootmarkWithParameter:lDic success:^(id object) {
        NSDictionary* lDic = object;
        MyLog(@"%@",lDic);
        if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            NSMutableArray* lArray1 = [NSMutableArray array];
            NSMutableArray* lArray2 = [NSMutableArray array];
            NSDictionary* dic = object;
            NSArray* lArray = dic[@"data"][@"list"];
            if (lArray.count > 0) {
                _temp ++;
            }else{
                [self.normalView setFrame:CGRectMake(0, 175, kSizeOfScreen.width, _tableView.frame.size.height - 175)];
                [_tableView addSubview:self.normalView];
            }
            self.cityNumLabel.text = [NSString stringWithFormat:@"%@个足迹点",dic[@"data"][@"point"]];
            self.stopNumLabel.text = [NSString stringWithFormat:@"%@个城市点",dic[@"data"][@"city"]];
            for (int i = 1 ; i<lArray.count; i++) {
                NSDictionary* lDic1 = lArray[i - 1];
                Footprint* lFootprint1 = [[Footprint alloc] initWithDic:lDic1];
                NSDictionary* lDic2 = lArray[i];
                Footprint* lFootprint2 = [[Footprint alloc] initWithDic:lDic2];
                
                if ([lFootprint2.type isEqualToString:@"0"]) {
                    [_pointArray addObject:lFootprint2.lnglat];
                }
                if (i == 1) {
                    [lArray2 addObject:lFootprint1];
                }
                if ([[lFootprint1.time substringToIndex:10] isEqualToString:[lFootprint2.time substringToIndex:10]]) {
                    [lArray2 addObject:lFootprint2];
                }else{
                    [lArray1 addObject:@{@"time":[lFootprint1.time substringToIndex:10],@"trajectories":lArray2}];
                    lArray2 = [NSMutableArray array];
                    [lArray2 addObject:lFootprint2];
                }
                if (i == lArray.count - 1) {
                    [lArray1 addObject:@{@"time":[lFootprint2.time substringToIndex:10],@"trajectories":lArray2}];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (lArray.count == 1) {
                    Footprint* lFootprint1 = [[Footprint alloc] initWithDic:lArray[0]];
                    if ([lFootprint1.type isEqualToString:@"0"]) {
                        [_pointArray addObject:lFootprint1.lnglat];
                    }
                    _dataArray = [NSArray arrayWithObject:@{@"time":[lFootprint1.time substringToIndex:10],@"trajectories":@[lFootprint1]}];
                }else{
                    _dataArray = [NSArray arrayWithArray:lArray1];
                }
                for (NSString* lnglat in _pointArray) {
                    NSRange lRang =[lnglat rangeOfString:@","];
                    NSString* lng = [lnglat substringToIndex:lRang.location];
                    NSString* lat = [lnglat substringFromIndex:lRang.location+lRang.length];
                    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[lat floatValue], [lng floatValue]};
                    [self addpoint:pt];
                }
                [_tableView reloadData];
            });
        }
        [self hideHud];
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    if ([KUserManager.car.carId isEqualToString:@""]) {
        return;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _oldPt = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    _dataArray = [NSArray array];
    _pointArray = [NSMutableArray array];
    _temp = 1;
    [self creatHeadView];
    [self creatTableView];
    [self creatUpdateView];
    [self getData];
}
#pragma mark - 创建刷新视图
-(void)creatUpdateView{
//    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}
#pragma mark - 上拉加载方法
-(void)footerRefreshing{
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"device":KUserManager.car.device,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"size":@"10"};
    [ModelTool httpGainFootmarkWithParameter:lDic success:^(id object) {
        NSMutableArray* lArray1 = [NSMutableArray array];
        NSMutableArray* lArray2 = [NSMutableArray array];
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        NSArray* lArray = dic[@"data"][@"list"];
        if (lArray.count > 0) {
            _temp ++;
        }else{
            
        }
//        self.cityNumLabel.text = [NSString stringWithFormat:@"%@个足迹点",dic[@"data"][@"point"]];
//        self.stopNumLabel.text = [NSString stringWithFormat:@"%@个城市点",dic[@"data"][@"city"]];
        
        for (int i = 1 ; i<lArray.count; i++) {
            NSDictionary* lDic1 = lArray[i - 1];
            Footprint* lFootprint1 = [[Footprint alloc] initWithDic:lDic1];
            NSDictionary* lDic2 = lArray[i];
            Footprint* lFootprint2 = [[Footprint alloc] initWithDic:lDic2];
            if (i == 1) {
                [lArray2 addObject:lFootprint1];
            }
            if ([[lFootprint1.time substringToIndex:10] isEqualToString:[lFootprint2.time substringToIndex:10]]) {
                [lArray2 addObject:lFootprint2];
            }else{
                [lArray1 addObject:@{@"time":[lFootprint1.time substringToIndex:10],@"trajectories":lArray2}];
                lArray2 = [NSMutableArray array];
                [lArray2 addObject:lFootprint2];
            }
            if (i == lArray.count - 1) {
                [lArray1 addObject:@{@"time":[lFootprint2.time substringToIndex:10],@"trajectories":lArray2}];
            }
        }
        if (lArray.count == 1) {
            Footprint* lFootprint1 = [[Footprint alloc] initWithDic:lArray[0]];
            lArray1 = [NSMutableArray arrayWithObject:@{@"time":[lFootprint1.time substringToIndex:10],@"trajectories":@[lFootprint1]}];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray* lArray = [NSMutableArray arrayWithArray:_dataArray];
            for (NSDictionary* objectDic in lArray1) {
                if ([[lArray lastObject][@"time"] isEqualToString:objectDic[@"time"]]) {
                    NSMutableArray* lMutArray = [NSMutableArray arrayWithArray:[lArray lastObject][@"trajectories"]];
                    [lMutArray addObjectsFromArray:objectDic[@"trajectories"]];
                    [lArray removeLastObject];
                    [lArray addObject:@{@"time":objectDic[@"time"],@"trajectories":lMutArray}];
                }else{
                    [lArray addObject:objectDic];
                }
                
            }
            _dataArray = [NSArray arrayWithArray:lArray];
            [_tableView reloadData];
            [self loadShareDataInPage];
        });
        
    } faile:^(NSError *err) {
        
    }];
}
#pragma mark - 下拉刷新
-(void)headerRefreshing{
    [_tableView reloadData];
    [self loadShareDataInPage];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    MyLog(@"%d",animated);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
    [ModelTool stopAllOperation];
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}  
#pragma mark - 创建TableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height + kSTATUS_BAR) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 64)];
    _navigationView.backgroundColor = kCOLOR(204, 204, 204);
    _navigationView.alpha = 0;
    UIButton* lBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 28, 48, 16)];
//    [backBtn setTitle:@"< 返回" forState:UIControlStateNormal];
    [lBtn setBackgroundImage:[UIImage imageNamed:@"back_info"] forState:UIControlStateNormal];
    [lBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:lBtn];
    [self.view addSubview:_navigationView];
}

#pragma mark - 创建头部View
-(void)creatHeadView{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 175)];
    [self.view addSubview:_headView];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 175)];
    [_headView addSubview:_mapView];
    
    [self.markBackgroundView setFrame:CGRectMake(0, 109, self.markBackgroundView.frame.size.width, self.markBackgroundView.frame.size.height)];
    [_headView addSubview:self.markBackgroundView];
    [self setMapData];
    
    UIButton* mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 175)];
    [mapBtn addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:mapBtn];
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 21, 48, 16)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_info"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:backBtn];
}

#pragma mark = 实例化地图相关类
-(void)setMapData{
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    isGeoSearch = YES;
    [_mapView setZoomLevel:5];
    _mapView.mapType = BMKMapTypeSatellite;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    _mapView.centerCoordinate = _oldPt;
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    
    //    _mapView.showsUserLocation = YES;//显示定位图层
//    if (isGeoSearch) {
//        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//        reverseGeocodeSearchOption.reverseGeoPoint = _oldPt;
//        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//        if(flag)
//        {
//            MyLog(@"反geo检索发送成功");
//        }
//        else
//        {
//            MyLog(@"反geo检索发送失败");
//        }
//        isGeoSearch = NO;
//    }
}
-(void)addpoint:(CLLocationCoordinate2D)point{
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
#pragma mark - 地图代理协议
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"地址: %@",result.address];
        [_mapView addAnnotation:item];
//        _mapView.centerCoordinate = result.location;
    }
    
}
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.image = [UIImage imageNamed:@"zuji_loc"];
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}

#pragma mark - tableView数据源协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *lArray = _dataArray[section][@"trajectories"];
    return lArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *locationCell=@"locationCell";
    static NSString *pointCell=@"pointCell";
    Footprint* footprint = _dataArray[indexPath.section][@"trajectories"][indexPath.row];
    if (![footprint.type isEqualToString:@"0"]) {
        CWSTrajectoryLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:locationCell];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CWSTrajectoryLocationCell" owner:self options:nil][0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.starLabel.text = footprint.addrStart;
        cell.endLabel.text = footprint.addrEnd;
        NSString* lString1 = footprint.dateStart;
        NSString* lString2 = footprint.dateEnd;

        long time = [Utils getTimeDifference:lString1 currentTime:lString2];
        long minute = 0;
        if (time%3600 >= 60) {
            minute = time%3600/60;
        }
        cell.timeLabel.text = [NSString stringWithFormat:@"%li分钟",time/60];
        cell.starTimeLabel.text= [lString1 substringWithRange:NSMakeRange(11, 5)];
        NSData *jsonData = [footprint.lnglat dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary*datadic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        footprint.latAndlonDic = datadic;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@ km",footprint.mile];
        if ([footprint.type isEqualToString:@"1"]) {
            cell.markImagView.image = [UIImage imageNamed:@"zuji_car_ziji"];
        }else{
            cell.markImagView.image = [UIImage imageNamed:@"zuji_ren_zuji"];
        }
        return cell;
    }else{
        CWSTrajectoryPointCell* cell = [tableView dequeueReusableCellWithIdentifier:pointCell];
        if (cell==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"CWSTrajectoryPointCell" owner:self options:nil][0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.addressLabel.text = footprint.addrStart;
        NSString* lString1 = footprint.dateStart;
        NSString* lString2 = footprint.dateEnd;
//        cell.timeLabel.text = [NSString stringWithFormat:@"%@~%@",lString1,lString2];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",lString2];
        return cell;
    }
}

#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Footprint* footprint = _dataArray[indexPath.section][@"trajectories"][indexPath.row];
    if (![footprint.type isEqualToString:@"0"]) {
        return 90;
    }else{
        return 64;
    }
}
#pragma mark - 设置每一行的间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary* dic = _dataArray[section];
    NSString* title = [NSString stringWithFormat:@"%@",dic[@"time"]];
    UILabel* lLabel = [Utils labelWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 30) withTitle:title titleFontSize:kFontOfLetterSmall textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
    lLabel.backgroundColor = kCOLOR(232, 232, 232);
    
    return lLabel;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Footprint* footprint = _dataArray[indexPath.section][@"trajectories"][indexPath.row];
    CWSFootprintDetailsController* lController = [[CWSFootprintDetailsController alloc] init];
    
    lController.type = footprint.type;
    lController.footprint = footprint;
    if ([footprint.type isEqualToString:@"0"]) {
        NSRange lRang =[footprint.lnglat rangeOfString:@","];
        lController.lon = [footprint.lnglat substringToIndex:lRang.location];
        lController.lat = [footprint.lnglat substringFromIndex:lRang.location+lRang.length];
        lController.title = @"停驻点";
    }else{
        lController.title = @"足迹详情";
    }
    [self.navigationController pushViewController:lController animated:YES];
}
#pragma mark - scrollView代理协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int temp = 100;
    if (scrollView.contentOffset.y >= temp) {
        _navigationView.alpha = (scrollView.contentOffset.y - temp)/64;
    }
    if (scrollView.contentOffset.y <= 1) {
        _navigationView.alpha = 0;
    }
}
#pragma mark - 按钮点击
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)mapClick {
    MyLog(@"地图点击");
}

- (void)shareBtnClick {
    MyLog(@"分享");
}

@end
