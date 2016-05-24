//
//  CWSFindCarLocationController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindCarLocationController.h"



@interface CWSFindCarLocationController (){
    UserInfo *userInfo;
}
@property (weak, nonatomic) IBOutlet UIView *headChangeView;
@property (weak, nonatomic) IBOutlet UIButton *headMapButton;
@property (weak, nonatomic) IBOutlet UIView *heafMapLineView;
@property (weak, nonatomic) IBOutlet UIButton *headListButton;
@property (weak, nonatomic) IBOutlet UIView *headListLineView;
@property (weak, nonatomic) IBOutlet UIView *footCellView;

- (IBAction)headButtonClick:(UIButton *)sender;


@end

@implementation CWSFindCarLocationController
#pragma mark - 更新数据
-(void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar type:(int)type{
    _oldPt = coordinate;
//    [self showHudInView:self.view hint:@"数据加载中..."];
    NSDictionary* dic = @{@"latitude":[NSString stringWithFormat:@"%f",coordinate.longitude],
                          @"longitude":[NSString stringWithFormat:@"%f",coordinate.latitude],
                          @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          @"page":@"0",
                          @"size":@"20"};
    [ModelTool httpGainInterestWithParameter:dic success:^(id object) {
        
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        MyLog(@"%@",dic[@"data"][@"data"][@"message"]);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            [_dataArray removeAllObjects];
            for (NSDictionary* ldic in dic[@"data"][@"data"][@"pointList"]) {
                Interest* interest = [[Interest alloc] initWithDic:ldic];
                [_dataArray addObject:interest];
            }
            FindMapData* findMapData = [[FindMapData alloc] init];
            findMapData.point = coordinate;
            findMapData.nearbyCar = nearbyCar;
            findMapData.coordArray = _dataArray;
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_findMapView reloadData:findMapData type:type];
                if (_dataArray.count > 0) {
                    [self reloadFootView:_dataArray[0]];
                }
                [_tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    userInfo = [UserInfo userDefault];
    _dataArray = [NSMutableArray array];
//    _fenLanView = [self creatFenLanView];
//    self.headChangeView =_fenLanView;
//    self.navigationItem.titleView = _fenLanView;
    self.title = @"找加油站";
    _currentBtn = self.headMapButton;
    self.footCellView.hidden = YES;
    //创建地图View
    [self creatMapView];
    //定位
    [self getPoint];
    //创建TableView
    [self creatTableView];
    //创建通知
    [self creatNotification];
}
-(void)getPoint{
    
#if USENEWVERSION
    if (userInfo.desc == nil) {
        [self turnToLoginVC];
        return;
    }
    
//    if (KUserManager.userCID ==nil  || KUserManager.userDefaultVehicle[@"device"] == nil || [KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
//        UIButton* lBtn2 = (UIButton*)[self.view viewWithTag:11];
//        [lBtn2 setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone1"] forState:UIControlStateNormal];
//        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn2.tag-1];
//        [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar1"] forState:UIControlStateNormal];
        //手机定位
        [self shouji];
//    }else{
//        NSLog(@"%@%@",KUserManager.userCID,KUserManager.uid);
//        //车辆定位
//        [self dingwei];
//    }
#else
    
    if ([KUserManager.car.device isEqualToString:@""] || KUserManager.uid == nil) {
        UIButton* lBtn2 = (UIButton*)[self.view viewWithTag:11];
        [lBtn2 setBackgroundImage:[UIImage imageNamed:@"chedongtai_myphone1"] forState:UIControlStateNormal];
        UIButton* btn = (UIButton*)[self.view viewWithTag:lBtn2.tag-1];
        [btn setBackgroundImage:[UIImage imageNamed:@"chedongtai_mycar1"] forState:UIControlStateNormal];
        //手机定位
        [self shouji];
    }else{
        //车辆定位
        [self dingwei];
    }
#endif
    
    
    
    
}
#pragma mark - 通知返回方法
-(void)creatNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parkGoNav:) name:@"parkGoNav" object:nil];
}
#pragma mark - tableViewCell通知回调方法
-(void)parkGoNav:(NSNotification*)sender{
    NSDictionary* dic = sender.object;
    _newPt = (CLLocationCoordinate2D){[dic[@"lat"] floatValue], [dic[@"lon"] floatValue]};
    [self startNavi];
}
#pragma mark - CWSFindMapView代理协议
-(void)pointClick:(Interest*)interest{
    MyLog(@"%@",interest.distance);
    [self reloadFootView:interest];
}
#pragma mark - 刷新底部View
-(void)reloadFootView:(Interest*)interest{
    _newPt = (CLLocationCoordinate2D){[interest.lat floatValue], [interest.lng floatValue]};
    self.footCellView.hidden = NO;
    self.footNameLabel.text = interest.name;
    self.footAddressLabel.text = interest.address;
    self.footAddressLabel.textColor = [UIColor darkGrayColor];
    int meter = [interest.distance floatValue];
    if (meter >= 1000) {
        [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %.2f 千米",(float)meter/1000] forState:UIControlStateNormal];
    }else{
        [self.footDistanceBtn setTitle:[NSString stringWithFormat:@" %i 米",meter] forState:UIControlStateNormal];
    }
    
}
#pragma mark - 创建mapView
-(void)creatMapView{
    _findMapView = [[CWSFindMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _findMapView.type = self.findMapViewType;
    _findMapView.delegate = self;
    [self.view insertSubview:_findMapView atIndex:0];
    [self.footView setFrame:CGRectMake(0, kSizeOfScreen.height - self.footView.frame.size.height - kDockHeight - kSTATUS_BAR, self.footView.frame.size.width, self.footView.frame.size.height)];
    [self.view addSubview:self.footView];
}
#pragma mark - 创建tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kSizeOfScreen.width, kSizeOfScreen.height-44-40 ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [self.view insertSubview:_tableView atIndex:0];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
}

#pragma mark - 下拉刷新
-(void)headerRefreshing{
    [_tableView reloadData];
    [self loadShareDataInPage];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_header endRefreshing];
}

#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"parkCell";
    CWSParkCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSParkCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Interest* poi = _dataArray[indexPath.row];
    cell.parkNameLabel.text = [NSString stringWithFormat:@"%i.%@",(int)indexPath.row+1,poi.name];
    cell.parkAddressLabel.text = poi.address;
    cell.lat = poi.lat;
    cell.lon = poi.lng;
    int meter = [poi.distance floatValue];
    if (meter >= 1000) {
        [cell.distanceBtn setTitle:[NSString stringWithFormat:@" %.2f 千米",(float)meter/1000] forState:UIControlStateNormal];
    }else{
        [cell.distanceBtn setTitle:[NSString stringWithFormat:@" %i 米",meter] forState:UIControlStateNormal];
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}
#pragma mark - 创建分栏选择View
-(UIView *)creatFenLanView{

    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"FindGasStationHeadView" owner:self options:nil] lastObject];
    return view;
}



