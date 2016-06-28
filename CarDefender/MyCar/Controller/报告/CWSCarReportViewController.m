//
//  CWSCarReportViewController.m
//  CarDefender
//
//  Created by 李散 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarReportViewController.h"
#import "DriveBehaviorDetailsController.h"
#import "GroundView.h"
#import "ReportSpeed.h"
#import "NewReportMileage.h"
#import "ReportOil.h"
#import "NewReportTime.h"
#import "ReportHundredOil.h"
#import "ReportCost.h"
#import "CLWeeklyCalendarView.h"
#import "CycleScrollView.h"
#import "DriveBehavior.h"
#import "CWSReportAddCostController.h"

#import "MBProgressHUD+Add.h"
#define kJianGe 58
@interface CWSCarReportViewController ()<CLWeeklyCalendarViewDelegate,GroundViewDelegate,ReportCostDelegate,CellClickDelegate,NewReportTimeDelegate,NewReportMileageDelegate>
{
    NSMutableDictionary*  _bodyDic;
    UIButton*             _dateRightBtn;
    
    NSDate*               _currentDate;
    NSString*             _selectDay;
    NSDate*               _selectDate;
    NSDate*               _nowDate;
    BOOL                  _isUploadTimel;
    int                   oldWeekDay;
    
    BOOL                  loadORNoSide;
    BOOL                  _isShare;
    
    GroundView*       _groundView;
    UIView*           _currentView;
    UIView*           _backView;
    NSArray*          _dataArray;
    NSString*         _cost;
    UIView*           _stopView;
    
    DriveBehavior*       _driveBehavior;
    ReportSpeed*         _reportSpeed;
    ReportHundredOil*    _reportHundredOil;
    ReportOil*           _reportOil;
    NewReportMileage*    _reportMileage;
    NewReportTime*       _reportTime;
    ReportCost*          _reportCost;
    
    NSMutableDictionary*     _reportDic;
    
    NSDictionary*_costCurrentDic;
    
    UIButton *_menuBtnTouch;//报告模块被点击
    
    CGFloat _reportDetailY;//报告详情功能模块的y坐标
    
    BOOL _gotoAddCost;
    
}
@property (nonatomic, retain) CycleScrollView *mainScorllView;
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@end

@implementation CWSCarReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShare = YES;
    _gotoAddCost = NO;
    [Utils changeBackBarButtonStyle:self];
    //创建基本视图和基础数据
    [self buildUIAndBaseData];
    //创建右上角按钮事件
    [self buildRightBtn];
    //创建日期选择
    [self calendarViewBuild];
    self.title=@"车辆报告";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _selectDay = self.searchDate;
    [self creatUI];
    [self getdata];
    _getDataChooseOrNor=YES;
    _stopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    _stopView.backgroundColor = [UIColor clearColor];
    //日常费用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reportCostBack:) name:@"ReoirtCostBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareContentClick:) name:@"shareContent" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_menuBtnTouch) {
        _menuBtnTouch.hidden = NO;
    }
    _groundView.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    //存储当前界面标记
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"CWSCarReportViewController" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //存储当前界面标记
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
    _groundView.hidden = YES;
    if (_gotoAddCost) {
        _gotoAddCost = NO;
        _menuBtnTouch.hidden = YES;
    }
    [ModelTool stopAllOperation];
}

