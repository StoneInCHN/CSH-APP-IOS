//
//  CWSProtectView.m
//  CarDefender
//
//  Created by 李散 on 15/10/13.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSProtectView.h"
@interface CWSProtectView()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descripLabel;
@property (nonatomic, strong) UIButton *nextBtn;

@end
@implementation CWSProtectView

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel*label = [[UILabel alloc]init];
        label.text = @"车生活账户安全险";
        label.textColor = kCOLOR(51, 51, 51);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}
-(UILabel *)descripLabel
{
    if (_descripLabel == nil) {
        UILabel*label = [[UILabel alloc]init];
        label.text = @"2016-09-15";
        label.textColor = kCOLOR(152, 152, 152);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        _descripLabel = label;
    }
    return _descripLabel;
}
-(UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        
        UIButton*btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [Utils setViewRiders:btn riders:4];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:btn];
        _nextBtn = btn;
    }
    return _nextBtn;
}
-(void)setProtectType:(BOOL)protectType
{
    _protectType = protectType;
    
    if (protectType) {
        [self.nextBtn setTitle:@"保障中" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextBtn.backgroundColor = kCOLOR(98, 206, 73);
        [Utils setBianKuang:kCOLOR(98, 206, 73) Wide:1 view:self.nextBtn];
        
        self.descripLabel.text = @"2016-09-15";
    }else{
        [self.nextBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:kCOLOR(60, 152, 247) forState:UIControlStateNormal];
        self.nextBtn.backgroundColor = [UIColor whiteColor];
        [Utils setBianKuang:kCOLOR(60, 152, 247) Wide:1 view:self.nextBtn];
        
        self.descripLabel.text = @"保当前金额|无限次|8元/年";
    }
}
-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    self.descripLabel.text = timeString;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kCOLOR(246, 246, 246);
    }
    return self;
}
-(void)layoutSubviews
{
    self.titleLabel.frame = CGRectMake(10, 15, kSizeOfScreen.width*0.6, 20);
    self.descripLabel.frame = CGRectMake(10, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+10, self.titleLabel.frame.size.width, 15);
    CGRect btnFrame = self.nextBtn.frame;
    btnFrame.size = CGSizeMake(80, 33);
    btnFrame.origin = CGPointMake(0, 0);
    self.nextBtn.frame = btnFrame;
    self.nextBtn.center = CGPointMake(self.frame.size.width-10-40, self.frame.size.height/2);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.nextBtn.titleLabel.text isEqualToString:@"保障中"]) {
        [self.delegate protectViewWitchClick:YES];
    }
}
- (void)btnClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"保障中"]) {
        [self.delegate protectViewWitchClick:YES];
    }else{
        [self.delegate protectViewWitchClick:NO];
    }
}
@end
