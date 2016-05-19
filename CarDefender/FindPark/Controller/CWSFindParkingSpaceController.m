//
//  CWSFindParkingSpaceController.m
//  FindCarLocation
//
//  Created by 周子涵 on 15/7/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindParkingSpaceController.h"
#import "FindParkingSpaceMarkView.h"
#import "CWSFindCarLocDetailController.h"
#import "FindMapData.h"
#import "CWSFindParkSearchView.h"
#import "CWSParkMapView.h"
#import "ParkMarkView.h"
#import "CWSParkTabelView.h"
//#import "BNRoutePlanModel.h"
//#import "BNCoreServices.h"
#import "CWSFindParkSearchViewController.h"

#define kUSER_SCROLLVIEW_WIDTH (kSizeOfScreen.width-40)
#define SCROLLVIEW_Y  (kSizeOfScreen.height - SCROLLVIEW_HIGHT + kSTATUS_BAR)
CGFloat SCROLLVIEW_HIGHT = 83;
CGFloat SPACE = 20;

@interface CWSFindParkingSpaceController ()<MarkCellClickDelegate,CWSFindMapDelegate,ParkMarkCellClickDelegate,FindParkSearchDelegate,ParkTabelViewDelegate>
{
    NSMutableArray*            _mainDataArray;   //主数据
    NSMutableArray*            _minorDataArray;  //水滴数据
    UIScrollView *             _scrollView;
    UIScrollView *             _userScrollView;
    UIButton*                  _markBtn;
    UISearchBar*               _searchBar;
    int                        _currentNumber;
    BOOL                       _isEnd;
    BOOL                       _isCQ;
    BOOL                       _traffic;
    FindMapData*               _findMapData;
    CWSParkMapView*            _findMapView;
    CWSParkTabelView*          _parkTabelView;
    ParkMarkView*              _parkMarkView;
    FindParkingSpaceMarkView*  _findParkingSpaceMarkView;
    CWSFindParkSearchView*     _findParkSearchView;
    UIButton                   *_currentBtn;
    UIButton                    *rightButton;
    NSInteger                   tag;//判断头部是否显示删除按钮
    UIView                       *headView;
}
//@property (assign, nonatomic) BN_NaviType naviType;

@property (weak, nonatomic) IBOutlet UIButton *headMapButton;
@property (weak, nonatomic) IBOutlet UIView *headMapLineView;
@property (weak, nonatomic) IBOutlet UIButton *headListButton;

@property (weak, nonatomic) IBOutlet UIView *headListLineView;


@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
- (IBAction)leftButtonClick:(UIButton *)sender;
- (IBAction)headChangeButtonClick:(UIButton *)sender;

@end

