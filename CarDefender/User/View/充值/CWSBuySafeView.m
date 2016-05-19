//
//  CWSBuySafeView.m
//  CarDefender
//
//  Created by 李散 on 15/10/13.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSBuySafeView.h"
@interface CWSBuySafeView ()

@property (nonatomic, strong) UILabel*labelMsg;

@property (nonatomic, strong) UIButton*proteBtn;

@property (nonatomic, strong) UIButton *buyBtn;

@end
@implementation CWSBuySafeView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}
- (UILabel *)labelMsg
{
    if (_labelMsg == nil) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"同意";
        label.textColor = kCOLOR(73, 73, 73);
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
        _labelMsg = label;
    }
    return _labelMsg;
}
-(UIButton *)proteBtn
{
    if (_proteBtn == nil) {
        _proteBtn = [[UIButton alloc]init];
        [_proteBtn setTitle:@"《保障协议》" forState:UIControlStateNormal];
        [_proteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _proteBtn.tag = 1;
        [_proteBtn setTitleColor:kCOLOR(60, 152, 247) forState:UIControlStateNormal];
        _proteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_proteBtn];
    }
    return _proteBtn;
}
-(UIButton *)buyBtn
{
    if (_buyBtn == nil) {
        _buyBtn = [[UIButton alloc]init];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.tag = 2;
        [Utils setViewRiders:_buyBtn riders:4];
        _buyBtn.backgroundColor = kCOLOR(60, 152, 247);
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}
-(void)setProtBool:(BOOL)protBool
{
    _protBool = protBool;
    if (protBool) {
        self.labelMsg.text = @"查看";
        self.buyBtn.hidden = YES;
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 40)];
        view.backgroundColor = kCOLOR(241, 241, 241);
        [self addSubview:view];
        [self bringSubviewToFront:self.proteBtn];
        [self bringSubviewToFront:self.labelMsg];
    }else{
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kSizeOfScreen.width-30, 1)];
        view.backgroundColor = kCOLOR(195, 194, 199);
        [self addSubview:view];
    }
}
-(void)layoutSubviews
{
    NSString* titleString = @"同意";
    CGSize stringOfSize=[titleString boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size;
    self.labelMsg.frame = CGRectMake(15, 0, stringOfSize.width, 40);
    
    NSString* titleString1 = @"《保障协议》";
    CGSize stringOfSize1=[titleString1 boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size;
    self.proteBtn.frame = CGRectMake(self.labelMsg.frame.size.width+self.labelMsg.frame.origin.x, 0, stringOfSize1.width, 40);
    
    self.buyBtn.frame = CGRectMake(15, self.proteBtn.frame.size.height+self.proteBtn.frame.origin.y+30, kSizeOfScreen.width-20, 44);
}
- (void)btnClick:(UIButton*)sender
{
    [self.delegate buySafeViewWithBtnClick:sender.tag];
}
@end
