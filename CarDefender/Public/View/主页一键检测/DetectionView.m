//
//  DetectionView.m
//  yijianjiance
//
//  Created by 周子涵 on 15/6/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DetectionView.h"
#import "Define.h"


@implementation DetectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatDetectionDefaultView];
        [self creatDecetingView];
        [self creatDecetionEndView];
    }
    return self;
}
#pragma mark - 创建DetectionDefaultView
-(void)creatDetectionDefaultView{
    _detectionDefaultView = [[DetectionDefaultView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _detectionDefaultView.delegate = self;
    [self addSubview:_detectionDefaultView];
}
#pragma mark - 创建DecetingView
-(void)creatDecetingView{
    _detectingView = [[DetectingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _detectingView.hidden = YES;
    _detectingView.delegate = self;
    [self addSubview:_detectingView];
}
#pragma mark - 创建DecetionEndView
-(void)creatDecetionEndView{
    _detectionEndView = [[DetectionEndView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    _detectionEndView.hidden = YES;
    _detectionEndView.delegate = self;
    [self addSubview:_detectionEndView];
}

#pragma mark - 检测开始代理协议
-(void)detectionStart{
    MyLog(@"检测开始");
    [self.delegate detectionBtnClick:1 dic:nil];
    _detectionDefaultView.hidden = YES;
    _detectingView.hidden = NO;
    [self getData];
}
-(void)getData{
    NSDictionary* dic1 = @{@"name":@"总里程"};
    NSDictionary* dic11 = @{@"name":@"空燃比系数"};
    NSDictionary* dic12 = @{@"name":@"蓄电池电压"};
    NSDictionary* dic13 = @{@"name":@"气节门开度"};
    NSDictionary* dic14 = @{@"name":@"obd时间"};
    NSDictionary* dic15 = @{@"name":@"发动机负荷"};
    NSDictionary* dic16 = @{@"name":@"发动机运行时间"};
    NSDictionary* dic2 = @{@"name":@"百公里油耗"};
    NSDictionary* dic3 = @{@"name":@"剩余油量"};
    NSDictionary* dic4 = @{@"name":@"发动机转速"};
    NSDictionary* dic5 = @{@"name":@"车速"};
    NSDictionary* dic6 = @{@"name":@"环境温度"};
    NSDictionary* dic7 = @{@"name":@"水温"};
    NSDictionary* dic8 = @{@"name":@"距下次年检"};
    NSDictionary* dic9 = @{@"name":@"距离上次保养"};
    NSDictionary* dic10 = @{@"name":@"故障码"};
    NSDictionary* dic = @{@"licensePlateNumber":@"",
                          @"synthesis":@"",
                          @"carState":@"",
                          @"maintainState":@"",
                          @"list":@[dic1,dic11,dic12,dic13,dic14,dic15,dic16,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9,dic10]};
    [_detectingView setGroundView];
    [_detectingView animationStarDictionary:dic];
}
#pragma mark - 检测中代理协议
-(void)detectionEnd:(NSDictionary *)dataDic{
    MyLog(@"检测动画结束");
    [self.delegate detectionBtnClick:4 dic:nil];
    _detectionEndView.hidden = NO;
    [_detectionEndView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    if (dataDic == nil) {
        UIAlertView* thyAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测失败，请重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [thyAlertView show];
        [_detectionEndView setDataViewHidden:YES];
        [self detectionEndBtnClick:1 dictionary:nil];
    }else{
        [_detectionEndView setDataViewHidden:NO];
    }
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _detectionEndView.frame;
        frame.origin.y = 0;
        _detectionEndView.frame = frame;
    } completion:^(BOOL finished) {
        [_detectionEndView animationStar:dataDic];
    }];
}
#pragma mark - 检测结束代理协议
-(void)detectionEndBtnClick:(int)type dictionary:(NSDictionary *)dic{
    switch (type) {
        case 1:
        {
            MyLog(@"关闭");
            [_detectionEndView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = _detectionEndView.frame;
                frame.origin.y = self.frame.size.height;
                _detectionEndView.frame = frame;
            } completion:^(BOOL finished) {
//                [_detectionEndView animationStar];
                _detectionEndView.hidden = YES;
            }];
            _detectionDefaultView.hidden = NO;
            _detectingView.hidden = YES;
            [self.delegate detectionBtnClick:2 dic:nil];
        }
            break;
        case 2:
        {
            MyLog(@"重新检测");
            _detectionEndView.hidden = YES;
            [self detectionStart];
        }
            break;
        case 3:
        {
            MyLog(@"查看详情");
            [self.delegate detectionBtnClick:3 dic:dic];
        }
            break;
            
        default:
            break;
    }
}
-(void)noStart:(int)type{
    [self.delegate noStart:type];
}
@end
