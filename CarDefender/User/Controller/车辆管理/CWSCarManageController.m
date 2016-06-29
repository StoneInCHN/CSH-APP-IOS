//
//  CWSCarManageController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarManageController.h"
#import "CWSAddCarController.h"//添加车辆
#import "CWSCarTrendsController.h"//车动态
//地图相关
#import <BaiduMapAPI/BMapKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

#import "CWSCarManagerCell.h"//车辆管理cell
#import "UIImageView+WebCache.h"//异步加载图片
#import "UserDefaultCar.h"//数据模型

#import "CWSCarManagerDeviceOkController.h"//
#import "CWSCarMangerAddNoDeviceController.h"

#import "CWSOrderCarWashController.h"

#import "CWSNoDataView.h"
@interface CWSCarManageController ()<UITableViewDataSource,UITableViewDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
{
    BMKMapView*      _mapView;
    UITableView*     _tableView;
    UIView*          _fenLanView;
    UIView*          _footView;
    UIButton*        _currentBtn;
    NSMutableArray*  _dataArray;
    NSMutableDictionary*_bodyDic;
    
    CWSNoDataView* _noCarView;
    
    BOOL cellSelectYN;
    UIButton*_chooseCostBack;
    
    BOOL _goBangDingCost;
    
    BOOL _isLoadTableView;
    
    UIButton*_leftBtn;
    NSMutableArray *cellArray;
}
@property (assign, nonatomic) BN_NaviType naviType;
@end