-(void)goBackBarButton:(UIButton*)sender
{
    [_menuBtnTouch removeFromSuperview];
    
    if (_detailOrMain) {
        self.title=@"车辆报告";
        _detailOrMain=NO;
        
        if (_currentView != nil) {
            [UIView animateWithDuration:0.4 animations:^{
                CGRect frame = _currentView.frame;
                frame.origin.y = kSizeOfScreen.height + kSTATUS_BAR;
                _currentView.frame = frame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    CGFloat distanceGroundView;
                    if (kSizeOfScreen.height < 500) {
                        distanceGroundView=0;
                    }else{
                        distanceGroundView=10;
                    }
                    CGRect groundFrame=_groundView.frame;
                    groundFrame.origin.y=self.calendarView.frame.size.height+self.calendarView.frame.origin.y+distanceGroundView;
                    _reportDetailY = self.calendarView.frame.size.height+self.calendarView.frame.origin.y+distanceGroundView;
                    _groundView.frame=groundFrame;
                } completion:^(BOOL finished) {
                    _reportView.hidden = NO;
                    _reportView2.hidden = NO;
                }];
            }];
        }
        //报告主界面更新数据
        [self getdata];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIView*)creatBackView{
    UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width/2 - 50, 20, 100, 44)];
    lView.backgroundColor = [UIColor redColor];
    return lView;
}
-(void)buildUIAndBaseData
{
    _detailOrMain=NO;
    _bodyDic=[NSMutableDictionary dictionary];
}
#pragma mark -左右滑动动画介绍代理协议
-(void)animateFinish:(BOOL)isLeft{
    
    
    //    if (!loadORNoSide) {
    [self.view addSubview:_stopView];
    NSString * timeStampString;
    if (isLeft) {
        MyLog(@"动画结束--左滑");
        timeStampString = [NSString stringWithFormat:@"%ld",(long)[_currentDate timeIntervalSince1970]+86400];
        if (oldWeekDay==6) {//左滑
            [self.calendarView delegateSwipeAnimation:NO blnToday:NO selectedDate:nil];
        }
    }else{
        MyLog(@"动画结束--右滑");
        timeStampString = [NSString stringWithFormat:@"%ld",(long)[_currentDate timeIntervalSince1970]-86400];
        if (oldWeekDay==0) {//右滑
            [self.calendarView delegateSwipeAnimation:YES blnToday:NO selectedDate:nil];
        }
    }
    NSTimeInterval _interval=[[timeStampString substringToIndex:10] doubleValue];
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    int age=[self getTimeWithDate:date1];
    if (age<0) {
        self.calendarView.gestuerDate=_currentDate;
        [_bodyDic setObject:[self checkMsgWithDate:date1] forKey:@"time"];
//        [self getdata];
        NSDictionary* lDic1 = @{@"image":@"baogao_youhao",
                                @"name":@"当日耗量",
                                @"data":[NSString stringWithFormat:@"%.2fL",[_costCurrentDic[@"oil"] floatValue]]};
        NSDictionary* lDic2 = @{@"image":@"baogao_baigongli",
                                @"name":@"平均油耗",
                                @"data":[NSString stringWithFormat:@"%.2fL/100km",[_costCurrentDic[@"avgOil"] floatValue]]};
        NSDictionary* lDic3 = @{@"image":@"baogao_time",
                                @"name":@"驾驶时间",
                                @"data":[NSString stringWithFormat:@"%.2fMin",[_costCurrentDic[@"feeTime"] floatValue]]};
        NSDictionary* lDic4 = @{@"image":@"baogao_licheng",
                                @"name":@"当日里程",
                                @"data":[NSString stringWithFormat:@"%.2fkm",[_costCurrentDic[@"mile"] floatValue]]};
        NSDictionary* lDic5 = @{@"image":@"baogao_sudu",
                                @"name":@"平均速度",
                                @"data":[NSString stringWithFormat:@"%.2fkm/h",[_costCurrentDic[@"avgSpeed"] floatValue]]};
        NSArray* array = @[lDic1,lDic2,lDic3,lDic4,lDic5];
        NSString* cost = [NSString stringWithFormat:@"￥%.2f",[_costCurrentDic[@"fee"] floatValue]];
        
        [_groundView reloadData:array cost:cost];
        if ([_costCurrentDic[@"mile"] floatValue] < 3) {
            _normalLabel1.hidden = NO;
            _normalLable.hidden = NO;
        }else{
            _normalLabel1.hidden = YES;
            _normalLable.hidden = YES;
        }
//        _scoreLabel1.text = [NSString stringWithFormat:@"%@分",_costCurrentDic[@"drivingScore"]];
//        _scoreLabel2.text = [NSString stringWithFormat:@"%@分",_costCurrentDic[@"drivingScore"]];
        
        _scoreLabel1.text = [NSString stringWithFormat:@"%@分",@"-"];
        _scoreLabel2.text = [NSString stringWithFormat:@"%@分",@"-"];
        
        [_stopView removeFromSuperview];
        [_stopView removeFromSuperview];
        
        //        [_dateRightBtn setTitle:[self checkMsgWithDate:date1] forState:UIControlStateNormal];
        //        int currentWeek=[self checkWeekDay:date1];
        //
        //        oldWeekDay=currentWeek;
        [[[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择今天以前的日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];return;
    }else{
        _currentDate=date1;
        
    }
    
    self.calendarView.gestuerDate=date1;
    [_bodyDic setObject:[self checkMsgWithDate:date1] forKey:@"time"];
    [self getdata];
    
    [_dateRightBtn setTitle:[self checkMsgWithDate:date1] forState:UIControlStateNormal];
    int currentWeek=[self checkWeekDay:date1];
    
    oldWeekDay=currentWeek;
    //    }
    
}

#pragma mark 按钮点击事件
#warning ---------这里数据接口还未改

-(void)iconClick:(NSString *)type{
    MyLog(@"%@",type);
    _detailOrMain=YES;
    if (_menuBtnTouch==nil) {
        _menuBtnTouch=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
        [_menuBtnTouch addTarget:self action:@selector(goBackBarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.view addSubview:_menuBtnTouch];
    
    
    [_reportDic setObject:_bodyDic[@"time"] forKey:@"time"];
//    switch ([type intValue]) {
//        case 0://油耗量
//        {
//            MyLog(@"油耗量");
//            self.title=@"当日油耗";
//            [_reportDic setObject:@"oil" forKey:@"type"];
//            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSDictionary* lDic = object;
//                MyLog(@"%@",lDic);
//                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_reportOil reloadData:lDic];
//                    });
//                }
//            } faile:^(NSError *err) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            }];
//            NSDictionary* dic = @{@"data": @{@"status":@"0",
//                                             @"percent": @"0",
//                                             @"surplus": @"无法获取",
//                                             @"oil": @"0"},
//                                  @"operationState": @"SUCCESS",
//                                  @"title": @""
//                                  };
//            if (_reportOil == nil) {
//                _reportOil = [[ReportOil alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kJianGe - kDockHeight) Dictionary:dic];
//                [self.view addSubview:_reportOil];
//            }
//            [self moveAnimate:_reportOil finish:^(UIView *view) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_reportOil animateStart];
//                });
//            }];
//        }
//            break;
//        case 1://百公里油耗
//        {
//            MyLog(@"百公里油耗");
//            self.title=@"平均油耗";
//            [_reportDic setObject:@"avgOil" forKey:@"type"];
//            
//            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSDictionary* lDic = object;
//                MyLog(@"%@",lDic);
//                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_reportHundredOil reloadData:lDic];
//                    });
//                }
//            } faile:^(NSError *err) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            }];
//            NSDictionary* dic = @{@"data":@{@"status":@"0"}};
//            if (_reportHundredOil == nil) {
//                _reportHundredOil = [[ReportHundredOil alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - 100) Dictionary:dic];
//                [self.view addSubview:_reportHundredOil];
//            }
//            [self moveAnimate:_reportHundredOil finish:^(UIView *view) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_reportHundredOil animateStart];
//                });
//            }];
//        }
//            break;
//        case 2://驾驶时间
//        {
//            MyLog(@"驾驶时间");
//            [self goToTime];
//        }
//            break;
//        case 3://总里程
//        {
//            MyLog(@"总里程");
//            [self goToMileage];
//        }
//            break;
//        case 4://平均速度
//        {
//            MyLog(@"平均速度");
//            self.title=@"平均时速";
//            //            NSDictionary* lDic = @{@"uid":@"30",
//            //                                  @"key":@"bed3eb2d-3dda-4240-92ce-8ffe97a06a55",
//            //                                  @"cid":@"274",
//            //                                  @"time":@"2015-05-17",
//            //                                  @"type":@"speed" };
//            [_reportDic setObject:@"speed" forKey:@"type"];
//            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSDictionary* lDic = object;
//                MyLog(@"%@",lDic);
//                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_reportSpeed reloadData:lDic];
//                    });
//                }
//            } faile:^(NSError *err) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            }];
//            NSDictionary* dic = @{@"data":@{@"status":@"0"}};
//            if (_reportSpeed == nil) {
//                _reportSpeed = [[ReportSpeed alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - 100) Dictionary:dic];
//                [self.view addSubview:_reportSpeed];
//            }
//            [self moveAnimate:_reportSpeed finish:^(UIView *view) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_reportSpeed animateStart];
//                });
//            }];
//        }
//            break;
//        case 5://费用
//        {
//            MyLog(@"费用");
//            [self goToCost];
//        }
//            break;
//        default:
//            break;
//    }
}
#pragma mark - 时间
-(void)goToTime
{
    self.title=@"驾驶时间";
    [_reportDic setObject:@"time" forKey:@"type"];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_reportTime reloadDataWithDic:object[@"data"]];
                
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    if (_reportTime == nil) {
        _reportTime = [[NewReportTime alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kJianGe - kDockHeight)];
        _reportTime.delegate=self;
        [self.view addSubview:_reportTime];
    }
    [self moveAnimate:_reportTime finish:^(UIView *view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [_reportTime animateStart];
        });
    }];
}
#pragma mark - 里程
-(void)goToMileage
{
    self.title=@"当日里程";
    [_reportDic setObject:@"mile" forKey:@"type"];
    
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if (_reportMileage) {
                    //                    [_reportMileage reloadData:object[@"data"]];
                    [_reportMileage reloadDataWithDic:object[@"data"]];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    if (_reportMileage == nil) {
        _reportMileage = [[NewReportMileage alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kJianGe - kDockHeight)];
        _reportMileage.delegate=self;
        [self.view addSubview:_reportMileage];
    }
    
    [self moveAnimate:_reportMileage finish:^(UIView *view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [_reportMileage animateStart];
        });
    }];
}
#pragma mark - 费用
-(void)goToCost
{
    if (_reportCost == nil) {
        _reportCost = [[ReportCost alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR/2, kSizeOfScreen.width, kSizeOfScreen.height - kJianGe - kDockHeight)];
        _reportCost.delegate=self;
        [self.view addSubview:_reportCost];
    }
    self.title=@"用车支出";
    [_reportDic setObject:@"fee" forKey:@"type"];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_reportCost reloadData:object[@"data"]];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [self moveAnimate:_reportCost finish:^(UIView *view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_reportCost animateStart];
        });
    }];
}

