//
//  CWSOrderCarWashController.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSOrderCarWashController.h"
//#import "FindParkingSpaceMarkView.h"
#import "CarWashSpaceMarkView.h"
//#import "CWSFindCarLocDetailController.h"
#import "CWSCarWashDetileController.h"
#import "FindMapData.h"
#import "CWSFindParkSearchView.h"
#import "CWSParkMapView.h"
#import "ParkMarkView.h"
//#import "CWSParkTabelView.h"
#import "CWSCarWashTabelView.h"
#import "SubmitDateView.h"
#import "OrderWash.h"
#import "CWSCarManageController.h"
#import "CWSOrderHistoryController.h"

#define kUSER_SCROLLVIEW_WIDTH (kSizeOfScreen.width-40)
#define SCROLLVIEW_Y  (kSizeOfScreen.height - SCROLLVIEW_HIGHT - kDockHeight)
extern CGFloat SCROLLVIEW_HIGHT;
extern CGFloat SPACE;

@interface CWSOrderCarWashController ()<MarkCellClickDelegate,CWSFindMapDelegate,ParkMarkCellClickDelegate,FindParkSearchViewDelegate,ParkTabelViewDelegate,SubmitDateViewDelegate>
{
    NSMutableArray*            _mainDataArray;   //主数据
    UIScrollView *             _scrollView;
    UIScrollView *             _userScrollView;
    UIButton*                  _markBtn;
    UIButton*                  _naviRightBtn;
    UISearchBar*               _searchBar;
    int                        _currentNumber;
    BOOL                       _isEnd;
    BOOL                       _isCQ;
    BOOL                       _traffic;
    FindMapData*               _findMapData;
    CWSParkMapView*            _findMapView;
    CWSCarWashTabelView*       _parkTabelView;
    CarWashSpaceMarkView*      _findParkingSpaceMarkView;
    
    SubmitDateView*            _submitDateView;
    Park*                      _currentPark;
    NSString                   *_time;//剩余次数
}
@property (weak, nonatomic) IBOutlet UIView *functionListView;
@property (weak, nonatomic) IBOutlet UIView *functionRoadView;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *functionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *functionListImageView;

@end

