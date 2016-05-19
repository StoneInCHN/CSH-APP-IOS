//
//  CWSFindParkingSpaceController.m
//  FindCarLocation
//
//  Created by 周子涵 on 15/7/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindParkingSpaceController.h"
#import "FindParkingSpaceMarkView.h"
#import "FindMapData.h"
#import "CWSFindParkSearchView.h"
#import "CWSParkMapView.h"
#import "ParkMarkView.h"

#define kUSER_SCROLLVIEW_WIDTH (kSizeOfScreen.width-40)
#define SCROLLVIEW_Y  (kSizeOfScreen.height - SCROLLVIEW_HIGHT + kSTATUS_BAR)
CGFloat SCROLLVIEW_HIGHT = 83;
CGFloat SPACE = 20;

@interface CWSFindParkingSpaceController ()<MarkCellClickDelegate,CWSFindMapDelegate,ParkMarkCellClickDelegate,FindParkSearchViewDelegate>
{
    NSMutableArray*     _mainDataArray;
    NSMutableArray*     _minorDataArray;
    UIScrollView *      _scrollView;
    UIScrollView *      _userScrollView;
    int                 _currentNumber;
    BOOL                _isEnd;
    CWSParkMapView*     _findMapView;
    ParkMarkView*       _parkMarkView;
    UIButton*           _markBtn;
    UISearchBar*        _searchBar;
    FindParkingSpaceMarkView* _findParkingSpaceMarkView;
    CWSFindParkSearchView* _findParkSearchView;
}
@end

