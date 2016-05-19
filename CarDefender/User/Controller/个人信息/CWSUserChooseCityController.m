//
//  CWSUserChooseCityController.m
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//33

#import "CWSUserChooseCityController.h"
#import "CWSUserMsgSettingController.h"
#import "ProvinceView.h"
#import <BaiduMapAPI/BMapKit.h>
@interface CWSUserChooseCityController ()<UITableViewDataSource,UITableViewDelegate,ProvinceViewDelegate,BMKGeoCodeSearchDelegate>
{
    NSArray*_provinces;
    UITableView*_tableview;
    ProvinceView*_provincesview;
    NSIndexPath*_oldIndexPath;
    NSArray*_addressArray;
    NSDictionary*firstDic;
    UIView* _headView;
    UILabel* _cityLable;
    UILabel* _markLabel;
    
    NSString*                cityString;
    BMKGeoCodeSearch*        _geocodesearch;
    bool                     isGeoSearch;
     NSArray*             _cityArray;
    
}

@end

@implementation CWSUserChooseCityController
-(void)getGPSCity{
    [self showHudInView:self.view hint:@"定位中..."];
    [ModelTool httpGetCityWithParameter:@{@"province":[KManager.currentCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"district":[KManager.currentSubCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} success:^(id object) {
        [self hideHud];
        if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
            KManager.currentCityID = object[@"data"][@"msg"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadHeadView];
            });
        }else{
            KManager.currentCityID = @"";
        }
        [self hideHud];
        
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
-(void)getLocationCity{
    
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
        isGeoSearch = false;
        NSLog(@"%f-%f",KManager.currentPt.latitude,KManager.currentPt.longitude);
    }
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [self creatHeadView];
    [self allMethod];
}
-(void)allMethod
{
    _cityArray = @[@"重庆市",@"北京市",@"天津市",@"上海市",@"香港特别行政区",@"澳门特别行政区"];
    //获取数据
    [self getData];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchbegan:) name:@"touchbegan" object:nil];
}
-(void)touchbegan:(NSNotification*)sender
{
    [_provincesview removeFromSuperview];
}
-(void)getData
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetAppGainCityWithParameter:@{@"grade":@"1"} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _provinces = object[@"data"][@"city"];
                //创建列表
                [self buildTableView];
            }else{
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)creatHeadView{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 84)];
    _headView.backgroundColor = kCOLOR(245, 245, 245);
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kSizeOfScreen.width, 44)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:whiteView];
    
    NSString* city;
    NSString* mark;
    if (KManager.currentSubCity!=nil || KManager.currentSubCity.length) {
        city = [NSString stringWithFormat:@"%@-%@",KManager.currentCity,KManager.currentSubCity];
        mark = @"GPS定位";
    }else{
        city = @"未获取到定位";
        mark = @"重新定位";
    }
    
    _cityLable = [Utils labelWithFrame:CGRectMake(10, 11, 193, 21) withTitle:city titleFontSize:kFontOfSize(17) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    [whiteView addSubview:_cityLable];
    
    _markLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 113, 11, 103, 21) withTitle:mark titleFontSize:kFontOfSize(17) textColor:kMainColor alignment:NSTextAlignmentRight];
    [whiteView addSubview:_markLabel];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 44)];
    [btn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
}
#pragma mark - 创建tableview
-(void)buildTableView
{
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight)];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.tableHeaderView = _headView;
    [self.view addSubview:_tableview];
}
#pragma mark - tableview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIDa=@"myCell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIDa];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDa];
    }
    
    cell.textLabel.text=_provinces[indexPath.row][@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//都有二级菜单
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _oldIndexPath=indexPath;
    firstDic = _provinces[indexPath.row];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetAppGainCityWithParameter:@{@"grade":@"2",@"parent":_provinces[indexPath.row][@"cid"]} success:^(id object) {
       dispatch_async(dispatch_get_main_queue(), ^{
           MyLog(@"%@",object);
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
               [self buildProvincesView];
               _provincesview.provincesArray=object[@"data"][@"city"];
           }else{
               UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               [alert show];
           }
       });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 创建城市二级菜单
-(void)buildProvincesView
{
    if (_provincesview==nil) {
        _provincesview=[[ProvinceView alloc]initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, 320, _tableview.frame.size.height)];
        _provincesview.delegate=self;
    }
    [self.view addSubview:_provincesview];
}
-(void)provinceViewWithBackMsg:(NSDictionary *)secondDic
{
    [self.navigationController popViewControllerAnimated:YES];
    NSArray*arrayback=@[firstDic,secondDic];
    
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[CWSUserMsgSettingController class]]) {
        CWSUserMsgSettingController *userMsgVC = (CWSUserMsgSettingController*)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        userMsgVC.cityMsgBack = [NSArray arrayWithArray:arrayback];
        userMsgVC.chooseMsgBack = @"回来了";
        [self.navigationController popToViewController:userMsgVC animated:YES];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseCityMsgBack" object:arrayback];
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result.addressDetail.city == nil || [result.addressDetail.city isEqualToString:@""]) {
        return;
    }
    NSString* province;
    NSString* city;
    if ([_cityArray containsObject:result.addressDetail.province]) {
        province = result.addressDetail.city;
        city = result.addressDetail.district;
    }else{
        province = result.addressDetail.province;
        city = result.addressDetail.city;
    }
    KManager.currentCity = province;
    KManager.currentSubCity = city;
    [self getGPSCity];
}
- (void)headBtnClick {
   
    if (KManager.currentSubCity!=nil || KManager.currentSubCity.length) {
        _cityLable.text = [NSString stringWithFormat:@"%@-%@",KManager.currentCity,KManager.currentSubCity];
        _markLabel.text = @"GPS定位";
        MyLog(@"GPS定位");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseCityMsgBack" object:@[@{@"name":KManager.currentCity},@{@"name":KManager.currentSubCity,@"cid":KManager.currentCityID}]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _cityLable.text = @"未获取到定位";
        _markLabel.text = @"重新定位";
        [self getLocationCity];
        MyLog(@"重新定位");
    }
}
-(void)reloadHeadView{
    if (KManager.currentSubCity!=nil || KManager.currentSubCity.length) {
        _cityLable.text = [NSString stringWithFormat:@"%@-%@",KManager.currentCity,KManager.currentSubCity];
        _markLabel.text = @"GPS定位";
        
    }else{
        _cityLable.text = @"未获取到定位";
        _markLabel.text = @"重新定位";
        
    }
}
@end
