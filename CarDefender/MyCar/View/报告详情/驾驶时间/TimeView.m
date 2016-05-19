//
//  TimeView.m
//  报告动画
//
//  Created by 李散 on 15/5/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "TimeView.h"
#import "Define.h"
#define kJiantou 5
#define kpercent 0.38
#define kJianMile 0.25
#define kLabelHeight 26

#define kDefine 0.2

#define kRightBSWeight 60
#define kXieLineX 15
@implementation TimeView

-(void)setNoData:(BOOL)noData
{
    NSLog(@"nodata");
    if (self.timeFirstIn) {
        _currentNoData=NO;
    }else
        _currentNoData=noData;
}
-(void)setTimeDic:(NSDictionary *)timeDic
{
    _rectArray=[NSMutableArray array];
    _colorArray=[NSMutableArray array];
    _currentDic=[NSDictionary dictionaryWithDictionary:timeDic];
    //创建历史时间按钮的点击事件
    CGFloat currentY=self.frame.size.height-self.frame.size.height*kJianMile;
    UIButton*allTimeBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, currentY-kLabelHeight, 60+20, self.frame.size.height*kJianMile)];
    [allTimeBtn setTitle:@"历史驾驶" forState:UIControlStateNormal];
    [self addSubview:allTimeBtn];
    allTimeBtn.tag=10;
    if (kSizeOfScreen.height<600) {
        allTimeBtn.titleLabel.font=kFontOfLetterSmall;
    }else
        allTimeBtn.titleLabel.font=kFontOfLetterMedium;
    [allTimeBtn addTarget:self action:@selector(moveBtnFrame:) forControlEvents:UIControlEventTouchUpInside];
    [_rectArray addObject:allTimeBtn];
    [_colorArray addObject:[UIColor grayColor]];
    
    
    //创建个时间段按钮的点击事件
    CGFloat weight=(self.frame.size.width-80-60)/4;
    CGFloat weightBtn =((5-1)*weight)/24/60/60;
    NSArray*timeArray=timeDic[@"list"];
    CGFloat firstTime=0;
    for (int i=0; i<timeArray.count; i++) {
        NSDictionary*dic=timeArray[i];
        CGFloat btnHeight=self.frame.size.height*kJianMile;
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(allTimeBtn.frame.origin.x+allTimeBtn.frame.size.width+[dic[@"start"] floatValue]*weightBtn, currentY-kLabelHeight, ([dic[@"end"] floatValue]-[dic[@"start"] floatValue])*weightBtn, btnHeight)];
        [_colorArray insertObject:kMainColor atIndex:_colorArray.count];
        btn.tag=i+11;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(moveBtnFrame:) forControlEvents:UIControlEventTouchUpInside];
        [_rectArray insertObject:btn atIndex:_rectArray.count];
        
        if (i==0) {
            firstTime=[dic[@"start"] floatValue];
            currentBtn=btn;
        }else{
            if (firstTime>[dic[@"start"] floatValue]) {
                firstTime=[dic[@"start"] floatValue];
                currentBtn=btn;
            }
        }
    }
    //默认第一段展示注释
    if (timeArray.count) {
        _bisoshiBool=YES;
        [self buildBianKuangViewWithRect:CGRectMake(currentBtn.frame.origin.x-2, currentBtn.frame.origin.y-2, currentBtn.frame.size.width+4, currentBtn.frame.size.height+4) withColor:kMainColor];
        oldTouchBtn=currentBtn;
        if (currentBtn.frame.origin.x<self.frame.size.width/2) {
            [self.delegate timeViewFirstBtnFrame:currentBtn.frame];
        }
    }
}
-(void)moveBtnFrame:(UIButton*)sender
{
    currentBtn=sender;
    UIColor* backColor;
    if (sender.tag!=10) {
        backColor=kMainColor;
        
    }else{
        backColor=kCOLOR(135, 135, 135);
    }
    if (oldTouchBtn) {
        _bisoshiBool=NO;
    }else
        _bisoshiBool=YES;
    [self setNeedsDisplay];
    if (oldTouchBtn) {//有触碰
        if (oldTouchBtn.tag!=10) {
        }
        if (_biankuangView) {
            [UIView animateWithDuration:kDefine animations:^{
                [self buildBianKuangViewWithRect:CGRectMake(sender.frame.origin.x-2, sender.frame.origin.y-2, sender.frame.size.width+4, sender.frame.size.height+4) withColor:backColor];
            }];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefine * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 _bisoshiBool=YES;
                [self setNeedsDisplay];
            });
        }
    }else{//没有触碰
        [self buildBianKuangViewWithRect:CGRectMake(sender.frame.origin.x-2, sender.frame.origin.y-2, sender.frame.size.width+4, sender.frame.size.height+4) withColor:backColor];
    }
    oldTouchBtn=sender;
}
-(void)buildBianKuangViewWithRect:(CGRect)rect withColor:(UIColor*)color
{
    if (_biankuangView==nil) {
        _biankuangView=[[UIView alloc]initWithFrame:rect];
        [self addSubview:_biankuangView];
    }else{
        _biankuangView.frame=rect;
    }
    _biankuangView.backgroundColor=[UIColor clearColor];
    _biankuangView.layer.borderColor = [color CGColor];
    _biankuangView.layer.masksToBounds = YES;
    _biankuangView.layer.cornerRadius = 2;
    _biankuangView.layer.borderWidth = 1;
    
}