@implementation CWSOrderCarWashController
-(void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar City:(NSString*)city{
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key,
                          @"cid":KUserManager.car.cid,
                          @"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
                          @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude]
                          };
    [ModelTool httpGetCarwashWithParameter:dic success:^(id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];//jifenshangcheng_click
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_mainDataArray removeAllObjects];
            _findMapView.normalPoint = coordinate;
            int temp = 0;
            //剩余次数
            _time = [NSString stringWithFormat:@"%i",4-[dic[@"data"][@"count"] intValue]];
            for (NSDictionary* ldic in dic[@"data"][@"data"]) {
                //                Park* interest = [[Park alloc] initWithDic:ldic];
                Park* interest = [[Park alloc] initWithCarWashDic:ldic];
                [_mainDataArray addObject:interest];
                temp ++;
            }
            if (_findMapData == nil) {
                _findMapData = [[FindMapData alloc] init];
            }
            _findMapData.point = coordinate;
            _findMapData.nearbyCar = nearbyCar;
            _findMapData.coordArray = _mainDataArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_findMapView reloadData:_findMapData type:6];
                if (_findParkingSpaceMarkView == nil) {
                    _findParkingSpaceMarkView = [[CarWashSpaceMarkView alloc] initWithFrame:CGRectMake(0, SCROLLVIEW_Y - 10, kSizeOfScreen.width, SCROLLVIEW_HIGHT) Dictionary:@{@"list":_mainDataArray}];
                    _findParkingSpaceMarkView.delegate = self;
                    [self.view addSubview:_findParkingSpaceMarkView];
                }else{
                    [_findParkingSpaceMarkView reloadData:@{@"list":_mainDataArray}];
                }
                NSMutableArray* dataArray = [NSMutableArray arrayWithArray:_mainDataArray];
                if (_parkTabelView == nil) {
                    _parkTabelView = [[CWSCarWashTabelView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) DataArray:dataArray];
                    _parkTabelView.delegate = self;
                    _parkTabelView.hidden = YES;
                    [self.view addSubview:_parkTabelView];
                }else{
                    [_parkTabelView reloadData:dataArray];
                }
            });
        }
        else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        _submitDateView = [[SubmitDateView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height) StarDate:[NSDate date] time:_time PredeterminateViewStyle:PredeterminateStyle];
        _submitDateView.hidden = YES;
        _submitDateView.delegate = self;
        [self.view addSubview:_submitDateView];
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    //1.初始化数据
    [self initData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //2.设置UI
    [self setUI];
    //3.创建地图View
    [self creatMapView];
    //4.定位
    [self shouji];
    //5.设置提交View

    

//    _submitDateView = [[SubmitDateView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height) StarDate:[NSDate date] time:_time PredeterminateViewStyle:PredeterminateStyle];
//    _submitDateView.hidden = YES;
//    _submitDateView.delegate = self;
//    [self.view addSubview:_submitDateView];
}
-(void)setUI{
    self.title = @"预约洗车";
    _naviRightBtn = [[UIButton alloc] init];
    [_naviRightBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_naviRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    _naviRightBtn.titleLabel.font = kImageFontOfSize(14);
    _naviRightBtn.titleLabel.font = kFontOfSize(14);
    [_naviRightBtn sizeToFit];
    [_naviRightBtn addTarget:self action:@selector(naviRightBtnClick)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:_naviRightBtn];
    
    self.navigationItem.rightBarButtonItem= rightItem;
}
#pragma mark - 初始化数据
-(void)initData{
    [Utils changeBackBarButtonStyle:self];
    _isEnd = NO;
    _traffic = NO;
    _currentNumber = 0;
    _mainDataArray = [NSMutableArray array];
    [Utils setViewRiders:self.functionListView riders:4];
    [Utils setViewRiders:self.functionRoadView riders:4];
}
#pragma mark - 创建地图
-(void)creatMapView{
    _findMapView = [[CWSParkMapView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _findMapView.type = 1;
    _findMapView.delegate = self;
    [self.view insertSubview:_findMapView atIndex:0];
    
    _markBtn = [Utils buttonWithFrame:CGRectMake(51, kSizeOfScreen.height + kSTATUS_BAR - 133, 38, 27) title:nil titleColor:KBlackMainColor font:kFontOfSize(8)];
    [_markBtn setBackgroundImage:[UIImage imageNamed:@"zhaochewei_dingwei_mi"] forState:UIControlStateNormal];
    [self.view addSubview:_markBtn];
}
#pragma mark - 手机定位
-(void)shouji{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    _nearbyCar = NO;
    [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
    _oldPt = point;
    _findMapView.normalPoint = _oldPt;
    [self getHttpData:KManager.mobileCurrentPt nearbyCar:NO City:KManager.currentCity];
}
#pragma mark - 预约方法

-(void)order:(Park*)park{
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key,
                          @"cid":KUserManager.car.cid,
                          @"cw_id":park.parkID,
                          @"time":@"2015-10-20"};
    [MBProgressHUD showMessag:@"数据请求中..." toView:self.view];
    [ModelTool httpGetAddOrderWithParameter:dic success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if ([object[@"data"][@"status"] isEqualToString:@"1"]) {
                    CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
                    lController.title = @"详情";
                    lController.oldPt = _oldPt;
                    lController.time = [_time integerValue];
                    OrderWash* lOrderWash = [[OrderWash alloc] initWithPark:_currentPark];
                    lOrderWash.uno = object[@"data"][@"uno"];
                    lOrderWash.time = object[@"data"][@"time"];
                    lController.orderWash = lOrderWash;
                    lController.state = 1;
                    [self.navigationController pushViewController:lController animated:YES];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"title"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma CWSParkMapView代理协议
-(void)pointClick:(NSString *)name{
    _findParkingSpaceMarkView.hidden = NO;
    [_findParkingSpaceMarkView reloadMark:[name intValue]];
}
#pragma mark - CWSParkMapView代理协议
-(void)cellClick:(NSString *)type{
    MyLog(@"%@",type);
    [self intoContent:[self getPark:[type intValue]]];
}
-(void)cellNavClick:(NSString *)type{
//    Park* park = [self getPark:[type intValue]];
//    _currentPark = park;
//    _submitDateView.hidden = NO;
//    [self.view bringSubviewToFront:_submitDateView];
    
    [self intoContent:[self getPark:[type intValue]]];
    
}
-(void)cellScrollEnd:(NSString *)type{
    MyLog(@"停止%@",type);
    [_findMapView reloadParkAnnotation:type];
}
#pragma mark - CWSParkTableView代理协议
-(void)parkTabelViewCellClick:(Park *)park{
    [self intoContent:park];
}
-(void)parkTabelViewNavClick:(Park *)park{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[park.latitude floatValue], [park.longitude floatValue]};
    [self startNaviWithNewPoint:point OldPoint:_oldPt];
}
-(void)parkTabelViewOrderClick:(Park*)park{
    MyLog(@"预约点击");
//    _currentPark = park;
//    _submitDateView.hidden = NO;
//    [self.view bringSubviewToFront:_submitDateView];
    //    [self order:park];
    [self intoContent:park];
}
#pragma mark - ParkMarkView代理协议
-(void)parkCellClick:(Park *)park{
    [self intoContent:park];
}
-(void)parkCellNavClick:(Park *)park{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[park.latitude floatValue], [park.longitude floatValue]};
}
-(void)carManagerBtnClick{
    CWSCarManageController* lController = [[CWSCarManageController alloc] init];
    [self.navigationController pushViewController:lController animated:YES];
}
#pragma mark - FindParkSearchView代理协议
-(void)findParkSearchViewBtnClick:(int)tag{
    switch (tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            MyLog(@"改变");
            if (_nearbyCar) {
                [self shouji];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)destinationClickWithPt:(CLLocationCoordinate2D)pt City:(NSString*)city{
    _nearbyCar = YES;
    [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
    [self getHttpData:pt nearbyCar:YES City:city];
}
#pragma SubmitDateView代理协议
-(void)submitDateBtnClickWithStyle:(SubmitDateClickStyle)style Date:(NSString *)date{
    if (style == SubmitStyle) {
        MyLog(@"%@",date);
        _submitDateView.hidden = YES;
        NSDictionary* dic = @{@"uid":KUserManager.uid,
                              @"key":KUserManager.key,
                              @"cid":KUserManager.car.cid,
                              @"cw_id":_currentPark.parkID,
                              @"time":date};
        [MBProgressHUD showMessag:@"数据请求中..." toView:self.view];
        [ModelTool httpGetAddOrderWithParameter:dic success:^(id object) {
            MyLog(@"%@",object);
            MyLog(@"%@",object[@"data"][@"msg"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    if ([object[@"data"][@"status"] isEqualToString:@"1"]) {
                        CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
                        lController.title = @"详情";
                        lController.oldPt = _oldPt;
                        OrderWash* lOrderWash = [[OrderWash alloc] initWithPark:_currentPark];
                        lOrderWash.uno = object[@"data"][@"uno"];
                        lOrderWash.time = object[@"data"][@"time"];
                        lController.orderWash = lOrderWash;
                        lController.state = 1;
                        [self.navigationController pushViewController:lController animated:YES];
                    }else{
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"title"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            });
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }else{
        _submitDateView.hidden = YES;
    }
}
#pragma mark - 根据number获取Park
-(Park*)getPark:(int)number{
    Park* park = _mainDataArray[number];
    return park;
}

#pragma mark - 进入列表详情界面
-(void)intoContent:(Park*)park{
    CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
    lController.title = @"详情";
    lController.oldPt = _oldPt;
    lController.time = [_time integerValue];
    OrderWash* lOrderWash = [[OrderWash alloc] initWithPark:park];
    lController.orderWash = lOrderWash;
    lController.state = 0;
    [self.navigationController pushViewController:lController animated:YES];
}


#pragma mark - 功能按钮点击事件
- (IBAction)functionBtnClick:(UIButton *)sender {
    if (sender.tag == 10) {
        _parkTabelView.hidden = !_parkTabelView.hidden;
        [self.view bringSubviewToFront:self.functionListView];
        if (!_parkTabelView.hidden) {
            self.functionLabel.text = @"地图";
            self.functionListImageView.image = [UIImage imageNamed:@"zhaochewei_ditu_icon"];
        }else{
            self.functionLabel.text = @"列表";
            self.functionListImageView.image = [UIImage imageNamed:@"zhaochewei_liebiao"];
        }
        
    }else{
        _traffic = !_traffic;
        if (_traffic) {
            self.functionImageView.image = [UIImage imageNamed:@"zhaochewei_lukuang_click"];
        }else{
            self.functionImageView.image = [UIImage imageNamed:@"zhaochewei_lukuang"];
        }
        [_findMapView changeTraffic:_traffic];
    }
}
-(void)naviRightBtnClick{
    CWSOrderHistoryController* lController = [[CWSOrderHistoryController alloc] init];
    lController.time = [_time integerValue];
    lController.title = @"我的订单";
    [self.navigationController pushViewController:lController animated:YES];
}
@end