-(void)reportCostBack:(NSNotification*)sender
{
    [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_reportCost reloadData:object[@"data"]];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma mark - 移动动画效果
-(void)moveAnimate:(UIView*)view finish:(void (^)(UIView *view))block{
    _currentView = view;
    _reportView.hidden = YES;
    _reportView2.hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _groundView.frame;
        frame.origin.y = kSizeOfScreen.height ;
        _groundView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame = view.frame;
            frame.origin.y = self.calendarView.frame.size.height+self.calendarView.frame.origin.y;
            view.frame = frame;
        } completion:^(BOOL finished) {
            block(view);
        }];
    }];
}
-(void)buildRightBtn
{
    [self.dateView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight - kSTATUS_BAR)];
    self.dateView.hidden = YES;
    [self.view addSubview:self.dateView];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    _dateRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,65,30)];
    
//    [_dateRightBtn setBackgroundImage:[UIImage imageNamed:@"baogao_kuang@2x"] forState:UIControlStateNormal];
    [_dateRightBtn setTitle:@"时间" forState:UIControlStateNormal];
    [_dateRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _dateRightBtn.titleLabel.font=kFontOfSize(12);
    [_dateRightBtn addTarget:self action:@selector(searchprogram)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:_dateRightBtn];
    
    self.navigationItem.rightBarButtonItem= rightItem;
}
#pragma mark - 选择日期
-(void)searchprogram
{
    NSDate* currentDay = self.calendarView.selectedDate;
    self.datePicker.date = currentDay;
    [self.view bringSubviewToFront:self.dateView];
    self.dateView.hidden = NO;
}
-(void)dateChanged:(UIDatePicker*)sender
{
    [Utils getTime];
    NSDate*date1=(NSDate*)sender.date;
    _nowDate = sender.date;
    
    int age=[self getTimeWithDate:date1];
    if (age<0) {
        _isUploadTimel = YES;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择今天以前的日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else{
        _isUploadTimel = NO;
    }
}
- (IBAction)submitBtnClick:(UIButton *)sender {
    if (sender.tag == 11) {
        if (_isUploadTimel) {
            [[[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择今天以前的日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }else{
            MyLog(@"%@",_selectDay);
            self.dateView.hidden = YES;
            [self dailyCalendarViewDidSelect:_nowDate];
            _selectDate = _nowDate;
            [self.calendarView redrawToDate:_selectDate];
            //            [_dateRightBtn setTitle:[self checkMsgWithDate:_selectDate] forState:UIControlStateNormal];
            
            //            [_bodyDic setObject:[self checkMsgWithDate:_selectDate] forKey:@"time"];
            //            [self getdata];
        }
    }else{
        self.dateView.hidden = YES;
    }
}
- (IBAction)groundTouchDown {
    self.dateView.hidden = YES;
}
-(int)getTimeWithDate:(NSDate*)chooseDate
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    date = date - 60*60*24;
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:chooseDate];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    
    int year1 = (int)[dateComponent1 year];
    int month1 = (int)[dateComponent1 month];
    int day1 = (int)[dateComponent1 day];
    
    _selectDay=[NSString stringWithFormat:@"%d-%02d-%02d",year1,month1,day1];
    
    int age;
    if (year>year1) {//大于的情况
        return 1;
    }else if(year==year1){//等于和大于的情况
        if (month>month1) {
            return 1;
        }else if (month == month1){
            if (day>=day1) {
                return 1;
            }else{
                age=-1;
            }
        }else{
            age=-1;
        }
    }else{
        age=-1;
    }
    return age;
    
    
}

- (NSString *)changeStrWithData:(id)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return @"0";
    }
    return data;
}
//获取数据
-(void)getdata
{
    loadORNoSide=YES;
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSLog(@"select day :%@",_selectDay);
    UserInfo *userInfo = [UserInfo userDefault];
    [HttpHelper oneKeyDetectionWithUserId:userInfo.desc
                                    token:userInfo.token
                                 deviceNo:userInfo.defaultDeviceNo
                               searchDate:_selectDay
                                  success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                      loadORNoSide=NO;
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSLog(@"car report message :%@",responseObjcet);
                                      NSDictionary *dict = (NSDictionary *)responseObjcet;
                                      userInfo.token = dict[@"token"];
                                      NSString *code = dict[@"code"];
                                      if ([code isEqualToString:SERVICE_SUCCESS]) {
                                          NSDictionary *msg = dict[@"msg"];
                                          _costCurrentDic = msg;
                                          NSDictionary* lDic1 = @{@"image":@"baogao_youhao",
                                                                  @"name":@"当日油耗",
                                                                  @"data":[NSString stringWithFormat:@"%@L",[self changeStrWithData:msg[@"fuelConsumption"]]]};
                                          NSDictionary* lDic2 = @{@"image":@"baogao_baigongli",
                                                                  @"name":@"平均油耗",
                                                                  @"data":[NSString stringWithFormat:@"%@L/100km",[self changeStrWithData:msg[@"averageFuelConsumption"]]]};
                                          NSDictionary* lDic3 = @{@"image":@"baogao_time",
                                                                  @"name":@"驾驶时间",
                                                                  @"data":[NSString stringWithFormat:@"%@Min",[self changeStrWithData:msg[@"runningTime"]]]};
                                          NSDictionary* lDic4 = @{@"image":@"baogao_licheng",
                                                                  @"name":@"当日里程",
                                                                  @"data":[NSString stringWithFormat:@"%@km",[self changeStrWithData:msg[@"mileAge"]]]};
                                          NSDictionary* lDic5 = @{@"image":@"baogao_sudu",
                                                                  @"name":@"平均速度",
                                                                  @"data":[NSString stringWithFormat:@"%@km/h",[self changeStrWithData:msg[@"averageSpeed"]]]};
                                          NSArray* array = @[lDic1,lDic2,lDic3,lDic4,lDic5];
                                          NSString* cost = [NSString stringWithFormat:@"￥%@",[self changeStrWithData:msg[@"cost"]]];
                                          [_groundView reloadData:array cost:cost];
                                          if ([msg[@"totalMileAge"] floatValue] < 3) {
                                              _normalLabel1.hidden = NO;
                                              _normalLable.hidden = NO;
                                          }else{
                                              _normalLabel1.hidden = YES;
                                              _normalLable.hidden = YES;
                                          }
                                          NSString *drivingScore = [NSString stringWithFormat:@"%@",msg[@"drivingScore"]];
                                          if ([drivingScore isKindOfClass:[NSNull class]]) {
                                              drivingScore = @"0分";
                                          } else if (![drivingScore isEqualToString:@"-"]){
                                              drivingScore = @"99分";
                                          } else {
                                               drivingScore = @"-分";
                                          }
                                          _scoreLabel1.text = drivingScore;
                                          _scoreLabel2.text = drivingScore;
                                          [_stopView removeFromSuperview];
                                          
                                      } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                      } else {
                                          [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"one key error :%@",error);
                                      [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                      [_stopView removeFromSuperview];
                                  }];
}
//创建主界面视图
-(void)creatUI{
    NSDictionary* lDic1 = @{@"image":@"baogao_youhao",
                            @"name":@"当日耗量",
                            @"data":@"L"};
    NSDictionary* lDic2 = @{@"image":@"baogao_baigongli",
                            @"name":@"平均油耗",
                            @"data":@"L"};
    NSDictionary* lDic3 = @{@"image":@"baogao_time",
                            @"name":@"驾驶时间",
                            @"data":@"Min"};
    NSDictionary* lDic4 = @{@"image":@"baogao_licheng",
                            @"name":@"当日里程",
                            @"data":@"km"};
    NSDictionary* lDic5 = @{@"image":@"baogao_sudu",
                            @"name":@"平均速度",
                            @"data":@"km/h"};
    _dataArray = @[lDic1,lDic2,lDic3,lDic4,lDic5];
    _cost = @"0";
    
    CGFloat distanceGroundView;
    if (kSizeOfScreen.height < 500) {
        distanceGroundView=-5;
    }else{
        distanceGroundView=10;
    }
    _groundView = [[GroundView alloc]initWithFrame:CGRectMake(0, self.calendarView.frame.size.height+self.calendarView.frame.origin.y+distanceGroundView, kSizeOfScreen.width, kSizeOfScreen.width) dataArray:_dataArray cost:_cost];
    _groundView.delegate = self;
    _groundView.backgroundColor = [UIColor whiteColor];
    _groundView.userInteractionEnabled = YES;
    //    _groundView.firstIn = YES;
    [_groundView drawRect:_groundView.frame];
    [self.view addSubview:_groundView];
    //设置驾驶行为界面
    if (kSizeOfScreen.height < 500) {
        //        [_reportView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, 44)];
        ////        _reportView.center = CGPointMake(_groundView.center.x, (_groundView.center.y + 150 + kSizeOfScreen.height - kDockHeight)/2);
        //        CGRect reportViewFrame = _reportView.frame;
        //        reportViewFrame.origin.y = kSizeOfScreen.height+20-_reportView.frame.size.height;
        //        _reportView.frame = reportViewFrame;
        [_reportView setFrame:CGRectMake(0, _groundView.frame.size.height + _groundView.frame.origin.y, kSizeOfScreen.width, 44)];
        [self.view addSubview:_reportView];
    }else{
        [_reportView2 setFrame:CGRectMake(0, 0, kSizeOfScreen.width, 44)];
        _reportView2.center = CGPointMake(_groundView.center.x, (_groundView.center.y + 150 + kSizeOfScreen.height - kDockHeight)/2);
        [self.view addSubview:_reportView2];
    }
}
//Initialize
-(void)calendarViewBuild
{
    self.calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, self.view.bounds.size.width, 58)];
    self.calendarView.delegate = self;
    self.calendarView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:self.calendarView];
}