-(void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    NSArray*array=@[@"开始记录",@"0时",@"6时",@"12时",@"18时",@"24时"];
    //获取绘图上下文
    //设置线宽
    CGFloat heightLine=rect.size.height*kJianMile;
    CGContextSetLineWidth(ctx, heightLine);
    
    CGFloat rColor;
    CGFloat gColor;
    CGFloat bColor;
    //没有数据时
    if (_currentNoData) {
        rColor = 132;
        gColor = 132;
        bColor = 132;
        CGContextSetLineWidth(ctx, 1.0);
        
        UILabel*noMsgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, (rect.size.height-kLabelHeight-heightLine)/2-10, kSizeOfScreen.width-20, 20)];
        noMsgLabel.text=@"暂无数据，请检测您的设备是否正常工作";
        noMsgLabel.textColor=[UIColor grayColor];
        
        if (kSizeOfScreen.height<600) {
            noMsgLabel.font=[UIFont boldSystemFontOfSize:14.0];
        }else
        noMsgLabel.font=[UIFont boldSystemFontOfSize:16.0];
        
        noMsgLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:noMsgLabel];
    }else{
        rColor=169;
        gColor=211;
        bColor=254;
    }
    
    CGContextSetRGBStrokeColor(ctx, rColor/255.0, gColor/255.0, bColor/255.0, 1);//kCOLOR(250, 197, 141)
    // 设置线条颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    //设置线宽
    CGContextSetLineWidth(ctx, 10);
    //设置填充颜色
    CGContextSetFillColorWithColor(ctx, [kCOLOR(rColor, gColor, bColor) CGColor]);
    //填充一个矩形
    CGContextFillRect(ctx, CGRectMake(20, rect.size.height-kLabelHeight-heightLine, rect.size.width-40, heightLine));

    if (_bisoshiBool) {
        [self drawTotalMieWithBtn:currentBtn];
    }
    
    //汇出框颜色
    for (int i=0; i<_rectArray.count; i++) {
        UIButton*btn=_rectArray[i];
        // 设置线条颜色
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        //设置线宽
        CGContextSetLineWidth(ctx, 10);
        //设置填充颜色
        CGContextSetFillColorWithColor(ctx, [_colorArray[i] CGColor]);
        //填充一个矩形
        CGContextFillRect(ctx, btn.frame);
    }
    
    if (!_btnTouch) {
        //设置时间段
        CGFloat weight=(rect.size.width-80-60)/4;
        for (int i=0; i<array.count; i++) {
            _btnTouch=YES;
            UILabel*label;
            if (i==0) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(40-30, rect.size.height-kLabelHeight, 60, kLabelHeight/2)];
                if (!_currentNoData) {
                    UILabel*begainLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height-kLabelHeight/2, 80, kLabelHeight/2)];
                    begainLabel.textColor=[UIColor grayColor];
                    begainLabel.text=_currentDic[@"recordDate"];
                    begainLabel.textAlignment=NSTextAlignmentCenter;
                    [self addSubview:begainLabel];
                    if (kSizeOfScreen.height<600) {
                        begainLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
                    }else
                        begainLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
                }               
            }else
                label=[[UILabel alloc]initWithFrame:CGRectMake(40+60+(i-1)*weight-30, rect.size.height-kLabelHeight, 60, kLabelHeight/2)];
            
            label.text=array[i];
            label.textColor=[UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            [self addSubview:label];
            CGFloat fontFloat;
            if (kSizeOfScreen.height<600) {
                fontFloat=10;
            }else
                fontFloat=12;
            label.font=[UIFont fontWithName:@"Helvetica Neue" size:fontFloat];
        }
    }
}
-(void)drawTotalMieWithBtn:(UIButton*)btn
{
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    CGRect btnFrame=btn.frame;
    //NO.6椭圆
    CGFloat leftPoint;
    CGFloat rightPoint;
    CGFloat rColor;
    CGFloat gColor;
    CGFloat yColor;
    if (btn.tag==10) {
        rColor = 124;
        gColor = 124;
        yColor = 124;
        rightPoint =btnFrame.origin.x+btnFrame.size.width*2/3;
        leftPoint=0;
    }else{
        rColor = 60;
        gColor = 152;
        yColor = 247;
        rightPoint =btnFrame.origin.x+btnFrame.size.width;
        leftPoint =btnFrame.origin.x-2;
    }
    //右标示
    CGRect aRect= CGRectMake(rightPoint, btnFrame.origin.y-4, 2, 2);
    CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddEllipseInRect(ctx, aRect); //椭圆
    CGContextDrawPath(ctx, kCGPathStroke);
    //左标示
    CGRect aRect1;
    if(leftPoint){
        aRect1= CGRectMake(leftPoint, btnFrame.origin.y-4, 2, 2);
        CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
        CGContextSetLineWidth(ctx, 2);
        CGContextAddEllipseInRect(ctx, aRect1); //椭圆
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    //右标示斜线
    //斜线
    //定义4个点，绘制线段
    CGFloat fl1=0;
    CGContextSetLineWidth(ctx, 1);
    const CGPoint points1[] = {
        CGPointMake(aRect.origin.x+kJiantou/4, aRect.origin.y+kJiantou/4),
        CGPointMake(aRect.origin.x+fl1+10,aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2),
        CGPointMake(aRect.origin.x+fl1+10, aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2),
        CGPointMake(aRect.origin.x+fl1+10+kRightBSWeight, aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2)
    };
    //绘制线段（默认不绘制端点）
    CGContextStrokeLineSegments(ctx, points1, 4);
    //设置短短的端点形状：方向端点
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    
    NSArray*currentArray=_currentDic[@"list"];
    if (btn.tag==10) {
        //写字
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBFillColor (ctx, 0.5, 0.5, 0.5, 0.5);
        UIFont  *font = [UIFont boldSystemFontOfSize:12];
        [[NSString stringWithFormat:@"%@",[self stringWihtTime:_currentDic[@"minute"] withBool:1]] drawInRect:CGRectMake(aRect.origin.x+fl1+10, aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2 -15, 65, 15) withFont:font];
    }else{
        //写字
        fl1=0;
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBFillColor (ctx, 60/255.0, 152/255.0, 247/255.0, 1);
        UIFont  *font = [UIFont boldSystemFontOfSize:12];
        NSString*stringStart=[NSString stringWithFormat:@"起:%@",[self stringWihtTime:currentArray[btn.tag -11][@"start"] withBool:0]];
        [stringStart drawInRect:CGRectMake(aRect.origin.x+fl1+10, aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2 -15, 65, 15) withFont:font];
        //写字
        NSString*stringStop=[NSString stringWithFormat:@"止:%@",[self stringWihtTime:currentArray[btn.tag -11][@"end"] withBool:0]];
        [stringStop drawInRect:CGRectMake(aRect.origin.x+fl1+10, aRect.origin.y+fl1-(self.frame.size.height*0.33-kJiantou)/2 , 65, 15) withFont:font];
    }
    //左标示斜线
    if (leftPoint) {
        
        CGFloat fl1=0;
        CGContextSetLineWidth(ctx, 1);
        CGContextSetRGBStrokeColor(ctx, rColor/255, gColor/255, yColor/255, 1.0);
        
        CGFloat originY=(self.frame.size.height*0.33-kJiantou)/2;
        
        const CGPoint points1[] = {
            CGPointMake(aRect1.origin.x+kJiantou/4, aRect.origin.y+fl1),
            CGPointMake(aRect1.origin.x+fl1-10,aRect1.origin.y+fl1-originY),
            CGPointMake(aRect1.origin.x+fl1-10, aRect1.origin.y+fl1-originY),
            CGPointMake(aRect1.origin.x+fl1-10-kRightBSWeight*0.75, aRect1.origin.y+fl1-originY)
        };
        //绘制线段（默认不绘制端点）
        CGContextStrokeLineSegments(ctx, points1, 4);
        //设置短短的端点形状：方向端点
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        
        //写字
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBFillColor (ctx, 60/255.0, 152/255.0, 247/255.0, 1);
        UIFont  *font = [UIFont boldSystemFontOfSize:12.0];
        NSString*lenghtString=[NSString stringWithFormat:@"%@",[self stringWihtTime:currentArray[btn.tag -11][@"feetime"] withBool:1]];
        [lenghtString drawInRect:CGRectMake(aRect1.origin.x+fl1-10-50, aRect1.origin.y+fl1-originY - kLabelHeight/2-3, 65, kLabelHeight/2) withFont:font];
    }
}
-(NSString*)stringWihtTime:(NSString*)timeString withBool:(BOOL)timeBool
{
    NSString*string;
    if (timeBool) {
        string=[NSString stringWithFormat:@"%d小时%d分",(int)[timeString integerValue]/60,(int)[timeString integerValue]%60];
    }else
    string=[NSString stringWithFormat:@"%d时%d分",(int)[timeString integerValue]/3600,(int)[timeString integerValue]%3600/60];
    MyLog(@"%@-%@",string,timeString);
    return string;
}

@end
