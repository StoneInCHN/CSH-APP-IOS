//
//  ReportTime.m
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportTime.h"
#import "TimeView.h"
#import "Define.h"
#import "ReportPublicBaskBtn.h"
#import "ReportContentView.h"
#define kJiantou 5
#define kpercent 0.38
#define kJianMile 0.85



//down define
#define kDistanceCurrentView 10
#define kBaskBtnWH 80
@implementation ReportTime

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ReportTime" owner:self options:nil][0];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        if (kSizeOfScreen.height<500) {
            _namalFont=14;
            _currentDistance=10;
        }else{
            _namalFont=16;
            _currentDistance=28;
        }
        noData=YES;
        _timeViewFirstIn=YES;
        [self buildUIWithDic:@{}];
        
    }
    return self;
}
-(void)buildUIWithDic:(NSDictionary*)dicMsg;
{
    if (self.subviews.count) {
        for (UIView*view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    _dicMsg=[NSDictionary dictionaryWithDictionary:dicMsg];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, kSizeOfScreen.width-20, self.frame.size.height*kpercent*kJianMile)];
    [self addSubview:_scrollView];
    if (noData) {
        _scrollView.userInteractionEnabled=NO;
    }
    _scrollView.showsHorizontalScrollIndicator=NO;
    TimeView *mileageView=[[TimeView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width*2, _scrollView.frame.size.height)];
    [_scrollView addSubview:mileageView];
    mileageView.backgroundColor=[UIColor whiteColor];
    mileageView.timeFirstIn=_timeViewFirstIn;
    mileageView.noData=noData;
    mileageView.delegate=self;
    if (!noData) {//有数据
        mileageView.timeDic=_dicMsg;
    }
    _scrollView.contentSize=CGSizeMake(kSizeOfScreen.width*2, _scrollView.frame.size.height);
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height+_scrollView.frame.origin.y, kSizeOfScreen.width, self.frame.size.height*kpercent*(1-kJianMile))];
    if (!noData) {
        label.text=@"点击图形可以了解驾驶时间详情";
    }
    label.textColor=[UIColor grayColor];
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    if (kSizeOfScreen.height<600) {
        label.font=kFontOfSize(10);
    }else
        label.font=kFontOfLetterSmall;
    [self buildDownView];
}
-(void)timeViewFirstBtnFrame:(CGRect)timeFrame
{
    _scrollView.contentOffset=CGPointMake(timeFrame.origin.x-60, 0);
}
-(void)buildDownView
{
    NSDictionary* dic;
    NSString*contentString;
    if (noData) {
        dic = @{@"title":@"您当日驾驶时长为",
                @"value":@"0",
                @"content":@"",
                @"mark":@""};
        contentString=@"";
    }else{
        contentString = [NSString stringWithFormat:@"其中最长连续驾驶%@分钟,击败了全国%@的车友",_dicMsg[@"max"],_dicMsg[@"percent"]];
        NSRange range1=[contentString rangeOfString:@"其中最长连续驾驶"];
        NSRange range2=[contentString rangeOfString:@"分钟,击败了全国"];
        NSRange range3=[contentString rangeOfString:@"的车友"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range3.location ,range3.length)];
        
        NSString*markString=@"";
        if (_dicMsg.count) {
            if ([_dicMsg[@"total"] floatValue]<15.0) {
                markString=@"赖在家里挺好，谁也别想让我出门。";
            }else{
                if ([_dicMsg[@"total"] floatValue]<60.0) {
                    markString=@"出门小转，有益健康。";
                }else{
                    if ([_dicMsg[@"total"] floatValue]<240.0) {
                        markString=@"全职车手，一般人我不告诉他";
                    }else{
                        markString=@"爱车是我家，吃睡不离她。";
                    }
                }
            }
        }
        
        dic = @{@"title":@"您当日驾驶时长为",
                @"value":[self stringWihtTime:_dicMsg[@"total"]],
                @"content":str,
                @"mark":markString};
    }
    _shareString=[NSString stringWithFormat:@"%@%@%@%@",dic[@"title"],dic[@"value"],contentString,dic[@"mark"]];
    [self buildDownViewWithDic:dic];
}
-(void)animateStart{
    NSLog(@"行驶时间动画开始");
}
-(void)reloadData:(NSDictionary *)dic
{
    _timeViewFirstIn=NO;
    NSArray*listArray=dic[@"list"];
    if ([dic[@"status"] intValue] == 1) {
        noData=NO;
    }else
        noData=YES;
    
    
    if (!listArray.count) {
        noData=YES;
    }else
        noData=NO;
    _timeDic=dic;
    [self buildUIWithDic:dic];
}
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef ctx=UIGraphicsGetCurrentContext();
//    //获取绘图上下文
//    //设置线宽
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
//
//    //画水平坐标系
//    const CGPoint points1[] = {CGPointMake(20, rect.size.height*kpercent),CGPointMake(rect.size.width-20, rect.size.height*kpercent)};
//    //绘制线段（默认不绘制端点）
//    CGContextStrokeLineSegments(ctx, points1, 2);
//    //设置短短的端点形状：方向端点
//    CGContextSetLineCap(ctx, kCGLineCapSquare);
//}
-(void)buildDownViewWithDic:(NSDictionary*)dic
{
    CGFloat downOrigin=self.frame.size.height*kpercent;
    UILabel*currentCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, downOrigin+_currentDistance, self.frame.size.width, 20)];
    currentCostLabel.text=dic[@"title"];
    currentCostLabel.textColor=KBlackMainColor;
    currentCostLabel.textAlignment=NSTextAlignmentCenter;
    currentCostLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:currentCostLabel];
    
    UILabel*totalCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, currentCostLabel.frame.size.height+currentCostLabel.frame.origin.y+_currentDistance/2, self.frame.size.width, 28)];
    totalCostLabel.text=[NSString stringWithFormat:@"%@",dic[@"value"]];
    totalCostLabel.textColor=kMainColor;
    totalCostLabel.textAlignment=NSTextAlignmentCenter;
    totalCostLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:30];
    [self addSubview:totalCostLabel];
    //
    
    UILabel*describeOilCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, totalCostLabel.frame.origin.y+totalCostLabel.frame.size.height, self.frame.size.width-2*20, 50)];
    describeOilCostLabel.textColor=kMainColor;
    if ([dic[@"content"] length]) {
        describeOilCostLabel.attributedText=dic[@"content"];
    }
    describeOilCostLabel.textAlignment=NSTextAlignmentCenter;
    describeOilCostLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:describeOilCostLabel];
    describeOilCostLabel.numberOfLines=0;
    //
    UILabel*characterLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, describeOilCostLabel.frame.size.height+describeOilCostLabel.frame.origin.y+_currentDistance/2, kSizeOfScreen.width, 15)];
    characterLabel.text=dic[@"mark"];
    characterLabel.textColor=KBlackMainColor;
    characterLabel.textAlignment=NSTextAlignmentCenter;
    characterLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:characterLabel];
    //
    ReportPublicBaskBtn*baskBtn=[[ReportPublicBaskBtn alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-kBaskBtnWH)/2, characterLabel.frame.origin.y+characterLabel.frame.size.height+_currentDistance/2, kBaskBtnWH, kBaskBtnWH)];
    if (noData) {
        [baskBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateNormal];
    }else{
        [baskBtn setImage:[UIImage imageNamed:@"shuai_icon"] forState:UIControlStateNormal];
        [baskBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateHighlighted];
    }
    
    [baskBtn addTarget:self action:@selector(timeShareClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:baskBtn];
}
-(void)timeShareClick
{
    [self.delegate reportTimeShareDic:@{@"content":_shareString,@"url":_timeDic[@"shareUrl"],@"imgUrl":_timeDic[@"shareIcon"]}];
}
-(NSString*)stringWihtTime:(NSString*)timeString
{
    NSString*string;
    string=[NSString stringWithFormat:@"%d小时%d分",(int)[timeString integerValue]/60,(int)[timeString integerValue]%60];    MyLog(@"%@-%@",string,timeString);
    return string;
}
@end