#pragma mark - CLWeeklyCalendarViewDelegate 设定周几排在前面
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @7,
             };
}

#pragma mark - 获取选择数据
-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    int age=[self getTimeWithDate:date];
    if (age<0) {
        _isUploadTimel = YES;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择今天以前的日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [self.calendarView redrawToDate:_selectDate];
        return;
    }else{
        if ([_selectDate isEqualToDate:date]) {
            return;
        }
        _selectDate = date;
    }
    [_bodyDic setObject:[self checkMsgWithDate:date] forKey:@"time"];
    
    [_dateRightBtn setTitle:[self checkMsgWithDate:date] forState:UIControlStateNormal];
    
    _currentDate=date;
    MyLog(@"%@\n%@",date,[self checkMsgWithDate:date]);
    oldWeekDay=[self checkWeekDay:date];
    //    NSArray*dateArray=[Utils getTime];
    [_reportDic setObject:_bodyDic[@"time"] forKey:@"time"];
    
    //    if (![[NSString stringWithFormat:@"%@-%@-%@",dateArray[0],dateArray[1],dateArray[2]] isEqualToString:[self checkMsgWithDate:date]]) {
    if (_getDataChooseOrNor) {
        _getDataChooseOrNor=NO;
        return;
    }
    
    
#warning ---------这里数据接口还未改
    if (_detailOrMain) {//详情界面出现
        
        if ([_currentView isMemberOfClass:[ReportSpeed class]]) {//平均速度
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary* lDic = object;
                MyLog(@"%@",lDic);
                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_reportSpeed reloadData:lDic];
                    });
                }
            } faile:^(NSError *err) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }else if ([_currentView isMemberOfClass:[NewReportMileage class]]){//里程
            
            [_reportDic setObject:[self checkMsgWithDate:date] forKey:@"time"];
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                        if (_reportMileage) {
                            [_reportMileage reloadDataWithDic:object[@"data"]];
                        }
                    }else{
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                });
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }else if ([_currentView isMemberOfClass:[NewReportTime class]]){//时间
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    MyLog(@"%@",object);
                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                        [_reportTime reloadDataWithDic:object[@"data"]];
                        
                    }else{
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                });
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }else if ([_currentView isMemberOfClass:[ReportCost class]]){//消费
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                        [_reportCost reloadData:object[@"data"]];
                    }else{
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                });
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }else if ([_currentView isMemberOfClass:[ReportOil class]]){//油
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary* lDic = object;
                MyLog(@"%@",lDic);
                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_reportOil reloadData:lDic];
                    });
                }
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }else if ([_currentView isMemberOfClass:[ReportHundredOil class]]){//百公里油耗
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetReportDesWithParameter:_reportDic success:^(id object) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary* lDic = object;
                MyLog(@"%@",lDic);
                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_reportHundredOil reloadData:lDic];
                    });
                }
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
            
        }else if ([_currentView isMemberOfClass:[DriveBehavior class]]){//驾驶行为
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            [ModelTool httpGetDriveBehaviorDayDataWithParameter:_reportDic success:^(id object) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary* lDic = object;
                MyLog(@"%@",lDic);
                if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([lDic[@"data"][@"status"] isEqualToString:@"0"]) {
                            [_driveBehavior reloadData:@{@"data": @{@"fatigueDriving": @"0",
                                                                    @"drivingScore": @"0",
                                                                    @"brokenOn": @"0",
                                                                    @"rapidAcceleration": @"0",
                                                                    @"drivingTime": @"0",
                                                                    @"suddenTurn": @"0",
                                                                    @"drivingMile": @"0"
                                                                    }
                                                         }];
                        }else{
                            [_driveBehavior reloadData:lDic];
                        }
                    });
                }
            } faile:^(NSError *err) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
        }
        
    }else{
        [self getdata];
    }
    //    }
}
-(NSString*)checkMsgWithDate:(NSDate*)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    return time;
}
-(int)checkWeekDay:(NSDate*)date
{
    NSString*stringDate=[self checkMsgWithDate:date];
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[[stringDate substringWithRange:NSMakeRange(8, 2)] integerValue]];
    [_comps setMonth:[[stringDate substringWithRange:NSMakeRange(5, 2)] integerValue]];
    [_comps setYear:[[stringDate substringWithRange:NSMakeRange(0, 2)] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    int _weekday = (int)[weekdayComponents weekday]-1;
    NSLog(@"_weekday::%d",_weekday);
    return _weekday;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//驾驶行为按钮

#pragma mark 查看详情
- (IBAction)findMoreBtn {
    MyLog(@"驾驶行为");
    _detailOrMain=YES;
    
    if (_menuBtnTouch==nil) {
        _menuBtnTouch=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
        [_menuBtnTouch addTarget:self action:@selector(goBackBarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.view addSubview:_menuBtnTouch];
    
//    [_reportDic setObject:_bodyDic[@"time"] forKey:@"time"];
//    [_reportDic setObject:@"day" forKey:@"type"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool httpGetDriveBehaviorDayDataWithParameter:_reportDic success:^(id object) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSDictionary* lDic = object;
//        MyLog(@"%@",lDic);
//        if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_driveBehavior reloadData:lDic];
//            });
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//    } faile:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
//    NSDictionary* lDic = @{@"data": @{@"fatigueDriving": @"0",
//                                      @"drivingScore": @"0",
//                                      @"brokenOn": @"0",
//                                      @"rapidAcceleration": @"0",
//                                      @"drivingTime": @"0",
//                                      @"suddenTurn": @"0",
//                                      @"drivingMile": @"0"
//                                      },
//                           @"operationState": @"SUCCESS",
//                           @"title": @""
//                           };
//    if (_driveBehavior == nil) {
//        _driveBehavior = [[DriveBehavior alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - 100) Dictionary:lDic];
//        _driveBehavior.delegate = self;
//        [self.view addSubview:_driveBehavior];
//    }
//    [self moveAnimate:_driveBehavior finish:^(UIView *view) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_driveBehavior animateStart];
//        });
//    }];
    
    
    [_driveBehavior reloadData:_costCurrentDic];
    if (_driveBehavior == nil) {
        _driveBehavior = [[DriveBehavior alloc] initWithFrame:CGRectMake(0, kSizeOfScreen.height + kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - 100) Dictionary:_costCurrentDic];
        _driveBehavior.delegate = self;
        [self.view addSubview:_driveBehavior];
    }
    [self moveAnimate:_driveBehavior finish:^(UIView *view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_driveBehavior animateStart];
        });
    }];
}

#pragma mark - 车辆报告代理协议
-(void)cellClick:(NSString*)type{
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key,
                          @"cid":KUserManager.car.cid,
                          @"time":_bodyDic[@"time"],
                          @"type":type};
    DriveBehaviorDetailsController* lController = [[DriveBehaviorDetailsController alloc] initWithNibName:@"DriveBehaviorDetailsController" bundle:nil];
    lController.dataDic = dic;
    lController.title = @"行为详情";
    [self.navigationController pushViewController:lController animated:YES];
}

