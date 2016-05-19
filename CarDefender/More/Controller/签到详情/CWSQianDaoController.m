//
//  CWSQianDaoController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSQianDaoController.h"
#import "QianDao.h"

#define kHitht 30
@interface CWSQianDaoController ()
{
    int            _year;
    int            _month;
    int            _day;
    int            _nowMonth;
    NSString*      _todayStr;
    NSArray*       _dataArray;
    QianDao*       _qiaoDao;
    CGFloat        _viewWight;
    UIView*        _bacgroundView;
    UIScrollView*  _scrollView;
    UIButton*      _qianDaoBtn;
    BOOL           _temp;
}
@end

@implementation CWSQianDaoController
-(void)initDay
{
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    _year = (int)[dd year];
    _month = (int)[dd month];
    _nowMonth = _month;
    _day = (int)[dd day];
    _todayStr = [NSString stringWithFormat:@"%li-%02li-%02li",(long)[dd year],(long)[dd month],(long)[dd day]];
//    [self setLabel:_year month:_month];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self initDay];
    _temp = NO;
    _viewWight = (kSizeOfScreen.width - 40)/7.0;
    _qiaoDao = [[QianDao alloc] init];
    
    if (KUserManager == nil) {
        return;
    }
    
    [self http];
    
}
-(void)http{
    NSDictionary* lDic = @{@"uid": KUserManager.uid,
                           @"key": KUserManager.key,
                           @"start":[NSString stringWithFormat:@"%i-%02i-01",_year,_month],
                           @"end":[self backDay]};
    [self showHudInView:self.view hint:@"数据加载中..."];
    [ModelTool httpGetGainSignWithParameter:lDic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            [self hideHud];
            if (_scrollView != nil) {
                [_scrollView removeFromSuperview];
                _scrollView = nil;
            }
            NSMutableArray* lMutArray = [NSMutableArray array];
            
            for (NSDictionary* lDic in dic[@"data"][@"sign"]) {
                NSString * timeStampString = lDic[@"time"];
                NSTimeInterval interval=[[timeStampString substringToIndex:10] doubleValue];
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSString* str = [NSString stringWithFormat:@"%@",confromTimesp];
                NSRange lRange=NSMakeRange(0, 10);
                NSString *lString=[str substringWithRange:lRange];
                NSString* nowDay = [NSString stringWithFormat:@"%i-%02i-%02i",_year,_month,_day];
                if ([lString isEqualToString:nowDay]) {
                    _temp = YES;
                }
                MyLog(@"%@-%@",lString,nowDay);
                [lMutArray addObject:lString];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataArray = [NSArray arrayWithArray:lMutArray];
                [self creatUI];
                if (_temp) {
                    KUserManager.sign = @"1";
                    _qianDaoBtn.userInteractionEnabled = NO;
                    [_qianDaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
                    [_qianDaoBtn setBackgroundImage:[UIImage imageNamed:@"sign_button2"] forState:UIControlStateNormal];
                }
            });
        }
        else {
            [self hideHud];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } faile:^(NSError *err) {
        [self hideHud];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
-(NSString*)backDay{
    int year = _year;
    int month = _month;
    month ++;
    if (month > 12) {
        year += 1;
        month = 1;
    }
    NSString* lDay = [NSString stringWithFormat:@"%i-%02i-01",year,month];
    return lDay;
}

-(void)creatUI{
//    NSLog(@"%i",[self getRowWithYear:_year month:_month]);
    int temp = [self getRowWithYear:_year month:_month];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _bacgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_scrollView atIndex:0];
    
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width / 2 - 64, 15, 128, 57)];
    lImageView.image = [UIImage imageNamed:@"sign_dian.png"];
    [_bacgroundView addSubview:lImageView];
    
