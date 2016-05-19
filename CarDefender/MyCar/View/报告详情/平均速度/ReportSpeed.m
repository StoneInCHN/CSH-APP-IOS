//
//  ReportSpeed.m
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportSpeed.h"




@implementation ReportSpeed
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"ReportSpeed" owner:self options:nil][0];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.data = dic;
        NSLog(@"%@",dic);
        _temp = 0;
        _topArray = [NSMutableArray array];
        [self creatTop];
        [self creatBottom];
//        [self updateContentLabel];
        for (int i = 1; i < 5; i++) {
            UILabel* lLabel = (UILabel*)[self viewWithTag:i];
            CGFloat normalSize = lLabel.font.pointSize;
            lLabel.font = kFontOfSize(normalSize*kSizeOfScreen.height/460);
            MyLog(@"%f",lLabel.font.pointSize);
        }
    }
    return self;
}
#pragma mark - 刷新数据
-(void)reloadData:(NSDictionary*)dic{
    
    self.data = dic;
    [_speedCoordView removeFromSuperview];
    _speedCoordView = nil;
//    [self setNeedsDisplay];
    NSDictionary* bottomDic;
    if ([dic[@"data"][@"status"] isEqualToString:@"0"]) {
        [self creatMarkLabel];
        return;
    }else{
//        _scrollerView.hidden = NO;
        bottomDic = [self getBottomDic:dic[@"data"]];
//        _markLabel.hidden = YES;
        for (int i = 10; i < 15; i++) {
            UIView* lView = [self viewWithTag:i];
            [lView removeFromSuperview];
        }
    }
    NSDictionary* topDic = [self getTopDic:dic[@"data"]];
    _speedCoordView = [[SpeedCoordView alloc] initWithFrame:CGRectMake(kNormalWight, kNormalHight * 0.05, self.frame.size.width - 2*kNormalWight, kNormalHight * 0.9) Dictionary:@{@"data":topDic[@"array"]} markData:topDic[@"dic"]];
//    [Utils setViewRiders:_speedCoordView riders:4];
    [self addSubview:_speedCoordView];
    [_reportBottomView reloadData:bottomDic];
//    CGFloat width = (_scrollerView.frame.size.width )/5 * 4;
//    CGFloat startX = [dic[@"data"][@"list"][0][@"start"] floatValue]*width/86400;
//    if (startX > _scrollerView.frame.size.width + _scrollerView.frame.size.width/2) {
//        startX = _scrollerView.frame.size.width + _scrollerView.frame.size.width/2;
//    }else{
//        startX += 20;
//    }
//    [_scrollerView setContentOffset:CGPointMake(startX, 0)];
}
//创建标志Label
-(void)creatMarkLabel{
    if (_markLabel == nil) {
        _markLabel = [Utils labelWithFrame:CGRectMake(kNormalWight , kNormalHight * 0.05, self.frame.size.width - 2*kNormalWight, kNormalHight * 0.9) withTitle:@"暂无数据,请检测您的设备是否正常工作" titleFontSize:kFontOfSize(13) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
        _markLabel.backgroundColor = kCOLOR(245, 245, 245);
        [self addSubview:_markLabel];
    }else{
        _markLabel.hidden = NO;
    }
}
-(NSDictionary*)getBottomDic:(NSDictionary*)dic{
    if (dic == nil) {
        NSDictionary* bottomDic = @{@"title":@"当日平均时速为",
                                    @"value":@"0",
                                    @"content":[[NSMutableAttributedString alloc] initWithString:@""],
                                    @"mark":@"",
                                    @"sharecontent":@""};
        return bottomDic;
    }
    NSString* stringDesc = [NSString stringWithFormat:@"拥堵状态下的行驶时间为%@分钟,拥堵系数%@,击败了全国%@的车友",dic[@"jamTime"],dic[@"jamPercent"],dic[@"percent"]];
    NSRange range1=[stringDesc rangeOfString:@"拥堵状态下的行驶时间为"];
    NSRange range2=[stringDesc rangeOfString:@"分钟,拥堵系数"];
    NSRange range3=[stringDesc rangeOfString:@"击败了全国"];
    NSRange range4=[stringDesc rangeOfString:@"的车友"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringDesc];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range3.location - 1,range3.length+1)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range4.location,range4.length)];
    NSString* markStr;
    if ([dic[@"jamPercent"] floatValue] < 0.2) {
        markStr = @"车技棒不如选路棒,晚出发早到,不堵车就是任性";
    }else if ([dic[@"jamPercent"] floatValue] < 0.55){
        markStr = @"走走停停看风景,堵堵通通磨心境";
    }else{
        markStr = @"公路变成停车场,麻将一圈走一辆";
    }
    NSDictionary* bottomDic = @{@"title":@"当日平均时速为",
                                @"value":[NSString stringWithFormat:@"%@km/h",dic[@"avgDay"]],
                                @"content":str,
                                @"mark":markStr,
                                @"sharecontent":[NSString stringWithFormat:@"当日平均时速为%@%@%@",[NSString stringWithFormat:@"%@Km/h",dic[@"avgDay"]],stringDesc,markStr],
                                @"url":dic[@"shareUrl"],
                                @"imgUrl":dic[@"shareIcon"]};
    return bottomDic;
}