@implementation CWSCarManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@",KUserManager.userCID);
    _goBangDingCost=NO;
    cellSelectYN=YES;
    [Utils changeBackBarButtonStyle:self];
    
    UIBarButtonItem* backItem2 = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCar)];
    [backItem2 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.149f green:0.698f blue:0.898f alpha:1.00f],NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = backItem2;
    
    self.title = @"我的车辆";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    cellArray = [[NSMutableArray alloc] init];

    //获取数据
    [self initialData];
    
    //当前页面展示且收到推送消息时处理事件的通知方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRemoteNotiAndCurrentIsManager:) name:@"currentIsCarManager" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.backMsg isEqualToString:@"回来了"]) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //移除
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
    
    if (_goBangDingCost) {
        _goBangDingCost=NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    if (_leftBtn != nil) {
        [_leftBtn removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentIsCarManager" object:nil];
    [ModelTool stopAllOperation];
}

-(void)getRemoteNotiAndCurrentIsManager:(NSNotification*)sender
{
    [self getData];
}
-(void)addCarMsgOk:(NSNotification*)sender
{
    if ([sender.object isEqualToString:@"1"]) {
        [_tableView reloadData];
        return;
    }
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark - 获取数据

-(void)initialData{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
    }
    [self getData];
    
}

-(void)getData{
//    [_dataArray removeAllObjects];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    /*
#if USENEWVERSION
    [ModelTool getVehicleInfoWithParameter:@{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile} andSuccess:^(id object) {
        MyLog(@"--------车辆管理获取信息-------%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                _dataArray = object[@"data"];
                
                if(_dataArray.count > 0){
                    if(_dataArray.count == 3){
                        self.navigationItem.rightBarButtonItem.title = @"";
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                    }else{
                        self.navigationItem.rightBarButtonItem.title = @"添加";
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }
                    NSString* userCid = _dataArray[0][@"id"];
                    NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                    [thyUserDefaults setValue:userCid forKey:@"cid"];
                    NSMutableDictionary *userDefaultVehicle = [NSMutableDictionary dictionaryWithDictionary:_dataArray[0]];
                    //去除为空得值
                    for (NSString* key in [userDefaultVehicle allKeys]) {
                        if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSDictionary class]]){
                            for (NSString* subKey in [[userDefaultVehicle valueForKey:key] allKeys]) {
                                if([[[userDefaultVehicle valueForKey:key] valueForKey:subKey] isKindOfClass:[NSNull class]]){
                                    [[userDefaultVehicle valueForKey:key] setObject:[PublicUtils checkNSNullWithgetString:[[userDefaultVehicle valueForKey:key] valueForKey:subKey]] forKey:subKey];
                                }
                            }
                        }else{
                            if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSNull class]]){
                                [userDefaultVehicle setObject:[PublicUtils checkNSNullWithgetString:[userDefaultVehicle valueForKey:key]] forKey:key];
                            }
                        }
                    }
                    [thyUserDefaults setObject:userDefaultVehicle forKey:@"userDefaultVehicle"];
                    [NSUserDefaults resetStandardUserDefaults];
                    KUserManager.userCID = userCid;
                    MyLog(@"我的CID：%@",KUserManager.userCID);
                    //创建车辆列表
                    if(_noCarView.subviews.count){
                        [_noCarView removeFromSuperview];
                    }
                    if(!_isLoadTableView){
                        [self creatTableView];
                    }
                    [_tableView reloadData];
                    //[self uploadPoint];
                }else{
                    
                    
                    _noCarView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
                    _noCarView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 55);
                    _noCarView.noDataImageView.image = [UIImage imageNamed:@"mycar_icon"];
                    
                    _noCarView.noDataTitleLabel.text = @"您还没有添加车辆";
                    _noCarView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noCarView.noDataImageView.frame)+30, 150, 20);
                    _noCarView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
                    _noCarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];

                    [self.view addSubview:_noCarView];
                }
            }else {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } andFail:^(NSError *err) {
        MyLog(@"%@",err);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
#else
    [ModelTool httpGetAppGainCarsWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"page":@"1"} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _dataArray = object[@"data"][@"cars"];
                if (_dataArray.count>0) {
                    //                    [_tableView reloadData];
                    //创建车辆列表
                    if(_noCarView.subviews.count){
                        [_noCarView removeFromSuperview];
                    }
                    [self creatTableView];
                    [self uploadPoint];
                }else{
                    //                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前还没有车辆信息，请点击添加以绑定车辆!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    //                    [alert show];
                    _noCarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
                    _noCarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
                    UIImageView* noCarViewImage = [[UIImageView alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-75)/2, 50, 75, 55)];
                    noCarViewImage.image = [UIImage imageNamed:@"mycar_icon"];
                    [_noCarView addSubview:noCarViewImage];
                    UILabel* noCarViewLabel = [[UILabel alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(noCarViewImage.frame)+10, 150, 20)];
                    noCarViewLabel.text = @"您还没有添加车辆";
                    noCarViewLabel.textAlignment = NSTextAlignmentCenter;
                    noCarViewLabel.font = [UIFont boldSystemFontOfSize:16.0];
                    noCarViewLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
                    [_noCarView addSubview:noCarViewLabel];
                    [self.view addSubview:_noCarView];
                    
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
#endif
*/
    

    [HttpHelper searchVehicleListWithUserID:KUserInfo.desc token:KUserInfo.token success:^(AFHTTPRequestOperation *operation,id object){
        
        MyLog(@"--------车辆管理获取信息-------%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"code"] isEqualToString:SERVICE_SUCCESS]){
                _dataArray = object[@"msg"];
                
                if(_dataArray.count > 0){
                    if(_dataArray.count == 3){
                        self.navigationItem.rightBarButtonItem.title = @"";
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                    }else{
                        self.navigationItem.rightBarButtonItem.title = @"添加";
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }
                    //获取默认车辆
                    NSString* userCid = [NSString string];
                    NSLog(@"%@",_dataArray);
                    for(NSDictionary *dateDic in _dataArray){
                        if ([dateDic[@"isDefault"]integerValue]==1) {
                            userCid = dateDic[@"id"];
                        }
                    }
                    
                    NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                    [thyUserDefaults setValue:userCid forKey:@"cid"];
                    NSMutableDictionary *userDefaultVehicle = [NSMutableDictionary dictionaryWithDictionary:_dataArray[0]];
                    //去除为空得值
                    for (NSString* key in [userDefaultVehicle allKeys]) {
                        if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSDictionary class]]){
                            for (NSString* subKey in [[userDefaultVehicle valueForKey:key] allKeys]) {
                                if([[[userDefaultVehicle valueForKey:key] valueForKey:subKey] isKindOfClass:[NSNull class]]){
                                    [[userDefaultVehicle valueForKey:key] setObject:[PublicUtils checkNSNullWithgetString:[[userDefaultVehicle valueForKey:key] valueForKey:subKey]] forKey:subKey];
                                }
                            }
                        }else{
                            if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSNull class]]){
                                [userDefaultVehicle setObject:[PublicUtils checkNSNullWithgetString:[userDefaultVehicle valueForKey:key]] forKey:key];
                            }
                        }
                    }
                    [thyUserDefaults setObject:userDefaultVehicle forKey:@"userDefaultVehicle"];
                    [NSUserDefaults resetStandardUserDefaults];
                    KUserManager.userCID = userCid;
                    MyLog(@"我的CID：%@",KUserManager.userCID);
                    //创建车辆列表
                    if(_noCarView.subviews.count){
                        [_noCarView removeFromSuperview];
                    }
                    if(!_isLoadTableView){
                        [self creatTableView];
                    }
                    [_tableView reloadData];
                    //[self uploadPoint];
                }else{
                    
                    
                    _noCarView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
                    _noCarView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 55);
                    _noCarView.noDataImageView.image = [UIImage imageNamed:@"mycar_icon"];
                    
                    _noCarView.noDataTitleLabel.text = @"您还没有添加车辆";
                    _noCarView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noCarView.noDataImageView.frame)+30, 150, 20);
                    _noCarView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
                    _noCarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
                    
                    [self.view addSubview:_noCarView];
                }
            }else {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });

    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
    
    }];
}
-(void)uploadPoint{
    NSDictionary* dic = @{@"carId":KUserManager.car.carId,@"uid":KUserManager.uid,@"key":KUserManager.key,@"isMode":@"0"};
    [ModelTool httpGetGPSCarInfoWithParameter:dic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_geocodesearch == nil) {
                    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
                    _geocodesearch.delegate = self;
                    isGeoSearch = false;
                }
                CLLocationCoordinate2D lPoint = (CLLocationCoordinate2D){[dic[@"data"][@"data"][@"body"][@"lat"] floatValue], [dic[@"data"][@"data"][@"body"][@"lon"] floatValue]};
                BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
                reverseGeocodeSearchOption.reverseGeoPoint = lPoint;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } faile:^(NSError *err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
#pragma mark - 地图反向解码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"地址: %@",result.address];
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
#warning 注释要崩部分--------------车辆管理
    if ([self.chooseCostOK isEqualToString:@"chooseOK"]) {
        self.chooseCostOK = @"";
        [self getData];
        [self.navigationController setNavigationBarHidden:NO];
    }
    if ([self.backMsg isEqualToString:@"回来了"]) {
        self.backMsg = @"";
        [self getData];
        [self.navigationController setNavigationBarHidden:NO];
    }
    //存储当前界面标记
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"CWSCarManageController" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
    
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSOrderCarWashController class]]) {
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
        _leftBtn.backgroundColor = [UIColor clearColor];
        [self.navigationController.view addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(washCarBack) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)washCarBack
{
    [_leftBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)chooseCostBackToMain:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginToMainController" object:nil];
}

#pragma mark - 创建tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0f;
    _tableView.allowsSelectionDuringEditing = YES; //编辑状态下可以选中
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSCarManagerCell" bundle:nil] forCellReuseIdentifier:@"CWSCarManagerCell"];

    _tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"CWSCarManagerCell";
    CWSCarManagerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[CWSCarManagerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.dicMsg=_dataArray[indexPath.row];
    
    [cellArray addObject:cell];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CWSAddCarController*addCarVC=[[CWSAddCarController alloc]initWithNibName:@"CWSAddCarController" bundle:nil];
    addCarVC.title=@"编辑车辆";
    addCarVC.editDic=_dataArray[indexPath.row];
    [self.navigationController pushViewController:addCarVC animated:YES];
    [_tableView reloadData];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [_tableView setEditing:editing animated:animated];
}



- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"编辑";
}

