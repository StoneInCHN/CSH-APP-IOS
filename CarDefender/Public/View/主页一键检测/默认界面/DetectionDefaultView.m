//
//  DetectionDefaultView.m
//  yijianjiance
//
//  Created by 周子涵 on 15/6/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DetectionDefaultView.h"
static const CGFloat ANIMATEIMAGEVIEW_SIZE_RATIO = 0.86;
static const int     DETCTIONBTN_SIZE = 110;

@implementation DetectionDefaultView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* groundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        groundImageView.image = [UIImage imageNamed:@"home_shizijia"];
        [self addSubview:groundImageView];
        
        _animateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height * ANIMATEIMAGEVIEW_SIZE_RATIO, frame.size.height * ANIMATEIMAGEVIEW_SIZE_RATIO)];
        _animateImageView.image = [UIImage imageNamed:@"home_yuanyinying"];
        _animateImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _animateImageView.hidden = YES;
        [self addSubview:_animateImageView];
        
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _animateImageView.frame.size.width, _animateImageView.frame.size.height)];
        _circleImageView.image = [UIImage imageNamed:@"home_yuan"];
        _circleImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_circleImageView];
        
        
        UIButton* detctionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DETCTIONBTN_SIZE, DETCTIONBTN_SIZE)];
        detctionBtn.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [detctionBtn setBackgroundImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
        [detctionBtn setBackgroundImage:[UIImage imageNamed:@"home_button_click"] forState:UIControlStateHighlighted];
        [detctionBtn addTarget:self action:@selector(detctionStar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detctionBtn];
        
        _rate = 6;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(run) userInfo:nil repeats:YES];
    }
    return self;
}
#pragma mark - Timer执行方法
-(void)run{
    if (KUserManager.uid == nil) {
        _animateImageView.hidden = YES;
    }else{
        _animateImageView.hidden = NO;
    }
    [UIView animateWithDuration:0.45 animations:^{
        _animateImageView.transform = CGAffineTransformRotate(_animateImageView.transform, _rate);
    }];
}
#pragma mark - 检测按钮点击事件
-(void)detctionStar{
    if (KUserManager.uid == nil) {
        [self.delegate noStart:0];
        _circleImageView.hidden = NO;
    }else if ([KUserManager.car.device isEqualToString:@""]){
        [self.delegate noStart:1];
        _circleImageView.hidden = YES;
    }else{
        [self.delegate detectionStart];
    }
}
@end