@implementation CWSFindParkingSpaceController
-(void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar City:(NSString*)city{
    NSDictionary* dic;
    NSRange lRang=[city rangeOfString:@"重庆"];
    if (lRang.location==NSNotFound) {
        dic = @{@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
                @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],
                @"type":@"qt"};
        _isCQ = NO;
    }else{
        dic = @{@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
                @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],
                @"type":@"cq"};
        _isCQ = YES;
    }
    [ModelTool httpGetParkWithParameter:dic success:^(id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary* dic = object;
        MyLog(@"%@",dic);

//        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_mainDataArray removeAllObjects];
                [_minorDataArray removeAllObjects];
                _findMapView.normalPoint = coordinate;
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
                if (_mainDataArray.count == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"未获取到任何数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];return;
                }
                if (_findMapData == nil) {
                    _findMapData = [[FindMapData alloc] init];
                }
                _findMapData.point = coordinate;
                _findMapData.nearbyCar = nearbyCar;
                _findMapData.coordArray = _mainDataArray;
                _findMapData.minorCoordArray = _minorDataArray;
                
                [_findMapView reloadData:_findMapData type:1];
                if (_findParkingSpaceMarkView == nil) {
                    _findParkingSpaceMarkView = [[FindParkingSpaceMarkView alloc] initWithFrame:CGRectMake(0, SCROLLVIEW_Y - 10, kSizeOfScreen.width, SCROLLVIEW_HIGHT) Dictionary:@{@"list":_mainDataArray}];
                    _findParkingSpaceMarkView.delegate = self;
                    [self.view addSubview:_findParkingSpaceMarkView];
                }else{
                    [_findParkingSpaceMarkView reloadData:@{@"list":_mainDataArray}];
                }
                NSMutableArray* dataArray = [NSMutableArray arrayWithArray:_mainDataArray];
                [dataArray addObjectsFromArray:_minorDataArray];
                if (_parkTabelView == nil) {
                    _parkTabelView = [[CWSParkTabelView alloc] initWithFrame:CGRectMake(0, kDockHeight + kSTATUS_BAR+40, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight-100) DataArray:dataArray];
                    _parkTabelView.delegate = self;
                    _parkTabelView.hidden = YES;
                    [self.view addSubview:_parkTabelView];
                }else{
                    [_parkTabelView reloadData:dataArray];
                }
                if (_parkMarkView == nil) {
                    _parkMarkView = [[ParkMarkView alloc] initWithFrame:CGRectMake(20, SCROLLVIEW_Y - 10, kUSER_SCROLLVIEW_WIDTH, SCROLLVIEW_HIGHT) Park:_minorDataArray[0]];
                    _parkMarkView.hidden = YES;
                    _parkMarkView.delegate = self;
                    [Utils setViewRiders:_parkMarkView riders:4];
                    [Utils setBianKuang:KGroundColor Wide:1 view:_parkMarkView];
                    [self.view addSubview:_parkMarkView];
                }
                
            }
            else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
//        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找车位";
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"jiuyuan_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    tag = 1;
    //1.初始化数据
    _isEnd = NO;
    _traffic = NO;
    _currentNumber = 0;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _mainDataArray = [NSMutableArray array];
    _minorDataArray = [NSMutableArray array];
    
    //2.设置UI
    [self setUI];
    //3.创建地图View
    [self creatMapView];
    //4.定位
    [self shouji];
    
    //地图、列表选择view
    UIView *headChooseView = [[[NSBundle mainBundle] loadNibNamed:@"FindGasStationHeadView" owner:self options:nil] lastObject];
    headChooseView.frame = CGRectMake(0, kDockHeight + kSTATUS_BAR, kSizeOfScreen.width, 40);
    [self.view insertSubview:headChooseView atIndex:1];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _currentBtn = self.headMapButton;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ModelTool stopAllOperation];
}