#pragma mark - tableView代理协议

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CWSCarManagerCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //买车险页面的切换车辆
    if (self.tag == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCar" object:nil userInfo:_dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //本页面切换默认车辆
    else {
        if(![_dataArray[indexPath.row][@"device"] isEqualToString:@""]){
            
            for (CWSCarManagerCell *cell in cellArray) {
                cell.selectButton.selected = NO;
                cell.defaultLabel.hidden = YES;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:KUserManager.uid forKey:@"uid"];
//            [dic setValue:KUserManager.mobile forKey:@"mobile"];
//            [dic setValue:_dataArray[indexPath.row][@"id"] forKey:@"n_cid"];//新的默认车辆ID
//            [dic setValue:KUserManager.userCID forKey:@"o_cid"];//旧的默认车辆ID
            NSLog(@"%@=%@",KUserManager.uid,KUserInfo.desc);
            [dic setObject:KUserInfo.desc forKey:@"userId"];
            [dic setObject:KUserInfo.token forKey:@"token"];
            [dic setObject:_dataArray[indexPath.row][@"id"] forKey:@"vehicleId"];
           
            
            //新接口
            [MBProgressHUD showMessag:@"更改默认车辆中..." toView:self.view];
            [HttpHelper insertDeviceSetDefaultWithUserDic:dic success:^(AFHTTPRequestOperation*operation,id object){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([object[@"code"] isEqualToString:SERVICE_SUCCESS]){
                        MyLog(@"-------------%@",object);
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        //显示默认
                        currentCell.selectButton.selected = YES;
                        currentCell.defaultLabel.text = @"[默认]";
                        currentCell.defaultLabel.hidden = NO;
                        
                        //更改默认车辆信息
                        NSDictionary *defautCarInfo = _dataArray[indexPath.row];
                        //更换UserDefaults中保存的默认车辆cid
                        KUserInfo.defaultDeviceNo = [PublicUtils checkNSNullWithgetString:defautCarInfo[@"deviceNo"]];
                        KUserInfo.defaultVehicleIcon = [PublicUtils checkNSNullWithgetString:defautCarInfo[@"brandIcon"]];
                        KUserInfo.defaultVehicleId = [PublicUtils checkNSNullWithgetString:defautCarInfo[@"id"]];
                        
                        
                        NSString* userCid = defautCarInfo[@"id"];
                        NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                        [thyUserDefaults setValue:userCid forKey:@"cid"];
                        
                        [thyUserDefaults setObject:[PublicUtils checkNSNullWithgetString:defautCarInfo[@"plate"]] forKey:@"defaultVehiclePlate"];
                        [thyUserDefaults setObject:[PublicUtils checkNSNullWithgetString:defautCarInfo[@"deviceNo"]] forKey:@"defaultDeviceNo"];
                        [thyUserDefaults setObject:[PublicUtils checkNSNullWithgetString:defautCarInfo[@"brandIcon"]]  forKey:@"defaultVehicleIcon"];
                        [thyUserDefaults setObject:[PublicUtils checkNSNullWithgetString:defautCarInfo[@"id"]] forKey:@"defaultVehicleId"];
                        NSMutableDictionary *userDefaultVehicle = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
                        //去除为空得值
                        for (NSString* key in [userDefaultVehicle allKeys]) {
                            if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSDictionary class]]){
                                for (NSString* subKey in [[userDefaultVehicle valueForKey:key] allKeys]) {
                                    if([[[userDefaultVehicle valueForKey:key] valueForKey:subKey] isKindOfClass:[NSNull class]]){
                                        [[userDefaultVehicle valueForKey:key] setObject:[PublicUtils checkNSNullWithgetString:[[userDefaultVehicle valueForKey:key] valueForKey:subKey]] forKey:subKey];
                                    }
                                }
                            }else{
                                if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSNull class]]){
                                    [userDefaultVehicle setObject:[PublicUtils checkNSNullWithgetString:[userDefaultVehicle valueForKey:key]] forKey:key];
                                }
                            }
                        }
                        [thyUserDefaults setObject:userDefaultVehicle forKey:@"userDefaultVehicle"];
                        [NSUserDefaults resetStandardUserDefaults];
                        KUserManager.userCID = userCid;
                        
                        MyLog(@"我的CID：%@",KUserManager.userCID);
                        
                        
                    }
                    else {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                });
                
                
            } failure:^(AFHTTPRequestOperation*operation,NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }];

            
           /* [MBProgressHUD showMessag:@"更改默认车辆中..." toView:self.view];
            
            [ModelTool changeDefaultCarWithParameter:dic andSuccess:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                        MyLog(@"-------------%@",object);
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        //显示默认
                        currentCell.selectButton.selected = YES;
                        currentCell.defaultLabel.text = @"[默认]";
                        currentCell.defaultLabel.hidden = NO;
                        
                        
                        //更换UserDefaults中保存的默认车辆cid
                        NSString* userCid = _dataArray[indexPath.row][@"id"];
                        NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                        [thyUserDefaults setValue:userCid forKey:@"cid"];
                        NSMutableDictionary *userDefaultVehicle = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
                        //去除为空得值
                        for (NSString* key in [userDefaultVehicle allKeys]) {
                            if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSDictionary class]]){
                                for (NSString* subKey in [[userDefaultVehicle valueForKey:key] allKeys]) {
                                    if([[[userDefaultVehicle valueForKey:key] valueForKey:subKey] isKindOfClass:[NSNull class]]){
                                        [[userDefaultVehicle valueForKey:key] setObject:[PublicUtils checkNSNullWithgetString:[[userDefaultVehicle valueForKey:key] valueForKey:subKey]] forKey:subKey];
                                    }
                                }
                            }else{
                                if([[userDefaultVehicle valueForKey:key] isKindOfClass:[NSNull class]]){
                                    [userDefaultVehicle setObject:[PublicUtils checkNSNullWithgetString:[userDefaultVehicle valueForKey:key]] forKey:key];
                                }
                            }
                        }
                        [thyUserDefaults setObject:userDefaultVehicle forKey:@"userDefaultVehicle"];
                        [NSUserDefaults resetStandardUserDefaults];
                        KUserManager.userCID = userCid;
                        
                        MyLog(@"我的CID：%@",KUserManager.userCID);
                        
                        
                    }
                    else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            }
            });
            } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            }];
            }else{
            [WCAlertView showAlertWithTitle:@"提示" message:@"该车辆未绑定设备!" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            }*/
        }
        
        
        
    }
}



//-(void)
//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.image = [UIImage imageNamed:@"chedongtai_car"];
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
#pragma mark 添加按钮点击事件
-(void)addCar{
    CWSAddCarController* lController = [[CWSAddCarController alloc] init];
    lController.title = @"添加车辆";
    [self.navigationController pushViewController:lController animated:YES];
}
-(void)btnClick:(UIButton*)sender{
    if (sender.tag == 10) {
        if (sender != _currentBtn) {
            [_currentBtn setBackgroundColor:kMainColor];
            [_currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor whiteColor]];
            [sender setTitleColor:kMainColor forState:UIControlStateNormal];
            [self.view addSubview:_tableView];
            [_mapView removeFromSuperview];
        }
    }else
    {
        if (sender != _currentBtn) {
            [_currentBtn setBackgroundColor:kMainColor];
            [_currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundColor:[UIColor whiteColor]];
            [sender setTitleColor:kMainColor forState:UIControlStateNormal];
            [_tableView removeFromSuperview];
            [self.view addSubview:_mapView];
        }
    }
    _currentBtn = sender;
}
- (void)deleHeadView:(UIButton*)sender {
//    _tableView.tableHeaderView=nil;
    [_tableView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    [_footView removeFromSuperview];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -设置tableView分割线
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