-(NSDictionary*)getTopDic:(NSDictionary*)dic{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* lDic in dic[@"list"]) {
        NSMutableDictionary* dataDic = [NSMutableDictionary dictionary];
        [dataDic setObject:lDic[@"maxCurrent"] forKey:@"top"];
        [dataDic setObject:lDic[@"avgCurrent"] forKey:@"bottom"];
        [dataDic setObject:lDic[@"start"] forKey:@"start"];
        [dataDic setObject:lDic[@"end"] forKey:@"end"];
        [dataDic setObject:lDic[@"startTime"] forKey:@"startTime"];
        [dataDic setObject:lDic[@"endTime"] forKey:@"endTime"];
//        NSMutableArray* mutArray = [NSMutableArray array];
//        for (NSDictionary* dic in lDic[@"list"]) {
//            NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
//            [mutDic setObject:dic[@"speed"] forKey:@"mark"];
//            [mutDic setObject:dic[@"status"] forKey:@"status"];
//            [mutDic setObject:dic[@"time"] forKey:@"time"];
//            [mutArray addObject:mutDic];
//        }
//        [dataDic setObject:mutArray forKey:@"list"];
        [array addObject:dataDic];
    }
    
//    NSDictionary* dic = @{@"topName":@"最高时速",
//                          @"bottomName":@"平均时速",
//                          @"max":@"120",
//                          @"mark":@"1"};
    NSDictionary* topDic = @{@"array":array,
                             @"dic":@{@"topName":@"最高时速",
                                      @"bottomName":@"平均时速",
                                      @"max":@"120",
                                      @"mark":@"1"}};
    return topDic;
}
-(void)creatTop{
//    UIView* lView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.38, kSizeOfScreen.width, 1)];
//    lView.backgroundColor = [UIColor darkGrayColor];
//    [self addSubview:lView];
    
//    CGFloat length = kNormalHight*0.9;
//    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(kNormalWight, kNormalHight * 0.05, self.frame.size.width - 2*kNormalWight, kNormalHight * 0.9)];
////    _scrollerView.contentSize = CGSizeMake((_scrollerView.frame.size.width)*2, 0);
//    _scrollerView.showsHorizontalScrollIndicator = NO;
//    _scrollerView.bounces = NO;
    
//    UILabel* lLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * (1-kRatio) * kTopRatio + 20, kSizeOfScreen.width, 20)];
//    lLabel1.text = @"点击图形可以了解最高时速详情";
//    lLabel1.font = kFontOfSize(10);
//    lLabel1.textColor = [UIColor darkGrayColor];
//    lLabel1.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:lLabel1];
    
//    [self addSubview:_scrollerView];
    
    if ([self.data[@"data"][@"status"] isEqualToString:@"0"]) {
        [self creatMarkLabel];
        return;
    }
    
    NSDictionary* topDic = [self getTopDic:self.data[@"data"]];
    
    _speedCoordView = [[SpeedCoordView alloc] initWithFrame:CGRectMake(kNormalWight, kNormalHight * 0.05, self.frame.size.width - 2*kNormalWight, kNormalHight * 0.9) Dictionary:@{@"data":topDic[@"array"]} markData:topDic[@"dic"]];
    [self addSubview:_speedCoordView];
}
-(void)creatBottom{
    NSDictionary* dic;
    if ([self.data[@"data"][@"status"] isEqualToString:@"0"]) {
        dic = [self getBottomDic:nil];
    }else{
        dic = [self getBottomDic:self.data[@"data"]];
    }
    
    _reportBottomView = [[ReportContentView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*(1-kRatio), self.frame.size.width, self.frame.size.height*kRatio) Dictionary:dic];
    [self addSubview:_reportBottomView];
    
    
    //    [_contentView setFrame:CGRectMake(0,self.frame.size.height - (kSizeOfScreen.height - 102)*kRatio, self.frame.size.width, (kSizeOfScreen.height - 102)*kRatio)];
    //    [self addSubview:_contentView];
}
//#pragma mark - 绘图方法
//- (void)drawRect:(CGRect)rect
//{
////    [self drawCoordinateY];
////    if ([self.data[@"data"][@"status"] isEqualToString:@"0"]) {
////        [self drawCoordinateX];
////    }
//}
//#pragma mark - 画直角坐标系x轴
//-(void)drawCoordinateX{
//    CGContextRef ctx=UIGraphicsGetCurrentContext();
//    NSArray*xArray=@[@"0时",@"6时",@"12时",@"18时",@"24时"];
//    //获取绘图上下文
//    
//    //设置线宽
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
//    
//    //画水平坐标系
//    const CGPoint points[] = {CGPointMake(kNormalWight, kNormalHight),CGPointMake(self.frame.size.width-20, kNormalHight)};
//    //绘制线段（默认不绘制端点）
//    CGContextStrokeLineSegments(ctx, points, 2);
//    //设置短短的端点形状：方向端点
//    CGContextSetLineCap(ctx, kCGLineCapSquare);
//    
//    //绘制三角形
//    //拿到当前视图准备好的画板
//    //    CGContextRef context = UIGraphicsGetCurrentContext();
//    //利用path进行绘制三角形
//    CGContextBeginPath(ctx);//标记
//    CGContextMoveToPoint(ctx, self.frame.size.width-20, kNormalHight);//设置起点
//    CGContextAddLineToPoint(ctx, self.frame.size.width-20-5, kNormalHight-5/2);
//    CGContextAddLineToPoint(ctx, self.frame.size.width-20-5, kNormalHight+5/2);
//    CGContextClosePath(ctx);//路径结束标志，不写默认封闭
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] setFill];
//    //设置填充色
//    //设置边框颜色
//    CGContextDrawPath(ctx, kCGPathFillStroke);//绘制路径path
//    
//    //设置时间段
//    CGFloat weight=(self.frame.size.width - kNormalWight)/5;
//    for (int i=0; i<xArray.count; i++) {
//        //        yn=YES;
//        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(37+i*weight, kNormalHight+5, weight, 20)];
//        label.text=xArray[i];
//        label.tag = i + 10;
//        label.textColor=[UIColor grayColor];
//        label.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:label];
//        label.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
//        NSLog(@"%f",label.center.x);
//    }
//}
//#pragma mark - 画直角坐标系y轴
//-(void)drawCoordinateY{
//    CGFloat length = kNormalHight*0.8;
//    
//    CGContextRef ctx=UIGraphicsGetCurrentContext();
//    NSArray*xArray=@[@"0",@"30",@"60",@"90",@"120"];
//    //获取绘图上下文
//    
//    //设置线宽
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
//    //画水平坐标系
//    const CGPoint points[] = {CGPointMake(kNormalWight, kNormalHight),CGPointMake(kNormalWight, kNormalHight - length)};
//    //绘制线段（默认不绘制端点）
//    CGContextStrokeLineSegments(ctx, points, 2);
//    //设置短短的端点形状：方向端点
//    CGContextSetLineCap(ctx, kCGLineCapSquare);
//
//    //绘制三角形
//    //拿到当前视图准备好的画板
//    //    CGContextRef context = UIGraphicsGetCurrentContext();
//    //利用path进行绘制三角形
//    CGContextBeginPath(ctx);//标记
//    CGContextMoveToPoint(ctx, kNormalWight, kNormalHight - length);//设置起点
//    CGContextAddLineToPoint(ctx, kNormalWight+5/2, kNormalHight - length+5);
//    CGContextAddLineToPoint(ctx, kNormalWight-5/2, kNormalHight - length+5);
//    CGContextClosePath(ctx);//路径结束标志，不写默认封闭
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:1] setFill];
//    //设置填充色
//    //设置边框颜色
//    CGContextDrawPath(ctx, kCGPathFillStroke);//绘制路径path
//    
//    //设置时间段
//    CGFloat weight=length/5;
//    for (int i=0; i<xArray.count; i++) {
//        //        yn=YES;
//        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, kNormalHight - i*weight - 10, 30, 20)];
//        label.text=xArray[i];
//        label.textColor=[UIColor grayColor];
//        label.textAlignment = NSTextAlignmentRight;
//        [self addSubview:label];
//        label.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
//        if (i == xArray.count-1) {
//            UILabel*lLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, label.frame.origin.y - 12, 30, 12)];
//            lLabel.text=@"(km/h)";
//            lLabel.textColor=[UIColor lightGrayColor];
//            lLabel.textAlignment = NSTextAlignmentRight;
//             lLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
//            [self addSubview:lLabel];
//        }
//    }
//}
//#pragma mark - 画数据
//-(void)drawData{
//    CGFloat width = (self.frame.size.width - kNormalWight)/5 * 4;
//    CGFloat hight = 120;
//    NSArray* dataArray = self.data[@"data"][@"list"];
//    for (int i = 0; i < dataArray.count; i++) {
//        [[UIColor blackColor]set];
//        //得到当前上下文
//        CGContextRef currentContext = UIGraphicsGetCurrentContext();
//        //得到线的宽度
//        CGContextSetLineWidth(currentContext, 1.0f);
//        NSDictionary* lDic = dataArray[i];
//        CGFloat startX = [lDic[@"startTime"] floatValue]*width/86400 + kNormalWight;
//        CGFloat endX = [lDic[@"endTime"] floatValue]*width/86400 + kNormalWight;
//        CGContextMoveToPoint(currentContext, startX, kNormalHight);
//        NSArray* array = lDic[@"array"];
//        CGFloat blank = 0;
//        CGFloat maxHight = 0;
//        CGFloat maxX = 0;
//        for (int i = 0; i < array.count; i++) {
//            blank += [array[i][@"time"] floatValue]*width/86400;
//            CGFloat h = [array[i][@"speed"] floatValue]*hight/120;
//            CGContextAddLineToPoint(currentContext, startX + blank, kNormalHight - h);
//            if (h > maxHight) {
//                maxHight = h;
//                maxX = startX+ blank;
//            }
//        }
//        CGContextAddLineToPoint(currentContext, endX, kNormalHight);
//        CGContextSetLineJoin(currentContext, kCGLineJoinMiter);
//        CGContextStrokePath(currentContext);
//        NSDictionary* topPointDic = @{@"hight":[NSString stringWithFormat:@"%f",maxHight],
//                                      @"x":[NSString stringWithFormat:@"%f",maxX]};
//        [_topArray addObject:topPointDic];
//        UIButton* lBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, kNormalHight - maxHight, endX - startX, maxHight)];
//        lBtn.tag = i;
//        [lBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:lBtn];
//    }
////    [self addSubview:_rightView];
////    [self addSubview:_leftView];
////    [self reloadMark];
//    
//}
-(void)btnClick:(UIButton*)sender{
    _temp = (int)sender.tag;
//    [self reloadMark];
}
-(void)animateStart{
    NSLog(@"速度动画开始");
}
@end