#pragma mark - 分栏点击事件
- (IBAction)headButtonClick:(UIButton *)sender {
    
    if (sender == self.headMapButton) {
        if (sender != _currentBtn) {
            //
            [_currentBtn setImage:[UIImage imageNamed:@"chewei_list"] forState:UIControlStateNormal];
            [_currentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            //选中的地图
            [sender setImage:[UIImage imageNamed:@"chewei_map_click"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            _footView.hidden = NO;
            self.trafficBtn.hidden = NO;
            self.heafMapLineView.hidden = NO;
            self.headListLineView.hidden = YES;
            
        }
    }else
    {
        
        if (sender != _currentBtn) {
            
            [_currentBtn setImage:[UIImage imageNamed:@"chewei_map"] forState:UIControlStateNormal];
            [_currentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            //选中的列表
            [sender setImage:[UIImage imageNamed:@"chewei_list_click"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            
            _footView.hidden = YES;
            self.trafficBtn.hidden = YES;
            self.heafMapLineView.hidden = YES;
            self.headListLineView.hidden = NO;
            self.headListLineView.backgroundColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
        }
    }
    _currentBtn = sender;

}


#pragma mark - 车辆定位
-(void)dingwei{
#if USENEWVERSION
//    if (KManager.currentPt.latitude >0 && KManager.currentPt.longitude>0) {
//         [self carLocationPoint:KManager.currentPt];
//    }
//    else {
//         [self carLocationPoint:KManager.mobileCurrentPt];
//    }
    if (KUserManager.userDefaultVehicle[@"device"] == nil || [KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能看到您爱车附近的加油站噢！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        
        [self carLocationPoint:KManager.currentPt];
    }
    
#else
    NSDictionary* lDic = @{@"carId":KUserManager.car.carId,@"uid":KUserManager.uid,@"key":KUserManager.key,@"isMode":@"0"};
    MyLog(@"%@",lDic);
    [self showHudInView:self.view hint:@"数据加载中..."];
    [ModelTool httpGetGPSCarInfoWithParameter:lDic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CLLocationCoordinate2D point = (CLLocationCoordinate2D){[dic[@"data"][@"data"][@"body"][@"lat"] floatValue], [dic[@"data"][@"data"][@"body"][@"lon"] floatValue]};
                _nearbyCar = YES;
                [self carLocationPoint:point];
            });
        }else{
            [self hideHud];
            
        }
    } faile:^(NSError *err) {
        [self hideHud];
    }];
    
#endif
    
}
#pragma mark - 车辆定位方法
-(void)carLocationPoint:(CLLocationCoordinate2D)point{
    [self getHttpData:point nearbyCar:YES type:self.findMapViewType];
}
#pragma mark - 手机定位
-(void)shouji{
    
    _subCity = KManager.currentSubCity;
    
    _nearbyCar = NO;
    [self getHttpData:KManager.mobileCurrentPt nearbyCar:NO type:self.findMapViewType];
}

#pragma mark - 左边按钮点击
- (IBAction)qiehuanbtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 10://定位车辆
        {
            if (KUserManager.uid == nil) {//登录
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后才能看到您爱车附近的加油站噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            if ([KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定设备后才能看到您爱车附近的加油站噢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [sender setBackgroundImage:[UIImage imageNamed:@"dongtai_mycar_click"] forState:UIControlStateNormal];
            UIButton* btn = (UIButton*)[self.view viewWithTag:sender.tag+1];
            [btn setBackgroundImage:[UIImage imageNamed:@"dongtai_myphone"] forState:UIControlStateNormal];
            [self dingwei];
        }
            break;
        case 11://定位人
        {
            MyLog(@"手机");
//            if (KManager.currentCity == nil || [KManager.currentCity isEqualToString:@""]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取当前城市失败，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//                return;
//            }
            _subCity = KManager.currentSubCity;
            [sender setBackgroundImage:[UIImage imageNamed:@"dongtai_myphone_click"] forState:UIControlStateNormal];
            UIButton* btn = (UIButton*)[self.view viewWithTag:sender.tag-1];
            [btn setBackgroundImage:[UIImage imageNamed:@"dongtai_mycar"] forState:UIControlStateNormal];
            [self shouji];
        }
            break;
        case 12://路况
        {
            MyLog(@"路况");
            NSString* imageName;
            if (_traffic) {
                imageName = @"dongtai_lukuang";
            }else{
                imageName = @"dongtai_lukuang_click";
            }
            [sender setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            _traffic = !_traffic;
            FindMapData* lFindData = [[FindMapData alloc] init];
            lFindData.traffic = _traffic;
            [_findMapView reloadData:lFindData type:2];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 地图导航按钮
- (IBAction)goBtnClick {
    [self startNavi];
    
}
#pragma mark - 改变地图zoomLevel大小点击事件
- (IBAction)addBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1) {
        [_findMapView changeMapZoomLevel:1];
    }else{
        [_findMapView changeMapZoomLevel:-1];
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
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = _newPt.longitude;
    endNode.pos.y = _newPt.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate 百度导航代理协议
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
