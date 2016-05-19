//
//  GroundView.m
//  报告动画
//
//  Created by 周子涵 on 15/5/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "GroundView.h"
#define kRidel 118
#define kFrameWidth self.frame.size.width
#define KSmallRadius 50
#define kInterval 40

@implementation GroundView
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray*)dataArray cost:(NSString*)cost
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        //        self.dataArray = dataArray;
        self.subViewList = [NSMutableArray array];
        self.subViewList2 = [NSMutableArray array];
        //
        //        //设置背景图片按钮
        _groundImageView = [self creatGroundImageView:CGPointMake(kFrameWidth/2, kFrameWidth/ 2)];
        [self addSubview:_groundImageView];
        
        _groundImageView2 = [self creatGroundImageView:CGPointMake(kSizeOfScreen.width + kFrameWidth/2, kFrameWidth/ 2)];
        [self addSubview:_groundImageView2];
        
        //设置费用按钮
        _costView1 = [[ChildView alloc] initWithFrame:CGRectMake(0 , 0 , kInterval, kInterval) cost:cost];
        _costView1.center = CGPointMake(kFrameWidth/2, kFrameWidth/2);
        [self addSubview:_costView1];
        
        _costView2 = [[ChildView alloc] initWithFrame:CGRectMake(0 , 0 , kInterval, kInterval) cost:cost];
        _costView2.center = CGPointMake(kSizeOfScreen.width + kFrameWidth/2 , kFrameWidth/2);
        _costView2.nameLabel.hidden = YES;
        _costView2.dataLabel.hidden = YES;
        [self addSubview:_costView2];
        //
        //        //设置油耗量、百公里油耗、驾驶时间、总里程、平均速度
        int temp = 72;
        for (int i = 0; i<5; i++) {
            CGPoint point1 = CGPointMake(kFrameWidth/2 + kRidel*(sin(i*temp*M_PI/180)), kFrameWidth/2 - kRidel*cos(i*temp*M_PI/180) + kInterval/2);
            
            ChildView* childView = [[ChildView alloc] initWithFrame:CGRectMake(0 , 0 , KSmallRadius + kInterval, KSmallRadius + kInterval) Dictionary:dataArray[i]];
            childView.currentRadian = i*temp;
            childView.temp = i;
            childView.center = point1;
            childView.currentCenter = point1;
            childView.backgroundColor = [UIColor clearColor];
            [self.subViewList addObject:childView];
            
            CGPoint point2 = CGPointMake(kSizeOfScreen.width + kFrameWidth/2 + kRidel*(sin(i*temp*M_PI/180)), kFrameWidth/2);
            
            ChildView* childView2 = [[ChildView alloc] initWithFrame:CGRectMake(0 , 0 , KSmallRadius + kInterval, KSmallRadius + kInterval) Dictionary:dataArray[i]];
            childView2.nameLabel.hidden = YES;
            childView2.dataLabel.hidden = YES;
            childView2.currentRadian = i*temp;
            childView2.temp = i;
            childView2.center = point2;
            childView2.currentCenter = point2;
            childView2.backgroundColor = [UIColor clearColor];
            [self.subViewList2 addObject:childView2];
        }
        for (int i = 0; i < 5; i++) {
            ChildView* childView1 = self.subViewList[i];
            ChildView* childView2 = self.subViewList2[i];
            [self addSubview:childView1];
            [self addSubview:childView2];
        }
    }
    return self;
}

#pragma mark - 刷新数据
-(void)reloadData:(NSArray*)array{
    for (int i = 0; i < array.count; i++) {
        ChildView* childView = self.subViewList[i];
        [childView reloadData:array[i]];
    }
}

#pragma mark - 创建背景图片
-(UIImageView*)creatGroundImageView:(CGPoint)point{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kRidel*2, kRidel*2)];
    imageView.center = point;
    imageView.image = [UIImage imageNamed:@"baogao_yuan"];
    return imageView;
}

