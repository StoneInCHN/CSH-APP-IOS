//
//  DetectingView.m
//  yijianjiance
//
//  Created by 周子涵 on 15/6/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DetectingView.h"

static const int BOTTOM_HEIGHT = 60;
static const int CAR_IMAGE_WIDTH = 261;
static const CGFloat CAR_ANIMATION_TIME = 0.3;
static const CGFloat ANIMATION_TIME = 0.4;
static const CGFloat TIMER_TIME = 0.01;

@implementation DetectingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _intervalTime = 0;
        [self creatCarImageView];
        [self creatCoverView];
        [self creatGroundImageView];
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_TIME target:self selector:@selector(run) userInfo:nil repeats:YES];
    }
    return self;
}
#pragma mark - Timer执行方法
-(void)run{
    if (_intervalTime != 0) {
        NSString* lstring = @"%";
        if (_percent <= 1) {
            _percent += _interval*TIMER_TIME/_intervalTime/CAR_IMAGE_WIDTH;
            _percentLabel.text = [NSString stringWithFormat:@"%.0f%@",_percent*100,lstring];
            [_coverView setFrame:CGRectMake((self.frame.size.width - CAR_IMAGE_WIDTH)/2 + CAR_IMAGE_WIDTH*_percent, 0, (self.frame.size.width - CAR_IMAGE_WIDTH)/2 + CAR_IMAGE_WIDTH*(1-_percent), self.frame.size.height)];
        }else{
            _percentLabel.text = @"100%";
            [_coverView setFrame:CGRectMake((self.frame.size.width - CAR_IMAGE_WIDTH)/2 + CAR_IMAGE_WIDTH, 0, (self.frame.size.width - CAR_IMAGE_WIDTH)/2, self.frame.size.height)];
        }
        
    }
}
#pragma mark - 创建汽车View
-(void)creatCarImageView{
    _carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, (self.frame.size.height - BOTTOM_HEIGHT)/2 - 47, CAR_IMAGE_WIDTH, 94)];
    _carImageView.image = [UIImage imageNamed:@"home_color_car"];
    [self addSubview:_carImageView];
}

#pragma mark - 创建覆盖View
-(void)creatCoverView{
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _coverView.backgroundColor = [UIColor whiteColor];
    _coverView.alpha = 0.75;
    //蓝色的间隔线
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, _coverView.frame.size.height - BOTTOM_HEIGHT)];
    lineView.backgroundColor = kCOLOR(60, 152, 247);
    [_coverView addSubview:lineView];
    [self addSubview:_coverView];
    //三角形
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-3, _coverView.frame.size.height - BOTTOM_HEIGHT + 1, 7, 6)];
    _markImageView.image = [UIImage imageNamed:@"home_sanjiaoxing"];
    _markImageView.hidden = YES;
    [_coverView addSubview:_markImageView];
    
    //百分比Label
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30 , self.frame.size.height - BOTTOM_HEIGHT + 10, 60, 10)];
    _percentLabel.text = @"0%";
    _percentLabel.textColor = kCOLOR(60, 152, 247);
    _percentLabel.font = kFontOfSize(10);
    [_percentLabel setTextAlignment:NSTextAlignmentCenter];
    _percentLabel.hidden = YES;
    [_coverView addSubview:_percentLabel];
    
}
#pragma mark - 创建背景图片
-(void)creatGroundImageView{
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - BOTTOM_HEIGHT)];
    lImageView.image = [UIImage imageNamed:@"home_wangge"];
    [self addSubview:lImageView];
    
    //检测项
    _detectNameLabel = [Utils labelWithFrame:CGRectMake(15, self.frame.size.height - 36, 200, 15) withTitle:@"" titleFontSize:kFontOfSize(15) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    _detectNameLabel.hidden = YES;
    [self addSubview:_detectNameLabel];
    
    //数值
    _detectMarkLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 15 - 60, self.frame.size.height - 36, 60, 14) withTitle:@"" titleFontSize:kFontOfSize(14) textColor:kCOLOR(60, 152, 247) alignment:NSTextAlignmentRight];
    _detectMarkLabel.hidden = YES;
    [self addSubview:_detectMarkLabel];
}

-(void)setGroundView{
    [_coverView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_carImageView setFrame:CGRectMake(self.frame.size.width, (self.frame.size.height - BOTTOM_HEIGHT)/2 - 47, 261, 94)];
}

#pragma mark - 动画开始
-(void)animationStarDictionary:(NSDictionary*)dataDic{
    MyLog(@"%@",dataDic);
    _dataDic = dataDic;
    _dataArray = dataDic[@"list"];
    _number = (int)_dataArray.count;
    _percent = 0;
    _intervalTime = 0;
    _interval = 261/(int)_dataArray.count;
    _animationStart = YES;
    
    [UIView animateWithDuration:CAR_ANIMATION_TIME animations:^{
        [_carImageView setFrame:CGRectMake(self.frame.size.width/2 - _carImageView.frame.size.width/2, _carImageView.frame.origin.y, _carImageView.frame.size.width, _carImageView.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            [_coverView setFrame:CGRectMake(_carImageView.frame.origin.x , 0, self.frame.size.width - _carImageView.frame.origin.x, self.frame.size.height)];
        } completion:^(BOOL finished) {
            _percentLabel.hidden = NO;
            _markImageView.hidden = NO;
            _detectMarkLabel.text = [NSString stringWithFormat:@"(0/%lu)",(unsigned long)_dataArray.count];
            _detectNameLabel.text = [NSString stringWithFormat:@"正在检测:%@...",_dataArray[0][@"name"]];
            _detectMarkLabel.hidden = NO;
            _detectNameLabel.hidden = NO;
            [self detectionAnimationStart];
        }];
    }];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"device":KUserManager.car.device,
                           @"cid":KUserManager.car.cid};
    [ModelTool httpGetGainOBDWithParameter:lDic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _dataDic = dic[@"data"];
        }else{
            _dataDic = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } faile:^(NSError *err) {
        _dataDic = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];

}
#pragma mark - 检测动画开始
-(void)detectionAnimationStart{
    _intervalTime = (CGFloat)(arc4random()%5 + 2)/10;
    [UIView animateWithDuration:_intervalTime animations:^{
        CGRect frame = _detectNameLabel.frame;
        frame.size.width += 5;
        _detectNameLabel.frame = frame;
    } completion:^(BOOL finished) {
        if (_number > 1) {//检测中
            _number --;
            int temp = (int)_dataArray.count - _number;
            _detectMarkLabel.text = [NSString stringWithFormat:@"(%i/%lu)",temp+1,(unsigned long)_dataArray.count];
            _detectNameLabel.text = [NSString stringWithFormat:@"正在检测:%@...",_dataArray[temp][@"name"]];
            [self detectionAnimationStart];
            
        }else{//检测结束
            _percentLabel.hidden = YES;
            _markImageView.hidden = YES;
            _detectMarkLabel.hidden = YES;
            _detectNameLabel.hidden = YES;
            _intervalTime = 0;
            [self animationEnd];
        }
    }];
}
#pragma mark - 检测完成动画
-(void)animationEnd{
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [_coverView setFrame:CGRectMake(self.frame.size.width , 0, 0, self.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.delegate detectionEnd:_dataDic];
    }];
}
@end