@implementation CWSFindParkingSpaceController
-(void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar{
    _oldPt = coordinate;
    NSDictionary* dic = @{@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
                          @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude]};
    [ModelTool httpGetParkWithParameter:dic success:^(id object) {
        [self hideHud];
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        MyLog(@"%@",dic[@"data"][@"data"][@"message"]);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            [_mainDataArray removeAllObjects];
            int temp = 0;
            for (NSDictionary* ldic in dic[@"data"][@"data"][@"parkInfoList"]) {
                Park* interest = [[Park alloc] initWithDic:ldic];
                if (temp < 10) {
                    [_mainDataArray addObject:interest];
                }else{
                    [_minorDataArray addObject:interest];
                }
                temp ++;
            }
            FindMapData* findMapData = [[FindMapData alloc] init];
            findMapData.point = coordinate;
            findMapData.nearbyCar = NO;
            findMapData.coordArray = _mainDataArray;
            findMapData.minorCoordArray = _minorDataArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_findMapView reloadData:findMapData type:1];
                _findParkingSpaceMarkView = [[FindParkingSpaceMarkView alloc] initWithFrame:CGRectMake(0, SCROLLVIEW_Y - 10, kSizeOfScreen.width, SCROLLVIEW_HIGHT) Dictionary:@{@"list":_mainDataArray}];
                _findParkingSpaceMarkView.delegate = self;
                [self.view addSubview:_findParkingSpaceMarkView];
                _parkMarkView = [[ParkMarkView alloc] initWithFrame:CGRectMake(20, SCROLLVIEW_Y - 10, kUSER_SCROLLVIEW_WIDTH, SCROLLVIEW_HIGHT) Park:_minorDataArray[0]];
                _parkMarkView.hidden = YES;
                [self.view addSubview:_parkMarkView];
                
            });
        }
    } faile:^(NSError *err) {
        [self hideHud];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isEnd = NO;
    _currentNumber = 0;
    _mainDataArray = [NSMutableArray array];
    _minorDataArray = [NSMutableArray array];
    _markArray = @[@"10米",@"20米",@"50米",@"100米",@"500米",@"1公里",@"2公里",@"5公里",@"10公里",@"20公里",@"25公里",@"50公里",@"100公里",@"200公里",@"500公里",@"1000公里",@"2000公里",@"2000公里"];
    //设置UI
    [self setUI];
    //创建搜索控件
    [self creatHeadSearchView];
    //创建地图View
    [self creatMapView];
    //定位
    [self shouji];
    //搜索View
    _findParkSearchView = [[CWSFindParkSearchView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height + kSTATUS_BAR)];
    _findParkSearchView.delegate = self;
    [self.view insertSubview:_findParkSearchView atIndex:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
#pragma mark - 设置UI
-(void)setUI{
    [Utils setViewRiders:self.searchGroundView riders:4];
    [self.searchView setFrame:CGRectMake(0, 20, kSizeOfScreen.width, kDockHeight)];
    self.searchView.hidden = YES;
    [self.view addSubview:self.searchView];
    [Utils setViewRiders:self.searchViewGroundView riders:4];
}
#pragma mark - 创建地图
-(void)creatMapView{
    _findMapView = [[CWSParkMapView alloc] initWithFrame:CGRectMake(0, kDockHeight + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _findMapView.type = 1;
    _findMapView.delegate = self;
    [self.view insertSubview:_findMapView atIndex:0];
    
    _markBtn = [Utils buttonWithFrame:CGRectMake(51, kSizeOfScreen.height + kSTATUS_BAR - 133, 38, 27) title:nil titleColor:[UIColor blackColor] font:kFontOfSize(8)];
    [_markBtn setBackgroundImage:[UIImage imageNamed:@"zhaochewei_dingwei_mi"] forState:UIControlStateNormal];
    [self.view addSubview:_markBtn];
}
-(void)creatHeadSearchView{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(43, 25, 188, 31)];
    self.navigationItem.titleView = _searchBar;
}
#pragma mark - 手机定位
-(void)shouji{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    _nearbyCar = NO;
    [self showHudInView:self.view hint:@"数据加载中..."];
    [self getHttpData:point nearbyCar:NO];
}
#pragma CWSParkMapView代理协议
-(void)pointClick:(NSString *)name{
    if ([name intValue] < 10) {
        _findParkingSpaceMarkView.hidden = NO;
        _parkMarkView.hidden = YES;
        [_findParkingSpaceMarkView reloadMark:[name intValue]];
    }else{
        _findParkingSpaceMarkView.hidden = YES;
        _parkMarkView.hidden = NO;
        [_parkMarkView reloadCell:_minorDataArray[[name intValue] - 10]];
    }
}
#pragma mark - CWSParkMapView代理协议
-(void)cellClick:(NSString *)type{
    MyLog(@"%@",type);
}
-(void)cellNavClick:(NSString *)type{
    MyLog(@"导航%@",type);
}
-(void)cellScrollEnd:(NSString *)type{
    MyLog(@"停止%@",type);
    [_findMapView reloadParkAnnotation:type];
}
#pragma mark - ParkMarkView代理协议
-(void)parkCellClick:(Park *)park{
    MyLog(@"%@",park.name);
}
-(void)parkCellNavClick:(Park *)park{
    MyLog(@"%@",park.name);
}
-(void)mapZoomLevel:(CGFloat)level{
    [_markBtn setTitle:[NSString stringWithFormat:@"%@",_markArray[_markArray.count + 2 - (int)level]] forState:UIControlStateNormal];
    CGRect frame = _markBtn.frame;
    frame.size.width = 38 + 24*(level - (int)level);
    _markBtn.frame = frame;
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
        }
            break;
        case 3:
        {
            MyLog(@"搜索");
            [self.view bringSubviewToFront:_findParkSearchView];
        }
            break;
        case 4:
        {
            MyLog(@"取消");
            [self.view sendSubviewToBack:_findParkSearchView];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 改变地图zoomLevel大小点击事件
- (IBAction)addBtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        [_findMapView changeMapZoomLevel:1];
    }else{
        [_findMapView changeMapZoomLevel:-1];
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            MyLog(@"我旁边");
        }
            break;
        case 3:
        {
            [_findMapView backPoint:_oldPt];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)btnTouchDown:(UIButton *)sender {
    MyLog(@"按钮点击");
    self.searchView.hidden = NO;
    [self.searchTextField becomeFirstResponder];
}
@end