#pragma mark - UITouches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _move = NO;
    _rotate = NO;
    
    _beginPoint = [[[event allTouches] anyObject] locationInView:self];
    for (ChildView* childView in self.subViewList) {
        if (_beginPoint.x >= childView.frame.origin.x && _beginPoint.x<= childView.frame.origin.x + childView.frame.size.width && _beginPoint.y >= childView.frame.origin.y && _beginPoint.y <= childView.frame.origin.y + childView.frame.size.height) {
            _childView = childView;
            _rotate = YES;
        }
    }
}
#pragma mark - 触摸过程代理方法
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _move = YES;
    _endPoint = [[[event allTouches] anyObject] locationInView:self];
    if (_rotate) {
        CGFloat angleInDegrees = [self getAngleInDegreesStartPoint:kFrameWidth/2 endPoint:_endPoint] - _childView.temp*72;
        MyLog(@"%f",angleInDegrees);
        for (int i = 0; i<5; i++) {
            ChildView* childView = self.subViewList[i];
            CGFloat radius = angleInDegrees  + i *72;
            [self setChildViewRadius:radius view:childView Anmation:NO hidden:YES];
        }
    }else{
        if (_endPoint.x - _beginPoint.x > 0) {
            _left = NO;
        }else{
            _left = YES;
        }
        CGFloat change = _endPoint.x - _beginPoint.x;
        CGPoint point = _groundImageView.center;
        point.x = kFrameWidth/2 + change;
        [_groundImageView setFrame:CGRectMake(0, 0, kRidel*2 - [self getCurrent:change Ridel:kRidel*2], kRidel*2 - [self getCurrent:change Ridel:kRidel*2])];
        _groundImageView.center = point;
        _costView1.center = point;
        
        CGPoint point2 = _groundImageView2.center;
        if (_left) {
            point2.x = kFrameWidth  + kRidel + change;
        }else{
            point2.x = change - kRidel;
        }
        [_groundImageView2 setFrame:CGRectMake(0, 0, [self getCurrent:change Ridel:kRidel*2], [self getCurrent:change Ridel:kRidel*2])];
        if (_groundImageView2.hidden) {
            _groundImageView2.hidden =  NO;
        }
        _groundImageView2.center = point2;
        if (_costView2.hidden) {
            _costView2.hidden = NO;
        }
        _costView2.center = point2;
        
        for (int i=0; i<5; i++) {
            
            ChildView* childView = self.subViewList[i];
            childView.dataLabel.hidden = YES;
            childView.nameLabel.hidden = YES;
            _costView1.dataLabel.hidden = YES;
            _costView1.nameLabel.hidden = YES;
            childView.center = [self getRadiuspoint:point Radius:childView.currentRadian Ridel:kRidel - [self getCurrent:change Ridel:kRidel]];
            
            ChildView* childView2 = self.subViewList2[i];
            if (childView2.hidden) {
                childView2.hidden = NO;
            }
            childView2.center = [self getRadiuspoint:point2 Radius:childView.currentRadian Ridel:[self getCurrent:change Ridel:kRidel]];
        }
        
    }
}
#pragma mark - 触摸结束的时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _endPoint = [[[event allTouches] anyObject] locationInView:self];
    if (_move) {//移动结束
        if (_rotate) {//旋转结束
            CGFloat angleInDegrees = [self getAngleInDegreesStartPoint:kFrameWidth/2 endPoint:_endPoint] - _childView.temp*72;
            if (((int)angleInDegrees + 360)%72 > 36) {
                angleInDegrees += 72 - ((int)angleInDegrees + 360)%72;
            }else{
                angleInDegrees -= ((int)angleInDegrees + 360)%72;
            }
            for (int i = 0; i<5; i++) {
                ChildView* childView = self.subViewList[i];
                CGFloat radius = angleInDegrees +  i *72;
                childView.currentRadian = radius;
                [self setChildViewRadius:radius view:childView Anmation:YES hidden:NO];
            }
        }else{//左右移动
            if (_left) {//左滑
                if (_beginPoint.x - _endPoint.x >= kRidel) {
                    [self animateStartX:-kFrameWidth/2 stopX:kFrameWidth/2 go:YES];
                    [self childViewAnimateStopX:-kFrameWidth/2 go:YES];
                    [self.delegate animateFinish:YES];
                }else{
                    [self animateStartX:kFrameWidth/2 stopX:kFrameWidth*3/2 go:NO];
                    [self childViewAnimateStopX:kFrameWidth*3/2 go:NO];
                }
            }else{//右滑
                if (_endPoint.x - _beginPoint.x >= kRidel) {
                    [self animateStartX:kFrameWidth*3/2 stopX:kFrameWidth/2 go:YES];
                    [self childViewAnimateStopX:kFrameWidth*3/2 go:YES];
                    [self.delegate animateFinish:NO];
                }else{
                    [self animateStartX:kFrameWidth/2 stopX:-kFrameWidth/2 go:NO];
                    [self childViewAnimateStopX:-kFrameWidth/2 go:NO];
                }
            }
            _costView1.dataLabel.hidden = NO;
            _costView1.nameLabel.hidden = NO;
            
        }
    }else{//点击结束
        if (_rotate) {
            [self.delegate iconClick:[NSString stringWithFormat:@"%i",_childView.temp]];
            return;
        }
        if (_endPoint.x >= kFrameWidth/2 - kInterval/2 && _endPoint.x <= kFrameWidth/2 + kInterval/2 && _endPoint.y >= kFrameWidth/2 - kInterval/2 && _endPoint.y <= kFrameWidth/2 + kInterval/2) {
            [self.delegate iconClick:@"5"];
        }
    }
    
}
#pragma mark - 按钮结束动画
-(void)childViewAnimateStopX:(CGFloat)stopX go:(BOOL)go{
    for (int i=0; i<5; i++) {
        ChildView* childView = self.subViewList[i];
        ChildView* childView2 = self.subViewList2[i];
        CGPoint endCenter = CGPointMake(stopX, kFrameWidth/2);
        [UIView animateWithDuration:0.4 animations:^{
            if (go) {
                childView.center = endCenter;
                childView2.center = childView.currentCenter;
            }else{
                childView.center = childView.currentCenter;
                childView2.center = endCenter;
            }
        } completion:^(BOOL finished) {
            childView.center = childView.currentCenter;
            childView.dataLabel.hidden = NO;
            childView.nameLabel.hidden = NO;
            childView2.center = endCenter;
        }];
    }
}
#pragma mark - 背景结束动画
-(void)animateStartX:(CGFloat)startX stopX:(CGFloat)stopX go:(BOOL)go{
    [UIView animateWithDuration:0.4 animations:^{
        CGPoint point = _groundImageView.center;
        CGPoint point2 = _groundImageView2.center;
        point.x = startX;
        point2.x = stopX;
        if (go) {
            [_groundImageView setFrame:CGRectMake(0, 0, 0, 0)];
            [_groundImageView2 setFrame:CGRectMake(0, 0, kRidel*2, kRidel*2)];
        }else{
            [_groundImageView setFrame:CGRectMake(0, 0, kRidel*2, kRidel*2)];
            [_groundImageView2 setFrame:CGRectMake(0, 0, 0, 0)];
        }
        _groundImageView.center = point;
        _costView1.center = point;
        _groundImageView2.center = point2;
        _costView2.center = point2;
    } completion:^(BOOL finished) {
        [_groundImageView setFrame:CGRectMake(0, 0, kRidel*2, kRidel*2)];
        [_groundImageView2 setFrame:CGRectMake(0, 0, 0, 0)];
        CGPoint point = CGPointMake(kFrameWidth/2, kFrameWidth/2);
        CGPoint point2 = CGPointMake(-kFrameWidth/2, kFrameWidth/2);
        _groundImageView.center = point;
        _costView1.center = point;
        _groundImageView2.center = point2;
        _costView2.center = point2;
    }];
    
}
#pragma mark - 获取改变状态半径
-(CGFloat)getCurrent:(CGFloat)change Angle:(CGFloat)angle{
    CGFloat ridel;
    if (change > 0) {
        if (change <= kSizeOfScreen.width/2) {
            ridel = 360 * change / (kSizeOfScreen.width/2);
        }else{
            ridel = 360;
        }
    }else{
        if (-change <= kSizeOfScreen.width/2) {
            ridel = 360 * change / (kSizeOfScreen.width/2);
        }else{
            ridel = -360;
        }
    }
    return ridel;
}
#pragma mark - 获取改变状态半径
-(CGFloat)getCurrent:(CGFloat)change Ridel:(CGFloat)lRidel{
    CGFloat ridel;
    if (change > 0) {
        if (change <= kSizeOfScreen.width/2) {
            ridel = lRidel * change / (kSizeOfScreen.width/2);
        }else{
            ridel = lRidel;
        }
    }else{
        if (-change <= kSizeOfScreen.width/2) {
            ridel = -lRidel * change / (kSizeOfScreen.width/2);
        }else{
            ridel = lRidel;
        }
    }
    return ridel;
}
#pragma mark - 获取当前坐标位置
-(CGPoint)getRadiuspoint:(CGPoint)currentPoint Radius:(CGFloat)radius Ridel:(CGFloat)ridel{
    CGPoint point = CGPointMake(currentPoint.x + ridel*(sin(radius*M_PI/180)), currentPoint.y - ridel*cos(radius*M_PI/180)  + kInterval/2);
    return point;
}
#pragma mark - 获取旋转角度
-(CGFloat)getAngleInDegreesStartPoint:(CGFloat)radius endPoint:(CGPoint)lEndPoint{
    CGFloat deltaY = radius - lEndPoint.y;
    CGFloat deltaX = radius - lEndPoint.x;
    CGFloat angleInDegrees = [self normalizeAngle:(atan2f(deltaY, deltaX) * 180 / M_PI - 90)];
    return angleInDegrees;
}
#pragma mark - 获取旋转位置
-(void)setChildViewRadius:(CGFloat)radius view:(ChildView*)view Anmation:(BOOL)anmation hidden:(BOOL)hidden{
    
    CGFloat animateTime = 0.4;
    CGPoint point = CGPointMake(self.frame.size.width/2 + kRidel*(sin(radius*M_PI/180)), self.frame.size.width/2 - kRidel*cos(radius*M_PI/180)  + kInterval/2);
    if (anmation) {
        [UIView animateWithDuration:animateTime animations:^{
            view.center = point;
            view.currentCenter = point;
        } completion:^(BOOL finished) {
            view.nameLabel.hidden = hidden;
            view.dataLabel.hidden = hidden;
        }];
    }else{
        view.center = point;
        view.nameLabel.hidden = hidden;
        view.dataLabel.hidden = hidden;
    }
    
}
#pragma mark - 刷新数据
-(void)reloadData:(NSArray*)array cost:(NSString*)cost{
    for (int i = 0; i < array.count; i++) {
        NSDictionary* dic = array[i];
        ChildView* childView = self.subViewList[i];
        childView.dataLabel.hidden = NO;
        childView.nameLabel.hidden = NO;
        [childView reloadData:dic];
    }
    _costView1.dataLabel.hidden = NO;
    _costView1.nameLabel.hidden = NO;
    [_costView1 reloadData:@{@"data":cost}];
}
#pragma mark - 默认旋转角度
- (CGFloat)normalizeAngle:(CGFloat)angle {
    CGFloat normalizedAngle = (int)angle % 360;
    if (normalizedAngle < 0) {
        normalizedAngle = 360 + normalizedAngle;
    }
    return normalizedAngle;
}

@end