//    [self creatBtn:@"上一页" tag:1 fatherView:_bacgroundView frame:CGRectMake(20, 20, 46, 30)];
    UIButton* lBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 46, 30)];
    lBtn1.tag = 1;
    lBtn1.titleLabel.font = kFontOfSize(15);
    [lBtn1 setTitleColor:kMainColor forState:UIControlStateNormal];
    [lBtn1 setTitle:@"上一页" forState:UIControlStateNormal];
    [lBtn1 addTarget:self action:@selector(changeMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bacgroundView addSubview:lBtn1];
//    [self creatBtn:@"下一页" tag:2 fatherView:_bacgroundView frame:CGRectMake(kSizeOfScreen.width - 20 - 46, 20, 46, 30)];
    UIButton* lBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(kSizeOfScreen.width - 20 - 46, 20, 46, 30)];
    lBtn2.tag = 2;
    lBtn2.titleLabel.font = kFontOfSize(15);
    [lBtn2 setTitleColor:kMainColor forState:UIControlStateNormal];
    [lBtn2 setTitle:@"下一页" forState:UIControlStateNormal];
    [lBtn2 addTarget:self action:@selector(changeMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bacgroundView addSubview:lBtn2];
    
    UIView* backGroundView = [[UIView alloc] initWithFrame:CGRectMake(20, 71, kSizeOfScreen.width - 40, (temp+1) * _viewWight + kHitht)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [Utils setBianKuang:kMainColor Wide:2 view:backGroundView];
    [Utils setViewRiders:backGroundView riders:8];
    [_bacgroundView addSubview:backGroundView];
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width - 40, _viewWight + kHitht)];
    headView.backgroundColor = [UIColor whiteColor];
    [self creatHeadView:headView];
    [backGroundView addSubview:headView];
    [self creatDayView:backGroundView];
    
    UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, backGroundView.frame.size.height + backGroundView.frame.origin.y + 20, kSizeOfScreen.width - 40, 20)];
    lLabel.text = @"提示：每日签到可以赚更多积分";
    lLabel.textColor = [UIColor darkGrayColor];
    lLabel.font = kFontOfLetterMedium;
    [_bacgroundView addSubview:lLabel];
    
    _qianDaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, lLabel.frame.origin.y + lLabel.frame.size.height + 20, 70, 35)];
    [_qianDaoBtn setBackgroundImage:[UIImage imageNamed:@"sign_button1"] forState:UIControlStateNormal];
    [_qianDaoBtn setTitle:@"今日签到" forState:UIControlStateNormal];
    _qianDaoBtn.titleLabel.font = kFontOfLetterMedium;
    [_qianDaoBtn setTintColor:[UIColor whiteColor]];
    [_qianDaoBtn addTarget:self action:@selector(qianDaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bacgroundView addSubview:_qianDaoBtn];
    [_bacgroundView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, _qianDaoBtn.frame.size.height + _qianDaoBtn.frame.origin.y + 20)];
    MyLog(@"%f",_bacgroundView.frame.size.height);
    [_scrollView addSubview:_bacgroundView];
    _scrollView.contentSize = CGSizeMake( 0, _bacgroundView.frame.size.height);
}
-(void)creatBtn:(NSString*)title tag:(int)tag fatherView:(UIView*)view frame:(CGRect)frame{
    UIButton* lBtn = [[UIButton alloc] initWithFrame:frame];
    lBtn.tag = tag;
    lBtn.titleLabel.font = kFontOfSize(15);
    [lBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [lBtn setTitle:title forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(changeMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:lBtn];
}
-(void)creatHeadView:(UIView*)view{
    NSArray* lArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    UILabel* lLabel = [Utils labelWithFrame:CGRectMake(0, 0, view.frame.size.width, kHitht) withTitle:[NSString stringWithFormat:@"%i年%i月",_year,_month] titleFontSize:kFontOfSize(17) textColor:kMainColor alignment:NSTextAlignmentCenter];
    [view addSubview:lLabel];
    int i = 0;
    for (NSString* lString in lArray) {
        UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewWight*i, kHitht, _viewWight, _viewWight)];
        lLabel.font = kFontOfSize(17);
        lLabel.textColor = kMainColor;
        [lLabel setTextAlignment:NSTextAlignmentCenter];
        lLabel.text = lString;
        [view addSubview:lLabel];
        i++;
    }
}
-(void)creatDayView:(UIView*)view{
    int starX = [_qiaoDao getDifferDayNumber:_year month:_month day:1]%7;
    for (int i=0; i< 7*[self getRowWithYear:_year month:_month]; i++) {
        NSString* lSrting = [NSString stringWithFormat:@"%i-%02i-%02i",_year,_month,i - starX + 1];
        UIView* lView = [[UIView alloc] initWithFrame:CGRectMake(i%7*_viewWight, _viewWight + kHitht + i/7*_viewWight, _viewWight, _viewWight)];
        [Utils setBianKuang:kMainColor Wide:1 view:lView];
        
        if (i>=starX && i< [_qiaoDao judgeMonthHaveDays:_year month:_month] + starX) {
            UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWight, _viewWight)];
            lLabel.font = kFontOfSize(20);
            lLabel.textColor = kMainColor;
            [lLabel setTextAlignment:NSTextAlignmentCenter];
            lLabel.text = [NSString stringWithFormat:@"%i",i - starX + 1];
            [lView addSubview:lLabel];
        }
        if ([_dataArray containsObject:lSrting]) {
            UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWight, _viewWight)];
            lImageView.image = [UIImage imageNamed:@"qiandao_kuang"];
            [lView addSubview:lImageView];
        }
        [view addSubview:lView];
    }
}
-(int)getRowWithYear:(int)year month:(int)month{
    int temp = ([_qiaoDao getDifferDayNumber:year month:month day:1]%7 + [_qiaoDao judgeMonthHaveDays:year month:month]);
    if (temp%7 == 0) {
        temp = temp/7;
    }else{
        temp = temp/7 + 1;
    }
    return temp;
}
- (void)changeMonthClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            _month -= 1;
            if (_month == 0) {
                _year -= 1;
                _month = 12;
            }
        }
            break;
        case 2:
        {
            _month += 1;
            if (_month > 12) {
                _year += 1;
                _month = 1;
            }
        }
            break;
            
        default:
            break;
    }
    NSLog(@"%i-%i",_year,_month);
    
    [self http];
}
-(void)qianDaoBtnClick{
    MyLog(@"签到");
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key};
    MyLog(@"%@",dic);
    [self showHudInView:self.view hint:@"数据加载中..."];
    [ModelTool httpGetSignWithParameter:dic success:^(id object) {
        NSDictionary* lDic = object;
        MyLog(@"%@",lDic);
        MyLog(@"%@",lDic[@"data"][@"msg"]);
        if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            
            NSString* nowDay = [NSString stringWithFormat:@"%i-%02i-%02i",_year,_month,_day];
            NSUserDefaults*user=[[NSUserDefaults alloc]init];
            [user setObject:nowDay forKey:KUserManager.uid];
            [NSUserDefaults resetStandardUserDefaults];
            
            NSMutableArray* lArray = [NSMutableArray arrayWithArray:_dataArray];
            [lArray addObject:nowDay];
            _dataArray = [NSArray arrayWithArray:lArray];
            MyLog(@"%@",nowDay);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_month == _nowMonth) {
                    [_scrollView removeFromSuperview];
                    [self creatUI];
                }
                KUserManager.sign = @"1";
                _qianDaoBtn.userInteractionEnabled = NO;
                [_qianDaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
                [_qianDaoBtn setBackgroundImage:[UIImage imageNamed:@"sign_button2"] forState:UIControlStateNormal];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:lDic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                KUserManager.score.now = [NSString stringWithFormat:@"%@",lDic[@"data"][@"score"]];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:lDic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            });
        }
        [self hideHud];
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}

@end
