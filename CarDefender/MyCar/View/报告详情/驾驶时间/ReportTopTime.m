
//
//  ReportTopTime.m
//  CarDefender
//
//  Created by 李散 on 15/5/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportTopTime.h"
#import "Define.h"
#define kLabelHeight 22
#define kLabelWeiht 30
#define kRiderWH 2

#define kBiaozPercent 0.25
@implementation ReportTopTime
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pointArray=[NSMutableArray array];
        whichType=0;
        _allBool=YES;
        _currentChooseDic=nil;
    }
    return self;
}

-(void)setTopDicMsg:(NSDictionary *)topDicMsg
{
    _reportDic=topDicMsg;
    whichType=1;
    _allBool=YES;
    _currentChooseDic=nil;
//    self.pointArray
    [self setNeedsDisplay];
}

-(void)allBtnTouchDownWithPointArray:(NSArray*)array
{
    MyLog(@"点击了全部按钮");
    _allBool=YES;
    _currentChooseDic=nil;
    //    [self.pointArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",centerX]];
    self.pointArray = [NSMutableArray arrayWithArray:array];
    [self setNeedsDisplay];
}
-(void)timeCellSelect:(NSDictionary*)dic withPointArray:(NSArray*)array
{
    _allBool=NO;
    MyLog(@"timeCell点击了 - \n%@",dic);
    _currentChooseDic=nil;
    self.pointArray = [NSMutableArray arrayWithArray:array];
    [self setNeedsDisplay];
    
}
-(void)timeCellAfterLoginMsg:(NSDictionary *)chooseDic
{
    _allBool=NO;
    _currentChooseDic=chooseDic;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    // 获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!whichType) {
        return;
    }
    // 设置线条宽度
    CGContextSetLineWidth(ctx, 1);
    // 设置线条颜色
    CGContextSetStrokeColorWithColor(ctx, kCOLOR(169, 211, 254).CGColor);
    // 设置线条连接点的形状
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    // 绘制一个矩形边框
    CGFloat linHeight=rect.size.height*kBiaozPercent;
    CGFloat originYT=rect.size.height*(1-kBiaozPercent)-1;
    CGContextStrokeRect(ctx , CGRectMake(20 , originYT, rect.size.width-40 , linHeight));
    
    if (self.pointArray.count==6) {
        //绘制历史驾驶
        CGFloat weight=[self.pointArray[1] floatValue]/2-[self.pointArray[0] floatValue]/2;
        // 绘制一个矩形边框
        CGFloat linHeight=rect.size.height*kBiaozPercent;
        CGRect frameSize=CGRectMake(20, originYT, weight, linHeight);
        CGContextStrokeRect(ctx , frameSize);
        // 设置填充颜色
        CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
        CGContextFillRect(ctx , CGRectMake(20 , originYT, weight , linHeight));
        
        [self drawAllBtnFrame:frameSize];
    }

    CGFloat weightBtn;
    if (self.pointArray.count==6) {
        weightBtn =([self.pointArray[self.pointArray.count-1] floatValue] - [self.pointArray[1] floatValue])/24/60/60;
    }else{
        weightBtn =([self.pointArray[self.pointArray.count-1] floatValue] - [self.pointArray[0] floatValue])/24/60/60;
    }
    NSArray*arrayMsg=_reportDic[@"list"];
    CGRect chooseFrame;
    NSDictionary*chooseDic;
    
    for (int i=(int)([arrayMsg count]-1); i<[arrayMsg count]; i--) {
        
        NSDictionary*dic=arrayMsg[i];

        CGFloat weightFloat=([dic[@"end"] floatValue]-[dic[@"start"] floatValue])*weightBtn;
        CGFloat origX;
        if (self.pointArray.count==6) {
            origX=[self.pointArray[1] floatValue]+[dic[@"start"] floatValue]*weightBtn;
        }else{
            origX=[self.pointArray[0] floatValue]+[dic[@"start"] floatValue]*weightBtn;
        }
        CGRect frame = CGRectMake(origX, originYT, weightFloat, linHeight);
        // 设置填充颜色
        UIColor*kColor;
        if (_currentChooseDic!=nil&&[dic isEqual:_currentChooseDic]) {
            kColor=kMainColor;
            chooseFrame=frame;
            chooseDic=dic;
        }else
            kColor=kCOLOR(169, 211, 254);
        CGContextSetFillColorWithColor(ctx, kColor.CGColor);
        // 填充一个矩形
        CGContextFillRect(ctx , frame);
    }
    //画标注
    if (chooseFrame.size.height) {
        [self drawTotalMieWithFrame:chooseFrame withDicMsg:chooseDic];
    }
}
-(void)drawAllBtnFrame:(CGRect)frameCurrent
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CGRect btnFrame=frameCurrent;
    
    CGFloat rightPoint;
    CGFloat rColor;
    CGFloat gColor;
    CGFloat yColor;
    rColor = 124;
    gColor = 124;
    yColor = 124;
    CGFloat distance=(btnFrame.size.width-kRiderWH)/3;
    rightPoint=btnFrame.origin.x+btnFrame.size.width-kRiderWH/2-distance;
    //右标示
    CGRect aRect= CGRectMake(rightPoint, btnFrame.origin.y-kRiderWH*2, kRiderWH, kRiderWH);
    CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
    CGContextSetLineWidth(ctx, kRiderWH);
    CGContextAddEllipseInRect(ctx, aRect); //椭圆
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //右标示斜线
    //斜线
    //定义4个点，绘制线段
    //计算字体长度确定标注长度
    NSString*startTime=[NSString stringWithFormat:@"%@",[self stringWithTotalTime:_reportDic[@"minute"]]];
    
    CGSize ziSize = [self takeTheSizeOfString:startTime withFont:[UIFont boldSystemFontOfSize:12]];
    CGContextSetLineWidth(ctx, 1);
    const CGPoint pointsR[] = {
        CGPointMake(aRect.origin.x+kRiderWH/2, aRect.origin.y+kRiderWH/2),
        CGPointMake(aRect.origin.x+kRiderWH/2+10,aRect.origin.y-(self.frame.size.height*kBiaozPercent)/2),
        CGPointMake(aRect.origin.x+kRiderWH/2+10,aRect.origin.y-(self.frame.size.height*kBiaozPercent)/2),
        CGPointMake(aRect.origin.x+kRiderWH/2+10+ziSize.width, aRect.origin.y-(self.frame.size.height*kBiaozPercent)/2)
    };
    //绘制线段（默认不绘制端点）
    CGContextStrokeLineSegments(ctx, pointsR, 4);
    //设置短短的端点形状：方向端点
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    
    //写字
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBFillColor (ctx, 124/255.0, 124/255.0, 124/255.0, 1);
    UIFont  *font = [UIFont boldSystemFontOfSize:12];
    [startTime drawInRect:CGRectMake(aRect.origin.x+kRiderWH/2+10, aRect.origin.y-(self.frame.size.height*kBiaozPercent)/2 -ziSize.height, ziSize.width, ziSize.height) withFont:font];
    
}
-(void)drawTotalMieWithFrame:(CGRect)frameCurrent withDicMsg:(NSDictionary*)dicMsg
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CGRect btnFrame=frameCurrent;
    
    CGFloat leftPoint;
    CGFloat rightPoint;
    CGFloat rColor;
    CGFloat gColor;
    CGFloat yColor;
    rColor = 60;
    gColor = 152;
    yColor = 247;
    if (btnFrame.size.width<4) {
        rightPoint=btnFrame.origin.x+btnFrame.size.width/2-kRiderWH/2;
        leftPoint=btnFrame.origin.x+btnFrame.size.width/2-kRiderWH/2;
    }else{
        CGFloat distance=btnFrame.size.width/3;
        leftPoint=btnFrame.origin.x+distance-kRiderWH;
        rightPoint=btnFrame.origin.x+btnFrame.size.width-distance;
    }
    //右标示
    CGRect aRect= CGRectMake(rightPoint, btnFrame.origin.y-kRiderWH*2, kRiderWH, kRiderWH);
    CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
    CGContextSetLineWidth(ctx, kRiderWH);
    CGContextAddEllipseInRect(ctx, aRect); //椭圆
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //左标示
    CGRect aRect1;
    aRect1= CGRectMake(leftPoint, btnFrame.origin.y-kRiderWH*2, kRiderWH, kRiderWH);
    CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
    CGContextSetLineWidth(ctx, kRiderWH);
    CGContextAddEllipseInRect(ctx, aRect1); //椭圆
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //右标示斜线
    //斜线
    //定义4个点，绘制线段
    //计算字体长度确定标注长度
    NSString*startTime=[self stringWihtTime:dicMsg[@"start"] withHour:@"时" withMin:@"分"];
    startTime=[NSString stringWithFormat:@"起:%@",startTime];
    
    NSString*endTime=[self stringWihtTime:dicMsg[@"end"] withHour:@"时" withMin:@"分"];
    endTime=[NSString stringWithFormat:@"止:%@",endTime];
    
    CGSize ziSize = [self takeTheSizeOfString:startTime withFont:[UIFont boldSystemFontOfSize:12]];
    
    CGFloat rightOriginX=aRect.origin.x+kRiderWH/2+10+ziSize.width;
    CGFloat wordsWidth;
    CGFloat wordsX;
    CGFloat wordsHeight;
    if (rightOriginX>self.frame.size.width) {
        
        wordsWidth=rightOriginX-2*ziSize.width;
        wordsX=wordsWidth;
        wordsHeight=aRect.origin.y-(self.frame.size.height*kBiaozPercent)*3/2;
    }else{
        wordsWidth=rightOriginX;
        wordsX=aRect.origin.x+kRiderWH/2+10;
        wordsHeight=aRect.origin.y-(self.frame.size.height*kBiaozPercent)/2;
    }
    CGContextSetLineWidth(ctx, 1);
    const CGPoint pointsR[] = {
        CGPointMake(aRect.origin.x+kRiderWH/2, aRect.origin.y+kRiderWH/2),
        CGPointMake(aRect.origin.x+kRiderWH/2+10,wordsHeight),
        CGPointMake(aRect.origin.x+kRiderWH/2+10,wordsHeight),
        CGPointMake(wordsWidth, wordsHeight)
    };
    CGPoint pointRightOrigin=CGPointMake(aRect.origin.x+kRiderWH/2+10, wordsHeight);

    
    //绘制线段（默认不绘制端点）
    CGContextStrokeLineSegments(ctx, pointsR, 4);
    //设置短短的端点形状：方向端点
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    
    //写字v
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBFillColor (ctx, 60/255.0, 152/255.0, 247/255.0, 1);
    UIFont  *font = [UIFont boldSystemFontOfSize:12];
    [startTime drawInRect:CGRectMake(wordsX, wordsHeight-ziSize.height, ziSize.width, ziSize.height) withFont:font];
    //写字
    [endTime drawInRect:CGRectMake(wordsX, wordsHeight , ziSize.width, ziSize.height) withFont:font];
    
    //左标示斜线
    //当前里程数
    NSString*currentMileage=dicMsg[@"driverMile"];
    currentMileage=[NSString stringWithFormat:@"%@",[self stringWithTotalTime:dicMsg[@"feetime"]]];
    CGSize milSize=[self takeTheSizeOfString:[self stringWithTotalTime:dicMsg[@"feetime"]] withFont:[UIFont boldSystemFontOfSize:12.0]];
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
    CGFloat checkX=aRect1.origin.x+kRiderWH/2-10-milSize.width;
    
    if (checkX>0) {
        const CGPoint pointsL[] = {
            CGPointMake(aRect1.origin.x+kRiderWH/2, aRect1.origin.y+kRiderWH/2),
            CGPointMake(aRect1.origin.x+kRiderWH/2-10,aRect1.origin.y-(self.frame.size.height*kBiaozPercent)/2),
            CGPointMake(aRect1.origin.x+kRiderWH/2-10,aRect1.origin.y-(self.frame.size.height*kBiaozPercent)/2),
            CGPointMake(aRect1.origin.x+kRiderWH/2-10-milSize.width, aRect1.origin.y-(self.frame.size.height*kBiaozPercent)/2)
        };
        //绘制线段（默认不绘制端点）
        CGContextStrokeLineSegments(ctx, pointsL, 4);
        //设置短短的端点形状：方向端点
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        
        //写字
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBFillColor (ctx, 60/255.0, 152/255.0, 247/255.0, 1);
        UIFont  *fontL = [UIFont boldSystemFontOfSize:12.0];
        [currentMileage drawInRect:CGRectMake(aRect1.origin.x+kRiderWH/2-10-milSize.width, aRect1.origin.y-(self.frame.size.height*kBiaozPercent)/2-milSize.height, milSize.width, milSize.height) withFont:fontL];
    }else{
        const CGPoint pointsL[] = {
            CGPointMake(aRect1.origin.x+kRiderWH/2, aRect1.origin.y+kRiderWH/2),
            CGPointMake(pointRightOrigin.x,pointRightOrigin.y-2*ziSize.height),
            CGPointMake(pointRightOrigin.x,pointRightOrigin.y-2*ziSize.height),
            CGPointMake(pointRightOrigin.x+milSize.width, pointRightOrigin.y-2*ziSize.height)
        };
        //绘制线段（默认不绘制端点）
        CGContextStrokeLineSegments(ctx, pointsL, 4);
        //设置短短的端点形状：方向端点
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        
        //写字
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBFillColor (ctx, 60/255.0, 152/255.0, 247/255.0, 1);
        UIFont  *fontL = [UIFont boldSystemFontOfSize:12.0];
        [currentMileage drawInRect:CGRectMake(pointRightOrigin.x, pointRightOrigin.y-2*ziSize.height-milSize.height, milSize.width, milSize.height) withFont:fontL];
    }
    
}
-(NSString*)stringWithTotalTime:(NSString*)string
{
    MyLog(@"%@",string);
    NSString*timeString;
    int hour1 = (int)[string integerValue]/60;
    int min1 = (int)[string integerValue]%60;
    if (hour1>0) {
        timeString=[NSString stringWithFormat:@"%d小时%d分",hour1,min1];
    }else
        timeString=[NSString stringWithFormat:@"%d分钟",min1];
    
    return timeString;
}
-(NSString*)stringWihtTime:(NSString*)timeString withHour:(NSString*)hour withMin:(NSString*)min
{
    NSString*string;
    int hour1 = (int)[timeString integerValue]/3600;
    int min1 = (int)[timeString integerValue]%3600/60;
    NSString* hourString;
    if (hour1<10) {
        hourString=[NSString stringWithFormat:@"0%d",hour1];
    }else
        hourString=[NSString stringWithFormat:@"%d",hour1];
    
    NSString*minString;
    if (min1<10) {
        minString=[NSString stringWithFormat:@"0%d",min1];
    }else
        minString=[NSString stringWithFormat:@"%d",min1];
    string=[NSString stringWithFormat:@"%@%@%@%@",hourString,hour,minString,min];
    return string;
}
-(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font{
    CGSize stringOfSize=[string boundingRectWithSize:CGSizeMake(275, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return stringOfSize;
}

@end
