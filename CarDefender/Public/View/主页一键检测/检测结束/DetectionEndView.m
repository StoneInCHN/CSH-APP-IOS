//
//  DetectionEndView.m
//  yijianjiance
//
//  Created by 周子涵 on 15/6/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DetectionEndView.h"
#import "UIImageView+WebCache.h"

CGFloat TIMER_TIME = 0.01;
CGFloat ANIMATION_TIME = 0.5;

@implementation DetectionEndView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"DetectionEndView" owner:self options:nil][0];
        self.frame = frame;
//        _carStateNumber = [dic[@"carState"] floatValue];
//        _maintainStateNumber = [dic[@"maintainState"] floatValue];
        [self setBianKuang:kCOLOR(60, 152, 247) Wide:1 view:self.detectionAgainBtn];
        [self setBianKuang:kCOLOR(60, 152, 247) Wide:1 view:self.findMoreBtn];
        [self setViewRiders:self.detectionAgainBtn riders:6];
        [self setViewRiders:self.findMoreBtn riders:6];
        [self setViewRiders:self.carPlanView riders:6];
        [self setViewRiders:self.maintainPlanView riders:6];
        _animationStart = NO;
        _carStatePercent = 0;
        _maintainStatePercent = 0;
        self.carPlanImageView.frame = CGRectMake(-self.carPlanImageView.frame.size.width, 0, self.carPlanImageView.frame.size.width, self.carPlanImageView.frame.size.height);
        self.maintainPlanImageView.frame = CGRectMake(-self.maintainPlanImageView.frame.size.width, 0, self.maintainPlanImageView.frame.size.width, self.maintainPlanImageView.frame.size.height);
        [NSTimer scheduledTimerWithTimeInterval:TIMER_TIME target:self selector:@selector(run) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)run{
    if (_animationStart) {
        _carStatePercent += _carStateNumber*TIMER_TIME/ANIMATION_TIME;
        _maintainStatePercent += _maintainStateNumber*TIMER_TIME/ANIMATION_TIME;
        self.carStateLabel.text = [NSString stringWithFormat:@"%.0f分",_carStatePercent];
        self.maintainStateLabel.text = [NSString stringWithFormat:@"%.0f分",_maintainStatePercent];
    }
}
#pragma mark - 动画开始
- (void)animationStar:(NSDictionary*)dataDic{
    if (dataDic == nil) {
        return;
    }
    _dataDic = dataDic;
    _carStateNumber = [dataDic[@"carState"] floatValue];
    _maintainStateNumber = [dataDic[@"maintainState"] floatValue];
    if (_carStateNumber >= 80) {
        self.carStateLabel.textColor = kInsertGreenColor;
    }else if (_carStateNumber >= 60 && _carStateNumber < 80){
        self.carStateLabel.textColor = kInsertOrangeColor;
    }else{
        self.carStateLabel.textColor = kInsertRedColor;
    }
    if (_maintainStateNumber >= 80) {
        self.maintainStateLabel.textColor = kInsertGreenColor;
    }else if (_maintainStateNumber >= 60 && _maintainStateNumber < 80){
        self.maintainStateLabel.textColor = kInsertOrangeColor;
    }else{
        self.maintainStateLabel.textColor = kInsertRedColor;
    }
    _plateNumberLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"plate"]];
    if (![dataDic[@"dtc"] isEqualToString:@"未发现故障码"]) {
        _faultLabel.textColor = kInsertRedColor;
    }else{
        _faultLabel.textColor = kInsertGreenColor;
    }
    _faultLabel.text = dataDic[@"dtc"];
    [self.carLogoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dataDic[@"logo"]]] placeholderImage:[UIImage imageNamed:@"home_baoma.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    if ([dataDic[@"synthesis"] isEqualToString:@"优秀"]) {
        self.evaluateImageView.image = [UIImage imageNamed:@"home_jiance_youxiu.png"];
    }else if ([dataDic[@"synthesis"] isEqualToString:@"良好"]){
        self.evaluateImageView.image = [UIImage imageNamed:@"home_jiance_lianghao-.png"];
    }else if ([dataDic[@"synthesis"] isEqualToString:@"一般"]){
        self.evaluateImageView.image = [UIImage imageNamed:@"home_jiance_yiban.png"];
    }else if ([dataDic[@"synthesis"] isEqualToString:@"较差"]){
        self.evaluateImageView.image = [UIImage imageNamed:@"home_jiance_jiaocha.png"];
    }else if ([dataDic[@"synthesis"] isEqualToString:@"危险"]){
        self.evaluateImageView.image = [UIImage imageNamed:@"home_jiance_weixian"];
    }
    self.evaluateImageView.alpha = 0;
    self.carPlanImageView.frame = CGRectMake(-self.carPlanImageView.frame.size.width, 0, self.carPlanImageView.frame.size.width, self.carPlanImageView.frame.size.height);
    self.maintainPlanImageView.frame = CGRectMake(-self.maintainPlanImageView.frame.size.width, 0, self.maintainPlanImageView.frame.size.width, self.maintainPlanImageView.frame.size.height);
    self.carPlanImageView.hidden = NO;
    self.maintainPlanImageView.hidden = NO;
    _animationStart = YES;
    self.faultLabel.hidden = NO;
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        CGRect frame1 = self.carPlanImageView.frame;
        frame1.origin.x += self.planOneImageView.frame.size.width *_carStateNumber/100;
        self.carPlanImageView.frame = frame1;
//
        CGRect frame2 = self.maintainPlanImageView.frame;
        frame2.origin.x += self.planOneImageView.frame.size.width * _maintainStateNumber/100;
        self.maintainPlanImageView.frame = frame2;
    } completion:^(BOOL finished) {
        _animationStart = NO;
        self.carStateLabel.text = [NSString stringWithFormat:@"%.0f分",_carStateNumber];
        self.maintainStateLabel.text = [NSString stringWithFormat:@"%.0f分",_maintainStateNumber];
        [UIView animateWithDuration:0.3 animations:^{
            self.evaluateImageView.alpha = 1;
        }];
    }];
}
-(void)setDataViewHidden:(BOOL)hidden{
    self.dataView.hidden = hidden;
    self.noDataView.hidden = !hidden;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag != 3) {
        self.evaluateImageView.alpha = 0;
        self.carPlanImageView.hidden = YES;
        self.maintainPlanImageView.hidden = YES;
        self.carStateLabel.text = @"0分";
        self.maintainStateLabel.text = @"0分";
        _carStatePercent = 0;
        _maintainStatePercent = 0;
        self.faultLabel.hidden = YES;
    }
    [self.delegate detectionEndBtnClick:(int)sender.tag dictionary:_dataDic];
}
// 设置边框
-(void)setBianKuang:(UIColor *)coler Wide:(CGFloat)wide view:(UIView *)view
{
    view.layer.borderColor = [coler CGColor];
    view.layer.borderWidth = wide;
}
// 设置弧度
-(void)setViewRiders:(UIView *)view riders:(CGFloat)riders
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = riders;
}
@end
