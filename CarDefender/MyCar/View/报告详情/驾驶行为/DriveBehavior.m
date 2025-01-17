//
//  DriveBehavior.m
//  报告动画
//
//  Created by 周子涵 on 15/5/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DriveBehavior.h"
#import "ReportContentView.h"
#import "Define.h"

#define kRatio 0.62

@implementation DriveBehavior
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _dataDic = dic;
        NSDictionary* dataDic = dic;
        _dataArray = @[[NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"rapidlyspeedupcount"]]],
                       [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"suddenturncount"]]],
                       [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"emergencybrakecount"]]],
                       [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"fatiguedrivingcount"]]]];
        [self creatHeadView];
        [self creatCell:CGRectMake(0, 73, kSizeOfScreen.width, 65) image:[UIImage imageNamed:@"jiashi_jijiasu1"] title:@"急加速" value:_dataArray[0] tag:1 warning:NO];
        [self creatCell:CGRectMake(0, 139, kSizeOfScreen.width, 65) image:[UIImage imageNamed:@"jiashi_jishache1"] title:@"急转弯" value:_dataArray[1] tag:2 warning:NO];
        [self creatCell:CGRectMake(0, 205, kSizeOfScreen.width, 65) image:[UIImage imageNamed:@"jiashi_jizhuanwan1"] title:@"急刹车" value:_dataArray[2] tag:3 warning:NO];
        [self creatCell:CGRectMake(0, 271, kSizeOfScreen.width, 65) image:[UIImage imageNamed:@"jiashi_jiashi1"] title:@"疲劳驾驶" value:_dataArray[3] tag:4 warning:YES];
    }
    return self;
}
- (NSString *)converStrNotNull:(id)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return @"0";
    } else {
        return [NSString stringWithFormat:@"%@",data];
    }
}
-(void)creatHeadView{
    //创建头部View
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 73)];
    //创建驾驶里程
    UILabel* mileLabel = [Utils labelWithFrame:CGRectMake(8, 12, 54, 21) withTitle:@"行驶里程" titleFontSize:kFontOfSize(13) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    [_headView addSubview:mileLabel];
    _mileLabel = [Utils labelWithFrame:CGRectMake(70, 12, 106, 21) withTitle:[NSString stringWithFormat:@"%@km",[self converStrNotNull:_dataDic[@"mileAge"]]] titleFontSize:kFontOfSize(12) textColor:kMainColor alignment:NSTextAlignmentLeft];
    
    [_headView addSubview:_mileLabel];
    //创建驾驶时间
    UILabel* timeLabel = [Utils labelWithFrame:CGRectMake(8, 41, 54, 21) withTitle:@"行驶时间" titleFontSize:kFontOfSize(13) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    [_headView addSubview:timeLabel];
    
    int min = [_dataDic[@"runningTime"] intValue]/1000%60;
    int hour = [_dataDic[@"runningTime"] intValue]/1000/60;
    _timeLabel = [Utils labelWithFrame:CGRectMake(70, 41, 106, 21) withTitle:[NSString stringWithFormat:@"%i小时%i分钟",hour,min] titleFontSize:kFontOfSize(12) textColor:kMainColor alignment:NSTextAlignmentLeft];
    [_headView addSubview:_timeLabel];
    //创建得分
    NSString *drivingScore = [self converStrNotNull:_dataDic[@"drivingScore"]];
    if (![drivingScore isEqualToString:@"-"]) {
        drivingScore = @"99";
    }
    _gradeLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 52, 25, 42, 21) withTitle:[NSString stringWithFormat:@"%@分",drivingScore] titleFontSize:kFontOfSize(19) textColor:kMainColor alignment:NSTextAlignmentLeft];
    
    [_headView addSubview:_gradeLabel];
    UILabel* gradeLabel = [Utils labelWithFrame:CGRectMake(_gradeLabel.frame.origin.x - 98, 26, 92, 21) withTitle:@"驾驶行为得分" titleFontSize:kFontOfSize(15) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    [_headView addSubview:gradeLabel];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 72, kSizeOfScreen.width - 20, 1)];
    imageView.image = [UIImage imageNamed:@"feiyong_line.png"];
    [_headView addSubview:imageView];
    
    [self addSubview:_headView];
}
-(void)creatCell:(CGRect)frame image:(UIImage*)image title:(NSString*)title value:(NSString*)value tag:(int)tag warning:(BOOL)warning{
    UIView* lView = [[UIView alloc] initWithFrame:frame];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, 45, 45)];
    imageView.image = image;
    [lView addSubview:imageView];
    UILabel* lLabel = [Utils labelWithFrame:CGRectMake(61, 24, 76, 21) withTitle:title titleFontSize:kFontOfSize(17) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    [lView addSubview:lLabel];
    UILabel* valueLabel = [Utils labelWithFrame:CGRectMake(139, 24, 45, 21) withTitle:value titleFontSize:kFontOfSize(17) textColor:kMainColor alignment:NSTextAlignmentLeft];
    valueLabel.tag = tag + 100;
    [lView addSubview:valueLabel];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(kSizeOfScreen.width - 85, 20, 75, 30)];
    [button setTitle:@"查看全部>>" forState:UIControlStateNormal];
    button.titleLabel.font = kFontOfSize(14);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.tag = tag;
    button.alpha = 0;
    button.userInteractionEnabled = NO;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lView addSubview:button];
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64, kSizeOfScreen.width - 20, 1)];
    lineImageView.image = [UIImage imageNamed:@"feiyong_line.png"];
    [lView addSubview:lineImageView];
    [self addSubview:lView];
}
-(void)reloadData:(NSDictionary*)dic{
    NSDictionary* dataDic = dic;
    _dataArray = @[[NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"rapidlyspeedupcount"]]],
                   [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"suddenturncount"]]],
                   [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"emergencybrakecount"]]],
                   [NSString stringWithFormat:@"%@次",[self converStrNotNull:dataDic[@"fatiguedrivingcount"]]]];
    for (int i = 0; i < _dataArray.count; i++) {
        UILabel* lLabel = (UILabel*)[self viewWithTag:i + 101];
        lLabel.text = _dataArray[i];
    }
    int min = [_dataDic[@"runningTime"] intValue]/1000%60;
    int hour = [_dataDic[@"runningTime"] intValue]/1000/60;
    
    _timeLabel.text = [NSString stringWithFormat:@"%i小时%i分钟",hour,min];
    _mileLabel.text = [NSString stringWithFormat:@"%@km",dataDic[@"mileAge"]];
    NSString *drivingScore = [self converStrNotNull:_dataDic[@"drivingScore"]];
    if (![drivingScore isEqualToString:@"-"]) {
        drivingScore = @"99";
    }
    _gradeLabel.text = [NSString stringWithFormat:@"%@分",drivingScore];
}
-(void)btnClick:(UIButton*)sender{
    MyLog(@"%i",(int)sender.tag);
    [self.delegate cellClick:[NSString stringWithFormat:@"%i",(int)sender.tag]];
}
-(void)animateStart{
    NSLog(@"速度动画开始");
}

@end