#pragma mark - 搜索
- (void)rightBarButtonItemClick:(UIBarButtonItem *)item
{
    
    if (tag == 1) {
        CWSFindParkSearchViewController *vc = [[CWSFindParkSearchViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (tag == 2){
        
        [headView removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = @"找车位";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = KBlackMainColor;
        label.font = [UIFont systemFontOfSize:17];
        [self.navigationItem setTitleView:label];
        tag = 1;
        [rightButton setBackgroundImage:[UIImage imageNamed:@"jiuyuan_search"] forState:UIControlStateNormal];
        [self shouji];
    }
    
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
    _findMapView = [[CWSParkMapView alloc] initWithFrame:CGRectMake(0, kDockHeight + kSTATUS_BAR+40, kSizeOfScreen.width, kSizeOfScreen.height-40 )];
    _findMapView.type = 1;
    _findMapView.delegate = self;
    [self.view insertSubview:_findMapView atIndex:0];
    
//    _markBtn = [Utils buttonWithFrame:CGRectMake(51, kSizeOfScreen.height + kSTATUS_BAR - 133, 38, 27) title:nil titleColor:[UIColor blackColor] font:kFontOfSize(8)];
//    [_markBtn setBackgroundImage:[UIImage imageNamed:@"zhaochewei_dingwei_mi"] forState:UIControlStateNormal];
//    [self.view addSubview:_markBtn];
}
#pragma mark - 手机定位
-(void)shouji{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){KManager.mobileCurrentPt.latitude, KManager.mobileCurrentPt.longitude};
    
    _nearbyCar = NO;
    [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
    _oldPt = point;
    _findMapView.normalPoint = _oldPt;
    [self getHttpData:KManager.mobileCurrentPt nearbyCar:NO City:KManager.currentCity];
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
//    [self intoContent:[self getPark:[type intValue]]];
}

-(void)cellNavClick:(NSString *)type{
    Park* park = [self getPark:[type intValue]];
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[park.latitude floatValue], [park.longitude floatValue]};
    [self startNaviWithNewPoint:point OldPoint:_oldPt];
}

-(void)cellScrollEnd:(NSString *)type{
    MyLog(@"停止%@",type);
    [_findMapView reloadParkAnnotation:type];
}

#pragma mark - CWSParkTableView代理协议
-(void)parkTabelViewCellClick:(Park *)park{
//    [self intoContent:park];
}

-(void)parkTabelViewNavClick:(Park *)park{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[park.latitude floatValue], [park.longitude floatValue]};
    [self startNaviWithNewPoint:point OldPoint:_oldPt];
}

#pragma mark - ParkMarkView代理协议
-(void)parkCellClick:(Park *)park{
//    [self intoContent:park];
}

-(void)parkCellNavClick:(Park *)park{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[park.latitude floatValue], [park.longitude floatValue]};
    [self startNaviWithNewPoint:point OldPoint:_oldPt];
}

#pragma mark - FindParkSearchView代理协议

-(void)destinationClickWithPt:(CLLocationCoordinate2D)pt City:(NSString*)city{
    
    _nearbyCar = YES;
    [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
    [self getHttpData:pt nearbyCar:YES City:city];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    headView.layer.borderWidth = 1;
    headView.layer.cornerRadius = 5;
    headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhaochewei_sousuo.png"]];
    imageView.frame = CGRectMake(9, 8, 12, 12);
    [headView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.endX+5,0 , headView.bounds.size.width-30, headView.bounds.size.height)];
    label.text = city;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    [headView addSubview:label];
    
    [self.navigationItem setTitleView:headView];
    tag = 2;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"weizhang_shan"] forState:UIControlStateNormal];
}



#pragma mark - 根据number获取Park
-(Park*)getPark:(int)number{
    Park* park;
    if (number < 10) {
        park = _mainDataArray[number];
    }else{
        park = _mainDataArray[number - 10];
    }
    return park;
}

#pragma mark - 进入列表详情界面
-(void)intoContent:(Park*)park{
    if (_isCQ) {
        [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
        [ModelTool httpGetParkInfoWithParameter:@{@"parkID":park.parkID} success:^(id object) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    park.priceDesc = object[@"data"][@"data"][@"parkInfo"][@"priceDesc"];
                    CWSFindCarLocDetailController* lController = [[CWSFindCarLocDetailController alloc] init];
                    lController.oldPt = _oldPt;
                    lController.park = park;
                    [self.navigationController pushViewController:lController animated:YES];
                });
            }
            else {
                
            }
        } faile:^(NSError *err) {
            
        }];
    }else{
        CWSFindCarLocDetailController* lController = [[CWSFindCarLocDetailController alloc] init];
        lController.park = park;
        lController.oldPt = _oldPt;
        [self.navigationController pushViewController:lController animated:YES];
    }
}


- (IBAction)btnTouchDown:(UIButton *)sender {
    MyLog(@"按钮点击");
    self.searchView.hidden = NO;
    [self.searchTextField becomeFirstResponder];
}

#pragma mark - 分栏按钮
- (IBAction)headChangeButtonClick:(UIButton *)sender {
    if (sender == self.headMapButton) {
        if (sender != _currentBtn) {
            //
            [_currentBtn setImage:[UIImage imageNamed:@"chewei_list"] forState:UIControlStateNormal];
            [_currentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            //选中的地图
            [sender setImage:[UIImage imageNamed:@"chewei_map_click"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
            _parkTabelView.hidden = YES;
            [self.view sendSubviewToBack:_parkTabelView];
            self.headMapLineView.hidden = NO;
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
            
            
            _parkTabelView.hidden = NO;
            [self.view bringSubviewToFront:_parkTabelView];
            
            self.headMapLineView.hidden = YES;
            self.headListLineView.hidden = NO;
            self.headListLineView.backgroundColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
        }
    }
    _currentBtn = sender;
    
}

#pragma mark - 路况
- (IBAction)leftButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_findMapView changeTraffic:sender.selected];
}


@end