#pragma mark - 费用代理协议
-(void)reportCostAddCarCostWithDic:(NSDictionary *)dic
{
    CWSReportAddCostController*addCostVC=[[CWSReportAddCostController alloc]initWithNibName:@"CWSReportAddCostController" bundle:nil];
    addCostVC.title=@"添加费用";
    addCostVC.currentCostDic=dic;
    addCostVC.reportTime=_bodyDic[@"time"];
    addCostVC.reportRid=_costCurrentDic[@"rid"];
    _gotoAddCost = YES;
    [self.navigationController pushViewController:addCostVC animated:YES];
}
-(void)reportCostEdit:(NSDictionary *)array
{
    CWSReportAddCostController*addCostVC=[[CWSReportAddCostController alloc]initWithNibName:@"CWSReportAddCostController" bundle:nil];
    addCostVC.title=@"编辑费用";
    addCostVC.menuDic=array;
    addCostVC.reportTime=_bodyDic[@"time"];
    addCostVC.reportRid=_costCurrentDic[@"rid"];
    _gotoAddCost = YES;
    [self.navigationController pushViewController:addCostVC animated:YES];
}


#pragma mark - 分享代理协议
-(void)costShareMsg:(NSDictionary *)dic
{
    [self shareMsgWithImage:dic[@"imgUrl"] withContent:dic[@"content"] withDefaultContent:dic[@"content"] withTitle:@"嘿~你的车联网了么" withUrl:dic[@"url"] withDescription:@""];
}
-(void)newReportMileageShareMsgDic:(NSDictionary *)dicMsg
{
    [self shareMsgWithImage:dicMsg[@"imgUrl"] withContent:dicMsg[@"content"] withDefaultContent:dicMsg[@"content"] withTitle:@"嘿~你的车联网了么" withUrl:dicMsg[@"url"] withDescription:@""];
}
-(void)newRportTimeShareWithDic:(NSDictionary *)dicMsg
{
    [self shareMsgWithImage:dicMsg[@"imgUrl"] withContent:dicMsg[@"content"] withDefaultContent:dicMsg[@"content"] withTitle:@"嘿~你的车联网了么" withUrl:dicMsg[@"url"] withDescription:@""];
}
-(void)shareContentClick:(NSNotification*)sender{
    if (_isShare) {
        _isShare = NO;
        NSDictionary* dic = sender.object;
        MyLog(@"%@",dic);
        [self shareMsgWithImage:dic[@"imgUrl"] withContent:dic[@"content"] withDefaultContent:dic[@"content"] withTitle:@"嘿~你的车联网了么" withUrl:dic[@"url"] withDescription:@""];
    }else{
        _isShare = YES;
    }
    
}
@end
